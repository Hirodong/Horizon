//
//  HRContentScrollView.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRImageContentView;
@class HRContentScrollView;

@protocol  HRContentScrollView<UIScrollViewDelegate>
- (void)headerScroll:(HRContentScrollView *)scroll didSelectItemAtIndex:(NSInteger)index;
- (void)headerScroll:(HRContentScrollView *)scroll didClose:(BOOL)close;



@end
@interface HRContentScrollView : UIScrollView

@property (nonatomic ,assign ,readonly) NSInteger currentIndex;

- (void)setCurrentIndex:(NSInteger)currentIndex;

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray index:(NSInteger)index;
@end
