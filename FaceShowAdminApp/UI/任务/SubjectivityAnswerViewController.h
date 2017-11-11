//
//  SubjectivityAnswerViewController.h
//  FaceShowAdminApp
//
//  Created by LiuWenXing on 2017/11/11.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "QuestionRequestItem.h"

@interface SubjectivityAnswerViewController : PagedListViewControllerBase
@property (nonatomic, strong) QuestionRequestItem_question *question;
@end
