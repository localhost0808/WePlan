//
//  MainNavigationController.m
//  JiaBianHealth
//
//  Created by JBWL on 2016/11/12.
//  Copyright © 2016年 JBWL. All rights reserved.
//

#import "MainNavigationController.h"
#import <QuartzCore/QuartzCore.h>

typedef enum  NavStyle {
    NavStyleColor = 0,
    NavStyleImage
} NavStyle;

#define WINDOW_KEY      [[[UIApplication sharedApplication] delegate]window]
#define ScreenWidth     [UIScreen mainScreen].bounds.size.width
#define TOP_VIEW        [[UIApplication sharedApplication]keyWindow].rootViewController.view
#define IMG(img)        [UIImage imageNamed:img]

@interface MainNavigationController ()<UINavigationControllerDelegate> {
    CGPoint startTouch;
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    UINavigationBar *bar;
}
@property (nonatomic, weak) id PopDelegate;//系统侧滑代理
@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;
@property (nonatomic,assign) BOOL isMoving;

@end

@implementation MainNavigationController
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [self setNavigationBarStyle:NavStyleColor];//设置全局导航栏样式
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
    }
    return self;
}

#pragma mark    设置全局导航栏样式
- (void)setNavigationBarStyle:(NavStyle)style{
    switch (style) {
        case NavStyleColor: {
            [UINavigationBar appearance].barTintColor = MAIN_COLOR;

            //    [UINavigationBar appearance].translucent = NO;
            [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:20] };
            if([[UIApplication sharedApplication]  respondsToSelector:@selector(setStatusBarStyle:)]){
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
            }
        }
            break;

        case NavStyleImage: {

            UIImage * img= [UIImage imageNamed:@"lanuchImage.png"];
            [[UINavigationBar appearance] setShadowImage:[UIImage new]];
            [[UINavigationBar appearance] setBackgroundImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(-5, 0, 20, 0) resizingMode:UIImageResizingModeTile] forBarMetrics:UIBarMetricsDefault];
            [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
            [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置侧滑返回代理，自定义LeftBar
//    self.PopDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];


/*   //系统的返回方式
    self.delegate = self;
    id target = self.interactivePopGestureRecognizer.delegate;
    // 创建全屏滑动手势，调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:sel_registerName("handleNavigationTransition:")];
    // 设置手势代理，拦截手势触发
    pan.delegate = self;
    // 给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    // 禁止使用系统自带的滑动手势
    self.interactivePopGestureRecognizer.enabled = NO;
 
 */


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:(BOOL)animated];
    if (self.screenShotsList.count == 0) {
        UIImage *capturedImage = [self capture];

        if (capturedImage) {
            [self.screenShotsList addObject:capturedImage];
        }
    }
}


- (void)dealloc {
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.viewControllers.count > 0) {
//        //解决push 时候隐藏TabBar
////        viewController.hidesBottomBarWhenPushed = YES;
//    }
    UIImage *capturedImage = [self capture];

    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
    }

    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];

    return [super popViewControllerAnimated:animated];
}

/*
//设置侧滑生效，设置leftBarBtn 后会失效
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.PopDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}
*/
#pragma mark 通用返回按钮
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers[0] != viewController) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:IMG(@"nav_back") forState:UIControlStateNormal];
        [button setContentMode:UIViewContentModeScaleAspectFit];
        [button addTarget:self action:@selector(backBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
        button.bounds = CGRectMake(0, 0, 30, 30);
        [button setTitle:@"      " forState:UIControlStateNormal];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -32, 0, 0)];
        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        viewController.navigationItem.leftBarButtonItem = backBarButtonItem;

    }

}

- (void)backBarButtonItemAction {
    [self popViewControllerAnimated:YES];
}


#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture {
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, [UIScreen mainScreen].scale - 0.01);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x {
    x = x>ScreenWidth?ScreenWidth:x;
    x = x<0?0.00001:x;

    CGRect frame = TOP_VIEW.frame;
    frame.origin.x = x;
    TOP_VIEW.frame = frame;

    //    缩放率
    float scale = x/(ScreenWidth * 0.618) < 0.618?0.618:x/(ScreenWidth * 0.618);

    //设置上层VC的宽高缩放率
    lastScreenShotView.transform = CGAffineTransformMakeScale(1.f,1.f);
    lastScreenShotView.frame = CGRectMake(- ScreenWidth/3 + x/3, 0, lastScreenShotView.frame.size.width, lastScreenShotView.frame.size.height);

    float alpha = 0.5 - (x/ScreenWidth)/2;//遮罩黑色View
    blackMask.alpha = alpha;

}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.viewControllers.count <= 1 || !self.canDragBack) return NO;

    return YES;
}
#pragma 设置滑动有效范围
static CGFloat popMax = 40;
#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer {
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    CGPoint touchPoint = [recoginzer locationInView:WINDOW_KEY];



    __weak typeof(self) WeakSelf = self;

    switch (recoginzer.state) {
        case UIGestureRecognizerStateBegan: {
            NSLog(@"UIGestureRecognizerStateBegan");
            _isMoving = YES;
            startTouch = touchPoint;

            if (!self.backgroundView)
            {
                CGRect frame = TOP_VIEW.frame;

                //            设置阴影，设置背景View（superView）
                self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
                blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
                blackMask.backgroundColor = [UIColor blackColor];
                [self.backgroundView addSubview:blackMask];
            }

            self.backgroundView.hidden = NO;

            if (lastScreenShotView) [lastScreenShotView removeFromSuperview];

            UIImage *lastScreenShot = [self.screenShotsList lastObject];
            lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
            [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];

            //End paning, always check that if it should move right or move left automatically
        }
            break;

        case UIGestureRecognizerStateEnded: {
            if (startTouch.x > popMax) {
                return;
            }
            if (touchPoint.x - startTouch.x > ScreenWidth/3) {
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:ScreenWidth];
                } completion:^(BOOL finished) {

                    [self popViewControllerAnimated:NO];
                    CGRect frame = TOP_VIEW.frame;
                    frame.origin.x = 0;
                    TOP_VIEW.frame = frame;

                    WeakSelf.isMoving = NO;
                    self.backgroundView.hidden = YES;

                }];
            }else{
                [UIView animateWithDuration:0.3 animations:^{
                    [self moveViewWithX:0];
                } completion:^(BOOL finished) {
                    WeakSelf.isMoving = NO;
                    self.backgroundView.hidden = YES;
                }];
            }
            startTouch = CGPointZero;
            return;
        }
            break;

        case UIGestureRecognizerStateCancelled: {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                WeakSelf.isMoving = NO;
                self.backgroundView.hidden = YES;
            }];

            if (bar) {
                bar.frame = CGRectMake(0, bar.frame.origin.y, bar.frame.size.width, bar.frame.size.height);
            }

            return;
        }
            break;

        default:
            if (startTouch.x > popMax) {
                touchPoint = CGPointZero;
            }
//            if (bar) {
//                bar.frame = CGRectMake(touchPoint.x, bar.frame.origin.y, bar.frame.size.width, bar.frame.size.height);
//            }
            break;
    }

    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

@end
