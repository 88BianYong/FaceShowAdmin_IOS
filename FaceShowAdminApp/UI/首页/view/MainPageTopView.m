//
//  MainPageTopView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/15.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageTopView.h"

@interface MainPageTopView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *projectLabel;
@property (nonatomic, strong) UIButton *classButton;
@property (nonatomic, strong) UILabel *studentLabel;
@property (nonatomic, strong) UILabel *teacherLabel;
@end

@implementation MainPageTopView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.bgImageView = [[UIImageView alloc]init];
    self.bgImageView.image = [UIImage imageNamed:@"背景图片-首页"];
    self.bgImageView.userInteractionEnabled = YES;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImageView.clipsToBounds = YES;
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    WEAK_SELF
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] init];
    [[gestureRecognizer rac_gestureSignal] subscribeNext:^(UITapGestureRecognizer *x) {
        STRONG_SELF
        if (x.state == UIGestureRecognizerStateEnded) {
            BLOCK_EXEC(self.mainPagePushDetailBlock);
        }
    }];
    [self.bgImageView addGestureRecognizer:gestureRecognizer];
    
    UIView *topView = [[UIView alloc]init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(60, 24));
    }];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = CGRectMake(0, 0, 60, 24);
    layer.fillColor = [[UIColor blackColor]colorWithAlphaComponent:0.3].CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:layer.frame byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    layer.path = path.CGPath;
    [topView.layer addSublayer:layer];
    UILabel *topLabel = [[UILabel alloc]init];
    topLabel.font = [UIFont systemFontOfSize:10];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.text = @"当前项目";
    [topView addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.classButton = [[UIButton alloc]init];
    [self.classButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.classButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    self.classButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.classButton.font = [UIFont boldSystemFontOfSize:13];
    self.classButton.layer.cornerRadius = 6;
    self.classButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.classButton.layer.borderWidth = 1;
    self.classButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    self.classButton.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 4);
    [self.classButton setImage:[UIImage imageNamed:@"点击二维码"] forState:UIControlStateNormal];
    [self addSubview:self.classButton];
    [self.classButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_bottom).mas_offset(67);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(26);
        make.left.mas_greaterThanOrEqualTo(15);
        make.right.mas_lessThanOrEqualTo(-15);
    }];
    [[self.classButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.mainPagePushDetailBlock);
    }];
    self.projectLabel = [[UILabel alloc]init];
    self.projectLabel.textColor = [UIColor whiteColor];
    self.projectLabel.font = [UIFont boldSystemFontOfSize:18];
    self.projectLabel.textAlignment = NSTextAlignmentCenter;
    self.projectLabel.numberOfLines = 2;
    [self addSubview:self.projectLabel];
    [self.projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(self.classButton.mas_top);
    }];
}
#pragma mark - set
- (void)setClazsInfo:(ClazsGetClazsRequestItem_Data_ClazsInfo *)clazsInfo {
    _clazsInfo = clazsInfo;
    if (_clazsInfo.clazsName.length == 0) {
        [self.classButton setHidden:YES];
        return;
    }
    [self.classButton setTitle:_clazsInfo.clazsName forState:UIControlStateNormal];
    CGSize size = [_clazsInfo.clazsName sizeWithFont:[UIFont boldSystemFontOfSize:13]];
    [self.classButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width + 20 + 30);
        make.height.mas_equalTo(20 + 10);
    }];

}
- (void)setProjectInfo:(ClazsGetClazsRequestItem_Data_ProjectInfo *)projectInfo {
    _projectInfo = projectInfo;
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineHeightMultiple = 1.2;
    paraStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle};
    NSString *project = _projectInfo.projectName;
    NSAttributedString *projectAttributeStr = [[NSAttributedString alloc] initWithString:project attributes:dic];
    self.projectLabel.attributedText = projectAttributeStr;
}

@end
