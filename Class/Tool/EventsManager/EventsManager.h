//
//  EventsManager.h
//  WePlan
//
//  Created by Harry on 2018/8/30.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface EKEventModel : NSObject

@property (nonatomic, strong) NSString *title;                          //标题
@property (nonatomic, strong) NSString *location;                       //地点
@property (nonatomic, strong) NSString *startDateStr;                   //开始时间
@property (nonatomic, strong) NSString *endDateStr;                     //结束时间
@property (nonatomic, assign) BOOL allDay;                              //是否全天
@property (nonatomic, strong) NSString *notes;                          //备注
@property (nonatomic, strong) NSString *alarmStr;                       //提醒

- (instancetype)eventTitle:(NSString *)title Location:(NSString *)location StartDateStr:(NSString *)startDateStr EndDateStr:(NSString *)endDateStr AllDay:(BOOL)allDay Notes:(NSString *)notes AlarmStr:(NSString *)alarmStr;

@end


@interface EventsManager : NSObject
+ (instancetype)manager;

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
- (void)createEventWithEventModel:(EKEventModel *)eventModel;
//删除事件必须 之前创建过，只能删除通过工具创建的事件

/**
 *  删除事件
 */
- (BOOL)deleteEvent:(EKEventModel *)eventModel;

/**
 *  删除用户创建的所有事件
 */
- (void)deleteAllCreatedEvent;

@end


