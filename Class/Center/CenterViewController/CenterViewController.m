//
//  CenterViewController.m
//  WePlan
//
//  Created by iOS on 2018/8/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "CenterViewController.h"
#import "CenterViewControllerTableViewCell.h"
#import <UIViewController+MMDrawerController.h>
#import <MMDrawerBarButtonItem.h>

#import "EidtViewController.h"

@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSTimer *_timer;
}

@end

@implementation CenterViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCalendarData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mm_drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeBezelPanningCenterView;
    self.navigationItem.title = @"主页";
    [self setupLeftMenuButton];
    [self.tableView registerClass:[CenterViewControllerTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];
    [self.view addSubview:self.tableView];
//
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(getCalendarData) userInfo:nil repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];

}

-(void)setupLeftMenuButton {
    //创建按钮
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //为navigationItem添加LeftBarButtonItem
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_add"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoEidtViewController)] animated:YES];

}
//抽屉按钮动作
-(void)leftDrawerButtonPress:(id)sender {
    //开关左抽屉
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (void)gotoEidtViewController {
    [self.navigationController pushViewController:[[EidtViewController alloc] init] animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EKEvent *event = _dataSourceArray[indexPath.row];
    if (!event.eventIdentifier) {
        NSLog(@"eventIdentifier 找不到");
    }else {
        [self.navigationController pushViewController:[[EidtViewController alloc] initWithEvent:event] animated:YES];
    }
}

#pragma mark 获取数据
- (void)getCalendarData {
     NSArray *arr = [EventsManager getEventsCalendars:nil];
    if (self.tableView && ![self.dataSourceArray isEqualToArray:arr]) {
        self.dataSourceArray = arr;
        [self.tableView reloadData];
    }
}

#pragma mark -- TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    EKEvent * event = self.dataSourceArray[indexPath.row];
    [cell setEvent:event isFirst:YES];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterViewControllerTableViewCell *cell = [[CenterViewControllerTableViewCell alloc] init];
    EKEvent * event = self.dataSourceArray[indexPath.row];
    [cell setEvent:event isFirst:YES];
    CGFloat rowHight = cell.rowHeight;
    cell = nil;
    return rowHight;
}

#pragma mark -- 懒加载

@end
