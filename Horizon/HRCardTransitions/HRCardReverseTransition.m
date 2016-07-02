//
//  HRCardReverseTransition.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRCardReverseTransition.h"

@implementation HRCardReverseTransition
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect sourceRect = [transitionContext initialFrameForViewController:fromVC];
    
    CGAffineTransform rotation;
    rotation = CGAffineTransformMakeRotation(M_PI);
    UIView *container = [transitionContext containerView];
    fromVC.view.frame = sourceRect;
    fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
    fromVC.view.layer.position = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 0);
    
    [container insertSubview:toVC.view belowSubview:fromVC.view];
    toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
    toVC.view.layer.position = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 0);
    toVC.view.transform = CGAffineTransformRotate(fromVC.view.transform, M_PI);
    
    [UIView animateWithDuration:1.0
                          delay:0.0
         usingSpringWithDamping:0.8
          initialSpringVelocity:6.0
                        options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
                         
                         fromVC.view.center = CGPointMake(fromVC.view.center.x - [UIScreen mainScreen].bounds.size.width, fromVC.view.center.y);
                         toVC.view.transform = CGAffineTransformMakeRotation(-0);
                     } completion:^(BOOL finished) {
                         
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
}



@end
