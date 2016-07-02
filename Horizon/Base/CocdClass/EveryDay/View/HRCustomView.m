//
//  HRCustomView.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRCustomView.h"

@implementation HRCustomView

- (instancetype)initWithFrame:(CGRect)frame Width:(CGFloat)width LabelString:(id)labelString collor:(UIColor *)collor{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGFloat totalWidth = self.frame.size.width;
        CGFloat totalHeight = self.frame.size.height;
        
        _button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        
        _button.frame = CGRectMake(0, 0, width, totalHeight);
        
        _button.tintColor = collor;
        
        [self addSubview:_button];
        
        _label = [[UILabel alloc]initWithFrame:CGRectMake(width, 0, totalWidth - width, totalHeight)];
        
        _label.textColor = collor;
        
        NSString *string = [NSString stringWithFormat:@"%@",labelString];
        
        _label.text = string;
        
        NSLog(@"%@",string);
        
        _label.font = [UIFont systemFontOfSize:14];
        
        [self addSubview:_label];
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    self.label.text =[NSString stringWithFormat:@"%@",title];
}

- (void)setColor:(UIColor *)color {
    
    self.button.tintColor = color;
    self.label.textColor = color;
}

@end
