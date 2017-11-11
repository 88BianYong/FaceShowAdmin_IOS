//
//  SubjectivityAnswerCell.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSubjectivityAnswerReuqest.h"

@interface SubjectivityAnswerCell : UITableViewCell
@property (nonatomic, strong) GetsubjectivityAnswer_Element *item;
@property (nonatomic, strong) NSString *currentTime;
@property (nonatomic, assign) BOOL bottomLineHidden;
@end
