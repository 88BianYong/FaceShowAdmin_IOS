//
//  HomeworkDetailView.m
//  FaceShowAdminApp
//
//  Created by ZLL on 2018/8/29.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HomeworkDetailView.h"
#import "GetUserHomeworksRequest.h"
#import "HomeworkMemberView.h"
#import "HomeworkCommentView.h"
#import "PreviewPhotosView.h"
#import "ErrorView.h"
#import "ReviewUserHomeworkRequest.h"
#import "GetUserHomeworkDetailRequest.h"
#import "HomeworkAttachmentView.h"
#import "HomeworkAttachmentView.h"

@interface HomeworkDetailView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) ErrorView *errorView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) HomeworkMemberView *memberView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) PreviewPhotosView *photosView;
@property (nonatomic, strong) HomeworkCommentView *commentView;
@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong)UIView *attachmentContainerView;
@property (nonatomic, strong) UILabel *attachTitleLabel;
@property (nonatomic, strong) HomeworkAttachmentView *attachmentView;

@property (nonatomic, strong) ReviewUserHomeworkRequest *reviewRequest;
@property (nonatomic, strong) GetUserHomeworkDetailRequest *detailRequest;
@property (nonatomic, strong) GetUserHomeworkDetailRequestItem_data *userHomework;

@property (nonatomic, strong) NSMutableArray *attachmentViewArray;
@end

@implementation HomeworkDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.contentView = [[UIView alloc]init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView.mas_width);
    }];
    
    UIView *topView = [[UIView alloc]init];
    topView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topView.mas_top).mas_offset(25);
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
    
    self.attachmentContainerView = [[UIView alloc]init];
    self.attachTitleLabel = [[UILabel alloc]init];
    self.attachTitleLabel.text = @"作业附件:";
    self.attachTitleLabel.font = [UIFont systemFontOfSize:14];
    self.attachTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.attachTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    
    self.commentView = [[HomeworkCommentView alloc]init];
    WEAK_SELF
    [self.commentView setConfirmBlock:^(NSString *comment) {
        STRONG_SELF
        [self reviewUserHomeworkWithComment:comment];
    }];
    [self addSubview:self.commentView];
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(140);
    }];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 140, 0);
    
    self.errorView = [[ErrorView alloc]init];
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestHomeworkDetail];
    }];
    [self reloadCommentViewWithComment:self.data.assess];
}

- (void)reviewUserHomeworkWithComment:(NSString *)comment {
    [self.reviewRequest stopRequest];
    self.reviewRequest = [[ReviewUserHomeworkRequest alloc]init];
    self.reviewRequest.stepId = self.stepId;
    self.reviewRequest.userHomeworkId = self.data.elementId;
    //后续可能会设置不通过重做作业,本期先默认都通过 1
    //    if ([comment isEqualToString:@"不合格"]) {
    //        self.reviewRequest.finishStatus = @"2";
    //    }else {
    //        self.reviewRequest.finishStatus = @"1";
    //    }
    self.reviewRequest.finishStatus = @"1";
    self.reviewRequest.assess = comment;
    WEAK_SELF
    [self nyx_startLoading];
    [self.reviewRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self nyx_stopLoading];
        if (error) {
            [self nyx_showToast:error.localizedDescription];
            return;
        }
        [self reloadCommentViewWithComment:comment];
        BLOCK_EXEC(self.commentComleteBlock,comment);
    }];
}

- (void)reloadCommentViewWithComment:(NSString *)comment {
    if (comment.length <= 0) {
        self.commentLabel.hidden = YES;
        self.commentView.hidden = NO;
        [self.commentView reloadData];
    }else {
        self.commentView.hidden = YES;
        self.commentLabel.text = comment;
        self.commentLabel.hidden = NO;
    }
}

- (void)setData:(GetUserHomeworksRequestItem_element *)data {
    _data = data;
    [self requestHomeworkDetail];
}

- (void)requestHomeworkDetail {
    [self.detailRequest stopRequest];
    self.detailRequest = [[GetUserHomeworkDetailRequest alloc]init];
    self.detailRequest.userHomeworkId = self.data.elementId;
    WEAK_SELF
    [self nyx_startLoading];
    [self.detailRequest startRequestWithRetClass:[GetUserHomeworkDetailRequestItem class] andCompleteBlock:^(id retItem, NSError *error, BOOL isMock) {
        STRONG_SELF
        [self nyx_stopLoading];
        if (error) {
            [self addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        [self.errorView removeFromSuperview];
        GetUserHomeworkDetailRequestItem *item = (GetUserHomeworkDetailRequestItem *)retItem;
        self.userHomework = item.data;
        [self reloadData];
    }];
}

- (void)reloadData {
    [self setupMock];
    [self reloadContentData];
    [self reloadCommentViewWithComment:self.userHomework.assess];
    [self reloadAttachmentView];
}

- (void)reloadContentData {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.4f;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSString *title = [NSString stringWithFormat:@"%@  ",self.userHomework.title];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, title.length)];
    if (self.userHomework.attachmentInfos2.count > 0) {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = [UIImage imageNamed:@"附件"];
        textAttachment.bounds = CGRectMake(10, 0, 14, 15);
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attributedString replaceCharactersInRange:NSMakeRange(title.length , 0) withAttributedString:attrStringWithImage];
    }
    
    self.titleLabel.attributedText = attributedString;
    
    self.memberView.name = self.userHomework.userName;
    self.memberView.headUrl = self.userHomework.avatar;
    self.dateLabel.text = [self.userHomework.submitTime omitSecondOfFullDateString];
    NSString *content = self.userHomework.content;
    attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.contentLabel.attributedText = attributedString;
    self.commentLabel.text = self.userHomework.assess;
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (int i = 0; i < self.userHomework.attachmentInfos.count; i++) {
        PreviewPhotosModel *model  = [[PreviewPhotosModel alloc] init];
        GetHomeworkRequestItem_attachmentInfo *info = self.userHomework.attachmentInfos[i];
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

- (void)reloadAttachmentView {
    if (self.userHomework.attachmentInfos2.count > 0) {
        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentLabel);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15.0f);
        }];
        [self.contentView addSubview:self.attachmentContainerView];
        [self.attachmentContainerView addSubview:self.attachTitleLabel];
        [self.attachmentContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.photosView.mas_bottom).offset(15.f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
        }];
        
        [self.attachTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
            if (self.userHomework.attachmentInfos2.count == 0) {
                make.bottom.mas_equalTo(0);
            }
        }];
        UIView *top = self.attachTitleLabel;
        for (GetHomeworkRequestItem_attachmentInfo *item in self.userHomework.attachmentInfos2) {
            HomeworkAttachmentView *attach = [[HomeworkAttachmentView alloc]init];
            attach.data = item;
            WEAK_SELF
            [attach setPreviewAction:^(HomeworkAttachmentView *attachment) {
                STRONG_SELF
            }];
            [self.attachmentContainerView addSubview:attach];
            [attach mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(60);
                CGFloat t = [self.userHomework.attachmentInfos2 indexOfObject:item]==0? 0:5;
                make.top.mas_equalTo(top.mas_bottom).mas_offset(t);
                if (self.userHomework.attachmentInfos2.lastObject == item) {
                    make.bottom.mas_equalTo(0);
                }
            }];
            [self.attachmentViewArray addObject:attach];
            top = attach;
        }
    }else {
        [self.attachmentContainerView removeFromSuperview];
        [self.photosView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.contentLabel);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(15.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
            make.height.mas_equalTo(0.1);
        }];
    }
}

- (void)setupMock {
    GetHomeworkRequestItem_attachmentInfo *attach1 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach1.resName = @"附件1";
    attach1.ext = @"doc";
    attach1.previewUrl = @"http://pic.58pic.com/58pic/15/23/09/74T58PICZjg_1024.jpg";
    GetHomeworkRequestItem_attachmentInfo *attach2 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach2.resName = @"附件2";
    attach2.ext = @"xlsx";
    attach2.previewUrl = @"http://fc.topitme.com/c/46/4b/11204201334c04b46cl.jpg";
    GetHomeworkRequestItem_attachmentInfo *attach3 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach3.resName = @"附件3";
    attach3.ext = @"ppt";
    attach3.previewUrl = @"http://pic.58pic.com/58pic/13/19/88/82X58PICteS_1024.jpg";
    GetHomeworkRequestItem_attachmentInfo *attach4 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach4.resName = @"附件4";
    attach4.ext = @"jpg";
    attach4.previewUrl = @"http://imgsrc.baidu.com/imgad/pic/item/b21bb051f8198618076e0ba640ed2e738bd4e6e3.jpg";
    GetHomeworkRequestItem_attachmentInfo *attach5 = [[GetHomeworkRequestItem_attachmentInfo alloc]init];
    attach5.resName = @"附件5";
    attach5.ext = @"mp4";
    attach5.previewUrl = @"http://pic.58pic.com/58pic/13/68/96/68x58PICrws_1024.jpg";
    self.userHomework.attachmentInfos2 = @[attach1,attach2,attach3,attach4,attach5];
    self.userHomework.title = @"ahsdioahsiofhoiasf";
    self.userHomework.content = @"迆你弄已热弄热欧冠no工农人工 工农热弄拜佛问佛跟我跟博物馆北外波纹管版本噢吧宫本 讴歌吧不改波哥噢 能喔";
    self.userHomework.attachmentInfos = @[attach1,attach2,attach3,attach4,attach5];
}
@end
