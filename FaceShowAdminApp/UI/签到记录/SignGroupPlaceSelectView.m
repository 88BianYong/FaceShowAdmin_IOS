//
//  SignGroupPlaceSelectView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignGroupPlaceSelectView.h"
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>
@interface SignGroupPlaceSelectView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSString *placeStr;
@property (nonatomic, strong) UIView *lineView;


@end

@implementation SignGroupPlaceSelectView

- (instancetype)initWithGroupName:(NSString *)groupName andPlaceString:(NSString *)placeStr{
    self = [super init];
    if (self) {
        _groupName = groupName;
        _placeStr = placeStr;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{

    self.changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeButton setTitle:@"修改位置" forState:UIControlStateNormal];
    [self.changeButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    self.changeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    self.changeButton.layer.cornerRadius = 12.5;
    self.changeButton.layer.masksToBounds = YES;
    self.changeButton.layer.borderColor = [UIColor colorWithHexString:@"0068bd"].CGColor;
    self.changeButton.layer.borderWidth = 1.0f;
    WEAK_SELF
    [[self.changeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.clickSelectPlaceBlock);
    }];
    [self addSubview:self.changeButton];
    [self.changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.groupName;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.numberOfLines = 1;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self.changeButton);
        make.right.mas_equalTo(self.changeButton.mas_left).offset(-15);
    }];


    self.placeLabel = [[UILabel alloc] init];
    self.placeLabel.text = self.placeStr;
    self.placeLabel.font = [UIFont systemFontOfSize:14];
    self.placeLabel.textColor = [UIColor blackColor];
    self.placeLabel.numberOfLines = 0;
    self.placeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.changeButton.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-5);
    }];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(1);
    }];
}

- (void)changePlaceStr:(NSString *)placeStr{
    if (_placeStr != placeStr) {
        _placeStr = placeStr;
        self.placeLabel.text = placeStr;
    } 
}

- (void)setSelectedPoi:(BMKPoiInfo *)selectedPoi{
    _selectedPoi = selectedPoi;
    self.placeLabel.text = selectedPoi.name;
    _defaultDict = nil;
}

- (void)setDefaultDict:(NSDictionary *)defaultDict{
    _defaultDict = [defaultDict copy];
    [self.placeLabel setText:[NSString stringWithFormat:@"%@",defaultDict[@"positionSite"]]];
}

@end
