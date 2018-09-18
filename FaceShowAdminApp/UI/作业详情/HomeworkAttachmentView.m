//
//  HomeworkAttachmentView.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2018/8/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "HomeworkAttachmentView.h"
#import "ResourceTypeMapping.h"

@interface HomeworkAttachmentView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation HomeworkAttachmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"f5f7f8"];
    self.imageView = [[UIImageView alloc]init];
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.imageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(preview)];
    [self addGestureRecognizer:tap];
}

- (void)preview {
    BLOCK_EXEC(self.previewAction,self);
}

- (void)setData:(GetHomeworkRequestItem_attachmentInfo *)data {
    _data = data;
    self.imageView.image = [UIImage imageNamed:data.resType];
    self.titleLabel.text = data.resName;
}

@end
