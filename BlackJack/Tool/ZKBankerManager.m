//
//  ZKBankerManager.m
//  BlackJack
//
//  Created by Tom on 2017/12/20.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKBankerManager.h"

typedef void(^updateBlock)(void);
@interface ZKBankerManager ()
@property (nonatomic, strong) NSTimer        * timer;
@property (nonatomic, assign) NSTimeInterval   timeInterval;
@property (nonatomic,   copy) updateBlock      timerBlock;
@end

@implementation ZKBankerManager

+ (ZKBankerManager *)shareBankerManager {
    static ZKBankerManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZKBankerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.timeInterval = 1;
    }
    return self;
}

#pragma mark - Public
- (void)hitCardWithBlock:(void(^)(void))more {
    self.timerBlock = more;
    [self.timer fire];
}

- (void)stopCard {
    [self invalidateTimer];
}

#pragma mark - Private
- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.timeInterval target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}

- (void)updateTimer:(NSTimer *)tt{
    if (self.timerBlock) {
        self.timerBlock();
    }
}

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        self.timerBlock = nil;
    }
}

@end
