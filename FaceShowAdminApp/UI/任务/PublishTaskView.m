//
//  PublishTaskView.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/11.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "PublishTaskView.h"
#import "PublishTaskCell.h"
#import "PublishTaskHeaderView.h"
#import "CollectionViewEqualSpaceFlowLayout.h"
@interface PublishTaskItem : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *defaultImage;
@property (nonatomic, copy) NSString *highlightImage;
@end
@implementation PublishTaskItem
@end

@interface PublishTaskView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@end
@implementation PublishTaskView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupModel];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
#pragma mark - setupUI
- (void)setupModel {
    PublishTaskItem *item1 = [[PublishTaskItem alloc] init];
    item1.name = @"签到";
    item1.defaultImage = @"发布签到";
    
    PublishTaskItem *item2 = [[PublishTaskItem alloc] init];
    item2.name = @"作业";
    item2.defaultImage = @"发布作业";
    
    PublishTaskItem *item3 = [[PublishTaskItem alloc] init];
    item3.name = @"讨论";
    item3.defaultImage = @"发布讨论";
    
    PublishTaskItem *item4 = [[PublishTaskItem alloc] init];
    item4.name = @"问卷";
    item4.defaultImage = @"发布问卷";
    
    PublishTaskItem *item5 = [[PublishTaskItem alloc] init];
    item5.name = @"投票";
    item5.defaultImage = @"发布投票";
    
    PublishTaskItem *item6 = [[PublishTaskItem alloc] init];
    item6.name = @"评价";
    item6.defaultImage = @"发布评论";
    
    self.dataArray = @[item1,item2,item6,item4,item5,item3];

}
- (void)setupUI {
    CollectionViewEqualSpaceFlowLayout *flowLayout = [[CollectionViewEqualSpaceFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 27.0f;
    flowLayout.minimumInteritemSpacing = 45.0f;
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 27.0f);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, (SCREEN_WIDTH - 225.0f - 50.0f - 2.0f)/2.0f, 0, (SCREEN_WIDTH - 225.0f - 50.0f - 2.0f)/2.0f);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.layer.cornerRadius = 6.0f;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[PublishTaskCell class] forCellWithReuseIdentifier:@"PublishTaskCell"];
    [self.collectionView registerClass:[PublishTaskHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishTaskHeaderView"];
    [self addSubview:self.collectionView];
    
}
- (void)setupLayout {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - UICollectionViewDataScore
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PublishTaskCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PublishTaskCell" forIndexPath:indexPath];
    PublishTaskItem *item = self.dataArray[indexPath.row];
    [cell reloadTask:item.name defaultImage:item.defaultImage highlightImage:item.highlightImage];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PublishTaskHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PublishTaskHeaderView" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BLOCK_EXEC(self.publishTaskBlock,indexPath.row);
}
#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(45, 45 + 23.0f);
}
@end
