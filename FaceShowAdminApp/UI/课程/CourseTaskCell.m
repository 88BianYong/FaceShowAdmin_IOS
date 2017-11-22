//
//  CourseTaskCell.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2017/11/8.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CourseTaskCell.h"
#import "FSDataMappingTable.h"

@interface CourseTaskCell()
@property (nonatomic, strong) UIImageView *typeImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation CourseTaskCell

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
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    self.typeImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.typeImageView];
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeImageView.mas_right).mas_offset(13);
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(-15);
    }];
    self.descLabel = [[UILabel alloc]init];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = [UIColor colorWithHexString:@"666666"];
    [self.contentView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(6);
        make.right.mas_equalTo(self.titleLabel.mas_right);
    }];
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"dce0e3"];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

- (void)setData:(GetCourseRequestItem_InteractStep *)data {
    _data = data;
    self.titleLabel.text = data.interactName;
    InteractType type = [FSDataMappingTable InteractTypeWithKey:data.interactType];
    if (type == InteractType_Comment) {
        self.descLabel.attributedText = [[NSAttributedString alloc]initWithString:@"已开启"];
    }else {
        NSString *count = [NSString stringWithFormat:@"%@/%@",data.finishedStudentNum,data.totalStudentNum];
        NSString *complete = [NSString stringWithFormat:@"已完成人数：%@",count];
        NSRange range = [complete rangeOfString:count];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:complete];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0068bd"] range:range];
        [attr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range];
        self.descLabel.attributedText = attr;
    }
    
    if (type == InteractType_Vote) {
        self.typeImageView.image = [UIImage imageNamed:@"投票icon"];
    } else if (type == InteractType_Questionare) {
        self.typeImageView.image = [UIImage imageNamed:@"问卷icon"];
    } else if (type == InteractType_Comment) {
        self.typeImageView.image = [UIImage imageNamed:@"评论icon"];
    } else if (type == InteractType_SignIn) {
        self.typeImageView.image = [UIImage imageNamed:@"签到icon"];
    }
}

@end
