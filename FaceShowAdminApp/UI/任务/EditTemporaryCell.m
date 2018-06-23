//
//  EditTemporaryCell.m
//  FaceShowAdminApp
//
//  Created by 郑小龙 on 2018/6/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "EditTemporaryCell.h"
//修改ios10 6p 输入跳动问题
@implementation EditTemporaryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_offset(1.0f);
        }];
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
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
