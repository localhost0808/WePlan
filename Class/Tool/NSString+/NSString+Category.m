//
//  NSString+Category.m
//  WePlan
//
//  Created by Harry on 2018/8/31.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)
- (CGFloat)stringHeightWithViewWidth:(CGFloat)viewWidth Font:(UIFont *)font {
    CGFloat height = [self boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return height;
}

- (NSString*)getWeekDay {
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",nil];

    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    NSDate*date =[dateFormat dateFromString:self];
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone*timeZone = [[NSTimeZone alloc]init];
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return[weekdays objectAtIndex:theComponents.weekday];
}

@end
