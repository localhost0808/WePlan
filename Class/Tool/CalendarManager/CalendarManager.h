//
//  CalendarManager.h
//  WePlan
//
//  Created by Harry on 2018/8/15.
//  Copyright © 2018年 Harry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Speech/Speech.h>
#import<AVFoundation/AVFoundation.h>

API_AVAILABLE(ios(10.0))
@interface CalendarManager : NSObject
@property (nonatomic,strong) AVAudioEngine *audioEngine;//语音控制

@property(nonatomic,strong) SFSpeechRecognizer*speechRecognizer;//语音识别器

@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;//语音识别请求

@property (nonatomic, strong) SFSpeechRecognitionTask *recognitionTask;//语音任务管理器
+ (instancetype)manager;
- (void)isSpeech;
- (void)startRecording;
- (void)endRecording;
@end
