//
//  PrivacyPermission.h
//  CQSuDaKB
//
//  Created by iOS on 2018/5/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrivacyPermission : NSObject
+ (instancetype)manager;
- (void)getPrivacyForLocaltion;//定位 /* 定位需要使用对象调用，否则提示框会消失 */-
+ (void)getPrivacyNet;//网络
+ (void)getPrivacyPhotos;//相册-
+ (void)getPrivacyAVFoundation;//相机和麦克风-
+ (void)getPrivacyPushNotification;//通知-
+ (void)getPrivacyAddressBook;//通讯录-
+ (void)getPrivacyDate;//日历、备忘录-
+ (void)getSpeech;
@end
