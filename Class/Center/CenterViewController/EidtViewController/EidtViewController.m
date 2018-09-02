//
//  EidtViewController.m
//  WePlan
//
//  Created by Harry on 2018/8/31.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "EidtViewController.h"

#import "EidtViewControllerDefaultCell.h"
#import "TLTalkButton.h"
#import "SpeechManager.h"
#import "PrivacyPermission.h"

@interface EidtViewController ()
@property (nonatomic, strong) EKEvent *event;
@property (nonatomic, strong) TLTalkButton *talkButton;
@property (nonatomic, strong) NSString *eventIdentifier;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) SpeechManagerInfo *info;

@end

@implementation EidtViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar addSubview:self.talkButton];
    self.talkButton.backgroundColor = [UIColor greenColor];
    self.talkButton.frame = CGRectMake(0, 0, self.tabBarController.tabBar.frame.size.width, self.tabBarController.tabBar.frame.size.height);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_talkButton) {
        [_talkButton removeFromSuperview];
        _talkButton = nil;
    }
}

- (instancetype)initWithEvent:(EKEvent *)event {
    self = [super init];
    if (self) {
        if (!event) {
            NSLog(@"事件不存在或无法修改");
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            self.event = event;
            [self.tableView registerClass:[EidtViewControllerDefaultCell class] forCellReuseIdentifier:TableViewCellIdentifier];
            [self.view addSubview:self.tableView];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
    /**
     0 标题
     1 位置
     2 时间信息
     3 全天开关
     4 开始时间
     5 结束时间
     6 提醒
     7 备注
     8 删除
     */
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EidtViewControllerDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier forIndexPath:indexPath];
    cell = [cell indexPath:indexPath WithEvent:self.event];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EidtViewControllerDefaultCell *cell = [EidtViewControllerDefaultCell new];
    cell = [cell indexPath:indexPath WithEvent:self.event];
    CGFloat rowHeight = cell.rowHeight;
    cell = nil;
    return rowHeight;
}

- (TLTalkButton *)talkButton {
    if (_talkButton == nil) {
        _talkButton = [[TLTalkButton alloc] init];
        __weak typeof(self) weakSelf = self;
        [_talkButton setTouchBeginAction:^{
            [[SpeechManager manager] startRecordingWithSpeechInfo:^(SpeechManagerInfo *info) {
                if (info.text.length>0) {
                    weakSelf.info = info;
                    [weakSelf setTitle:info.text];
                }
            }];
        } willTouchCancelAction:^(BOOL cancel) {
            NSLog(@"willTouchCancelAction");

        } touchEndAction:^{
            NSLog(@"touchEndAction");
            [[SpeechManager manager] endRecording];
        } touchCancelAction:^{
            NSLog(@"touchCancelAction");
            weakSelf.titleLabel.text = @"取消了";
            [[SpeechManager manager] endRecording];
            weakSelf.info = nil;
        }];
    }
    return _talkButton;
}

@end
