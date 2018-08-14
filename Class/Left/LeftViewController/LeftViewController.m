//
//  LeftViewController.m
//  WePlan
//
//  Created by iOS on 2018/8/13.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "LeftViewController.h"
#import "LeftViewControllerHeaderView.h"
#import "LeftViewControllerTableViewCell.h"
#import <UIViewController+MMDrawerController.h>

#define LEFTVIEWCONTROLLERTABLEVIEWCELLIFTIFER @"LEFTVIEWCONTROLLERTABLEVIEWCELLIFTIFER"
#define LeftHeader_Height 170

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LeftViewControllerHeaderView *leftViewControllerHeaderView;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.leftViewControllerHeaderView];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LEFTVIEWCONTROLLERTABLEVIEWCELLIFTIFER forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:@"001"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld测试测试",indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
//    .SFUIText 默认
//    -Bold 加粗

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

#pragma mark -- Frame

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.leftViewControllerHeaderView.frame = CGRectMake(0, 0, SELF_W, LeftHeader_Height);
    self.tableView.frame = CGRectMake(0, LeftHeader_Height + 12, SELF_W, SELF_H - LeftHeader_Height);
}

#pragma mark -- 懒加载

- (UITableView *)tableView {
    if(_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[LeftViewControllerTableViewCell class] forCellReuseIdentifier:LEFTVIEWCONTROLLERTABLEVIEWCELLIFTIFER];
    return _tableView;
}

- (LeftViewControllerHeaderView *)leftViewControllerHeaderView {
    if(_leftViewControllerHeaderView) return _leftViewControllerHeaderView;
    _leftViewControllerHeaderView = [[LeftViewControllerHeaderView alloc] initWithFrame:self.view.frame];
    return _leftViewControllerHeaderView;
}
@end
