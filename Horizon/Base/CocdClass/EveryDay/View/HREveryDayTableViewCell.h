//
//  HREveryDayTableViewCell.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HREveryDayModel;
@interface HREveryDayTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *picture;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *littleLabel;

@property (nonatomic, strong) UIView *coverview;

@property (nonatomic, strong) HREveryDayModel *model;

- (CGFloat)cellOffset;
@end
