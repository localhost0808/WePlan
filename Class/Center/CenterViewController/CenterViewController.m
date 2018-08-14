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

#define CENTERVIEWCONTROLLERTABLEVIEWCELLIFTIFER @"CENTERVIEWCONTROLLERTABLEVIEWCELLIFTIFER"

@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"主页";
    [self setupLeftMenuButton];
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    }
    [self.view addSubview:self.tableView];
}

-(void)setupLeftMenuButton {
    //创建按钮
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    //为navigationItem添加LeftBarButtonItem
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}
//抽屉按钮动作
-(void)leftDrawerButtonPress:(id)sender {
    //开关左抽屉
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

#pragma mark -- TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CenterViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CENTERVIEWCONTROLLERTABLEVIEWCELLIFTIFER forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

#pragma mark -- 懒加载

- (UITableView *)tableView {
    if(_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[CenterViewControllerTableViewCell class] forCellReuseIdentifier:CENTERVIEWCONTROLLERTABLEVIEWCELLIFTIFER];
    return _tableView;
}

@end
