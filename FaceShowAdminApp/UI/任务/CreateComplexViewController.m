//
//  CreateVoteViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateComplexViewController.h"
#import "UITextField+Restriction.h"
#import "SAMTextView+Restriction.h"
#import "CreateComplexTableHeaderView.h"
#import "YXNoFloatingHeaderFooterTableView.h"
#import "SubordinateCourseViewController.h"
#import "ChooseTemplateViewController.h"
#import "CreateQuestionGroupItem.h"
#import "QuestionTemplatesCell.h"
#import "QuestionTemplatesHeaderView.h"
#import "UITableView+TemplateLayoutHeaderView.h"
#import "FSDefaultHeaderFooterView.h"
#import "EditQuestionViewController.h"
#import "AddQuestionViewController.h"
@interface CreateComplexViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;
@property (nonatomic, strong) CreateComplexTableHeaderView *tableHeaderView;
@property (nonatomic, strong) NSString *courseId;
@property (nonatomic, strong) CreateQuestionGroupItem *itemData;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) CreateComplexRequest *createRequest;

@end

@implementation CreateComplexViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self setupLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - setupUI
- (void)setupUI {
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.rowHeight = 45.0f;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[QuestionTemplatesCell class] forCellReuseIdentifier:@"QuestionTemplatesCell"];
    [self.tableView registerClass:[QuestionTemplatesHeaderView class] forHeaderFooterViewReuseIdentifier:@"QuestionTemplatesHeaderView"];
    [self.tableView registerClass:[FSDefaultHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"FSDefaultHeaderFooterView"];
    self.tableHeaderView = [[CreateComplexTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 310.0f)];
    WEAK_SELF
    self.tableHeaderView.courseView.pushSubordinateCourseBlock = ^{
        STRONG_SELF
        SubordinateCourseViewController *VC = [[SubordinateCourseViewController alloc] init];
        VC.courseId = self.courseId;
        VC.chooseSubordinateCoursBlock = ^(NSString *courseId,NSString *courseName) {
            if (courseId == nil) {
                self.tableHeaderView.courseView.chooseType = SubordinateCourse_Class;
                self.tableHeaderView.courseView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
                self.courseId = nil;
            }else {
                self.tableHeaderView.courseView.chooseType = SubordinateCourse_Course;
                self.courseId = courseId;
                self.tableHeaderView.courseView.chooseContentString = courseName;
            }
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
    self.tableHeaderView.templateView.pushSubordinateCourseBlock = ^{
        STRONG_SELF
        ChooseTemplateViewController *VC = [[ChooseTemplateViewController alloc] init];
        if (self.itemData.questions.count > 0) {
            CreateQuestionGroupItem_Question *question = self.itemData.questions[0];
            VC.templateId = question.templateId;
        }
        VC.loadTemplateBlock = ^(CreateQuestionGroupItem *itemData) {
            STRONG_SELF
            self.itemData = itemData;
            self.tableHeaderView.textField.text = self.itemData.title;
            self.tableHeaderView.textView.text = self.itemData.desc;
            [self.tableHeaderView reloadInputNumber];
            [self reloadPublishButtonStatus];
            self.tableHeaderView.templateView.chooseContentString = self.itemData.title;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:VC animated:YES];        
    };
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_offset(49.0f);
    }];
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton.backgroundColor = [UIColor colorWithHexString:@"0068bd"];
    self.addButton.layer.cornerRadius = 6.0f;
    self.addButton.clipsToBounds = YES;
    self.addButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.addButton setTitle:@"添加问题" forState:UIControlStateNormal];
    [bottomView addSubview:self.addButton];
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        AddQuestionViewController *VC = [[AddQuestionViewController alloc] init];
        VC.createType = self.createType;
        VC.serialNumber = self.itemData.questions.count + 1;
        WEAK_SELF
        VC.addQuestionBlock = ^(CreateQuestionGroupItem_Question *item) {
            STRONG_SELF
            if (self.itemData == nil) {
                self.itemData = [[CreateQuestionGroupItem alloc] init];
                NSMutableArray<CreateQuestionGroupItem_Question> *mutableArray = [[NSMutableArray<CreateQuestionGroupItem_Question> alloc] init];
                self.itemData.questions = mutableArray;
            }
            [self.itemData.questions addObject:item];
            [self formatQuestionData];
            [self.tableView reloadData];
            [self reloadPublishButtonStatus];
        };
        [self.navigationController pushViewController:VC animated:YES];
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.height.mas_offset(39.0f);
        make.left.equalTo(bottomView.mas_left).offset(15.0f);
        make.right.equalTo(bottomView.mas_right).offset(-15.0f);
    }];
    [self setupNavigationRightView];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [[recognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        if (x.state == UIGestureRecognizerStateEnded) {
            [self.tableHeaderView.textField  resignFirstResponder];
            [self.tableHeaderView.textView resignFirstResponder];
        }
    }];
    [self.tableView addGestureRecognizer:recognizer];
}
- (void)setupLayout {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49.0f);
    }];
}
- (void)setupNavigationRightView{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 40.0f, 40.0f);
    [rightButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    WEAK_SELF
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        self.itemData.title = [self.tableHeaderView.textField.text yx_stringByTrimmingCharacters];
        self.itemData.desc = [self.tableHeaderView.textView.text yx_stringByTrimmingCharacters];
        [self requestForCreateEvaluate];
    }];
    rightButton.enabled = NO;
    self.publishButton = rightButton;
    [self nyx_setupRightWithCustomView:rightButton];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        [self reloadPublishButtonStatus];
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        [self reloadPublishButtonStatus];
    }];
}
- (void)reloadPublishButtonStatus {
    if (([self.tableHeaderView.textField.text yx_stringByTrimmingCharacters].length != 0) &&
        (self.itemData.questions.count > 0)) {
        self.publishButton.enabled = YES;
    }else {
        self.publishButton.enabled = NO;
    }
}
- (void)backAction {
    if (self.tableHeaderView.textView.text.length > 0 || self.tableHeaderView.textField.text.length > 0 || self.itemData.questions.count > 0) {
        [self showAlertView];
    }else {
        [super backAction];
    }
}

- (void)showAlertView {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否退出此次创建" message:nil preferredStyle:UIAlertControllerStyleAlert];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemData.questions.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CreateQuestionGroupItem_Question *question = self.itemData.questions[section];
    return question.voteInfo.voteItems.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTemplatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionTemplatesCell" forIndexPath:indexPath];
    CreateQuestionGroupItem_Question *question = self.itemData.questions[indexPath.section];
    CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = question.voteInfo.voteItems[indexPath.row];
    [cell reloadTemplate:item.itemName withType:question.questionType.integerValue];
    return cell;
}
#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    QuestionTemplatesHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"QuestionTemplatesHeaderView"];
    CreateQuestionGroupItem_Question *question = self.itemData.questions[section];
    [headerView reloadTemplate:question.title withIndex:section+1 withType:question.questionType.integerValue];
    WEAK_SELF
    headerView.clickQuestionTemplateBlock = ^{
        STRONG_SELF
        CreateQuestionGroupItem_Question *question = self.itemData.questions[section];
        EditQuestionViewController *VC = [[EditQuestionViewController alloc] init];
        VC.question = question;
        VC.createType = self.createType;
        VC.serialNumber = section + 1;
        WEAK_SELF
        VC.editQuestionBlock = ^(CreateQuestionGroupItem_Question *item) {
            STRONG_SELF
            if (item == nil) {
                [self.itemData.questions removeObjectAtIndex:section];
            }else {
                [self.itemData.questions replaceObjectAtIndex:section withObject:item];
            }
            [self.itemData.questions enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.title = [obj.title yx_stringByTrimmingCharacters];
                [obj.voteInfo.voteItems enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
                    item.itemName = [item.itemName yx_stringByTrimmingCharacters];
                }];
            }];//去除空格
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
    return headerView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    FSDefaultHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FSDefaultHeaderFooterView"];
    return footerView;
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"QuestionTemplatesCell" configuration:^(QuestionTemplatesCell *cell) {
        CreateQuestionGroupItem_Question *question = self.itemData.questions[indexPath.section];
        CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item = question.voteInfo.voteItems[indexPath.row];
        [cell reloadTemplate:item.itemName withType:question.questionType.integerValue];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [tableView yx_heightForHeaderWithIdentifier:@"QuestionTemplatesHeaderView" configuration:^(QuestionTemplatesHeaderView *header) {
        CreateQuestionGroupItem_Question *question = self.itemData.questions[section];
        [header reloadTemplate:question.title withIndex:section+1 withType:question.questionType.integerValue];
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CreateQuestionGroupItem_Question *question = self.itemData.questions[indexPath.section];
    EditQuestionViewController *VC = [[EditQuestionViewController alloc] init];
    VC.question = question;
    VC.createType = self.createType;
    VC.serialNumber = indexPath.section + 1;
    WEAK_SELF
    VC.editQuestionBlock = ^(CreateQuestionGroupItem_Question *item) {
        STRONG_SELF
        if (item == nil) {
            [self.itemData.questions removeObjectAtIndex:indexPath.section];
        }else {
            [self.itemData.questions replaceObjectAtIndex:indexPath.section withObject:item];
        }
        [self.itemData.questions enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.title = [obj.title yx_stringByTrimmingCharacters];
            [obj.voteInfo.voteItems enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
                item.itemName = [item.itemName yx_stringByTrimmingCharacters];
            }];
        }];//去除空格
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableHeaderView keyBoardHide];
}
- (void)formatQuestionData {
    [self.itemData.questions enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.title = [obj.title yx_stringByTrimmingCharacters];
        [obj.voteInfo.voteItems enumerateObjectsUsingBlock:^(CreateQuestionGroupItem_Question_VoteInfo_VoteItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
            item.itemName = [item.itemName yx_stringByTrimmingCharacters];
        }];
    }];//去除空格
}
#pragma mark - request
- (void)requestForCreateEvaluate {
    CreateComplexRequest *request = [[CreateComplexRequest alloc] init];
    if (self.tableHeaderView.courseView.chooseType == SubordinateCourse_Course) {
        request.courseId = self.courseId;
    }else {
        request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    request.createType = self.createType;
    request.questionGroup = self.itemData.toJSONString;
    [self.view nyx_startLoading];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            BLOCK_EXEC(self.reloadComleteBlock);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    self.createRequest = request;
}
@end
