//
//  NoticeSaveContentCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2017/11/1.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "NoticeSaveContentCell.h"

@interface NoticeSaveContentCell ()<UITextViewDelegate>
@end

@implementation NoticeSaveContentCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textView = [[SAMTextView alloc] init];
        self.textView.font = [UIFont systemFontOfSize:14.0f];
        self.textView.placeholder = @"请输入通知内容（暂不支持表情）";
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineHeightMultiple = 1.2;
        NSDictionary *dic = @{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]};
        self.textView.typingAttributes = dic;
        self.textView.delegate = self;
        [self.contentView addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.top.equalTo(self.contentView.mas_top).offset(8.5f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-30.0f);
        }];
        UILabel *totaLabel = [[UILabel alloc] init];
        totaLabel.textColor = [UIColor colorWithHexString:@"999999"];
        totaLabel.font = [UIFont systemFontOfSize:12.0f];
        totaLabel.text = @"/200";
        totaLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:totaLabel];
        [totaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
        }];
        
        UILabel *inputLabel = [[UILabel alloc] init];
        inputLabel.textColor = [UIColor colorWithHexString:@"999999"];
        inputLabel.font = [UIFont systemFontOfSize:12.0f];
        inputLabel.text = @"0";
        inputLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:inputLabel];
        [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(totaLabel.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.0f);
        }];
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:nil] subscribeNext:^(NSNotification *notification) {
            STRONG_SELF
            if (self.textView.text.length > 0) {
                inputLabel.textColor = [UIColor colorWithHexString:@"0068bd"];
            }else {
               inputLabel.textColor = [UIColor colorWithHexString:@"999999"];
            }
            inputLabel.text = [NSString stringWithFormat:@"%ld",self.textView.text.length];
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15.0f);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
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

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage] || [text includeEmoji]) {
        return NO;
    }
    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (string.length > 200) {
        return NO;
    }
    return YES;
}

@end
