//
//  CreateWorkViewController.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "CreateWorkViewController.h"
#import <SAMTextView.h>
#import "QADataManager.h"
#import "PhotoBrowserController.h"
#import "YXImagePickerController.h"
#import "AlertView.h"
#import "FDActionSheetView.h"
#import "ImageAttachmentContainerView.h"
#import "QiniuDataManager.h"
#import "SAMTextView+Restriction.h"
#import "TaskChooseContentView.h"
#import "SubordinateCourseViewController.h"
#import "CreateHomeworkRequest.h"
#import "UITextField+Restriction.h"
@interface CreateWorkViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *createWorkView;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) SAMTextView *createWorkTextView;
@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) TaskChooseContentView *contentView;

@property (nonatomic, strong) CreateHomeworkRequest *createRequest;
@property (nonatomic, strong) UIButton *publishButton;
@property (nonatomic, strong) ImageAttachmentContainerView *imageContainerView;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, strong) NSMutableArray *resIdArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSString *courseId;


@end

@implementation CreateWorkViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.navigationItem.title = @"新建作业";
    [self setupUI];
    [self setupLayout];
    [self setupObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y, 0);
        }];
    }];
}

#pragma mark - setupUI
- (void)setupUI {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64.0f);
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.view addSubview:self.scrollView];
    
    self.createWorkView = [[UIView alloc] init];
    self.createWorkView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.createWorkView];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.scrollView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.createWorkView.mas_left);
        make.right.equalTo(self.createWorkView.mas_right);
        make.top.equalTo(self.createWorkView.mas_top);
        make.height.mas_offset(5.0f);
    }];
    
    
    self.textField = [[UITextField alloc] init];
    self.textField.characterInteger = 20;
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.textColor = [UIColor colorWithHexString:@"333333"];
    self.textField.font = [UIFont boldSystemFontOfSize:16.0f];
    self.textField.placeholder = @"作业标题(最多20字)";
    [self.createWorkView addSubview:self.textField];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.createWorkView addSubview:self.lineView];
    
    self.createWorkTextView = [[SAMTextView alloc] init];
    self.createWorkTextView.characterInteger = 200;
    self.createWorkTextView.font = [UIFont systemFontOfSize:15.0f];
    self.createWorkTextView.textColor = [UIColor colorWithHexString:@"333333"];
    self.createWorkTextView.placeholder = @"作业详细内容(选填)";
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14]};
    self.createWorkTextView.typingAttributes = dic;
    [self.createWorkView addSubview:self.createWorkTextView];
        
    UIView *containerView = [[UIView alloc] init];
    [self.createWorkView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.createWorkView.mas_left).offset(0.0f);
        make.bottom.equalTo(self.createWorkView.mas_bottom).offset(-15.0f);
        make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, [ImageAttachmentContainerView heightForCount:0]));
    }];
    self.imageContainerView = [[ImageAttachmentContainerView alloc]init];
    WEAK_SELF
    [self.imageContainerView setImagesChangeBlock:^(NSArray *images) {
        STRONG_SELF
        self.imageArray = [NSMutableArray arrayWithArray:images];
        [self reloadPublishButtonStatus];
        [self.createWorkView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(self.contentView.mas_bottom);
            make.height.mas_offset(180.0f+[ImageAttachmentContainerView heightForCount:images.count]);
        }];
        [containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.createWorkView.mas_left).offset(0.0f);
            make.bottom.equalTo(self.createWorkView.mas_bottom).offset(0.0f);
            make.size.mas_offset(CGSizeMake(SCREEN_WIDTH, [ImageAttachmentContainerView heightForCount:images.count]));
        }];
    }];
    [containerView addSubview:self.imageContainerView];
    [self.imageContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.contentView = [[TaskChooseContentView alloc] init];
    self.contentView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
    [self.scrollView addSubview:self.contentView];
    self.contentView.pushSubordinateCourseBlock = ^{
        STRONG_SELF
        SubordinateCourseViewController *VC = [[SubordinateCourseViewController alloc] init];
        VC.courseId = self.courseId;
        VC.chooseSubordinateCoursBlock = ^(NSString *courseId,NSString *courseName) {
            if (courseId == nil) {
                self.contentView.chooseType = SubordinateCourse_Class;
                self.contentView.chooseContentString = [UserManager sharedInstance].userModel.currentClass.clazsName;
                self.courseId = nil;
            }else {
                self.contentView.chooseType = SubordinateCourse_Course;
                self.courseId = courseId;
                self.contentView.chooseContentString = courseName;
            }
        };
        [self.navigationController pushViewController:VC animated:YES];
    };
    
    UILabel *totaLabel = [[UILabel alloc] init];
    totaLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    totaLabel.font = [UIFont systemFontOfSize:15.0f];
    totaLabel.text = @"/200";
    totaLabel.textAlignment = NSTextAlignmentRight;
    [self.createWorkView addSubview:totaLabel];
    [totaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.createWorkView.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.createWorkView.mas_bottom).offset(-20.0f);
    }];
    
    UILabel *inputLabel = [[UILabel alloc] init];
    inputLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
    inputLabel.font = [UIFont systemFontOfSize:15.0f];
    inputLabel.text = @"0";
    inputLabel.textAlignment = NSTextAlignmentRight;
    [self.createWorkView addSubview:inputLabel];
    [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(totaLabel.mas_left);
        make.bottom.equalTo(self.createWorkView.mas_bottom).offset(-20.0f);
    }];
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        if (notification.object == self.createWorkTextView) {
            if (self.createWorkTextView.text.length > 0) {
                inputLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
            }else {
                inputLabel.textColor = [UIColor colorWithHexString:@"cccccc"];
            }
            inputLabel.text = [NSString stringWithFormat:@"%@",@(self.createWorkTextView.text.length)];
        }
    }];
    [self setupNavigationRightView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [[recognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        if (x.state == UIGestureRecognizerStateEnded) {
            [self.textField  resignFirstResponder];
            [self.createWorkTextView resignFirstResponder];
        }
    }];
    [self.scrollView addGestureRecognizer:recognizer];
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
        [self.view nyx_startLoading];
        if (self.imageArray.count == 0) {
            [self requestForPublishMoment:nil];
        }else {
            [self requestForUploadImage];
        }
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
    if ([self.textField.text yx_stringByTrimmingCharacters].length != 0 && (self.imageArray.count != 0 || [self.createWorkTextView.text yx_stringByTrimmingCharacters].length != 0)) {
        self.publishButton.enabled = YES;
    }else {
        self.publishButton.enabled = NO;
    }
}
- (void)backAction {
    if (self.textField.text.length > 0 || self.createWorkTextView.text.length > 0 || self.imageArray.count > 0) {
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
- (void)setupLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.scrollView.mas_top).offset(5.0f);
        make.height.mas_offset(45.0f);
    }];
    
    
    [self.createWorkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.contentView.mas_bottom);
        make.height.mas_offset(56.0f + 213.0f);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.createWorkView.mas_left).offset(15.0f).priorityHigh();
        make.right.equalTo(self.createWorkView.mas_right).offset(-15.0f).priorityHigh();
        make.top.equalTo(self.createWorkView.mas_top).offset(25.0f);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.createWorkView.mas_left).offset(15.0f);
        make.right.equalTo(self.createWorkView.mas_right).offset(-15.0f);
        make.top.equalTo(self.createWorkView.mas_top).offset(56.0f + 5.0f + 5.0f);
        make.height.mas_offset(1.0f);
    }];

    [self.createWorkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.createWorkView.mas_left).offset(15.0f);
        make.right.equalTo(self.createWorkView.mas_right).offset(-15.0f);
        make.top.equalTo(self.lineView.mas_top).offset(10.0f);
        make.height.mas_offset(90.0f);
    }];
}
#pragma mark - imagePicker
- (YXImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}

- (void)showImagePicker {
    FDActionSheetView *actionSheetView = [[FDActionSheetView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    actionSheetView.titleArray = @[@{@"title":@"拍照"}, @{@"title":@"相册"}];
    AlertView *alertView = [[AlertView alloc] init];
    alertView.backgroundColor = [UIColor clearColor];
    alertView.hideWhenMaskClicked = YES;
    alertView.contentView = actionSheetView;
    WEAK_SELF
    [alertView setHideBlock:^(AlertView *view) {
        STRONG_SELF
        [UIView animateWithDuration:0.3 animations:^{
            [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view.mas_left);
                make.right.equalTo(view.mas_right);
                make.top.equalTo(view.mas_bottom);
                make.height.mas_offset(155.0f);
            }];
            [view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }];
    [alertView showWithLayout:^(AlertView *view) {
        STRONG_SELF
        [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left);
            make.right.equalTo(view.mas_right);
            make.top.equalTo(view.mas_bottom);
            make.height.mas_offset(155.0f );
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                [actionSheetView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(view.mas_left);
                    make.right.equalTo(view.mas_right);
                    make.bottom.equalTo(view.mas_bottom);
                    make.height.mas_offset(155.0f);
                }];
                [view layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        });
    }];
    actionSheetView.actionSheetBlock = ^(NSInteger integer) {
        STRONG_SELF
        [self.imagePickerController pickImageWithSourceType:integer == 1 ? UIImagePickerControllerSourceTypeCamera :  UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
            STRONG_SELF
            [self.imageArray addObject:selectedImage];
            [self reloadPublishButtonStatus];
        }];
        [alertView hide];
    };
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}
#pragma mark - request
- (void)requestForUploadImage{
    self.imageIndex = 0;
    self.resIdArray = [NSMutableArray array];
    [self.view nyx_startLoading];
    [self nyx_disableRightNavigationItem];
    [self uploadImageWithIndex:self.imageIndex];
}

- (void)uploadImageWithIndex:(NSInteger)index {
    UIImage *img = self.imageArray[index];
    NSData *data = [UIImage compressionImage:img limitSize:0.1 * 1024 * 1024];
    WEAK_SELF
    [[QiniuDataManager sharedInstance]uploadData:data withProgressBlock:nil completeBlock:^(NSString *key,NSString *host, NSError *error) {
        STRONG_SELF
        if (error) {
            [self.view nyx_stopLoading];
            [self nyx_enableRightNavigationItem];
            [self.view nyx_showToast:@"发布失败请重试"];
            return;
        }
        [self.resIdArray addObject:[NSString stringWithFormat:@"%@|jpeg",key]];
        self.imageIndex++;
        if (self.imageIndex < self.imageArray.count) {
            [self uploadImageWithIndex:self.imageIndex];
        }else {
            [self requestForPublishMoment:[self.resIdArray componentsJoinedByString:@","]];
        }
    }];
}
- (void)requestForPublishMoment:(NSString *)resourceIds{
    [self.view nyx_startLoading];
    CreateHomeworkRequest *request = [[CreateHomeworkRequest alloc] init];
    if (self.contentView.chooseType == SubordinateCourse_Course) {
        request.courseId = self.courseId;
    }else {
        request.clazsId = [UserManager sharedInstance].userModel.currentClass.clazsId;
    }
    request.desc = [self.createWorkTextView.text yx_stringByTrimmingCharacters];
    request.title = [self.textField.text yx_stringByTrimmingCharacters];
    request.resourceKey = resourceIds;
    [self nyx_disableRightNavigationItem];
    WEAK_SELF
    [request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        if (error) {
            [self.view nyx_stopLoading];
            [self nyx_enableRightNavigationItem];
            [self.view nyx_showToast:@"发布失败请重试"];
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//图片转换时间
                [self.view nyx_stopLoading];
                [self nyx_enableRightNavigationItem];
                BLOCK_EXEC(self.reloadComleteBlock);
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
    self.createRequest = request;
}
@end
