//
//  ViewController.m
//  集成高德LBS
//
//  Created by 杨卢青 on 16/4/3.
//  Copyright © 2016年 杨卢青. All rights reserved.
//

#import "AMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "YLQAnnotationView.h"
#import "YLQDetailPageViewViewController.h"
#import "YLQCalloutView.h"

#define APIKey @"5eb87fbf5ed4f0c53cc087a77d7aaca1"

#define kDefaultLocationZoomLevel       16.1
#define kDefaultControlMargin           22
#define kDefaultCalloutViewMargin       -8
@interface AMapViewController ()<MAMapViewDelegate, AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource, YLQCalloutViewDelegate, UIGestureRecognizerDelegate>
{
    MAMapView *_mapView;
    UIButton *_locationButton;
    
    AMapSearchAPI *_search;
    CLLocation *_currentLocation;
    
    UIImage *_controlsImage;
    
    UITableView *_tableView;
    NSArray *_pois;
    
    NSMutableArray *_annotations;
    
    NSIndexPath *_lastIndexPath;
    
    MAPointAnnotation *_destinationPoint;
    UILongPressGestureRecognizer *_longPressGesture;
    
    NSArray *_pathPolylines;
}
@property (nonatomic, strong) YLQDetailPageViewViewController *detailVC;
@end

@implementation AMapViewController

#pragma mark - init
/**初始化属性池*/
- (void)initAttributs
{
    _annotations = [NSMutableArray array];
    _pois = nil;
    
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    _longPressGesture.delegate = self;
    [_mapView addGestureRecognizer:_longPressGesture];
}

/**初始化搜索结果TableView*/
- (void)initTableView
{
    CGFloat halfHeight = CGRectGetHeight(self.view.bounds) * 0.7;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, halfHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) * 0.3) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
}

/**初始化Search*/
- (void)initSearch
{
    [AMapSearchServices sharedServices].apiKey = APIKey;
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
}

//初始化按钮
- (void)initControls
{
    /**初始化TrackModeButton*/
    _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationButton.frame = CGRectMake(20, CGRectGetHeight(_mapView.bounds) - 80, 40, 40);
    _locationButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    _locationButton.backgroundColor = [UIColor whiteColor];
    _locationButton.layer.cornerRadius = 5;
    [_locationButton addTarget:self action:@selector(locateAction)
              forControlEvents:UIControlEventTouchUpInside];
    [_locationButton setImage:[UIImage imageNamed:@"location_no"] forState:UIControlStateNormal];
    [_mapView addSubview:_locationButton];
    
    /**初始化附近搜索按钮*/
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchButton.frame = CGRectMake(80, CGRectGetHeight(_mapView.bounds) - 80, 40, 40);
    searchButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    
    [searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_mapView addSubview:searchButton];
    
    /*初始化路线搜索按钮*/
    UIButton *pathButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    pathButton.frame = CGRectMake(140, CGRectGetHeight(_mapView.bounds) - 60, 40, 40);
    pathButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin;
    pathButton.backgroundColor = [UIColor whiteColor];
    [pathButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [pathButton addTarget:self action:@selector(pathAction)
         forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:pathButton];
}

//初始化MapView
- (void)initMapView
{
    [MAMapServices sharedServices].apiKey = APIKey;
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _mapView.delegate = self;
    _mapView.compassOrigin = CGPointMake(_mapView.compassOrigin.x, 22);
    _mapView.scaleOrigin = CGPointMake(_mapView.scaleOrigin.x, 22);
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = 1;
    [self.view addSubview:_mapView];
}

#pragma mark - System Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSearch];
    [self initMapView];
    [self initControls];
    [self initTableView];
    [self initAttributs];
//    [self jumpToDetailPage];
}

#pragma mark - SDK Method
/**搜索结束, 得到回调结果, 并清空上次搜索的所有标记*/
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    NSLog(@"request: %@", request);
    NSLog(@"response: %@", response);
    if (0 == response.pois.count) {
        return;
    }
    _pois = response.pois;
    [_tableView reloadData];
    _tableView.hidden = NO;
    _mapView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height * 0.7 -64);
    //清空标注
    [_mapView removeAnnotations:_annotations];
    [_annotations removeAllObjects];
}

//修改定位模式时回调
- (void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated
{
    //修改定位按钮状态
    
    switch (mode) {
        case MAUserTrackingModeNone:
            _controlsImage = [UIImage imageNamed:@"location_no"];
            break;
        case MAUserTrackingModeFollow:
            _controlsImage = [UIImage imageNamed:@"location_yes"];
            break;
        case MAUserTrackingModeFollowWithHeading:
            _controlsImage = [UIImage imageNamed:@"search"];
            break;
        default:
            NSLog(@"状态错误");
            break;
    }
    [_locationButton setImage:_controlsImage forState:UIControlStateNormal];
}

//获得当前经纬度: mapView的回调
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"userLocation: %@", userLocation.location);
    _currentLocation = [userLocation.location copy];
}

//搜索失败时, 错误回调方法都是这个
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"request: %@, error: %@", request, error);
}

//新逆地理编码request后 在此拿到结果 设置annotation属性
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response: %@", response);
    
    //可能是直辖市
    NSString *title = response.regeocode.addressComponent.city;
    if (0 == title.length) {
        title = response.regeocode.addressComponent.province;
    }
    
    _mapView.userLocation.title = title;
    _mapView.userLocation.subtitle = response.regeocode.formattedAddress;
}

//当选中一个annotation views时，调用此接口
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MAUserLocation class]]) {
        [self reGeoAction];
    }
    // 调整自定义callout的位置，使其可以完全显示
    if ([view isKindOfClass:[YLQAnnotationView class]]) {
        YLQAnnotationView *cusView = (YLQAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.customCalloutView.frame toView:_mapView];
        cusView.customCalloutView.delegate = self;
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kDefaultCalloutViewMargin, kDefaultCalloutViewMargin, kDefaultCalloutViewMargin, kDefaultCalloutViewMargin));
        
        if (!CGRectContainsRect(_mapView.frame, frame))
        {
            CGSize offset = [self offsetToContainRect:frame inRect:_mapView.frame];
            
            CGPoint theCenter = _mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:theCenter toCoordinateFromView:_mapView];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

//创建annotation 时调用 , 制定annotation样式
//1.MAUserLocation  2.MAPointAnnotation   3.自定义annotation
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *reuseIdentifier = @"annotationReuseIndetifier";
        YLQAnnotationView *annotationView = (YLQAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIdentifier];
        annotationView.customCalloutView.delegate = self;
        if (nil == annotationView)
        {
            annotationView = [[YLQAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        }
        annotationView.image = [UIImage imageNamed:@"annotationImage"];
        //设置中心点偏移, 使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        //不让弹出系统的calloutView
        annotationView.canShowCallout = NO;
        return annotationView;
    }
    return nil;
}

//实现路径搜索的回调函数
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    if(response.route == nil)
    {
        return;
    }
    
    //通过AMapNavigationSearchResponse对象处理搜索结果
//    NSString *route = [NSString stringWithFormat:@"Navi: %@", response.route];
    NSLog(@"路线: %@", response.route.paths);
    [_mapView removeOverlays:_pathPolylines];
    _pathPolylines = nil;
    
    // 只显示第一条
    _pathPolylines = [self polylinesForPath:response.route.paths[0]];
    [_mapView addOverlays:_pathPolylines];
    
    [_mapView showAnnotations:@[_destinationPoint, _mapView.userLocation] animated:YES];
}

//polyLine属性设置
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        polylineView.lineWidth   = 4;
        polylineView.strokeColor = [UIColor cyanColor];
        
        return polylineView;
    }
    
    return nil;
}

#pragma mark - Helpers
- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}
//点击按钮切换定位状态
- (void)locateAction
{
    switch (_mapView.userTrackingMode) {
        case MAUserTrackingModeNone:
            _mapView.userTrackingMode = MAUserTrackingModeFollow;
            break;
        case MAUserTrackingModeFollow:
            _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
            break;
        case MAUserTrackingModeFollowWithHeading:
            _mapView.userTrackingMode = MAUserTrackingModeNone;
            break;
        default:
            NSLog(@"状态错误");
            break;
    }
    NSLog(@"%zd  mode", _mapView.userTrackingMode);
}

//执行request , 逆地理编码
- (void)reGeoAction
{
    if (_currentLocation) {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        //通过坐标的 纬度, 经度
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
    }
}

- (void)searchAction
{
    if (nil == _currentLocation || nil == _search) {
        NSLog(@"search faild");
        return;
    }
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    request.radius = 50000;
    request.types = @"餐饮服务|生活服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    [_search AMapPOIAroundSearch:request];
}

- (void)jumpToDetailPage
{
    YLQDetailPageViewViewController *detailVC = [[UIStoryboard storyboardWithName:@"YLQDetailPageViewViewController" bundle:nil] instantiateInitialViewController];
    self.detailVC = detailVC;
    [self.navigationController pushViewController:self.detailVC animated:YES];
}

//步行路线搜索
- (void)pathAction
{
    if (_destinationPoint == nil || _currentLocation == nil || _search == nil)
    {
        NSLog(@"path search failed \n %@\n%@\n%@", _destinationPoint, _currentLocation, _search);
        return;
    }
    AMapWalkingRouteSearchRequest *request = [[AMapWalkingRouteSearchRequest alloc] init];
    request.origin = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    request.destination = [AMapGeoPoint locationWithLatitude:_destinationPoint.coordinate.latitude longitude:_destinationPoint.coordinate.longitude];
    
    [_search AMapWalkingRouteSearch:request];
}

- (NSArray *)polylinesForPath:(AMapPath *)path
{
//    if (path == nil || path.steps.count == 0)
//    {
//        return nil;
//    }
    
    NSMutableArray *polylines = [NSMutableArray array];
    
    [path.steps enumerateObjectsUsingBlock:^(AMapStep *step, NSUInteger idx, BOOL *stop) {
        
        NSUInteger count = 0;
        CLLocationCoordinate2D *coordinates = [self coordinatesForString:step.polyline coordinateCount:&count parseToken:@";"];
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:coordinates count:count];
        [polylines addObject:polyline];
        
        free(coordinates), coordinates = NULL;
    }];
    
    return polylines;
}

- (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
                                 coordinateCount:(NSUInteger *)coordinateCount
                                      parseToken:(NSString *)token
{
    if (string == nil)
    {
        return NULL;
    }
    
    if (token == nil)
    {
        token = @",";
    }
    
    NSString *str = @"";
    if (![token isEqualToString:@","])
    {
        str = [string stringByReplacingOccurrencesOfString:token withString:@","];
    }
    
    else
    {
        str = [NSString stringWithString:string];
    }
    
    NSArray *components = [str componentsSeparatedByString:@","];
    NSUInteger count = [components count] / 2;
    if (coordinateCount != NULL)
    {
        *coordinateCount = count;
    }
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D*)malloc(count * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < count; i++)
    {
        coordinates[i].longitude = [[components objectAtIndex:2 * i]     doubleValue];
        coordinates[i].latitude  = [[components objectAtIndex:2 * i + 1] doubleValue];
    }
    
    return coordinates;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        //坐标转换
        CLLocationCoordinate2D coordinate = [_mapView convertPoint:[gesture locationInView:_mapView] toCoordinateFromView:_mapView];
        //选择目的地
        // 添加标注
        if (_destinationPoint != nil) {
            //更新目的地标记
            // 清理
            [_mapView removeAnnotation:_destinationPoint]; _destinationPoint = nil;
        }
        _destinationPoint = [[MAPointAnnotation alloc] init];
        _destinationPoint.coordinate = coordinate;
        _destinationPoint.title = @"Destination";
        [_mapView addAnnotation:_destinationPoint];
    }
}


#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _pois.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIDentifer";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    AMapPOI *poi = _pois[indexPath.row];
    
    cell.textLabel.text = poi.name;
    cell.detailTextLabel.text = poi.address;
    return cell;
}

#pragma mark - TableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell背景选择后恢复
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //过滤重复点击事件
    if (_lastIndexPath == indexPath) {
        return;
    }
    _lastIndexPath = indexPath;
    
    // 为点击的poi点添加标注
    AMapPOI *poi = _pois[indexPath.row];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
    annotation.title = poi.name;
    annotation.subtitle = poi.address;

    [_annotations addObject:annotation];
    [_mapView addAnnotation:annotation];
    
    //将地图焦点移动到选中点
    _mapView.centerCoordinate = annotation.coordinate;
#warning 先这样
    // 添加标注
    if (_destinationPoint != nil)
    {
        // 清理
        _destinationPoint = nil;
        
        [_mapView removeOverlays:_pathPolylines];
        _pathPolylines = nil;
    }
    
    _destinationPoint = [[MAPointAnnotation alloc] init];
    _destinationPoint.coordinate = annotation.coordinate;
}
@end
