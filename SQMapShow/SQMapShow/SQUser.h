//
//  SQUser.h
//  SQMapShow
//
//  Created by sqwu on 15/8/5.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQUser : NSObject

/**
 *  用户姓名
 */
@property (copy, nonatomic) NSString *userName;

/**
 *  用户id
 */
@property (assign, nonatomic) NSInteger userId;

@end
