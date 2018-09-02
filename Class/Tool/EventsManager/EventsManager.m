//
//  EventsManager.m
//  WePlan
//
//  Created by Harry on 2018/8/30.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "EventsManager.h"
@interface EventsManager()

@end
@implementation EventsManager

#pragma mark -- 懒加载
+ (instancetype)manager {
    static EventsManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [EventsManager new];
    });
    return instance;
}

- (EKEventStore *)eventStore {
    if (_eventStore) return _eventStore;
    _eventStore = [EKEventStore new];
    return _eventStore;
}

//TODO: 创建事件调用方法
/**
 *  创建事件
 */
- (void )createEventWithEvent:(EKEvent *)ekEvent {

    if ([self.eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {

            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"添加失败");
                } else if (!granted) {
                    NSLog(@"被拒绝");
                } else {
                    [self addEventWithEvent:ekEvent];
                }
            }) ;
        }];
    }
}

- (void)addEventWithEvent:(EKEvent *)ekEvent {
    //判断当前日历中是否已经创建了该事件
    EKEvent *event = [self getEventWithEKEvent:ekEvent];
    if (event == nil) {

        EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
        event.title = @"代码创建的日程";
        event.calendar = [self.eventStore defaultCalendarForNewEvents];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.hour = 1;
        NSDate *endTime = [calendar dateByAddingComponents:components toDate:[NSDate date] options:0];
        event.startDate = [NSDate date];
        event.endDate = endTime;
        event.notes = @"档期详情：hyaction://hunyu-music";
        [event addAlarm:[EKAlarm alarmWithRelativeOffset:-10*60]];

        NSError *error;
        [self.eventStore saveEvent:event span:EKSpanFutureEvents commit:YES  error:&error];
        if (!error) {
            NSLog(@"添加成功！");
        }else{
            NSLog(@"添加失败：%@",error);
        }
        
    }
}


- (EKCalendar *)createClandar {

    EKCalendar *calendar;
    for (EKCalendar *ekcalendar in [self.eventStore calendarsForEntityType:EKEntityTypeEvent]) {
        if ([ekcalendar.title isEqualToString:@"WePlan"]) {
            calendar = ekcalendar;
        }
    }
    if (!calendar) {
        EKSource *localSource = nil;
        for (EKSource *source in self.eventStore.sources) {
            if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"]) {
                localSource = source;
                break;
            }
        }

        if (localSource == nil) {
            for (EKSource *source in self.eventStore.sources) {
                if (source.sourceType == EKSourceTypeLocal) {
                    localSource = source;
                    break;
                }
            }
        }

        if (localSource == nil) {
            NSLog(@"创建Clendar失败。。。。。。。。请检查日历iCould是否打开");
            return nil;
        }
        calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
        calendar.source = localSource;
        calendar.title = @"WePlan";//自定义日历标题
        calendar.CGColor = [UIColor greenColor].CGColor;//自定义日历颜色
        NSError* error;
        [self.eventStore saveCalendar:calendar commit:YES error:&error];
    }

    return calendar;
}

/**
 *  删除事件
 */
- (BOOL)deleteEvent:(EKEvent *)ekEvent {
    __block BOOL isDeleted = NO;
    __block NSString *eventIdentif;
    dispatch_async(dispatch_get_main_queue(), ^{
        eventIdentif = ekEvent.eventIdentifier;
        NSError *err = nil;
        isDeleted = [self.eventStore removeEvent:ekEvent span:EKSpanThisEvent commit:YES error:&err];
    });

    if (isDeleted) {
        [self clearIdentifier:eventIdentif];
    }

    return isDeleted;
}

//删除后，清除 NSUserDefaults 中的 identifier
- (void)clearIdentifier:(NSString *)identifier {
    NSMutableArray *savedArr = [[NSUserDefaults standardUserDefaults] objectForKey:SavedEKEventsIdentifer];
    for (int i = 0; i < savedArr.count; i ++) {
        if ([identifier isEqualToString:savedArr[i]]) {
            [savedArr removeObjectAtIndex:i];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:savedArr forKey:SavedEKEventsIdentifer];
}

/**
 *  使用 identifier删除
 */
-(void)deleteWithIdentifier:(NSString *)identifier {
    EKEvent *event = [self.eventStore eventWithIdentifier:identifier];
    NSLog(@"eventtitle == %@", event.title);

    __block BOOL isDeleted = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *err = nil;
        isDeleted = [self.eventStore removeEvent:event span:EKSpanThisEvent commit:YES error:&err];
    });
    if (isDeleted) {
        [self clearIdentifier:event.eventIdentifier];
    }
}

/**
 *  删除全部保存的
 */
- (void)deleteAllCreatedEvent {


    NSMutableArray *savedArr = [[NSUserDefaults standardUserDefaults] objectForKey:SavedEKEventsIdentifer];

    for (int i = 0; i < savedArr.count; i++) {
        NSString *eventIdentifier = savedArr[i];
        [self deleteWithIdentifier:eventIdentifier];
    }

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SavedEKEventsIdentifer];
}

/**
 *  查找日历事件中相同的事件
 */
- (EKEvent *)getEventWithEKEvent:(EKEvent *)ekEvent {
    EKEvent *resultEvent = nil;
    for (EKEvent *event in [EventsManager getEventsCalendars:nil]) {
        if ([self checkEvent:event sameWithEvent:ekEvent]) {
            resultEvent = event;
        }
    }
    return resultEvent;
}

/**
 *  判断两个事件是否相同
 */
- (BOOL)checkEvent:(EKEvent *)event sameWithEvent:(EKEvent *)ekEvent {

    NSInteger alarm = ekEvent.alarms[0].relativeOffset;
    EKAlarm *eventAlarm = event.alarms[0];
    NSInteger alarmInt = eventAlarm.relativeOffset;

    //项目中日程 只有 标题和 时间 和提醒时间 所有只做两个判断
    if ([event.title isEqualToString: ekEvent.title] && (alarm == alarmInt)) {
        return YES;
    } else {
        return NO;
    }
}

/**
 *  获得提醒 NSinteger
 */
- (NSInteger)getAlarmWithStr:(NSString *)alarmStr {

    NSInteger alarmTime;
    if (alarmStr.length == 0) {
        alarmTime = 0;
    } else if ([alarmStr isEqualToString:@"不提醒"]) {
        alarmTime = 0;
    } else if ([alarmStr isEqualToString:@"1分钟前"]) {
        alarmTime = 60.0 * -1.0f;
    } else if ([alarmStr isEqualToString:@"10分钟前"]) {
        alarmTime = 60.0 * -10.f;
    } else if ([alarmStr isEqualToString:@"30分钟前"]) {
        alarmTime = 60.0 * -30.f;
    } else if ([alarmStr isEqualToString:@"1小时前"]) {
        alarmTime = 60.0 * -60.f;
    } else if ([alarmStr isEqualToString:@"1天前"]) {
        alarmTime = 60.0 * - 60.f * 24;
    }
    return alarmTime;
}

//TODO: 查新identifier对应的事件
+ (nullable EKEvent *)eventWithIdentifier:(NSString *)identifier {
    return [[EventsManager manager].eventStore eventWithIdentifier:identifier];
}
//TODO:    查询 两年前 和两年后所有的事件
+ (NSArray <EKEvent *> *)getEventsCalendars:(NSArray <EKCalendar *> *)calendars {
    EKEventStore * eventStore = [EventsManager manager].eventStore;
    NSDate *startDate = [EventsManager getCalendarDateYear:-2 Day:0 Hour:0 Minute:0];
    NSDate *endDate = [EventsManager getCalendarDateYear:2 Day:0 Hour:0 Minute:0];
    NSArray *eventsCalendars = @[[[EventsManager manager] createClandar]];
    NSPredicate * predicate = [eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:eventsCalendars];
    NSArray *clendarArray = [eventStore eventsMatchingPredicate:predicate];
    return clendarArray;
}

#pragma mark 获取时间
+ (NSDate *)getCalendarDateYear:(NSInteger)year Day:(NSInteger)day Hour:(NSInteger)hour Minute:(NSInteger)minute {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:year];
    [dateComponents setDay:day];
    [dateComponents setHour:hour];
    [dateComponents setMinute:minute];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [calendar dateByAddingComponents:dateComponents toDate:[NSDate date] options:0];
    //得到本地时间，避免时区问题
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

@end

