//
//  HRrilegouleView.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRContentView;
@class HRContentScrollView;
@class HREveryDayTableViewCell;
@interface HRrilegouleView : UIView
@property (nonatomic, strong) HRContentView *contentView;

@property (nonatomic, strong) HRContentScrollView *scrollView;

@property (nonatomic, strong)  HREveryDayTableViewCell *animationView;


@property (nonatomic ,strong) UIImageView *playView;

@property (nonatomic ,assign) NSInteger currentIndex;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray index:(NSInteger)index;

@property (nonatomic ,assign) CGFloat offsetY;
@property (nonatomic ,assign) CGAffineTransform animationTrans;

- (void)aminmationShow;
- (void)animationDismissUsingCompeteBlock:(void (^)(void))complete;


@end
