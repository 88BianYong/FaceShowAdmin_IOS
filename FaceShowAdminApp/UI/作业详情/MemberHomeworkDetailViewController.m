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

@interface MemberHomeworkDetailViewController ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HomeworkMemberView *memberView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PreviewPhotosView *photosView;
@property (nonatomic, strong) HomeworkCommentView *commentView;
@end

@implementation MemberHomeworkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupMockData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
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

@end
