//
//  HRCardTransition.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRCardTransition.h"

@implementation HRCardTransition
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect sourceRect = [transitionContext initialFrameForViewController:fromVC];
    
    CGAffineTransform rotation;
    rotation = CGAffineTransformRotate(fromVC.view.transform, -179 * M_PI/180.0);
    fromVC.view.frame = sourceRect;
    fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.0);
    fromVC.view.layer.position = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 0);
    
    UIView *container = [transitionContext containerView];
    [container insertSubview:toVC.view belowSubview:fromVC.view];
    __block CGPoint toCenter = toVC.view.center;
    
    [container addSubview:fromVC.view];
    
    toVC.view.center = CGPointMake(-sourceRect.size.width, sourceRect.size.height);
    toVC.view.transform = CGAffineTransformMakeRotation(M_PI/2);
    
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         fromVC.view.transform = rotation;
                         toVC.view.center = toCenter;
                         toVC.view.transform = CGAffineTransformMakeRotation(0);
                     } completion:^(BOOL finished) {
                         CGAffineTransform rotation2;
                         rotation2 = CGAffineTransformRotate(fromVC.view.transform, -1 * M_PI/180.0);
                         fromVC.view.transform = rotation2;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                     }];
    
    
}
@end
