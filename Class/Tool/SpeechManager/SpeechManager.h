//
//  SpeechManager.h
//  WePlan
//
//  Created by Harry on 2018/8/30.
//  Copyright © 2018年 Harry. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Speech/Speech.h>
#import<AVFoundation/AVFoundation.h>

@interface SpeechManagerInfo:NSObject
@property (nonatomic, assign) bool isSpeech;
@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) NSError *error;
+ (instancetype)isSpeech:(bool)isSpeech Text:(NSString *)text Error:(NSError *)error;
@end


typedef void(^SpeechInfo)(SpeechManagerInfo *info);

API_AVAILABLE(ios(10.0))
@interface SpeechManager : NSObject
@property (nonatomic,strong) AVAudioEngine *audioEngine;//语音控制

@property(nonatomic,strong) SFSpeechRecognizer*speechRecognizer;//语音识别器

@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;//语音识别请求

@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;//语音任务管理器

@property (nonatomic, copy) SpeechInfo SpeechInfo;
+ (instancetype)manager;
- (void)isSpeech;
- (void)startRecordingWithSpeechInfo:(SpeechInfo)info;
- (void)endRecording;
@end



