//
//  HRContentView.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HREveryDayModel;
@class HRCustomView;
@interface HRContentView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *littleLabel;

@property (nonatomic, strong) UILabel *descripLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) HRCustomView *collectionCustom;

@property (nonatomic, strong) HRCustomView *shareCustom;

@property (nonatomic, strong) HRCustomView *cacheCustom;

@property (nonatomic, strong) HRCustomView *replyCustom;



- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width model:(HREveryDayModel *)model collor:(UIColor *)collor;

- (void)setData:(HREveryDayModel *)model;
@end
