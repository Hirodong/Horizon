//
//  HREveryDayModel.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "HREveryDayModel.h"

@implementation HREveryDayModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"description"]) {
        
        self.descrip = value;
           
    }
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = [value stringValue];

    }
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    
    [super setValue:value forKey:key];
    
    if ([key isEqualToString:@"duration"]) {
        
        self.duration = [value stringValue];
     
    }
    
  
    
}

@end
