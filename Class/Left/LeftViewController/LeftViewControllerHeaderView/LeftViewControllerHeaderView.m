//
//  LeftViewControllerHeaderView.m
//  WePlan
//
//  Created by iOS on 2018/8/14.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "LeftViewControllerHeaderView.h"
#define HeadImage_X 20
#define HeadImage_Y 58 + 20//20 状态栏
#define HeadImage_W 40

#define UserName_FONT 25
@implementation LeftViewControllerHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgImageView];
        [self addSubview:self.headImageView];
        [self addSubview:self.userNameLabel];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgImageView.frame = self.frame;
    self.headImageView.frame = CGRectMake(HeadImage_X, HeadImage_Y, HeadImage_W, HeadImage_W);
    self.userNameLabel.frame = CGRectMake(HeadImage_X + HeadImage_W + 10/* 头像和用户名的间距 */,
                                          HeadImage_Y,
                                          self.frame.size.width - HeadImage_X + HeadImage_W,
                                          HeadImage_W);
}

#pragma mark --懒加载
- (UIImageView *)bgImageView {
    if(_bgImageView) return _bgImageView;
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _bgImageView.image = [UIImage imageNamed:@"bgImage.jpeg"];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    return _bgImageView;
}

- (UIImageView *)headImageView {
    if(_headImageView) return _headImageView;
    _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImageView.image = [UIImage imageNamed:@"HeadImage.jpeg"];
    _headImageView.layer.cornerRadius = HeadImage_W/2;
    _headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headImageView.layer.borderWidth = 2;
    _headImageView.layer.masksToBounds = YES;

    return _headImageView;
}

- (UILabel *)userNameLabel {
    if(_userNameLabel) return _userNameLabel;
    _userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _userNameLabel.text = @"雨夜";
    _userNameLabel.textColor = [UIColor whiteColor];
    _userNameLabel.font = [UIFont systemFontOfSize:UserName_FONT];
    _userNameLabel.adjustsFontSizeToFitWidth = YES;
    return _userNameLabel;
}
@end
