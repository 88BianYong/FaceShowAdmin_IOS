//
//  SignInPlaceHeaderView.m
//  FaceShowAdminApp
//
//  Created by niuzhaowang on 2018/5/28.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "SignInPlaceHeaderView.h"
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>

static CGFloat const placeHolderFont = 14.0;

@interface SignInPlaceHeaderView ()<UISearchBarDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) BMKPoiSearch *cityPoiSearch;
@property (nonatomic, strong) BMKGeoCodeSearch* geocodesearch;
@property (nonatomic, strong) BMKPoiInfo *nearbyPoi;
@property (nonatomic, assign) BOOL locComplete;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, strong) NSString *curCity;
@end

@implementation SignInPlaceHeaderView
- (void)dealloc {
    self.mapView = nil;
    self.cityPoiSearch = nil;
    self.geocodesearch = nil;
}
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
    self.searchBar.placeholder = @"搜索地点";
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
    
    self.mapView = [[BMKMapView alloc]init];
    [self addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
    }];
    
    self.locService = [[BMKLocationService alloc]init];
    self.cityPoiSearch = [[BMKPoiSearch alloc]init];
    self.geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    UIView *coverLine = [[UIView alloc]init];
    coverLine.backgroundColor = [UIColor colorWithHexString:@"ebeff2"];
    [self addSubview:coverLine];
    [coverLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.height.mas_equalTo(1);
    }];
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

-(void)viewWillAppear {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
    _cityPoiSearch.delegate = self;
    _geocodesearch.delegate = self;
    if (!self.locComplete) {
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        self.locComplete = YES;
    }
}

-(void)viewWillDisappear {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    _cityPoiSearch.delegate = nil;
    _geocodesearch.delegate = nil;
}

- (void)searchWithKey:(NSString *)key inCity:(NSString *)city{
    self.key = key;
    self.city = city;
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc]init];
    citySearchOption.pageIndex = self.pageIndex;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city= city;
    citySearchOption.keyword = key;
    BOOL success = [_cityPoiSearch poiSearchInCity:citySearchOption];
    if (!success) {
        [self.delegate searchResultUpdated:nil withKey:key];
    }
}

- (void)nearbySearchWithLocation:(CLLocationCoordinate2D)location {
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location;
    [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

- (void)updateWithPoiInfo:(BMKPoiInfo *)poi {
    self.nearbyPoi = poi;
    [_mapView setCenterCoordinate:poi.pt animated:YES];
    [self nearbySearchWithLocation:poi.pt];
}

- (void)endSearching {
    [self.searchBar resignFirstResponder];
    self.searchBar.text = nil;
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar setPositionAdjustment:UIOffsetMake(SCREEN_WIDTH/2 - [self placeholderWidth], 0) forSearchBarIcon:UISearchBarIconSearch];
    SAFE_CALL(self.delegate, searchFieldDidEndEditting);
}

- (void)moveToPoi:(BMKPoiInfo *)poi {
    [_mapView setCenterCoordinate:poi.pt animated:YES];
}

- (void)searchNextPage {
    self.pageIndex++;
    [self searchWithKey:self.key inCity:self.city];
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
    self.pageIndex = 0;
    [self searchWithKey:searchText inCity:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.pageIndex = 0;
    [self searchWithKey:searchBar.text inCity:nil];
}

#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"");
}
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    BMKPointAnnotation *lockedScreenAnnotation = [[BMKPointAnnotation alloc]init];
    lockedScreenAnnotation.isLockedToScreen = YES;
    lockedScreenAnnotation.screenPointToLock = CGPointMake(mapView.frame.size.width/2, mapView.frame.size.height/2);
    [_mapView addAnnotation:lockedScreenAnnotation];
}
#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = userLocation.location.coordinate;//中心点
    region.span.latitudeDelta = 0.05;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.05;//纬度范围
    [_mapView setRegion:region animated:YES];
    [_mapView setCenterCoordinate:region.center animated:YES];
    _mapView.showsUserLocation = YES;
    [_locService stopUserLocationService];
    
    [self nearbySearchWithLocation:userLocation.location.coordinate];
}
- (void)didFailToLocateUserWithError:(NSError *)error {
    [_locService stopUserLocationService];
}
#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (result.cityList.count == 0) {
            if (self.pageIndex == 0) {
                [self.delegate searchResultUpdated:result.poiInfoList withKey:self.key];
            }else {
                [self.delegate nextPageSearchResultUpdated:result.poiInfoList];
            }
        }else if (self.curCity && !self.city) {
            self.pageIndex = 0;
            [self searchWithKey:self.key inCity:self.curCity];
        }else {
            [self.delegate searchResultUpdated:nil withKey:self.key];
        }
    }else {
        [self.delegate searchResultUpdated:nil withKey:self.key];
    }
}
#pragma mark - BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_OPEN_NO_ERROR) {
        if (!self.nearbyPoi) {
            self.curCity = result.addressDetail.city;
        }
        NSMutableArray *array = [NSMutableArray arrayWithArray:result.poiList];
        if (self.nearbyPoi) {
            [array insertObject:self.nearbyPoi atIndex:0];
        }
        [self.delegate nearbySearchUpdated:array];
    }else {
        NSMutableArray *array = [NSMutableArray array];
        if (self.nearbyPoi) {
            [array insertObject:self.nearbyPoi atIndex:0];
        }
        [self.delegate nearbySearchUpdated:array];
    }
}
@end
