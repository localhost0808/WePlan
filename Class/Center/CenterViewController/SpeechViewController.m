//
//  SpeechViewController.m
//  WePlan
//
//  Created by iOS on 2018/8/15.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "SpeechViewController.h"

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
    [self.view addSubview:self.swicthBut];
    [self.view addSubview:self.labText];

    

}

- (void)switchOn:(UIButton *)sender {
    if (@available(iOS 10.0, *)) {
        if ([[SpeechManager manager] audioEngineStatusRunning]) {
            [[SpeechManager manager] endRecording];
            return;
        }
        __weak typeof(self) weakSelf =self;
        [[SpeechManager manager] speechIsSpeech:^(BOOL isSpeech) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"%s-______%@",__FUNCTION__,isSpeech?@"可以用":@"不能用");
                [weakSelf.swicthBut setTitle:isSpeech?@"可以录音":@"不能用" forState:UIControlStateNormal];
            });
        } isRunning:^(BOOL isRunning) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"%s-______%@",__FUNCTION__,isRunning?@"运行中。。。":@"关闭了");
                [weakSelf.swicthBut setTitle:isRunning?@"运行中。。。":@"没运行" forState:UIControlStateNormal];
            });
        } speechText:^(NSString *speechText) {
//            NSLog(@"%s-______%@",__FUNCTION__,speechText);
            dispatch_sync(dispatch_get_main_queue(), ^{
                weakSelf.labText.text = speechText;
            });
        }];
    } else {
        NSLog(@"不支持，别掉了");
    }
}

#pragma mark----显示控件

- (UILabel*)labText{
    
    
    
        if(!_labText) {
        
                _labText= [[UILabel alloc]init];
        
                _labText.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 50);
        
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
        
                _swicthBut= [[UIButton alloc]init];
        
                _swicthBut.frame=CGRectMake(50,150,80,30);
        
                _swicthBut.titleLabel.textAlignment = NSTextAlignmentCenter;
        
                [_swicthBut setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
                [_swicthBut addTarget:self action:@selector(switchOn:) forControlEvents:UIControlEventTouchUpInside];
        
                [_swicthBut setTitle:@"开始录音" forState:UIControlStateNormal];
        
            }
    
        return _swicthBut;
    
}
@end
