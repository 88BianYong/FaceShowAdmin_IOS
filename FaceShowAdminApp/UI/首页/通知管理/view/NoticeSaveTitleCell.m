//
//  NoticeSaveTitleCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeSaveTitleCell.h"
@interface NoticeSaveTitleCell ()<UITextViewDelegate>
@end
@implementation NoticeSaveTitleCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textField = [[UITextField alloc] init];
        self.textField.textColor = [UIColor colorWithHexString:@"333333"];
        self.textField.placeholder = @"请输入通知标题 (最多20字)";
        self.textField.font = [UIFont systemFontOfSize:14.0f];
        self.textField.font = [UIFont boldSystemFontOfSize:16.0f];
        [self.textField setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
        [self.contentView addSubview:self.textField];
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_offset(20.0f);
        }];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextFieldTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *notification) {
            STRONG_SELF
        }];
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1.0f);
        }];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
