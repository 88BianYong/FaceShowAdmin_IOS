//
//  SignGroupPlaceView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/10/16.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignGroupPlaceView.h"
#import "SignGroupPlaceSelectView.h"
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>
@interface SignGroupPlaceView()
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) MASViewAttribute *lastBottom;
@property (nonatomic, strong) NSMutableArray<SignGroupPlaceSelectView *> *viewArr;

@end

@implementation SignGroupPlaceView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    self.viewArr = [NSMutableArray array];

    UILabel *placeLabel = [[UILabel alloc] init];
    placeLabel.text = @"指定小组签到地点";
    placeLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:placeLabel];
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
    }];
    self.placeLabel = placeLabel;
    self.lastBottom = placeLabel.mas_bottom;

}


- (void)setGroupsArray:(NSArray <GroupListRequest_Item_groups *>*)groupArray{
    if (groupArray.count > 0) {
        [self.placeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(10);
        }];
    }
    [groupArray enumerateObjectsUsingBlock:^(GroupListRequest_Item_groups * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SignGroupPlaceSelectView *selectView = [[SignGroupPlaceSelectView alloc] initWithGroupName:obj.groupName andPlaceString:nil];
        selectView.tag = obj.groupsId.integerValue + 100;
        [self addSubview:selectView];
        [self.viewArr addObject:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.lastBottom);
            make.left.right.mas_equalTo(0);
            if (idx == groupArray.count - 1) {
                make.bottom.mas_equalTo(0);
            }
        }];
        WEAK_SELF
        selectView.clickSelectPlaceBlock = ^{
            STRONG_SELF
            BLOCK_EXEC(self.changePlaceBlock,idx);
        };
        self.lastBottom = selectView.mas_bottom;

    }];
}

- (BOOL)buttonEnabled{
    BOOL enabled = YES;
    for (SignGroupPlaceSelectView *selectView in self.viewArr) {
        if (!selectView.defaultDict && !selectView.selectedPoi) {
            enabled = NO;
            return enabled;
        }
    }
    return enabled;
}

- (NSString *)signInExts{
    NSMutableArray *arr = [NSMutableArray array];
    for (SignGroupPlaceSelectView *selectView in self.viewArr) {
        if (selectView.defaultDict) {
            [arr addObject:selectView.defaultDict];
        }else{
            NSString *groupId = [NSString stringWithFormat:@"%ld",selectView.tag - 100];
            NSString *signinPosition = [NSString stringWithFormat:@"%@,%@",@(selectView.selectedPoi.pt.longitude),@(selectView.selectedPoi.pt.latitude)];
            NSDictionary *dic = @{
                                  @"groupId":groupId,
                                  @"positionSite":selectView.selectedPoi.name,
                                  @"signinPosition":signinPosition,
                                  @"positionRange":@"1000"
                                  };

            [arr addObject:dic];
        }
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *signInExts = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return signInExts;
}

- (void)setBMKInfo:(BMKPoiInfo *)bmkInfo atIndex:(NSInteger)index{
    SignGroupPlaceSelectView *selectView = self.viewArr[index];
    [selectView setSelectedPoi:bmkInfo];
}

- (void)setDefaultDict:(NSDictionary *)dict atIndex:(NSInteger)index{
    SignGroupPlaceSelectView *selectView = self.viewArr[index];
    [selectView setDefaultDict:dict];
}
@end
