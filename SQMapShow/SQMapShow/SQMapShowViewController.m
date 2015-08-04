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

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    mapView.delegate = self;
    [self.view insertSubview:mapView atIndex:0];
    
    [self locationManagerStart];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [mapView removeAnnotations:mapView.annotations];
    
    // 添加 Annotation
    [mapView addAnnotations:[self annotations]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (id annotation in mapView.selectedAnnotations) {
        [mapView deselectAnnotation:annotation animated:NO];
    }
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

- (IBAction)positionAction:(id)sender {
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView_ viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation conformsToProtocol:@protocol(SQMapAnnotationUtilProtocol)]) {
        return [((NSObject<SQMapAnnotationUtilProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
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
    [mapView setRegion:region animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

#pragma mark - helpers

- (void)clean
{
    [mapView removeAnnotations:mapView.annotations];
}

#pragma mark - getters

- (NSArray *)annotations
{
    SQMapAnnotation *mapAnnotation1 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser1 = CLLocationCoordinate2DMake(0 * 0.001 + 40.018284, 0 * 0.002 + 116.345398);
    mapAnnotation1.coordinate = coordinateUser1;
    mapAnnotation1.image = [UIImage imageNamed:@"photo_0"];
    
    SQMapAnnotation *mapAnnotation2 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser2 = CLLocationCoordinate2DMake(1 * 0.001 + 40.018284, 1 * 0.002 + 116.345398);
    mapAnnotation2.coordinate = coordinateUser2;
    mapAnnotation2.image = [UIImage imageNamed:@"photo_1"];
    
    SQMapAnnotation *mapAnnotation3 = [[SQMapAnnotation alloc] init];
    CLLocationCoordinate2D coordinateUser3 = CLLocationCoordinate2DMake(2 * 0.001 + 40.018284, 2 * 0.002 + 116.345398);
    mapAnnotation3.coordinate = coordinateUser3;
    mapAnnotation3.image = [UIImage imageNamed:@"photo_2"];
    
    
    return @[[SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation1],
             [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation2],
             [SQMapAnnotationUtil annotationWithMapAnnotation:mapAnnotation3]];
}

@end
