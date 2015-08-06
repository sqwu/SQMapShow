//
//  ViewController.m
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SQMapShowViewController.h"
#import "SQMapAnnotation.h"
#import "SQMapAnnotationView.h"
#import "SQMapAnnotationUtil.h"

#import "TestViewController.h"

@interface SQMapShowViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
}

@property (strong, nonatomic) MKMapView *mapView;


@end

@implementation SQMapShowViewController

//@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.zoomEnabled = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsBuildings = YES;
    self.mapView.rotateEnabled = YES;
    self.mapView.delegate = self;
    [self.view insertSubview:self.mapView atIndex:0];
    
    [self locationManagerStart];
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 添加 Annotation
    [self.mapView addAnnotations:[self annotations]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    for (id annotation in self.mapView.selectedAnnotations) {
//        [self.mapView deselectAnnotation:annotation animated:NO];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)leftMenuAction:(id)sender {
    TestViewController *vc = [[TestViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)rightMenuAction:(id)sender {
    TestViewController *vc = [[TestViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

// 定位
- (IBAction)positionAction:(id)sender {
     [locationManager startUpdatingLocation];
}

// ===========  TEST ===========
- (IBAction)addOneUserAction:(id)sender {
    SQMapAnnotation *mapAnnotation = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser = CLLocationCoordinate2DMake(40, 116);
    mapAnnotation.coordinate = coordinateUser;
    mapAnnotation.image = [UIImage imageNamed:@"imgAdd_1"];
    mapAnnotation.title = @"userAdd1";
    mapAnnotation.user = nil;
    
    [self.mapView addAnnotations:@[[SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation]]];
    
//    MKCoordinateRegion region;
//    region.center.latitude = coordinateUser.latitude;
//    region.center.longitude = coordinateUser.longitude;
//    region.span.latitudeDelta = 0.8;
//    region.span.longitudeDelta = 0.8;
    
    MKCoordinateRegion region = [self fillRegionWithAnnotations:self.mapView.annotations centerCoordinate:coordinate];
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)addMoreUsersAction:(id)sender {
    SQMapAnnotation *mapAnnotation1 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser1 = CLLocationCoordinate2DMake(39, 116);
    mapAnnotation1.coordinate = coordinateUser1;
    mapAnnotation1.image = [UIImage imageNamed:@"imgAdd_2"];
    mapAnnotation1.title = @"userAdd2";
    mapAnnotation1.user = nil;
    
    SQMapAnnotation *mapAnnotation2 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser2 = CLLocationCoordinate2DMake(39, 118);
    mapAnnotation2.coordinate = coordinateUser2;
    mapAnnotation2.image = [UIImage imageNamed:@"imgAdd_3"];
    mapAnnotation2.title = @"userAdd3";
    mapAnnotation2.user = nil;
    
    [self.mapView addAnnotations:@[[SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation1],
                                   [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation2]]];
    
    MKCoordinateRegion region = [self fillRegionWithAnnotations:self.mapView.annotations centerCoordinate:coordinate];
    
    [self.mapView setRegion:region animated:YES];
}

- (IBAction)logoutOneUserAction:(id)sender {
    SQMapAnnotationUtil *mapAnnotation = self.mapView.annotations.firstObject;
    [self.mapView removeAnnotation:mapAnnotation];
}

- (IBAction)logoutAllUsersAction:(id)sender {
    [self.mapView removeAnnotations:self.mapView.annotations];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation conformsToProtocol:@protocol(SQMapAnnotationUtilProtocol)]) {
        return [((NSObject<SQMapAnnotationUtilProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view conformsToProtocol:@protocol(SQMapAnnotationViewProtocol)]) {
        [((NSObject<SQMapAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
    
    SQMapAnnotationView *mapAnnotationView = (SQMapAnnotationView *)view;
    NSLog(@"select: %@", mapAnnotationView.mapAnnotation.title);
    
    
    TestViewController *vc = [[TestViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

//- (void)mapView:(MKMapView *)mapView_ annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    TestViewController *vc = [[TestViewController alloc] init];
//    [self presentViewController:vc animated:YES completion:nil];
//    
//    [mapView deselectAnnotation:view.annotation animated:YES];
//}

#pragma mark - Location manager methods

- (void)locationManagerStart
{
    if (locationManager == nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

- (void)locationManagerStop
{
    [locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    coordinate = newLocation.coordinate;
    
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [self.mapView setRegion:region animated:YES];
    
    // 定位成功后关闭实时定位
    [locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

#pragma mark - helpers

- (void)clean
{
    [self.mapView removeAnnotations:self.mapView.annotations];
}

- (MKCoordinateRegion)fillRegionWithAnnotations:(NSArray *)annotations centerCoordinate:(CLLocationCoordinate2D)coord
{
#define MAP_PADDING 1.1
    // we'll make sure that our minimum vertical span is about a kilometer
    // there are ~111km to a degree of latitude. regionThatFits will take care of
    // longitude, which is more complicated, anyway.
#define MINIMUM_VISIBLE_LATITUDE 0.001
    CLLocationDegrees minLatitude = DBL_MAX;
    CLLocationDegrees maxLatitude = -DBL_MAX;
    CLLocationDegrees minLongitude = DBL_MAX;
    CLLocationDegrees maxLongitude = -DBL_MAX;
    
    for (id<MKAnnotation> annotation in annotations) {
        coord = annotation.coordinate;
        if (minLatitude > coord.latitude)
            minLatitude = coord.latitude;
        if (maxLatitude < coord.latitude)
            maxLatitude = coord.latitude;
        if (minLongitude > coord.longitude)
            minLongitude = coord.longitude;
        if (maxLongitude < coord.longitude)
            maxLongitude = coord.longitude;
    }
    
    if ((coord.latitude - minLatitude) > (maxLatitude - coord.latitude))
        maxLatitude = coord.latitude + coord.latitude - minLatitude;
    else
        minLatitude = coord.latitude - (maxLatitude - coord.latitude);
    if ((coord.longitude - minLongitude) > (maxLongitude - coord.longitude))
        maxLongitude = coord.longitude + coord.longitude - minLongitude;
    else
        minLongitude = coord.longitude - (maxLongitude - coord.longitude);
    
    MKCoordinateRegion region;
    region.center.latitude = (minLatitude + maxLatitude) / 2;
    region.center.longitude = (minLongitude + maxLongitude) / 2;
    
    region.span.latitudeDelta = (maxLatitude - minLatitude) * MAP_PADDING;
    
    region.span.latitudeDelta = (region.span.latitudeDelta < MINIMUM_VISIBLE_LATITUDE) ? MINIMUM_VISIBLE_LATITUDE : region.span.latitudeDelta;
    region.span.longitudeDelta = (maxLongitude - minLongitude) * MAP_PADDING;
    return region;
}

#pragma mark - getters

- (NSArray *)annotations
{
    SQMapAnnotation *mapAnnotation1 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser1 = CLLocationCoordinate2DMake(0 * 0.001 + 40.018284, 0 * 0.002 + 116.345398);
    mapAnnotation1.coordinate = coordinateUser1;
    mapAnnotation1.image = [UIImage imageNamed:@"photo_0"];
    mapAnnotation1.title = @"user1";
    mapAnnotation1.user = nil;
    
    SQMapAnnotation *mapAnnotation2 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser2 = CLLocationCoordinate2DMake(1 * 0.001 + 40.018284, 1 * 0.002 + 116.345398);
    mapAnnotation2.coordinate = coordinateUser2;
    mapAnnotation2.image = [UIImage imageNamed:@"photo_1"];
    mapAnnotation2.title = @"user2";
    mapAnnotation2.user = nil;
    
    SQMapAnnotation *mapAnnotation3 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser3 = CLLocationCoordinate2DMake(2 * 0.001 + 40.018284, 2 * 0.002 + 116.345398);
    mapAnnotation3.coordinate = coordinateUser3;
    mapAnnotation3.image = [UIImage imageNamed:@"photo_2"];
    mapAnnotation3.title = @"user3";
    mapAnnotation3.user = nil;
    
    
    return @[[SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation1],
             [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation2],
             [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation3]];
}

@end
