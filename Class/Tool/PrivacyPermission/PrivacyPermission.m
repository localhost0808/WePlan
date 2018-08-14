//
//  PrivacyPermission.m
//  CQSuDaKB
//
//  Created by iOS on 2018/5/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "PrivacyPermission.h"
//#import <CoreLocation/CLLocationManager.h>//定位
@import CoreLocation;//定位
@import CoreTelephony;//联网
@import AssetsLibrary;//相册9.0之前
@import Photos;//相册8.0之后
@import AVFoundation;//相机和麦克风
@import AddressBook;//通讯录
@import Contacts;//检查通讯录权限
@import EventKit;//日历和备忘录
//#import <EventKit/EventKit.h>

#define IOS9_0_AGO [[[UIDevice currentDevice] systemVersion] floatValue] < 9.0
@interface PrivacyPermission()<CLLocationManagerDelegate> {
    CLLocationManager *manager;
}
@end

@implementation PrivacyPermission
+ (instancetype)manager {
    static PrivacyPermission * pp = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
            pp = [PrivacyPermission new];
    });
    return pp;
}

#pragma mark ---- 获取定位权限
/*** 检查是否有定位权限 ***/

- (void)getPrivacyForLocaltion {
    
    /*** 获取定位权限 ***/
    BOOL isLocation = [CLLocationManager locationServicesEnabled];
    if (!isLocation) { NSLog(@"not turn on the location");}
    CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
    NSLog(@"定位状态：");

    switch (CLstatus) {
        case kCLAuthorizationStatusAuthorizedAlways: NSLog(@"定位状态：Always Authorized"); break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: NSLog(@"定位状态：AuthorizedWhenInUse"); break;
        case kCLAuthorizationStatusDenied: NSLog(@"定位状态：Denied"); break;
        case kCLAuthorizationStatusNotDetermined:NSLog(@"定位状态：not Determined"); break;
        case kCLAuthorizationStatusRestricted: NSLog(@"定位状态：Restricted"); break; default: break;
    }
    
    manager = [[CLLocationManager alloc] init];
    manager.delegate= self;
    [manager requestAlwaysAuthorization];//一直获取定位信息
    [manager requestWhenInUseAuthorization];//使用的时候获取定位信息

}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSLog(@"定位Delegate状态：");
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways: NSLog(@"定位Delegate状态：Always Authorized"); break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: NSLog(@"定位Delegate状态：AuthorizedWhenInUse"); break;
        case kCLAuthorizationStatusDenied: NSLog(@"定位Delegate状态：Denied"); break;
        case kCLAuthorizationStatusNotDetermined: NSLog(@"定位Delegate状态：not Determined"); break;
        case kCLAuthorizationStatusRestricted: NSLog(@"定位Delegate状态：Restricted"); break; default: break;
    }}

+ (void)getPrivacyNet {
    
    /*** 获取网络权限 ***/
    [self netCallOn]; //调用一次网络访问
    
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    NSLog(@"网络状态：");

    switch (state) {
        case kCTCellularDataRestricted: NSLog(@"网络状态：Restricrted"); break;
        case kCTCellularDataNotRestricted:
            NSLog(@"网络状态：Not Restricted");
//            MBHUD(@"没有网络连接", HJStyleError);
            break;
        case kCTCellularDataRestrictedStateUnknown: NSLog(@"网络状态：Unknown"); break; default: break;
    }

}

+ (void)netCallOn {
    NSURL *url = [NSURL URLWithString:@"http://m.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"Net--source!!!!");
    }];
}

+ (void)getPrivacyPhotos {
    /*** 获取相册权限 ***/
    NSLog(@"相册状态：");

#ifdef IOS9_0_AGO
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];

    switch (status) {
        case ALAuthorizationStatusAuthorized: NSLog(@"相册状态：Authorized"); break;
        case ALAuthorizationStatusDenied: NSLog(@"相册状态：Denied"); break;
        case ALAuthorizationStatusNotDetermined: NSLog(@"相册状态：not Determined"); break;
        case ALAuthorizationStatusRestricted: NSLog(@"相册状态：Restricted"); break; default: break;
    }

#else
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized: NSLog(@"相册状态：Authorized"); break;
        case PHAuthorizationStatusDenied: NSLog(@"相册状态：Denied"); break;
        case PHAuthorizationStatusNotDetermined: NSLog(@"相册状态：not Determined"); break;
        case PHAuthorizationStatusRestricted: NSLog(@"相册状态：Restricted"); break; default: break;}

#endif
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized)
        { NSLog(@"Authorized"); }
        else{ NSLog(@"Denied or Restricted");
        } }];
}

+ (void)getPrivacyAVFoundation {
    /*** 获取相机和麦克风权限 ***/
    NSLog(@"相机和麦克风状态：");

    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];//相机权限
//    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];//麦克风权限
    switch (AVstatus) {
            //允许状态
        case AVAuthorizationStatusAuthorized: NSLog(@"相机和麦克风状态：Authorized"); break;
            //不允许状态，可以弹出一个alertview提示用户在隐私设置中开启权限
        case AVAuthorizationStatusDenied: NSLog(@"相机和麦克风状态：Denied"); break;
            //未知，第一次申请权限
        case AVAuthorizationStatusNotDetermined: NSLog(@"相机和麦克风状态：not Determined"); break;
            //此应用程序没有被授权访问,可能是家长控制权限
        case AVAuthorizationStatusRestricted: NSLog(@"相机和麦克风状态：Restricted"); break; default: break;
    }
    
    [AVCaptureDevice requestAccessForMediaType:
     AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
         if (granted) { NSLog(@"相机状态：Authorized"); }
         else{ NSLog(@"相机状态：Denied or Restricted"); }}];
    [AVCaptureDevice requestAccessForMediaType:
     AVMediaTypeAudio completionHandler:^(BOOL granted)
     {//麦克风权限
         if (granted) { NSLog(@"麦克风状态：Authorized"); }
         else{ NSLog(@"麦克风状态：Denied or Restricted");
         }}];
}

+ (void)getPrivacyPushNotification {
    /*** 获取推送权限 ***/
    NSLog(@"推送状态：");

    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    switch (settings.types) {
        case UIUserNotificationTypeNone: NSLog(@"推送状态：None"); break;
        case UIUserNotificationTypeAlert: NSLog(@"推送状态：Alert Notification"); break;
        case UIUserNotificationTypeBadge: NSLog(@"推送状态：Badge Notification"); break;
        case UIUserNotificationTypeSound: NSLog(@"推送状态：sound Notification'"); break;
            NSLog(@"推送状态：%@",settings.types);

        default: break;
    }
    
    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    
}

+ (void)getPrivacyAddressBook {
    /*** 获取通讯录权限 ***/
    NSLog(@"通讯录状态：");

    ABAuthorizationStatus ABstatus = ABAddressBookGetAuthorizationStatus();
    switch (ABstatus) {
        case kABAuthorizationStatusAuthorized: NSLog(@"通讯录状态：Authorized"); break;
        case kABAuthorizationStatusDenied: NSLog(@"通讯录状态：Denied'"); break;
        case kABAuthorizationStatusNotDetermined: NSLog(@"通讯录状态：not Determined"); break;
        case kABAuthorizationStatusRestricted: NSLog(@"通讯录状态：Restricted"); break; default: break;
    }
    
//    获取通讯录权限
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        if (granted)
        { NSLog(@"通讯录状态：Authorized");
            CFRelease(addressBook);
        }else{ NSLog(@"通讯录状态：Denied or Restricted");
        }});
    
//    iOS9.0及以后
//    导入头文件 **@import Contacts;**
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusAuthorized: { NSLog(@"通讯录状态：Authorized:"); } break;
        case CNAuthorizationStatusDenied:{ NSLog(@"通讯录状态：Denied"); } break;
        case CNAuthorizationStatusRestricted:{ NSLog(@"通讯录状态：Restricted"); } break;
        case CNAuthorizationStatusNotDetermined:{ NSLog(@"通讯录状态：NotDetermined"); } break;
    }
    
//    查询是否获取通讯录权限
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) { NSLog(@"通讯录状态：Authorized"); }
        else{ NSLog(@"通讯录状态：Denied or Restricted"); }
    }];

}

+ (void)getPrivacyDate {
//    typedef NS_ENUM(NSUInteger, EKEntityType) {
//        EKEntityTypeEvent,//日历
//        EKEntityTypeReminder //备忘
//    };
//
    NSLog(@"备忘录和日历状态：");

        EKAuthorizationStatus EKstatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
        switch (EKstatus) {
            case EKAuthorizationStatusAuthorized: NSLog(@"备忘录和日历状态：Authorized"); break;
            case EKAuthorizationStatusDenied: NSLog(@"备忘录和日历状态：Denied'"); break;
            case EKAuthorizationStatusNotDetermined: NSLog(@"备忘录和日历状态：not Determined"); break;
            case EKAuthorizationStatusRestricted: NSLog(@"备忘录和日历状态：Restricted");
                break;
            default: break;
        }
        
//        查询是否获取日历或备忘录权限
        EKEventStore *store = [[EKEventStore alloc]init];
        [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"备忘录和日历状态：Authorized"); }
            else{ NSLog(@"备忘录和日历状态：Denied or Restricted"); }
        }];
}

@end
