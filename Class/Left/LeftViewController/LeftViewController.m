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

@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *titlesArr;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
    [self.view addSubview:self.leftViewControllerHeaderView];
    [self.view addSubview:self.tableView];
}

- (void)setData {
    _imagesArr = @[@"001",@"001",@"001",@"setting"];
    _titlesArr = @[@"001",@"001",@"001",@"设置"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imagesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LEFTVIEWCONTROLLERTABLEVIEWCELLIFTIFER forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:_imagesArr[indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", _titlesArr[indexPath.row]];
    cell.textLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
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