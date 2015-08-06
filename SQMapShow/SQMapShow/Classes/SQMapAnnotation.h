//
//  SQMapAnnotation.h
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SQUser;
@import MapKit;

@interface SQMapAnnotation : NSObject

@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

/**
 *  接收外部传递参数
 */
@property (strong, nonatomic) SQUser *user;

@end
