//
//  CenterViewControllerTableViewCell.m
//  WePlan
//
//  Created by iOS on 2018/8/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#define DATE_HEIGHT 20
#define Spacing 10

#import "CenterViewControllerTableViewCell.h"

@interface CenterViewControllerTableViewCell ()
@property (nonatomic, assign) BOOL allDay;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@end

@implementation CenterViewControllerTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.weatherButton];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.allDayLabel];
//        [self.contentView addSubview:self.startDateLabel];
//        [self.contentView addSubview:self.endDateLabel];
        [self.contentView addSubview:self.locationLabel];
        [self.contentView addSubview:self.remarksLabel];
    }
    return self;
}
- (void)setEvent:(EKEvent *)event isFirst:(BOOL)isFirst {
//    event
    self.titleLabel.text = event.title;
    self.startDate = [NSString stringWithFormat:@"%@",event.startDate];
    self.endDate = [NSString stringWithFormat:@"%@",event.endDate];
    self.locationLabel.text = event.location;
    self.remarksLabel.text = event.notes;
    self.dateLabel.text = [self.startDate componentsSeparatedByString:@" "][0];
    [self.weatherButton setTitle:@"多云" forState:UIControlStateNormal];

    self.allDay = event.allDay;
    if (_allDay) {
        self.allDayLabel.text = @"全天";
    }else {
        self.allDayLabel.text = [NSString stringWithFormat:@"%@ ~ %@",[self.startDate componentsSeparatedByString:@" "][1],[self.endDate componentsSeparatedByString:@" "][1]];
    }
    
    self.remarksLabel.frame = CGRectMake(DATE_HEIGHT, DATE_HEIGHT * 5 + Spacing * 4, SELF_VIEW_W - DATE_HEIGHT - Spacing,
                                         [self.remarksLabel.text stringHeightWithViewWidth:self.remarksLabel.frame.size.width Font:self.remarksLabel.font]);
    self.remarksLabel.backgroundColor = [UIColor greenColor];
    self.rowHeight = self.remarksLabel.frame.origin.y + self.remarksLabel.frame.size.height + Spacing;

}
#pragma mark 设置位置
- (void)layoutSubviews {
    [super layoutSubviews];
    self.dateLabel.frame = CGRectMake(DATE_HEIGHT, Spacing, SELF_VIEW_W/2, DATE_HEIGHT);
    self.weatherButton.frame = CGRectMake(SELF_VIEW_W/2, Spacing, SELF_VIEW_W/2, DATE_HEIGHT);

    self.titleLabel.frame = CGRectMake(DATE_HEIGHT, DATE_HEIGHT + Spacing, SELF_VIEW_W - DATE_HEIGHT - Spacing, DATE_HEIGHT * 2);
    self.allDayLabel.frame = CGRectMake(DATE_HEIGHT, DATE_HEIGHT*3 + Spacing*2, SELF_VIEW_W - DATE_HEIGHT - Spacing, DATE_HEIGHT);

    self.locationLabel.frame = CGRectMake(DATE_HEIGHT, DATE_HEIGHT * 4 + Spacing * 3, SELF_VIEW_W - DATE_HEIGHT - Spacing, DATE_HEIGHT);



}

#pragma mark -- 懒加载
- (UILabel *)dateLabel {
    if (_dateLabel) return _dateLabel;
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _dateLabel.textColor = [UIColor grayColor];
    return _dateLabel;
}


- (UIButton *)weatherButton {
    if (_weatherButton) return _weatherButton;
    _weatherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_weatherButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _weatherButton.titleLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    return _weatherButton;
}
- (UILabel *)titleLabel {
    if (_titleLabel) return _titleLabel;
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _titleLabel.textColor = [UIColor grayColor];
    _titleLabel.numberOfLines = 2;
//    _titleLabel.adjustsFontSizeToFitWidth = YES;
    return _titleLabel;
}

- (UILabel *)allDayLabel {
    if (_allDayLabel) return _allDayLabel;
    _allDayLabel = [[UILabel alloc] init];
    _allDayLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _allDayLabel.textColor = [UIColor grayColor];
    return _allDayLabel;
}

- (UILabel *)startDateLabel {
    if (_startDateLabel) return _startDateLabel;
    _startDateLabel = [[UILabel alloc] init];
    _startDateLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _startDateLabel.textColor = [UIColor grayColor];
    return _startDateLabel;
}

- (UILabel *)endDateLabel {
    if (_endDateLabel) return _endDateLabel;
    _endDateLabel = [[UILabel alloc] init];
    _endDateLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _endDateLabel.textColor = [UIColor grayColor];
    return _endDateLabel;
}
- (UILabel *)locationLabel {
    if (_locationLabel) return _locationLabel;
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _locationLabel.textColor = [UIColor grayColor];
    return _locationLabel;
}


- (UILabel *)remarksLabel {
    if (_remarksLabel) return _remarksLabel;
    _remarksLabel = [[UILabel alloc] init];
    _remarksLabel.font = [UIFont fontWithName:@".SFUIText" size:15];
    _remarksLabel.textColor = [UIColor grayColor];
    _remarksLabel.numberOfLines = 0;
    return _remarksLabel;
}
@end
