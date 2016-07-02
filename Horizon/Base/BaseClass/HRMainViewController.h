//
//  HRMainViewController.h
//  Horizon
//
//  Created by Hiro on 16/5/30.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HREveryDayTableViewController;
@class HRrilegouleView;
@interface HRMainViewController : UIViewController
@property (nonatomic, strong) HREveryDayTableViewController *everyDayVC;

@property (nonatomic, strong) HRrilegouleView *rilegoule;

@property (nonatomic, strong) UIImageView *BlurredView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end
