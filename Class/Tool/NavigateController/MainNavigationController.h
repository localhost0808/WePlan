//
//  MainNavigationController.h
//  JiaBianHealth
//
//  Created by JBWL on 2016/11/12.
//  Copyright © 2016年 JBWL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainNavigationController : UINavigationController<UIGestureRecognizerDelegate>
@property (nonatomic,assign) BOOL canDragBack;

@end
