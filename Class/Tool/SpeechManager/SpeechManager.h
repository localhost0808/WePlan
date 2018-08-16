//
//  SpeechManager.h
//  WePlan
//
//  Created by iOS on 2018/8/16.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Speech/Speech.h>
#import<AVFoundation/AVFoundation.h>

typedef void(^isSpeechBlock)(BOOL isSpeech);
typedef void(^isRunningBlock)(BOOL isRunning);
typedef void(^speechTextBlock)(NSString* speechText);


API_AVAILABLE(ios(10.0))
@interface SpeechManager : NSObject

@property (nonatomic,copy) isSpeechBlock isSpeech;//是否支持语音识别
@property (nonatomic,copy) isRunningBlock isRunning;//是否正在运行中
@property (nonatomic,copy) speechTextBlock speechText;//生成的文本

@property (nonatomic,strong) AVAudioEngine *audioEngine;//语音控制

@property(nonatomic,strong) SFSpeechRecognizer*speechRecognizer;//语音识别器

@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;//语音识别请求

@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;//语音任务管理器

+ (instancetype)manager;
- (void)speechIsSpeech:(isSpeechBlock)isSpeech isRunning:(isRunningBlock)isRunning speechText:(speechTextBlock)speechText;
- (void)endRecording;
- (void)startRecording;
- (BOOL)audioEngineStatusRunning;
@end
