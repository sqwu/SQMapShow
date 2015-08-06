//
//  SQMapAnnotationUtil.h
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@class SQMapAnnotation;
@class SQMapAnnotationView;

@protocol SQMapAnnotationUtilProtocol <NSObject>

- (MKAnnotationView *)annotationViewInMap:(MKMapView *)mapView;

@end

@interface SQMapAnnotationUtil : NSObject  <MKAnnotation, SQMapAnnotationUtilProtocol>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

/**
 *  用SQMapAnnotation初始化
 *
 *  @param mapAnnotation SQMapAnnotation
 *
 *  @return self
 */
+ (instancetype)annotationWithMapAnnotation:(SQMapAnnotation *)mapAnnotation;

@end
