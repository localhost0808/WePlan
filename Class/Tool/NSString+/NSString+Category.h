//
//  NSString+Category.h
//  WePlan
//
//  Created by Harry on 2018/8/31.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
- (CGFloat)stringHeightWithViewWidth:(CGFloat)viewWidth Font:(UIFont *)font;
- (NSString*)getWeekDay;//获取日期的 周
@end
