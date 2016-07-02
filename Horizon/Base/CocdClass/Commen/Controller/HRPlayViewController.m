//
//  HRPlayViewController.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HRPlayViewController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "HREveryDayModel.h"
@implementation HRPlayViewController
- (void)setModelArray:(NSArray *)modelArray {
    
    if (![modelArray isEqualToArray:_modelArray]) {
        
        _modelArray = modelArray;
    }
}

- (void)setIndex:(NSInteger)index {
    
    if (index != _index) {
        
        _index = index;
        
        HREveryDayModel *model = [_modelArray objectAtIndex:index];
        [self setContentURL:[NSURL URLWithString:model.playUrl]];
    }
    
}

@end
