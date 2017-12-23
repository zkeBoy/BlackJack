//
//  ZKVoiceManager.m
//  BlackJack
//
//  Created by Tom on 2017/12/22.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKVoiceManager.h"

@interface ZKVoiceManager()

@end

@implementation ZKVoiceManager

+ (ZKVoiceManager *)shareVoiceManager {
    static ZKVoiceManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZKVoiceManager alloc] init];
    });
    return manager;
}

#pragma mark - Publick
- (void)closeVoice{
    //关闭声音就是将静音
}

- (void)openVoice{
    //关闭静音
}

- (void)playVoiceWithType:(voiceType)type{
    if (type==voiceTypeCard) { //发牌的声音
        [self playVoiceWithName:@"setCard.wav"];
    }else if (type==voiceTypeWin) { //赢了的声音
        
    }else if (type==voiceTypelose) { //输了的声音
        
    }else if (type==voiceTypePush) { //平局的声音
        
    }
}

- (void)playVoiceWithName:(NSString *)name {
    [self playSoundEffectWithFilePath:[self appendFilePathWithName:name]];
}

-(void)playSoundEffectWithFilePath:(NSURL *)fileURL{
    //1.获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL), &soundID);
    //如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    //2.播放音频
    AudioServicesPlaySystemSound(soundID);//播放音效
    //AudioServicesPlayAlertSound(soundID);//播放音效并震动
}

void soundCompleteCallback(SystemSoundID soundID,void * clientData){
    NSLog(@"播放完成...");
}

- (NSURL *)appendFilePathWithName:(NSString *)voiceName {
    NSString * path = [[NSBundle mainBundle] pathForResource:voiceName ofType:nil];
    return [NSURL fileURLWithPath:path];
}

@end
