//
//  MySQLAPI.m
//  WePlan
//
//  Created by Harry on 2018/8/12.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "MySQLAPI.h"
#import <OHMySQL.h>

@interface MySQLAPI()
@property (nonatomic, strong) OHMySQLUser *usr;
@property (nonatomic, strong) OHMySQLStoreCoordinator *coordinator;
@property (nonatomic, strong) OHMySQLQueryContext *queryContext;

@end

@implementation MySQLAPI
+ (instancetype)manager {
    static MySQLAPI * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MySQLAPI new];
    });
    return instance;
}

- (NSArray *)mySQLAPISELECT:(NSString *)name {
    [self.coordinator connect];
    // 获取log表中的数据
    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:name condition:nil];
    NSError *error = nil;
    // task用于存放数据库返回的数据
    NSArray *tasks = [self.queryContext executeQueryRequestAndFetchResult:query error:&error];
//    if (tasks != nil) {
//        NSLog(@"%@",tasks);
//    }
    [self.coordinator disconnect];
    return tasks?tasks:@[@"SQL don't connect------MySQLAPI--tasks"];
}


- (OHMySQLUser *)usr {
    if (_usr) {
        return _usr;
    }
    // 1.初始化数据库连接用户
    _usr = [[OHMySQLUser alloc] initWithUserName:@"bdm260170647" password:@"Li463344" serverName:@"bdm260170647.my3w.com" dbName:@"bdm260170647_db" port:3306 socket:nil];
    return _usr;
}

- (OHMySQLStoreCoordinator *)coordinator {
    if (_coordinator) {
        return _coordinator;
    }
    // 2.初始化连接器
    _coordinator = [[OHMySQLStoreCoordinator alloc] initWithUser:self.usr];

    // 3.连接到数据库
//    [_coordinator connect]; //设置为调用时自动连接

    return _coordinator;
}

- (OHMySQLQueryContext *)queryContext {
    if (_queryContext) {
        return _queryContext;
    }
    // 初始化设备上下文
    _queryContext = [OHMySQLQueryContext new];
    // 设置连接器
    _queryContext.storeCoordinator = self.coordinator;
    // 获取log表中的数据
//    OHMySQLQueryRequest *query = [OHMySQLQueryRequestFactory SELECT:@"userInfo" condition:nil];
//    NSError *error = nil;
//    // task用于存放数据库返回的数据
//    NSArray *tasks = [_queryContext executeQueryRequestAndFetchResult:query error:&error];
//    if (tasks != nil) {
//        NSLog(@"%@",tasks);
//    }
//    [self.coordinator disconnect];
    return _queryContext;
}

@end
