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

@end
