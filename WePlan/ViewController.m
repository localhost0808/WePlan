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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = MAIN_COLOR;
    NSArray *sourceArr = [[MySQLAPI manager] mySQLAPISELECT:@"userInfo"];
    NSLog(@"%@",sourceArr);

    [self getPrivacy];
    [self setViewControllers:@[[[MainNavigationController alloc] initWithRootViewController:[NSClassFromString(@"CenterViewController") class].new]]];


}

- (void)getPrivacy {
    [PrivacyPermission getPrivacyNet]; //网络
    [[PrivacyPermission manager] getPrivacyForLocaltion];//定位
    [PrivacyPermission getPrivacyPhotos];//相册-
    [PrivacyPermission getPrivacyAVFoundation];//相机和麦克风-
    [PrivacyPermission getPrivacyAddressBook];//通讯录-
    [PrivacyPermission getPrivacyDate];//日历、备忘录-
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

@end
