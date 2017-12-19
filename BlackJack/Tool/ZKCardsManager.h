//
//  ZKCardsManager.h
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//  管理一切关于牌的方法 包括胜负结果 分数等
//  以及每张牌的位置

#import <Foundation/Foundation.h>
#import "ZKCard.h"

@interface ZKCardsManager : NSObject

//初始化牌 一共52种
+ (ZKCardsManager *)shareCardsManager;

//重新洗牌
- (void)reAddCards;

//得到所有的牌 一共52种 retuen NSArray
- (NSArray <ZKCard *>*)getAllCards;

//取牌方法
- (ZKCard *)getCard;

//根据牌的cardCombination 取值 例如:♥️K = 10
- (NSInteger)getValueByCard:(ZKCard *)card;

//
- (CGRect)cardDefaultFrame;

//庄家
- (CGRect)theBankerCardFrame;

//玩家
- (CGRect)thePlayerCardFrame;
@end
