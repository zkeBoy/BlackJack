//
//  ZKCardsManager.h
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//  管理一切关于牌的方法 包括胜负结果 分数等

#import <Foundation/Foundation.h>
#import "ZKCard.h"

@interface ZKCardsManager : NSObject

//初始化牌 一共52种
+ (ZKCardsManager *)shareCardsManager;

//重新洗牌
- (void)reAddCards;

//得到所有的牌 一共52种 retuen NSArray
- (NSArray <ZKCard *>*)getAllCards;

//已经放在桌上的牌 return NSArray
- (NSArray <ZKCard *>*)getExistCards;

//添加已经出现的牌
- (void)addCardToExist:(ZKCard *)card;

//取牌方法
- (ZKCard *)getCard;

//根据牌的cardCombination 取值 例如:♥️K = 10
- (NSInteger)getValueByCard:(ZKCard *)card;


@end
