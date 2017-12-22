//
//  ZKVoiceManager.h
//  BlackJack
//
//  Created by Tom on 2017/12/22.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//  声音管理器

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, voiceType) {
    voiceTypeCard = 0, //发牌
    voiceTypeWin  = 1, //玩家赢了
    voiceTypelose = 2, //玩家输了
    voiceTypePush = 3, //平手
};

#define ZKVoiceDefauleManager [ZKVoiceManager shareVoiceManager]
@interface ZKVoiceManager : NSObject
+ (ZKVoiceManager *)shareVoiceManager;

- (void)closeVoice;
- (void)openVoice;
- (void)playVoiceWithFilePath:(NSString *)path;
- (void)playVoiceWithType:(voiceType)type;
@end
