//
//  ContactsClassFilterView.h
//  FaceShowApp
//
//  Created by ZLL on 2018/3/5.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ClassListRequestItem_clazsInfos;

typedef void(^ClazsListFilterCompletedBlock) (ClassListRequestItem_clazsInfos *selectedClass, NSInteger selectedRow);

@interface ContactsClassFilterView : UIView
@property(nonatomic, assign) NSInteger selectedRow;
@property(nonatomic, strong) NSArray<ClassListRequestItem_clazsInfos *> *dataArray;
- (void)setClazsListFilterCompleteBlock:(ClazsListFilterCompletedBlock)block;
- (CGFloat)heightForContactsClassFilterView;
- (void)reloadData;
@end
