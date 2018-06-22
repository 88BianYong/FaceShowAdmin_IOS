//
//  MemberHomeworkCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/6/19.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "MemberHomeworkCell.h"
#import "GetUserHomeworksRequest.h"

@interface MemberHomeworkCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *scoreLabel;
@end

@implementation MemberHomeworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.scoreLabel = [[UILabel alloc]init];
    self.scoreLabel.font = [UIFont systemFontOfSize:13];
    self.scoreLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.scoreLabel];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(0);
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-70);
        make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_offset(-3);
    }];
    self.subtitleLabel = [[UILabel alloc]init];
    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
    self.subtitleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.subtitleLabel];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-70);
        make.top.mas_equalTo(self.mas_centerY).mas_offset(3);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    //mock mock
    self.titleLabel.text = @"大活动fnowinfoegowengowengowbegoweigoweigoweogwioegewg";
    self.subtitleLabel.text = @"发我饿on欧冠飞鸟我给你欧冠发我饿on欧冠飞鸟我给你欧冠发我饿on欧冠飞鸟我给你欧冠";
    self.scoreLabel.text = @"不合格";
    self.scoreLabel.textColor = [UIColor colorWithHexString:@"666666"];
//    self.scoreLabel.text = @"优秀";
//    self.scoreLabel.textColor = [UIColor colorWithHexString:@"f56f5d"];
    
}

- (void)setElement:(GetUserHomeworksRequestItem_element *)element {
    _element = element;
    self.titleLabel.text = element.userName;
    self.subtitleLabel.text = element.title;
    NSString *asses = element.assess;
    self.scoreLabel.text = asses;
    if ([asses isEqualToString:@"不合格"]) {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"666666"];
    }else {
        self.scoreLabel.textColor = [UIColor colorWithHexString:@"f56f5d"];
    }
}

- (void)setIsFinished:(NSString *)isFinished {
    _isFinished = isFinished;
    if (![isFinished boolValue]) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-70);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }else {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-70);
            make.bottom.mas_equalTo(self.contentView.mas_centerY).mas_offset(-3);
        }];
    }
}
@end
