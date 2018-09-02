//
//  BaseViewController.m
//  CQSuDaKB
//
//  Created by iOS on 2018/5/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@end
@implementation BaseViewController

@synthesize tableView = _tableView;
@synthesize dataSourceArray = _dataSourceArray;
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        if ([NSStringFromClass(self.class) isEqualToString:@"CenterViewController"]) {
            [self.navigationController.navigationBar setPrefersLargeTitles:YES];
            UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
            //        searchController.searchResultsUpdater = self;
            //        searchController.delegate = self;
            searchController.dimsBackgroundDuringPresentation = NO;
            searchController.hidesNavigationBarDuringPresentation = YES;
            //重点：在合适的地方添加下面一行代码
            self.definesPresentationContext = YES;
            self.navigationItem.searchController = searchController;
            //        searchResultsController
        }else {
            [self.navigationController.navigationBar setPrefersLargeTitles:NO];
            self.navigationItem.searchController = nil;
        }
    }


}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UITableView *)tableView {
    if(_tableView) return _tableView;
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    return _tableView;
}
#pragma mark 懒加载
@end
