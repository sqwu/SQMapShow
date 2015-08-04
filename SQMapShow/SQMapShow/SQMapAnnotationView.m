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

@property (strong, nonatomic) UIImageView *backgroundImageView;     /**< 背景图片 */
@property (strong, nonatomic) UIImageView *userImageView;           /**< 用户头像 */

@end

@implementation SQMapAnnotationView

@synthesize backgroundImageView;
@synthesize userImageView;

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
    backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.frame = self.bounds;
    [self addSubview:backgroundImageView];
    
    userImageView = [[UIImageView alloc] init];
    userImageView.frame = CGRectMake(SQAnnotationViewMargin, SQAnnotationViewMargin, CGRectGetWidth(self.bounds) - 2 * SQAnnotationViewMargin, CGRectGetWidth(self.bounds) - 2 * SQAnnotationViewMargin);
    userImageView.layer.cornerRadius = (CGRectGetWidth(self.bounds) - 2 * SQAnnotationViewMargin) / 2;
    userImageView.clipsToBounds = YES;
    [self addSubview:userImageView];
}

- (void)updateWithMapAnnotation:(SQMapAnnotation *)mapAnnotation
{
    backgroundImageView.image = [UIImage imageNamed:@"background"];
    userImageView.image = mapAnnotation.image;
}

@end
