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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    // 添加 Annotation
    [self.mapView addAnnotations:[self annotations]];
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
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    [self.mapView setRegion:region animated:YES];
}

// ===========  TEST ===========
- (IBAction)addOneUserAction:(id)sender {
    SQMapAnnotation *mapAnnotation = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser = CLLocationCoordinate2DMake(40, 116);
    mapAnnotation.coordinate = coordinateUser;
    mapAnnotation.image = [UIImage imageNamed:@"imgAdd_1"];
    mapAnnotation.title = @"user1";
    mapAnnotation.user = nil;
    
    [self.mapView addAnnotations:@[[SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation]]];
}

- (IBAction)addMoreUsersAction:(id)sender {
    SQMapAnnotation *mapAnnotation1 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser1 = CLLocationCoordinate2DMake(39, 116);
    mapAnnotation1.coordinate = coordinateUser1;
    mapAnnotation1.image = [UIImage imageNamed:@"imgAdd_2"];
    mapAnnotation1.title = @"user1";
    mapAnnotation1.user = nil;
    
    SQMapAnnotation *mapAnnotation2 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser2 = CLLocationCoordinate2DMake(39, 118);
    mapAnnotation2.coordinate = coordinateUser2;
    mapAnnotation2.image = [UIImage imageNamed:@"imgAdd_3"];
    mapAnnotation2.title = @"user1";
    mapAnnotation2.user = nil;
    
    [self.mapView addAnnotations:@[[SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation1],
                                   [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation2]]];
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
    
//    SQMapAnnotationView *mapAnnotationView = (SQMapAnnotationView *)view;
    
    
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
    mapAnnotation1.title = @"user2";
    mapAnnotation1.user = nil;
    
    SQMapAnnotation *mapAnnotation3 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser3 = CLLocationCoordinate2DMake(2 * 0.001 + 40.018284, 2 * 0.002 + 116.345398);
    mapAnnotation3.coordinate = coordinateUser3;
    mapAnnotation3.image = [UIImage imageNamed:@"photo_2"];
    mapAnnotation1.title = @"user3";
    mapAnnotation1.user = nil;
    
    
    return @[[SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation1],
             [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation2],
             [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation3]];
}

@end
