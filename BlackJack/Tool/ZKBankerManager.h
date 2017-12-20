//
//  ZKBankerManager.h
//  BlackJack
//
//  Created by Tom on 2017/12/20.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//  庄家管理

#import <Foundation/Foundation.h>
#define ZKBankerDefaultManager [ZKBankerManager shareBankerManager]
@interface ZKBankerManager : NSObject
+ (ZKBankerManager *)shareBankerManager;
- (void)hitCardWithBlock:(void(^)(void))more;
- (void)stopCard;
@end
