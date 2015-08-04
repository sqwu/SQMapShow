//
//  ViewController.m
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "ViewController.h"

#import "TestViewController.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D coordinate;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

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
    
    for (int i = 0; i < 3; i++) {
        CLLocationCoordinate2D coordinateUser = CLLocationCoordinate2DMake(i * 10 + 37.3, i * 10 + (-112.03));
        
        MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
        pointAnnotation.coordinate = coordinateUser;
        pointAnnotation.title = @"点我啊";
        
        [mapView addAnnotation:pointAnnotation];
    }
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

#pragma mark - helpers

- (void)clean
{
    [mapView removeAnnotations:mapView.annotations];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView_ viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.canShowCallout = YES;
    
    annotationView.image = [UIImage imageNamed:@"photo"];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView_ annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    TestViewController *vc = [[TestViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
    [mapView deselectAnnotation:view.annotation animated:YES];
}

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

@end
