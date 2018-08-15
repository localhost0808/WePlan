//
//  CalendarManager.m
//  WePlan
//
//  Created by Harry on 2018/8/15.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "CalendarManager.h"



@interface CalendarManager()<SFSpeechRecognizerDelegate>


@end

@implementation CalendarManager

- (void)isSpeech {
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            bool isButtonEnabled =false;
            switch(status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:

                    isButtonEnabled =true;

                     NSLog(@"可以语音识别");

                     break;

                     case SFSpeechRecognizerAuthorizationStatusDenied:

                     isButtonEnabled =false;

                     NSLog(@"用户未授权使用语音识别");

                     break;

                     case SFSpeechRecognizerAuthorizationStatusRestricted:

                     isButtonEnabled =false;

                     NSLog(@"语音识别在这台设备上受到限制");

                     break;

                     case SFSpeechRecognizerAuthorizationStatusNotDetermined:

                     isButtonEnabled =false;

                     NSLog(@"语音识别未授权");

                     break;

                     default:

                     break;
                }
            }];
    } else {
        NSLog(@"使用语音识别请在iOS10.0以上");
    }
}

#pragma mark---停止录音
- (void)endRecording{
    [self.audioEngine stop];
    if (_recognitionRequest) {
        [_recognitionRequest endAudio];
    }

    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;

    }
}

#pragma mark---开始录音
- (void)startRecording {
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;

    }

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];

    NSError*error;
    bool audioBool = [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];

    NSParameterAssert(!error);
    bool audioBool1= [audioSession setMode:AVAudioSessionModeMeasurement error:&error];

    NSParameterAssert(!error);
    bool audioBool2= [audioSession setActive:true withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];

    NSParameterAssert(!error);
    if(audioBool || audioBool1||audioBool2) {
        NSLog(@"可以使用");

    }else{
        NSLog(@"这里说明有的功能不支持");

    }

    if (@available(iOS 10.0, *)) {
        self.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    } else {
        self.recognitionTask = [[SFSpeechRecognitionTask alloc] init];
    }

    AVAudioInputNode *inputNode = self.audioEngine.inputNode;

    NSAssert(inputNode,@"录入设备没有准备好");

    NSAssert(self.recognitionRequest, @"请求初始化失败");

    self.recognitionRequest.shouldReportPartialResults = true;

    __weak typeof(self) weakSelf =self;
    //开始识别任务

    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {

        __strong typeof(weakSelf) strongSelf = weakSelf;

        bool isFinal =false;

        if(result) {

//            strongSelf.labText.text= [[result bestTranscription]formattedString];//语音转文本
            [[result bestTranscription]formattedString];
            isFinal = [result isFinal];

        }

        if(error || isFinal) {

            [strongSelf.audioEngine stop];

            [inputNode removeTapOnBus:0];

            strongSelf.recognitionRequest=nil;

            strongSelf.recognitionTask=nil;

//            [strongSelf.swicthBut setTitle:@"开始录音"forState:UIControlStateNormal];
//            strongSelf.swicthBut.enabled=true;

        }

    }];

    AVAudioFormat*recordingFormat = [inputNode outputFormatForBus:0];

    //在添加tap之前先移除上一个不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误

    [inputNode removeTapOnBus:0];


    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer*_Nonnull buffer,AVAudioTime*_Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if(strongSelf.recognitionRequest) {
            [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];

    [self.audioEngine prepare];

    bool audioEngineBool = [self.audioEngine startAndReturnError:&error];

    NSParameterAssert(!error);

//    self.labText.text = @"正在录音。。。";

    NSLog(@"%d",audioEngineBool);

}

- (void)speechRecognizer:(SFSpeechRecognizer*)speechRecognizer availabilityDidChange:(BOOL)available {

    if(available) {
//        self.swicthBut.enabled=YES;
//        [self.swicthBut setTitle:@"开始录音" forState:UIControlStateNormal];

    }else{
//        self.swicthBut.enabled=NO;
//        [self.swicthBut setTitle:@"语音识别不可用" forState:UIControlStateNormal];

    }

}
#pragma mark---识别本地音频文件

- (void)recognizeLocalAudioFile:(UIButton*)sender {

    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

    SFSpeechRecognizer *localRecognizer =[[SFSpeechRecognizer alloc] initWithLocale:local];

    NSURL *url =[[NSBundle mainBundle] URLForResource:@"录音.m4a" withExtension:nil];

    if(!url)return;

    SFSpeechURLRecognitionRequest *res =[[SFSpeechURLRecognitionRequest alloc] initWithURL:url];

    __weak typeof(self) weakSelf = self;

    [localRecognizer recognitionTaskWithRequest:res resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {

        if(error) {
            NSLog(@"语音识别解析失败,%@",error);

        }else {
//            weakSelf.labText.text = result.bestTranscription.formattedString;
            NSLog(@"%@",result.bestTranscription.formattedString);
        }

    }];

}


#pragma mark -- 懒加载 |
+ (instancetype)manager {
    static CalendarManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CalendarManager new];
    });
    return instance;
}
#pragma mark---创建录音引擎
- (AVAudioEngine*)audioEngine {
    if (!_audioEngine) {
        _audioEngine= [[AVAudioEngine alloc]init];
    }
    return _audioEngine;
}
#pragma mark---语音识别器
- (SFSpeechRecognizer*)speechRecognizer {
    if (!_speechRecognizer) {
        NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
        _speechRecognizer= [[SFSpeechRecognizer alloc]initWithLocale:cale];
        //设置代理
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}
@end
