//
//  ViewController.m
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "SQMapShowViewController.h"

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
    
    for (int i = 0; i < 3; i++) {
        CLLocationCoordinate2D coordinateUser = CLLocationCoordinate2DMake(i * 0.001 + 37.3, i * 0.001 + (-112.03));
        
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
    MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.canShowCallout = YES;
    
    UIImage *resizedImage = ResizeImage([UIImage imageNamed:@"photo"], 25, 25, 2);
    
    annotationView.image = [self loadImage:resizedImage userId:nil withRadious:3.5];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
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

#pragma mark - helpers

UIImage *ResizeImage(UIImage *image, CGFloat width, CGFloat height, CGFloat scale) {
    CGSize size = CGSizeMake(width, height);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [image drawInRect:rect];
    UIImage *resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized;
}

- (UIImage *)loadImage:(UIImage *)image userId:(NSString *)userId withRadious:(CGFloat)radious
{
    if (image == nil) return nil;
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGRect rect = CGRectMake(0, 0, imageWidth, imageHeight);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 2.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, radious, radious);
    
    CGFloat rectWidth = CGRectGetWidth (rect)/radious;
    CGFloat rectHeight = CGRectGetHeight (rect)/radious;
    
    CGContextMoveToPoint(context, rectWidth, rectHeight/2.0f);
    CGContextAddArcToPoint(context, rectWidth, rectHeight, rectWidth/2, rectHeight, radious);
    CGContextAddArcToPoint(context, 0, rectHeight, 0, rectHeight/2, radious);
    CGContextAddArcToPoint(context, 0, 0, rectWidth/2, 0, radious);
    CGContextAddArcToPoint(context, rectWidth, 0, rectWidth, rectHeight/2, radious);
    CGContextRestoreGState(context);
    CGContextClosePath(context);
    CGContextClip(context);
    
    [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)clean
{
    [mapView removeAnnotations:mapView.annotations];
}

@end
