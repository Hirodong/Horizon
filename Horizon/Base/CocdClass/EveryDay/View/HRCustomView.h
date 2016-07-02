//
//  HRCustomView.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRCustomView : UIView

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UILabel *label;

- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width LabelString:(id)labelString collor:(UIColor *)collor;

- (void)setTitle:(id)title;
- (void)setColor:(UIColor *)color;
@end
