//
//  CenterViewControllerTableViewCell.h
//  WePlan
//
//  Created by iOS on 2018/8/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterViewControllerTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *weatherButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *allDayLabel;
@property (nonatomic, strong) UILabel *startDateLabel;
@property (nonatomic, strong) UILabel *endDateLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *remarksLabel;

@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)setEvent:(EKEvent *)event isFirst:(BOOL)isFirst;
@end
