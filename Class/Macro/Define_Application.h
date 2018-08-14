//
//  Define_Application.h
//  WePlan
//
//  Created by Harry on 2018/8/14.
//  Copyright © 2018年 Harry. All rights reserved.
//

#ifndef Define_Application_h
#define Define_Application_h

#define IOS8_0_LATER    [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending

#define IMG(img) [UIImage imageNamed:img]

#define SELF_X self.view.frame.origin.x
#define SELF_Y self.view.frame.origin.y
#define SELF_W self.view.frame.size.width
#define SELF_H self.view.frame.size.height

//0,191,255  #00BFFF    深天蓝
#define MAIN_COLOR [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]

#endif /* Define_Application_h */
