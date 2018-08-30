//
//  CalendarManager.m
//  WePlan
//
//  Created by Harry on 2018/8/15.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "CalendarManager.h"
#import <EventKit/EventKit.h>

@interface CalendarManager()

@end

@implementation CalendarManager

#pragma mark -- 懒加载
+ (instancetype)manager {
    static CalendarManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CalendarManager new];
    });
    return instance;
}

@end
