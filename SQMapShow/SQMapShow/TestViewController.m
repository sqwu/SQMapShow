//
//  TestViewController.m
//  SQMapShow
//
//  Created by sqwu on 15/8/4.
//  Copyright (c) 2015年 sqwu.com. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *userPhotoImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userPhotoImageView.layer.cornerRadius = CGRectGetWidth(self.userPhotoImageView.frame) / 2;
    self.userPhotoImageView.clipsToBounds = YES;
    
    self.userPhotoImageView.image = self.userPhoto;
    self.userNameLabel.text = self.userName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
