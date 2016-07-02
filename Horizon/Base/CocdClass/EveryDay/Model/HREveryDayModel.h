//
//  HREveryDayModel.h
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HREveryDayModel : NSObject
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSNumber *collectionCount;

@property (nonatomic, strong) NSNumber *replyCount;

@property (nonatomic, strong) NSNumber *shareCount;

@property (nonatomic, strong) NSString *coverBlurred;

@property (nonatomic, strong) NSString *coverForDetail;

@property (nonatomic, strong) NSString *descrip;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *duration;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *playUrl;
@end
