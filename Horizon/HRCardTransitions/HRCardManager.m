//
//  HRCardManager.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRCardManager.h"
#import "HRDiscoverViewController.h"
#import "HRBaseClassViewController.h"
#import "HRCardTransition.h"
#import "HRCardReverseTransition.h"
@implementation HRCardManager
- (void)setMainController:(HRBaseClassViewController *)mainController{
    
    self.cardAnimation = [[HRCardTransition alloc]init];
    self.reverseAnimation = [[HRCardReverseTransition alloc]init];
    
    _mainController = mainController;
    UIScreenEdgePanGestureRecognizer *panGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(gestureHandler:)];
    panGesture.edges = UIRectEdgeLeft;
    
    [self.mainController.view.superview addGestureRecognizer:panGesture];
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)gestureHandler:(UIScreenEdgePanGestureRecognizer*)recognizer{
    
    CGPoint location = [recognizer locationInView:self.mainController.view.superview];
    CGPoint velocity = [recognizer velocityInView:self.mainController.view.superview];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (location.x < CGRectGetMidX(recognizer.view.bounds)) {
            if(!self.discoverController){
                self.interactionController = [[UIPercentDrivenInteractiveTransition alloc]init];
                self.discoverController = [[HRDiscoverViewController alloc]init];
                self.discoverController.transitioningDelegate = self;
                [self.mainController presentViewController:self.discoverController animated:YES completion:nil];
            }
        }
    }
    
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat animationRatio = location.x / CGRectGetWidth(self.mainController.view.superview.bounds);
        [self.interactionController updateInteractiveTransition:animationRatio];
    }
    
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (velocity.x > 0) {
            [self.interactionController finishInteractiveTransition];
        }
        else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

#pragma mark - UIVieControllerTransitioningDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    return self.cardAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.reverseAnimation;
}


- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.interactionController;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}


@end
