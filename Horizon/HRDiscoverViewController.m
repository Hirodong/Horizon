//
//  HRDiscoverViewController.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRDiscoverViewController.h"



#import "TencentNewsViewController.h"
@interface HRDiscoverViewController ()



@end

@implementation HRDiscoverViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor orangeColor];
    
    TencentNewsViewController *notification = [[TencentNewsViewController alloc]init];
    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:notification];
    naVC.navigationBar.translucent =YES;
    [self addChildViewController:naVC];
    [self.view addSubview:naVC.view];
//    NetEaseViewController *netEase = [[NetEaseViewController alloc]init];
//    UINavigationController *naVC=[[UINavigationController alloc]initWithRootViewController:netEase];
//    naVC.navigationBar.translucent = YES;
//    [self addChildViewController:naVC];
//    [self.view addSubview:naVC.view];
 

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
