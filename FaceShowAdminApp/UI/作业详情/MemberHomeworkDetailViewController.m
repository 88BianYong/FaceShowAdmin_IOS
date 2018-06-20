//
//  MemberHomeworkDetailViewController.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MemberHomeworkDetailViewController.h"
#import "HomeworkMemberView.h"
#import "PreviewPhotosView.h"
#import "HomeworkCommentView.h"
#import "GetUserHomeworksRequest.h"
#import "ReviewUserHomeworkRequest.h"

@interface MemberHomeworkDetailViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HomeworkMemberView *memberView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PreviewPhotosView *photosView;
@property (nonatomic, strong) HomeworkCommentView *commentView;
@property (nonatomic, strong) UILabel *commentLabel;
@property (nonatomic, strong) ReviewUserHomeworkRequest *request;
@end

@implementation MemberHomeworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupMockData];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIView *top = [[UIView alloc]init];
    top.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:top];
    [top mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top.mas_top).mas_offset(25);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    self.memberView = [[HomeworkMemberView alloc]init];
    [self.contentView addSubview:self.memberView];
    [self.memberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.centerX.mas_equalTo(0);
    }];
    self.commentLabel = [[UILabel alloc]init];
    self.commentLabel.backgroundColor = [UIColor colorWithHexString:@"fd763b"];
    self.commentLabel.textColor = [UIColor whiteColor];
    self.commentLabel.font = [UIFont systemFontOfSize:13];
    self.commentLabel.textAlignment = NSTextAlignmentCenter;
    self.commentLabel.layer.cornerRadius = 13;
    self.commentLabel.clipsToBounds = YES;
    [self.contentView addSubview:self.commentLabel];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.memberView.mas_top).mas_equalTo(8);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(60, 26));
    }];
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.font = [UIFont systemFontOfSize:13];
    self.dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.memberView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(0);
    }];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    self.photosView = [[PreviewPhotosView alloc] init];
    self.photosView.widthFloat = SCREEN_WIDTH - 15.0f - 15.0f;
    [self.contentView addSubview:self.photosView];
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(15.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
        make.height.mas_equalTo(0.1);
    }];
    self.commentView = [[HomeworkCommentView alloc]init];
    WEAK_SELF
    [self.commentView setConfirmBlock:^(NSString *comment) {
        STRONG_SELF
        [self reviewUserHomeworkWithComment:comment];
    }];
    [self.view addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(140);
    }];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 140, 0);
    if (![self.data.finishStatus isEqualToString:@"3"]) {
        self.commentLabel.hidden = YES;
        self.commentView.hidden = NO;
    }else {
        self.commentLabel.hidden = NO;
        self.commentView.hidden = YES;
    }
}

- (void)reviewUserHomeworkWithComment:(NSString *)comment {
    [self.request stopRequest];
    self.request = [[ReviewUserHomeworkRequest alloc]init];
    self.request.stepId = self.stepId;
    self.request.userHomeworkId = self.data.homeworkId;
    if ([comment isEqualToString:@"不合格"]) {
        self.request.finishStatus = @"2";
    }else {
        self.request.finishStatus = @"1";
    }
    self.request.assess = comment;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.request startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        self.commentView.hidden = YES;
        self.commentLabel.text = comment;
        self.commentLabel.hidden = NO;
    }];
}

- (void)setupMockData {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.4f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *title = @"火凤IE佛我把Iowa已变为U币跟i问个个动物刚 不够我围殴范围内鸟微风";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
    self.titleLabel.attributedText = attributedString;
    self.dateLabel.text = @"2017.06.21 14.32";
    NSString *content = @"这个属性是用来做优化的,但是有时候反而会降低性能,我跟你打个简单的比方,假如你有一个Department对象,它和Employee对象是一对多的关系(比如一个部门有100个员工),当你加载Department的时候,它包含的所有Employee也被加载了,此时如果returnsObjectsAsFaults为YES,则员工们不会被添加到内存中,而是被放在了row cache里,Department对象里的员工们只是一个指针(也称之为fault managed object),只有当你真正要用到Department里的员工数据的时候,Core Data才会再次从row cache中读取出来";
    attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.contentLabel.attributedText = attributedString;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        model.thumbnail = @"http://i0.sinaimg.cn/edu/2014/0607/U6360P352DT20140607090037.jpg";
        model.original = @"http://i0.sinaimg.cn/edu/2014/0607/U6360P352DT20140607090024.jpg";
        [mutableArray addObject:model];
    }
    self.photosView.imageModelMutableArray = mutableArray;
    [self.photosView reloadData];
    [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.photosView.heightFloat);
    }];
}

- (void)setupData {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.4f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSString *title = self.data.title;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
    self.titleLabel.attributedText = attributedString;
    self.dateLabel.text = [self.data.submitTime omitSecondOfFullDateString];
    NSString *content = self.data.content;
    attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.contentLabel.attributedText = attributedString;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < self.data.attachmentInfos.count; i++) {
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        GetHomeworkRequestItem_attachmentInfo *info = self.data.attachmentInfos[i];
        model.thumbnail = info.previewUrl;
        model.original = info.downloadUrl;
        [mutableArray addObject:model];
    }
    self.photosView.imageModelMutableArray = mutableArray;
    [self.photosView reloadData];
    [self.photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.photosView.heightFloat);
    }];
}

@end
