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

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.groupName;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    CGSize size = [self.groupName sizeWithFont:[UIFont systemFontOfSize:14]];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(size);
    }];

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
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];

    self.placeLabel = [[UILabel alloc] init];
    self.placeLabel.text = self.placeStr;
    self.placeLabel.font = [UIFont systemFontOfSize:14];
    self.placeLabel.textColor = [UIColor blackColor];
    self.placeLabel.textAlignment = NSTextAlignmentRight;
    self.placeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:self.placeLabel];
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(15);
        make.right.mas_equalTo(self.changeButton.mas_left).offset(-15);
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
