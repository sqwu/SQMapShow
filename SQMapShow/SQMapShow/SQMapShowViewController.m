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

#import "TestViewController.h"

@interface SQMapShowViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SQMapShowViewController

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mapView.delegate = self;
    
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
    SQMapAnnotationView *mapAnnotationView = (SQMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([SQMapAnnotationView class])];
    if (mapAnnotationView == nil) {
        mapAnnotationView = [[SQMapAnnotationView alloc] initWithAnnotationView:annotation];
    }
    
    
    SQMapAnnotation *mapAnnotation = [[SQMapAnnotation alloc] init];
    mapAnnotation.image = [UIImage imageNamed:@"photo"];
    
    [mapAnnotationView updateWithMapAnnotation:mapAnnotation];
    
    return mapAnnotationView;
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
//    region.center.latitude = coordinate.latitude;
//    region.center.longitude = coordinate.longitude;
    region.center.latitude = 37.3;
    region.center.longitude = -112.03;
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
    NSMutableArray *mutAnnotations = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        SQMapAnnotation *mapAnnotation = [[SQMapAnnotation alloc] init];
        CLLocationCoordinate2D coordinateUser = CLLocationCoordinate2DMake(i * 0.001 + 37.3, i * 0.002 + (-112.03));
        mapAnnotation.coordinate = coordinateUser;
        [mutAnnotations addObject:mapAnnotation];
    }
    
    return mutAnnotations;
}

@end
