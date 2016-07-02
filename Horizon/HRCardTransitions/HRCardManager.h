//
//  HRCardManager.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HRCardTransition,HRCardReverseTransition,HRBaseClassViewController,HRDiscoverViewController;
@interface HRCardManager : NSObject<UIViewControllerTransitioningDelegate>
@property(nonatomic,strong)HRBaseClassViewController *mainController;
@property(nonatomic,strong)HRDiscoverViewController *discoverController;
@property(nonatomic,strong)HRCardTransition *cardAnimation;
@property(nonatomic,strong)HRCardReverseTransition *reverseAnimation;
@property(nonatomic,strong)UIPercentDrivenInteractiveTransition *interactionController;


@end
