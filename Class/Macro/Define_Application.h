//
//  Define_Application.h
//  WePlan
//
//  Created by Harry on 2018/8/14.
//  Copyright © 2018年 Harry. All rights reserved.
//

#ifndef Define_Application_h
#define Define_Application_h

//TODO: KEY
#define yyyyMMddHHmm @"yyyy-MM-dd HH:mm"
#define SavedEKEventsIdentifer @"WePlanSavedEKEventsIdentifer"


#define IOS9_0_LATER    [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending


#define SELF_VIEW_X self.frame.origin.x
#define SELF_VIEW_Y self.frame.origin.y
#define SELF_VIEW_W self.frame.size.width
#define SELF_VIEW_H self.frame.size.height

#define SELF_X self.view.frame.origin.x
#define SELF_Y self.view.frame.origin.y
#define SELF_W self.view.frame.size.width
#define SELF_H self.view.frame.size.height

#define IMG(img) [UIImage imageNamed:img]
//TODO:颜色
#define RGB(r, g, b)             [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

//0,191,255  #00BFFF    深天蓝
#define MAIN_COLOR [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]

#endif /* Define_Application_h */
