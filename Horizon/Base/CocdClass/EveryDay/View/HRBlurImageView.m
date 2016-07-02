//
//  HRBlurImageView.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRBlurImageView.h"

@implementation HRBlurImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        //设置图片
        self.image = [UIImage imageNamed:@"11471923,2560,1600.jpg"];
        //创建模糊视图
        UIVisualEffectView *backVisual = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        //将模糊视图的大小等同于自身
        backVisual.frame = self.bounds;
        //设置模糊视图的透明度
        backVisual.alpha = 1;
        [self addSubview:backVisual];
        
    }
    return self;
}

@end
