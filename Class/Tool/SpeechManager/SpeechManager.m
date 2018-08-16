//
//  SpeechManager.m
//  WePlan
//
//  Created by iOS on 2018/8/16.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import "SpeechManager.h"
@interface SpeechManager ()<SFSpeechRecognizerDelegate>

@end
@implementation SpeechManager
- (BOOL)audioEngineStatusRunning {
    return self.audioEngine.isRunning;
}
- (void)speechIsSpeech:(isSpeechBlock)isSpeech isRunning:(isRunningBlock)isRunning speechText:(speechTextBlock)speechText {
    if ([self.audioEngine isRunning]) {
        [self endRecording];
        return;
    }
    
    _isSpeech = isSpeech;
    _isRunning = isRunning;
    _speechText = speechText;

    __weak typeof(self) weakSelf =self;

    //MARK: 判断是否支出录音功能。10.0以前的也禁止使用
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            switch(status) {
                case SFSpeechRecognizerAuthorizationStatusAuthorized:
                    isSpeech(true);
                    NSLog(@"可以语音识别");
                    //MARK:录音调用 --开始
                        [weakSelf startRecording];
                    //MARK:录音调用 --开始

                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusDenied:
                    
                    isSpeech(false);

                    NSLog(@"用户未授权使用语音识别");
                    
                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusRestricted:
                    
                    isSpeech(false);

                    NSLog(@"语音识别在这台设备上受到限制");
                    
                    break;
                    
                case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                    
                    isSpeech(false);

                    NSLog(@"语音识别未授权");
                    
                    break;
                    
                default:
                    
                    break;
            }
        }];
    } else {
        isSpeech(false);
        NSLog(@"使用语音识别请在iOS10.0以上");
    }
    
}

- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    if(available) {
//        self.isRunning(true);
        
    }else{
//        self.isRunning(false);
        self.isSpeech(false);
    }
}

#pragma mark---停止录音
- (void)endRecording{
    
    [self.audioEngine stop];
    //FIXME:    self.isRunning(false);
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
    if (self.recognitionTask) {//如果存在先移除，保险起见
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
        NSLog(@"执行了10.0之前，这是BUG");//MARK:如果执行就是BUG
        self.recognitionTask = [[SFSpeechRecognitionTask alloc] init];
    }
    
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    
    NSAssert(inputNode,@"录入设备没有准备好");
    NSAssert(self.recognitionRequest, @"请求初始化失败");
    
    self.recognitionRequest.shouldReportPartialResults = true;
    
    __weak typeof(self) weakSelf =self;
    //开始识别任务
    
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:self.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        //MARK: 转换回调
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        bool isFinal =false;
        
        if(result) {
            //MARK:转换的文字传递出去
            weakSelf.speechText([[result bestTranscription]formattedString]);
            isFinal = [result isFinal];
        }
        
        if(error || isFinal) {
            [strongSelf.audioEngine stop];
            [inputNode removeTapOnBus:0];
            strongSelf.recognitionRequest=nil;
            strongSelf.recognitionTask=nil;
//            weakSelf.isRunning(false); // //MARK:isRunning(false) 出错的话就停止
            return ;
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
//    self.isRunning(true);//MARK:isRunning(true)
    NSLog(@"%d",audioEngineBool);
    
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
//        [SFSpeechRecognizer supportedLocales];
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}
@end
