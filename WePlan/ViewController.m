//
//  ViewController.m
//  WePlan
//
//  Created by Harry on 2018/8/8.
//  Copyright © 2018年 Harry. All rights reserved.
//
typedef enum  NetworkStatus {
    NotReachable = 0,
    ReachableViaWiFi,
    ReachableViaWWAN
} NetworkStatus;

#import "ViewController.h"
#import "MainNavigationController.h"

#import "PrivacyPermission.h"
#import "MySQLAPI.h"

#import <EventKit/EventKit.h>

#import <EventKitUI/EventKitUI.h>


@interface ViewController ()<UITabBarControllerDelegate>
@property (nonatomic,strong) UIButton *speechButton;
@property (nonatomic,strong) UIView *baseView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = MAIN_COLOR;
//    self.tabBar.frame = CGRectMake(0, 200, 300, 200);


    [self getPrivacy];
    [self setViewControllers:@[[[MainNavigationController alloc] initWithRootViewController:[NSClassFromString(@"CenterViewController") class].new]]];

    
    
    _speechButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _speechButton.backgroundColor = [UIColor whiteColor];
    [_speechButton addTarget:self action:@selector(button) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:_speechButton];
    [_speechButton setTitle:@"点击添加事件" forState:UIControlStateNormal];
    
}


//查
- (void)search {
    EKEventStore * eventStore = [[EKEventStore alloc]init];
    NSArray *event = [eventStore calendarsForEntityType:EKEntityTypeEvent];
    NSArray *event1 = [eventStore calendarsForEntityType:EKEntityTypeReminder];
    NSLog(@"1111");
}


//存到日历
- (void)button {
    NSLog(@"11111");
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        // 这个方法在iOS6之后才有用
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",error);
                } else if (!granted) {
                    //被用户拒绝，不允许访问日历
                    NSLog(@"被用户拒绝，不允许访问日历");
                } else {
                    //事件保存到日历
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore]; //创建事件
                    event.title = @"WePlanTitle"; // 标题
                    event.location = @"上海市徐汇区"; // 地点
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setAMSymbol:@"AM"];
                    [dateFormatter setPMSymbol:@"PM"];
                    [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mmaaa"];
                    NSDate *date = [NSDate date];
                    //开始时间(必须传)
                    event.startDate = [date dateByAddingTimeInterval:60 * 2];
                    //结束时间(必须传)
                    event.endDate = [date dateByAddingTimeInterval:60 * 5 * 24];
                    event.allDay = YES;//全天
                    
                    //添加提醒
                    //第一次提醒  (几分钟后)
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0 * -1.0]];
                    //第二次提醒
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -10.0f * 24]];
                    
                    //事件内容备注
                    event.notes = @"接受信息类容备注";
//                FIXME:待修改
                    EKCalendar* calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
                    calendar.title = @"WePlan";
                    calendar.CGColor = [UIColor greenColor].CGColor;
                    [event setCalendar:calendar];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    NSLog(@"保存成功");
                }
            });
        }];
    }

    
}

- (void)getPrivacy {
    [PrivacyPermission getPrivacyNet]; //网络
    [[PrivacyPermission manager] getPrivacyForLocaltion];//定位
    [PrivacyPermission getPrivacyPhotos];//相册-
    [PrivacyPermission getPrivacyAVFoundation];//相机和麦克风-
    [PrivacyPermission getPrivacyAddressBook];//通讯录-
    [PrivacyPermission getPrivacyDate];//日历、备忘录-
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 100;
    tabFrame.origin.y = self.view.frame.size.height - 100;
    self.tabBar.frame = tabFrame;
    
    _speechButton.frame = CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height);

}

//设置tabbar上第1个按钮为不可选中状态，其他的按钮为可选择状态
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return ![viewController isEqual:tabBarController.viewControllers[0]];
}

#define kAppleUrlToCheckNetStatus @"http://captive.apple.com/"

- (BOOL)checkNetCanUse {

    __block BOOL canUse = NO;

    NSString *urlString = kAppleUrlToCheckNetStatus;

    // 使用信号量实现NSURLSession同步请求**

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSString* result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //解析html页面
        NSString *htmlString = [self filterHTML:result];
        //除掉换行符
        NSString *resultString = [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

        if ([resultString isEqualToString:@"SuccessSuccess"]) {
            canUse = YES;
            NSLog(@"---手机所连接的网络是可以访问互联网的: %d",canUse);

        }else {
            canUse = NO;
            NSLog(@"---手机无法访问互联网: %d",canUse);
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return canUse;
}

- (NSString *)filterHTML:(NSString *)html {

    NSScanner *theScanner;
    NSString *text = nil;

    theScanner = [NSScanner scannerWithString:html];

    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}

- (void)userData {
    NSArray *sourceArr = [[MySQLAPI manager] mySQLAPISELECT:@"userInfo"];
    NSLog(@"%@",sourceArr);
}

- (void)UI_init {
    /*** 标题列表 ***/
    NSArray *titles = @[@"首页"];
    /*** TabBar图标（普通） ***/
    NSArray *images = @[@""];
    /*** ViewController列表 ***/
    NSArray *classNames = @[@"CenterViewController"];
    /*** 创建。存放 导航 视图对象 ***/
    NSMutableArray *objArr = [[NSMutableArray alloc] initWithCapacity:classNames.count];
    for (int index = 0; index < classNames.count; index++) {
        NSString *title = titles[index];
        NSString *image = images[index];
        NSString *className = classNames[index];
        id nav = [self viewControllerWithClassName:className image:IMG(image) title:title];

        [objArr addObject:nav];
    }
    self.viewControllers = objArr;
    [self.tabBar setShadowImage:IMG(@"")];
    [self.tabBar setBackgroundImage:IMG(@"")];

//#ifdef IOS8_0_LATER
//    self.tabBar.tintColor = [UIColor greenColor];
//#else
//    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor greenColor]];
//#endif

}

- (UINavigationController *)viewControllerWithClassName:(NSString *)className image:(UIImage *)image title:(NSString *)title {
    Class class = NSClassFromString(className);
    id pClass = [class new];
    [pClass setTabBarItem:[[UITabBarItem alloc] initWithTitle:title image:image tag:0]];
    [pClass setTitle:title];//ViewController的Title
    MainNavigationController *navVC = [[MainNavigationController alloc] initWithRootViewController:pClass];
    return navVC;
}
- (void)tabBarNotification:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSInteger index = [[info objectForKey:@"index"]integerValue];
    self.selectedIndex = index;
}

/*
 
 BOOL shouldAdd = YES;
 
 EKCalendar *calendar;
 
 for (EKCalendar *ekcalendar in [_eventStore calendarsForEntityType:EKEntityTypeEvent]) {
 
 if ([ekcalendar.title isEqualToString:@"青橙科技"]) {
 
 shouldAdd = NO;
 
 calendar = ekcalendar;
 
 }
 
 }
 
 if (shouldAdd) {
 
 EKSource *localSource = nil;
 
 for (EKSource *source in _eventStore.sources)
 
 {
 
 if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"])
 
 {
 
 localSource = source;
 
 break;
 
 }
 
 }
 
 if (localSource == nil)
 
 {
 
 for (EKSource *source in _eventStore.sources) {
 
 if (source.sourceType == EKSourceTypeLocal)
 
 {
 
 localSource = source;
 
 break;
 
 }
 
 }
 
 }
 
 calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:_eventStore];
 
 calendar.source = localSource;
 
 calendar.title = @"青橙科技";//自定义日历标题
 
 calendar.CGColor = [UIColor greenColor].CGColor;//自定义日历颜色
 
 NSError* error;
 
 [_eventStore saveCalendar:calendar commit:YES error:&error];
 
 }
 
 
 */

@end
