//
//  EditQuestionCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/20.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "EditQuestionCell.h"
#import "SAMTextView+Restriction.h"
@interface EditQuestionCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation EditQuestionCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLogDebug(@"release========>>%@",[self class]);
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        WEAK_SELF
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"keyBoardHide" object:nil] subscribeNext:^(id x) {
            STRONG_SELF
            [self.textView resignFirstResponder];
        }];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}
- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    self.textView.tag = 10086 + tag;
//    char letter = (int)tag + 96;
//    NSString *letterStr = [[NSString stringWithFormat:@"%c",letter] uppercaseString];
    self.titleLabel.text = [NSString stringWithFormat:@"(%ld):",tag];
}
#pragma mark - setupUI
- (void)setupUI {
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setImage:[UIImage imageNamed:@"删除选项"] forState:UIControlStateNormal];
    WEAK_SELF
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        BLOCK_EXEC(self.deleteQuestionBlock);
    }];
    [self.contentView addSubview:self.deleteButton];
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    self.titleLabel.text = @"A:";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    
    self.textView = [[SAMTextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:15.0f];
    self.textView.textColor = [UIColor colorWithHexString:@"333333"];
    self.textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.textView.characterInteger = 200;
    self.textView.placeholder = @"请输入选项";
    self.textView.scrollEnabled = NO;
    [self.contentView addSubview:self.textView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self.contentView addSubview:self.lineView];
}
- (void)setupLayout {
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(2.0f);
        make.size.mas_offset(CGSizeMake(21.0f + 26.0f, 21.0f + 26.0f));
        make.top.equalTo(self.contentView.mas_top).offset(3.0f);
    }];
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deleteButton.mas_right);
        make.top.equalTo(self.contentView.mas_top).offset(16.0f);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10.0).priorityHigh();
        make.right.equalTo(self.contentView.mas_right).offset(-15.0f);
        make.top.equalTo(self.contentView.mas_top).offset(8.0f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-8.0f);
        make.height.mas_greaterThanOrEqualTo(28.0f).priorityHigh();
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.0f);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(15.0f);
        make.right.equalTo(self.contentView.mas_right);
    }];
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
