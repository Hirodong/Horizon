//
//  HRContentScrollView.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRContentScrollView.h"
#import "HRImageContentView.h"
#import "HREveryDayModel.h"
@interface HRContentScrollView ()
@property (nonatomic ,assign ,readwrite) NSInteger currentIndex;
@end
@implementation HRContentScrollView
- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray index:(NSInteger)index{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.contentSize = CGSizeMake([imageArray count] * kWidth, 0);
        
        self.bounces = NO;
        
        self.pagingEnabled = YES;
        
        self.contentOffset = CGPointMake(index * kWidth, 0);
        
        for (int i = 0; i < [imageArray count]; i ++) {
            
            HRImageContentView *sonView = [[HRImageContentView alloc]initWithFrame:CGRectMake(i * kWidth, 0, kWidth, kHeight) Width:35 model:imageArray[i] collor:[UIColor whiteColor]];
            
            HREveryDayModel *model = [[HREveryDayModel alloc]init];
            
            model = imageArray[i];
            
            [sonView.picture sd_setImageWithURL:[NSURL URLWithString:model.coverForDetail] placeholderImage:nil];
            
            [self addSubview:sonView];;
        }
        
    }
    return self;
}


@end
