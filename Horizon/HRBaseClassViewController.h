//
//  HRBaseClassViewController.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HRMainViewController;
@interface HRBaseClassViewController : UIViewController

@property (nonatomic, strong) HRMainViewController *mainVC;
@property (nonatomic,assign)NSInteger flag;
@end
