//
//  EventsManager.h
//  WePlan
//
//  Created by Harry on 2018/8/30.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EventsManager : NSObject
@property (nonatomic, strong) EKEventStore *eventStore;

+ (instancetype)manager;
- (EKCalendar *)createClandar;

/**
 创建日历事件
 @param title 标题
 @param location 地点
 @param startDateStr 开始时间
 @param endDateStr 结束时间
 @param allDay 是否全天
 @param notes 备注
 @param alarmStr 提醒时间
 */
- (void)createEventWithEvent:(EKEvent *)ekEvent;
//删除事件必须 之前创建过，只能删除通过工具创建的事件

/**
 *  删除事件
 */
- (BOOL)deleteEvent:(EKEvent *)ekEvent;

/**
 *  删除用户创建的所有事件
 */
- (void)deleteAllCreatedEvent;

//查询
+ (nullable EKEvent *)eventWithIdentifier:(NSString *)identifier;
+ (NSArray <EKEvent *> *)getEventsCalendars:(NSArray <EKCalendar *> *)calendars;
+ (NSDate *)getCalendarDateYear:(NSInteger)year Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute;
@end


