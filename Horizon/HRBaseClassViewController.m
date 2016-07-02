//
//  HRBaseClassViewController.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRBaseClassViewController.h"
#import "HRCardManager.h"

#import "HRMainViewController.h"


@interface HRBaseClassViewController ()
@property(nonatomic,strong)HRCardManager *transitionManager;



@end

@implementation HRBaseClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    self.view.backgroundColor = [UIColor blackColor];
    _mainVC =[[HRMainViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:_mainVC];
    nav.navigationBar.translucent = YES;//设置半透明
    [self addChildViewController:nav];
    [self.view addSubview:nav.view];
    
 

}


-(void)viewDidAppear:(BOOL)animated {
    
 
    self.transitionManager = [[HRCardManager alloc]init];
    self.transitionManager.mainController =self;
}


@end
