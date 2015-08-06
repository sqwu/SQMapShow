//
//  SQMapAnnotationUtil.m
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import "SQMapAnnotationUtil.h"
#import "SQMapAnnotation.h"
#import "SQMapAnnotationView.h"

@interface SQMapAnnotationUtil ()

@property (nonatomic, readwrite) SQMapAnnotationView *mapAnnotationView;
@property (nonatomic, readonly) SQMapAnnotation *mapAnnotation;

@end

@implementation SQMapAnnotationUtil

+ (instancetype)annotationWithMapAnnotation:(SQMapAnnotation *)mapAnnotation
{
    return [[self alloc] initWithMapAnnotation:mapAnnotation];
}

- (id)initWithMapAnnotation:(SQMapAnnotation *)mapAnnotation
{
    self = [super init];
    if (self) {
        _coordinate = mapAnnotation.coordinate;
        _mapAnnotation = mapAnnotation;
    }
    return self;
}

#pragma mark - SQMapAnnotationUtilProtocol

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView {
    if (!self.mapAnnotationView) {
        self.mapAnnotationView = (SQMapAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:SQAnnotationViewReuseID];
        if (!self.mapAnnotationView) {
            self.mapAnnotationView = [[SQMapAnnotationView alloc] initWithAnnotationView:self];
        }
    } else {
        self.mapAnnotationView.annotation = self;
    }
    [self updateMapAnnotation:self.mapAnnotation animated:NO];
    return self.mapAnnotationView;
}

- (void)updateMapAnnotation:(SQMapAnnotation *)mapAnnotation animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.33f animations:^{
            _coordinate = mapAnnotation.coordinate;
        }];
    } else {
        _coordinate = mapAnnotation.coordinate;
    }
    
    [self.mapAnnotationView updateWithMapAnnotation:mapAnnotation];
}

@end
