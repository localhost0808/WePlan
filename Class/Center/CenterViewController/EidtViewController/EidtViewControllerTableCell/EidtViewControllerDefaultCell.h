//
//  EidtViewControllerDefaultCell.h
//  WePlan
//
//  Created by Harry on 2018/8/31.
//  Copyright © 2018年 Harry. All rights reserved.
//
typedef NS_ENUM(NSUInteger, EidtViewControllerCellType) {
    EidtViewControllerCellTypeTitleTextView = 1,
    EidtViewControllerCellTypeLocation = 2,
    EidtViewControllerCellTypeDate = 3,
    EidtViewControllerCellTypeSwitch = 4,
    EidtViewControllerCellTypeArrow = 5,
    // 5 -> 6
    // 1 -> 7
    EidtViewControllerCellTypeDelete = 8,
    EidtViewControllerCellTypeDefault = 999,
};

#import <UIKit/UIKit.h>

@interface EidtViewControllerDefaultCell : UITableViewCell
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, assign) EidtViewControllerCellType type;
- (void)type:(EidtViewControllerCellType)type content:(id)content;
- (EidtViewControllerDefaultCell *)indexPath:(NSIndexPath *)indexPath WithEvent:(EKEvent *)event;
@end
