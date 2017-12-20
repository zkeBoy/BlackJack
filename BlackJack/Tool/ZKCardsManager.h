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

#define ZKCardsManagerDefault [ZKCardsManager shareCardsManager]

#define MaxScore 21

@interface ZKCardsManager : NSObject

//初始化牌 一共52种
+ (ZKCardsManager *)shareCardsManager;

#pragma mark - 初始化牌
//重新生成牌
- (void)reCreateCards;
//得到所有的牌 一共52种 retuen NSArray
- (NSArray <ZKCard *>*)getAllCards;
//取牌方法
- (ZKCard *)getCard;
//根据牌的cardCombination 取值 例如:♥️K = 10
- (NSInteger)getValueByCard:(ZKCard *)card;

#pragma mark - 牌的位置
//牌堆的位置,初始化牌的位置
- (CGRect)cardDefaultFrame;
//庄家
- (CGSize)theBankerCardPosition;
- (void)bankerAddCard;
//玩家
- (CGSize)thePlayerCardPosition;
- (void)playerAddCard;

#pragma mark - 玩家的金币
- (NSInteger)playCoinNum;
- (void)playerWin:(NSInteger)coin;
- (void)playerlose:(NSInteger)coin;

#pragma mark - 庄家的最大数
- (NSInteger)bankerMaxScore;

#pragma mark - 重新开始游戏
//把已经出现过的牌回收回来,始终保持52张,就不用重新去生成牌
- (void)reloadGame:(NSArray *)cards;
@end
