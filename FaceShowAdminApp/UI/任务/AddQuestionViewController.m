//
//  AddQuestionViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/21.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "AddQuestionViewController.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "EditQuestionCell.h"
#import "EditQuestionFooterView.h"
#import "EditQuestionHeaderView.h"
#import "EditQuestionTableHeaderView.h"
#import "FSDefaultHeaderFooterView.h"
#import "EditTemporaryCell.h"
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kVerticalBottomUpwardHeight (IS_IPHONE_X ? 34.0f : 0.0f)
@interface AddQuestionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) EditQuestionTableHeaderView *tableHeaderView;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) EditQuestionHeaderView *headerView;
@property (nonatomic, strong) EditQuestionFooterView *footerView;


@property (nonatomic, strong) CreateQuestionGroupItem_Question *question;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation AddQuestionViewController
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
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            if (keyboardFrame.origin.y == SCREEN_HEIGHT) {
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-(SCREEN_HEIGHT - keyboardFrame.origin.y) - kVerticalBottomUpwardHeight);
                }];
            }else {
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(-(SCREEN_HEIGHT - keyboardFrame.origin.y));
                }];
            }
        }];
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupModel
- (void)setupModel {
    self.question = [[CreateQuestionGroupItem_Question alloc] init];
    self.question.questionType = @"1";//默认单选
    CreateQuestionGroupItem_Question_VoteInfo *voteInfo = [[CreateQuestionGroupItem_Question_VoteInfo alloc] init];
    NSMutableArray<CreateQuestionGroupItem_Question_VoteInfo_VoteItem> *mutableArray = [[NSMutableArray<CreateQuestionGroupItem_Question_VoteInfo_VoteItem> alloc] init];
    voteInfo.voteItems = mutableArray;
    self.question.voteInfo = voteInfo;
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
    [self.tableView registerClass:[EditTemporaryCell class] forCellReuseIdentifier:@"EditTemporaryCell"];
    [self.tableView registerClass:[EditQuestionHeaderView class] forHeaderFooterViewReuseIdentifier:@"EditQuestionHeaderView"];
    [self.tableView registerClass:[EditQuestionFooterView class] forHeaderFooterViewReuseIdentifier:@"EditQuestionFooterView"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    self.footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EditQuestionFooterView"];
    WEAK_SELF
    self.footerView.addQuestionBlock = ^{
        STRONG_SELF
        CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = [[CreateQuestionGroupItem_Question_VoteInfo_VoteItem alloc] init];
        [self.question.voteInfo.voteItems addObject:item];
        [self reloadPublishButtonStatus];
        NSIndexPath * newIndexPath = [NSIndexPath indexPathForRow:self.question.voteInfo.voteItems.count inSection:0];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        EditQuestionCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.question.voteInfo.voteItems.count inSection:0]];
        [cell.textView becomeFirstResponder];
    };
    if (self.createType == CreateComplex_Vote) {
        self.tableHeaderView = [[EditQuestionTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.0f + 45.0f + 1.0f + 45.0f + 5.0f)];
    }else {
        self.tableHeaderView = [[EditQuestionTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5.0f + 45.0f + 1.0f + 45.0f + 1.0f + 45.0f + 5.0f)];
    }
    self.tableHeaderView.questionTypeBlock = ^(NSString *typeString) {
        STRONG_SELF
        self.question.questionType = typeString;
        if (self.question.questionType.integerValue == 3) {
            [self.question.voteInfo.voteItems removeAllObjects];
        }
        [self.tableView reloadData];
        [self reloadPublishButtonStatus];
    };
    self.tableHeaderView.tag = 1;
    self.tableView.tableHeaderView = self.tableHeaderView;
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"keyUploadHeight" object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        SAMTextView *textView = x.object;
        if (textView.tag >= 10087) {
            CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = self.question.voteInfo.voteItems[textView.tag - 10087];
            item.itemName = textView.text;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            });
        }else if (textView.tag == 10001){
            self.question.title = textView.text;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView beginUpdates];
                [self.tableView endUpdates];
            });
        }
        [self reloadPublishButtonStatus];
    }];
    [self setupAddButton];
    [self setupNavigationRightView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [[recognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        if (x.state == UIGestureRecognizerStateEnded) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"keyBoardHide" object:nil];
        }
    }];
    [self.tableView addGestureRecognizer:recognizer];
}
- (void)setupAddButton {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(-kVerticalBottomUpwardHeight);
        make.height.mas_offset(49.0f);
    }];
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.layer.cornerRadius = 6.0f;
    self.addButton.clipsToBounds = YES;
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.addButton setTitle:@"保存并添加下一题" forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"0068bd"]] forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[UIImage yx_createImageWithColor:[[UIColor colorWithHexString:@"0068bd"] colorWithAlphaComponent:0.3]] forState:UIControlStateDisabled];
    self.addButton.enabled = NO;
    [self.bottomView addSubview:self.addButton];
    WEAK_SELF
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.addQuestionBlock,self.question);
        [self.view endEditing:YES];
        [self setupModel];
        [self.tableHeaderView reloadSelected];
        self.serialNumber++;
        self.headerView.textView.text = self.question.title;
        self.headerView.tag = self.serialNumber;
        [self.tableView reloadData];
        [self reloadPublishButtonStatus];
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.height.mas_offset(39.0f);
        make.left.equalTo(self.bottomView.mas_left).offset(15.0f);
        make.right.equalTo(self.bottomView.mas_right).offset(-15.0f);
    }];
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
        BLOCK_EXEC(self.addQuestionBlock,self.question);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    rightButton.enabled = NO;
    self.publishButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
}
- (void)reloadPublishButtonStatus {
    if (self.question.questionType.integerValue == 3) {
        self.publishButton.enabled = [self.question.title yx_stringByTrimmingCharacters].length != 0;
    }else {
        __block BOOL isEmpty = NO;
        [self.question.voteInfo.voteItems enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question_VoteInfo_VoteItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.itemName yx_stringByTrimmingCharacters].length == 0) {
                isEmpty = YES;
                *stop = YES;
            }
        }];
        self.publishButton.enabled = ([self.question.title yx_stringByTrimmingCharacters].length != 0 && !isEmpty && self.question.voteInfo.voteItems.count > 1);
    }
    self.addButton.enabled = self.publishButton.enabled;
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49.0f);
    }];
}
- (void)backAction {
    if ([self.question.title yx_stringByTrimmingCharacters].length > 0 || self.question.voteInfo.voteItems.count > 0) {
        [self showAlertView];
    }else {
        [super backAction];
    }
}
- (void)showAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否退出问题添加" message:nil preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
    }];
    [alertVC addAction:cancleAction];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertVC addAction:backAction];
    [[self nyx_visibleViewController] presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark - UITableViewDataScore
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.question.voteInfo.voteItems.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {//TD:ios10.3.3 6sp 输入跳动问题 没找到原因 暂时这么改现象不会出现 zheng
        EditTemporaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditTemporaryCell" forIndexPath:indexPath];
        return cell;
    }else {
        EditQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditQuestionCell" forIndexPath:indexPath];
        CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = self.question.voteInfo.voteItems[indexPath.row - 1];
        cell.textView.text = item.itemName;
        WEAK_SELF
        cell.deleteQuestionBlock = ^{
            STRONG_SELF
            [self.question.voteInfo.voteItems removeObjectAtIndex:indexPath.row - 1];
            [self.tableView reloadData];
            [self reloadPublishButtonStatus];
        };
        cell.tag = indexPath.row;
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"EditQuestionHeaderView"];
    self.headerView.textView.text = self.question.title;
    self.headerView.tag = self.serialNumber;
    return self.headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.question.questionType.integerValue == 3) {
        FSDefaultHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
        return footerView;
    }else {
        return self.footerView;
    }
}
@end
