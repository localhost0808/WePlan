//
//  AppDelegate.m
//  WePlan
//
//  Created by Harry on 2018/8/8.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "AppDelegate.h"
#import <MMDrawerController.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [self setViewController];
    [self.window makeKeyAndVisible];
    return YES;
}



- (id)setViewController {
    id classMain = [NSClassFromString(@"ViewController") new];
    id classLeft = [NSClassFromString(@"LeftViewController") new];
    MMDrawerController *drawer = [[MMDrawerController alloc] initWithCenterViewController:classMain leftDrawerViewController:classLeft];
    drawer.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    drawer.closeDrawerGestureModeMask =MMCloseDrawerGestureModeAll;
    drawer.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width - 75.0;
    drawer.view.backgroundColor = [UIColor whiteColor];
    drawer.showsShadow = NO;
    return drawer;
}
@end
