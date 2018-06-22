//
//  EditQuestionViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "EditQuestionViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "EditQuestionCell.h"
#import "EditQuestionFooterView.h"
#import "EditQuestionHeaderView.h"
#import "EditQuestionTableHeaderView.h"
#import "FSDefaultHeaderFooterView.h"
@interface EditQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) EditQuestionTableHeaderView *tableHeaderView;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) EditQuestionFooterView *footerView;
@property (nonatomic, strong) CreateQuestionGroupItem_Question *editQuestion;
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation EditQuestionViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加问题";
    [self setupModel];
    [self setupUI];
    [self setupLayout];
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y, 0);
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupModel
- (void)setupModel {
    self.editQuestion = [[CreateQuestionGroupItem_Question alloc] init];
    self.editQuestion.questionType = self.question.questionType;
    self.editQuestion.title = self.question.title;
    CreateQuestionGroupItem_Question_VoteInfo *voteInfo = [[CreateQuestionGroupItem_Question_VoteInfo alloc] init];
    NSMutableArray<CreateQuestionGroupItem_Question_VoteInfo_VoteItem> *mutableArray = [[NSMutableArray<CreateQuestionGroupItem_Question_VoteInfo_VoteItem> alloc] init];
    [self.question.voteInfo.voteItems enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question_VoteInfo_VoteItem * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = [[CreateQuestionGroupItem_Question_VoteInfo_VoteItem alloc] init];
        item.itemName = obj.itemName;
        [mutableArray addObject:item];
    }];
    voteInfo.voteItems = mutableArray;
    self.editQuestion.voteInfo = voteInfo;
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedSectionHeaderHeight = 44.0f;
    self.tableView.sectionFooterHeight = 50.0f;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[EditQuestionCell class] forCellReuseIdentifier:@"EditQuestionCell"];
    [self.tableView registerClass:[EditQuestionHeaderView class] forHeaderFooterViewReuseIdentifier:@"EditQuestionHeaderView"];
    [self.tableView registerClass:[EditQuestionFooterView class] forHeaderFooterViewReuseIdentifier:@"EditQuestionFooterView"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    self.footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EditQuestionFooterView"];
    WEAK_SELF
    self.footerView.addQuestionBlock = ^{
        STRONG_SELF
        CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = [[CreateQuestionGroupItem_Question_VoteInfo_VoteItem alloc] init];
        [self.editQuestion.voteInfo.voteItems addObject:item];
        NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:self.editQuestion.voteInfo.voteItems.count - 1 inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        EditQuestionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.editQuestion.voteInfo.voteItems.count - 1 inSection:0]];
        [cell.textView becomeFirstResponder];
        [self reloadPublishButtonStatus];
    };
    if (self.createType == CreateComplex_Vote) {
       self.tableHeaderView = [[EditQuestionTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.0f + 45.0f + 1.0f + 45.0f + 5.0f)];
    }else {
      self.tableHeaderView = [[EditQuestionTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.0f + 45.0f + 1.0f + 45.0f + 1.0f + 45.0f + 5.0f)];
    }
    self.tableHeaderView.questionTypeBlock = ^(NSString *typeString) {
        STRONG_SELF
        self.editQuestion.questionType = typeString;
        if (self.editQuestion.questionType.integerValue == 3) {
            [self.editQuestion.voteInfo.voteItems removeAllObjects];
        }
        [self.tableView reloadData];
        [self reloadPublishButtonStatus];
    };
    self.tableView.tableHeaderView = self.tableHeaderView;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"keyUploadHeight" object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        SAMTextView *textView = x.object;
        if (textView.tag >= 10087) {
            CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = self.editQuestion.voteInfo.voteItems[textView.tag - 10087];
            item.itemName = textView.text;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            });
        }else if (textView.tag == 10001){
            self.editQuestion.title = textView.text;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            });
        }
        [self reloadPublishButtonStatus];
    }];
    [self setupDeleteButton];
    [self setupNavigationRightView];
}
- (void)setupDeleteButton {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49.0f);
    }];
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.backgroundColor = [UIColor colorWithHexString:@"0068bd"];
    self.deleteButton.layer.cornerRadius = 6.0f;
    self.deleteButton.clipsToBounds = YES;
    self.deleteButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.deleteButton setTitle:@"删除问题" forState:UIControlStateNormal];
    [bottomView addSubview:self.deleteButton];
    WEAK_SELF
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        [self showDeleteQuestionAlert];
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.mas_offset(39.0f);
        make.left.equalTo(bottomView.mas_left).offset(15.0f);
        make.right.equalTo(bottomView.mas_right).offset(-15.0f);
    }];
}
- (void)showDeleteQuestionAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        BLOCK_EXEC(self.editQuestionBlock,nil);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:delete];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)setupNavigationRightView{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.editQuestionBlock,self.editQuestion);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    rightButton.enabled = NO;
    self.publishButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}
- (void)backAction {
    BLOCK_EXEC(self.editQuestionBlock,self.question);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)reloadPublishButtonStatus {
    if (self.editQuestion.questionType.integerValue == 3) {
        self.publishButton.enabled = [self.editQuestion.title yx_stringByTrimmingCharacters].length != 0;
    }else {
        __block BOOL isEmpty = NO;
        [self.editQuestion.voteInfo.voteItems enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question_VoteInfo_VoteItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.itemName yx_stringByTrimmingCharacters].length == 0) {
                isEmpty = YES;
                *stop = YES;
            }
        }];
        self.publishButton.enabled = ([self.editQuestion.title yx_stringByTrimmingCharacters].length != 0 && !isEmpty);
    }
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49.0f);
    }];
}
#pragma mark - UITableViewDataScore
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.editQuestion.voteInfo.voteItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditQuestionCell" forIndexPath:indexPath];
    CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = self.editQuestion.voteInfo.voteItems[indexPath.row];
    cell.textView.text = item.itemName;
    cell.tag = indexPath.row + 1;
    WEAK_SELF
    cell.deleteQuestionBlock = ^{
        STRONG_SELF
        [self.editQuestion.voteInfo.voteItems removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    };
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    EditQuestionHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EditQuestionHeaderView"];
    headerView.textView.text = self.editQuestion.title;
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.editQuestion.questionType.integerValue == 3) {
        FSDefaultHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
        return footerView;
    }else {
        return self.footerView;
    }
}
@end
