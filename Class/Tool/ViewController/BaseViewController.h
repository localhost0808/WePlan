//
//  BaseViewController.h
//  CQSuDaKB
//
//  Created by iOS on 2018/5/18.
//  Copyright © 2018年 iOS. All rights reserved.
//

#define TableViewCellIdentifier [NSString stringWithFormat:@"%@CellIdentifier",NSStringFromClass(self.class)]

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *_dataSourceArray;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSourceArray;

@end
