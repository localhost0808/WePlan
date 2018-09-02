//
//  SpeechViewController.m
//  WePlan
//
//  Created by iOS on 2018/8/15.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "SpeechViewController.h"
#import "PrivacyPermission.h"
#import "SpeechManager.h"

@interface SpeechViewController ()

@property (nonatomic,strong)UIButton *swicthBut;

@property (nonatomic,strong)UILabel *labText;
@end

@implementation SpeechViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"测试";
    [self.view addSubview:[UIScrollView new]];
    [self.view addSubview:self.swicthBut];
    [self.view addSubview:self.labText];
    [PrivacyPermission getSpeech];
}



#pragma mark----显示控件

- (UILabel*)labText{
    if(!_labText) {
        _labText= [[UILabel alloc]init];
        _labText.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 70);
        _labText.backgroundColor = [UIColor greenColor];
        _labText.font= [UIFont systemFontOfSize:20.0f];

        _labText.numberOfLines = 0;

        _labText.textAlignment = NSTextAlignmentCenter;

        _labText.textColor = [UIColor blackColor];

        }

    return _labText;

}

#pragma mark----开关
- (UIButton*)swicthBut{
    if (!_swicthBut) {

        _swicthBut= [UIButton buttonWithType:UIButtonTypeCustom];

        [_swicthBut setBackgroundColor:[UIColor redColor]];
        _swicthBut.frame=CGRectMake(50,150,80,30);

        _swicthBut.titleLabel.textAlignment = NSTextAlignmentCenter;

        [_swicthBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        [_swicthBut addTarget:self action:@selector(startSpeech) forControlEvents:UIControlEventTouchDown];
        [_swicthBut addTarget:self action:@selector(endSpeech) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];

        [_swicthBut setTitle:@"开始录音" forState:UIControlStateNormal];

        }

    return _swicthBut;

}
- (void)startSpeech {
    NSLog(@"键盘按下");
    __weak typeof(self) WeakSelf = self;
//    [[SpeechManager manager] startRecordingWithSpeechInfo:^(SpeechManagerInfo *info) {
//        if (info.isSpeech || !info.error) {
//            WeakSelf.labText.text = info.text;
//        }
//    }];

    [[EventsManager manager] createEventWithEvent:nil];
}
- (void)endSpeech {
    NSLog(@"键盘弹起");
    [[SpeechManager manager] endRecording];
//
//    [[EventsManager manager] createEventWithEventModel:[[EKEventModel new] eventTitle:@"时间名称" Location:@"上海" StartDateStr:@"2018年8月30日" EndDateStr:@"2018年8月30日" AllDay:YES Notes:[NSString stringWithFormat:@"%@%@",_labText.text,@"备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注备注"] AlarmStr:nil]];
}
@end
