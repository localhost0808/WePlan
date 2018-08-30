//
//  SpeechManager.m
//  WePlan
//
//  Created by Harry on 2018/8/30.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "SpeechManager.h"

@interface SpeechManager()<SFSpeechRecognizerDelegate>
@property (nonatomic, assign)bool isButtonEnabled;
@end

@implementation SpeechManager
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

- (void)setIsButtonEnabled:(bool)isButtonEnabled {
    _isButtonEnabled = isButtonEnabled;
    _SpeechInfo([SpeechManagerInfo isSpeech:isButtonEnabled Text:@"" Error:nil]);
}

#pragma mark---开始录音
- (void)startRecordingWithSpeechInfo:(SpeechInfo)info {
    _SpeechInfo = info;

    __weak typeof(self) WeakSelf=self;
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        bool isButtonEnabled =false;
        switch(status) {
            case SFSpeechRecognizerAuthorizationStatusAuthorized:

                isButtonEnabled =true;
                NSLog(@"可以语音识别");
                [WeakSelf recording];//TODO 跳转录音

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


}

- (void)recording {
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

    self.recognitionRequest = [SFSpeechAudioBufferRecognitionRequest new];

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
            weakSelf.SpeechInfo([SpeechManagerInfo isSpeech:weakSelf.isButtonEnabled Text:[[result bestTranscription]formattedString] Error:nil]);
            isFinal = [result isFinal];
        }

        if(error || isFinal) {

            [strongSelf.audioEngine stop];

            [inputNode removeTapOnBus:0];

            strongSelf.recognitionRequest=nil;

            strongSelf.recognitionTask=nil;

            weakSelf.SpeechInfo([SpeechManagerInfo isSpeech:weakSelf.isButtonEnabled Text:@"" Error:error]);
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

    NSLog(@"正在录音。。。。。。。。。。。。。");
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
            NSLog(@"%@",result.bestTranscription.formattedString);
        }

    }];

}


#pragma mark -- 懒加载 |
+ (instancetype)manager {
    static SpeechManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SpeechManager new];
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

@interface SpeechManagerInfo()

@end

@implementation SpeechManagerInfo
+ (instancetype)manager {
    static SpeechManagerInfo * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SpeechManagerInfo new];
    });
    return instance;
}
+ (instancetype)isSpeech:(bool)isSpeech Text:(NSString *)text Error:(NSError *)error {
    return [[self manager] instanceIsSpeech:isSpeech Text:text Error:error];
}
- (instancetype)instanceIsSpeech:(bool)isSpeech Text:(NSString *)text Error:(NSError *)error {
    self.isSpeech = isSpeech;
    self.text = text;
    self.error = error;
    return self;
}
@end
