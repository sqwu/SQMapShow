//
//  ViewController.m
//  SQMapShow
//
//  Created by sqwu on 15/8/6.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import "ViewController.h"
#import "SQMapShowViewController.h"
#import "SQUser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMap:(id)sender {
    SQUser *user1 = [[SQUser alloc] init];
    user1.userPhoto = [UIImage imageNamed:@"photo_0"];
    user1.userName = @"user1";
    CLLocationCoordinate2D coordinateUser1 = CLLocationCoordinate2DMake(0 * 0.001 + 40.018284, 0 * 0.002 + 116.345398);
    user1.coordinate = coordinateUser1;
    
    SQUser *user2 = [[SQUser alloc] init];
    user2.userPhoto = [UIImage imageNamed:@"photo_1"];
    user2.userName = @"user2";
    CLLocationCoordinate2D coordinateUser2 = CLLocationCoordinate2DMake(1 * 0.001 + 40.018284, 1 * 0.002 + 116.345398);
    user2.coordinate = coordinateUser2;
    
    SQUser *user3 = [[SQUser alloc] init];
    user3.userPhoto = [UIImage imageNamed:@"photo_2"];
    user3.userName = @"user3";
    CLLocationCoordinate2D coordinateUser3 = CLLocationCoordinate2DMake(2 * 0.001 + 40.018284, 2 * 0.002 + 116.345398);
    user3.coordinate = coordinateUser3;
    
    
    SQMapShowViewController *vc = [[SQMapShowViewController alloc] init];
    
    vc.usersArray = @[user1, user2, user3];
    
    [self presentViewController:vc animated:YES completion:nil];
}


@end
