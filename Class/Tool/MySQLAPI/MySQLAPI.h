//
//  MySQLAPI.h
//  WePlan
//
//  Created by Harry on 2018/8/12.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySQLAPI : NSObject
+ (instancetype)manager;
- (NSArray *)mySQLAPISELECT:(NSString *)name;
@end
