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

#define LeftHeader_Height 170

@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) LeftViewControllerHeaderView *leftViewControllerHeaderView;

@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *titlesArr;
@end

@implementation LeftViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[LeftViewControllerTableViewCell class] forCellReuseIdentifier:TableViewCellIdentifier];

    [self setData];
    [self.view addSubview:self.leftViewControllerHeaderView];
    [self.view addSubview:self.tableView];
}

- (void)setData {
    _imagesArr = @[@"001",@"001",@"001",@"setting"];
    _titlesArr = @[@"001",@"001",@"001",@"设置"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
    UINavigationController *nav = (UINavigationController *)self.mm_drawerController.centerViewController.childViewControllers[0];
    [nav pushViewController:[NSClassFromString(@"SpeechViewController") new] animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imagesArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeftViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
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

- (LeftViewControllerHeaderView *)leftViewControllerHeaderView {
    if(_leftViewControllerHeaderView) return _leftViewControllerHeaderView;
    _leftViewControllerHeaderView = [[LeftViewControllerHeaderView alloc] initWithFrame:self.view.frame];
    return _leftViewControllerHeaderView;
}
@end
