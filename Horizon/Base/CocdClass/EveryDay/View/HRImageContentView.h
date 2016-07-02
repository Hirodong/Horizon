//
//  HRImageContentView.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HRContentView;
@class HREveryDayModel;
@interface HRImageContentView : UIView

@property (nonatomic, strong) UIImageView *picture;

- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width model:(HREveryDayModel *)model collor:(UIColor *)collor;

- (void)imageOffset;
@end
