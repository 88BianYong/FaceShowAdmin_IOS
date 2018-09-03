//
//  SearchHeadView.m
//  FaceShowAdminApp
//
//  Created by SRT on 2018/8/23.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "ContactsSearchHeadView.h"


static CGFloat const placeHolderFont = 14.0;

@interface ContactsSearchHeadView()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *key;
@end

@implementation ContactsSearchHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
    self.searchBar.placeholder = @"搜索";
    [self.searchBar setImage:[UIImage imageNamed:@"搜索"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"删除按钮2正常态"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    UITextField *field = [self.searchBar valueForKey:@"searchField"];
    field.tintColor = [UIColor clearColor];
    field.font = [UIFont systemFontOfSize:14];
    field.textColor = [UIColor colorWithHexString:@"333333"];
    [field setValue:[UIColor colorWithHexString:@"cccccc"] forKeyPath:@"_placeholderLabel.textColor"];
    [field setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:self.searchBar];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.searchBar setPositionAdjustment:UIOffsetMake(SCREEN_WIDTH/2 - [self placeholderWidth], 0) forSearchBarIcon:UISearchBarIconSearch];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardDidChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        UIButton *cancelButton = [self.searchBar valueForKey:@"cancelButton"];
        cancelButton.enabled = YES;
    }];
}

- (CGFloat)placeholderWidth {
    CGSize size = [self.searchBar.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
    CGFloat placeholderWidth = size.width;
    return placeholderWidth;
}

- (void)endSearching {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar setPositionAdjustment:UIOffsetMake(SCREEN_WIDTH/2 - [self placeholderWidth], 0) forSearchBarIcon:UISearchBarIconSearch];
    SAFE_CALL(self.delegate, searchFieldDidEndEditting);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    SAFE_CALL(self.delegate, searchFieldDidBeginEditting);
    self.searchBar.showsCancelButton = YES;
    UIButton *cancelButton = [searchBar valueForKey:@"cancelButton"];
    [cancelButton setTitleColor:[UIColor colorWithHexString:@"0068bd"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [searchBar setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    [self performSelector:@selector(showCursor) withObject:nil afterDelay:.5];
}
- (void)showCursor {
    UITextField *field = [self.searchBar valueForKey:@"searchField"];
    field.tintColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    UITextField *field = [self.searchBar valueForKey:@"searchField"];
    field.tintColor = [UIColor clearColor];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self endSearching];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    SAFE_CALL_OneParam(self.delegate, searchFieldDidTextChange, searchText);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    SAFE_CALL_OneParam(self.delegate, searchFieldDidTextChange, searchBar.text);
}

@end
