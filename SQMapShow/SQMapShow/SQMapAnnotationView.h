//
//  SQMapAnnotationView.h
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import <MapKit/MapKit.h>

@class SQMapAnnotation;

@interface SQMapAnnotationView : MKAnnotationView

/**
 *  初始化AnnotationView
 *
 *  @param annotation <MKAnnotation>annotation
 *
 *  @return AnnotationView
 */
- (id)initWithAnnotationView:(id<MKAnnotation>)annotation;

/**
 *  更新界面
 *
 *  @param mapAnnotation SQMapAnnotation
 */
- (void)updateWithMapAnnotation:(SQMapAnnotation *)mapAnnotation;

@end
