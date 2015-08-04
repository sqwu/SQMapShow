//
//  SQMapAnnotationView.m
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import "SQMapAnnotationView.h"
#import "SQMapAnnotation.h"

NSString * const SQAnnotationViewReuseID = @"SQMapAnnotationView";

static CGFloat const SQAnnotationViewWidth = 86.0f;
static CGFloat const SQAnnotationViewHeight = 95.0f;
static CGFloat const SQAnnotationViewMargin = 15.0f;

@interface SQMapAnnotationView ()

@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;

@property (strong, nonatomic) UIImageView *backgroundImageView;     /**< 背景图片 */
@property (strong, nonatomic) UIImageView *userImageView;           /**< 用户头像 */

@end

@implementation SQMapAnnotationView

- (id)initWithAnnotationView:(id<MKAnnotation>)annotation
{
    self = [super initWithAnnotation:annotation reuseIdentifier:SQAnnotationViewReuseID];
    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, SQAnnotationViewWidth, SQAnnotationViewHeight);
        self.backgroundColor = [UIColor clearColor];
        
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.frame = self.bounds;
    [self addSubview:self.backgroundImageView];
    
    self.userImageView = [[UIImageView alloc] init];
    self.userImageView.frame = CGRectMake(SQAnnotationViewMargin, SQAnnotationViewMargin, CGRectGetWidth(self.bounds) - 2 * SQAnnotationViewMargin, CGRectGetWidth(self.bounds) - 2 * SQAnnotationViewMargin);
    self.userImageView.layer.cornerRadius = (CGRectGetWidth(self.bounds) - 2 * SQAnnotationViewMargin) / 2;
    self.userImageView.clipsToBounds = YES;
    [self addSubview:self.userImageView];
}

- (void)updateWithMapAnnotation:(SQMapAnnotation *)mapAnnotation
{
    self.coordinate = mapAnnotation.coordinate;
    self.backgroundImageView.image = [UIImage imageNamed:@"background"];
    self.userImageView.image = mapAnnotation.image;
}

#pragma mark - SQMapAnnotationViewProtocol

- (void)didSelectAnnotationViewInMap:(MKMapView *)mapView
{
    [mapView setCenterCoordinate:self.coordinate animated:YES];
}

- (void)didDeselectAnnotationViewInMap:(MKMapView *)mapView
{
    
}

@end
