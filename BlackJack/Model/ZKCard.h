//
//  ZKCard.h
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
/*
 花色:
   红桃 ♥️ redHeart
   方块 ♦️ redBlock
   黑桃 ♠️ blackHeart
   梅花 ♣️ blackPlum
 
 大小:
   A 2 3 4 5 6 7 8 9 10 J  Q  K  //
   1 2 3 4 5 6 7 8 9 10 11 12 13 //实际数值
   1 2 3 4 5 6 7 8 9 10 10 10 10 //游戏数值
 除去王 一共 13X4 = 52
 
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, cardType) {
    cardTypeRedHeart   = 0, //♥️
    cardTypeRedBlock   = 1, //♦️
    cardTypeBlackHeart = 2, //♠️
    cardTypeBlackPlum  = 3  //mei hua
};

@interface ZKCard : NSObject
@property (nonatomic, assign) NSInteger  type;
@property (nonatomic, assign) NSInteger  num;

//readonly
@property (nonatomic, copy, readonly) NSString * cardType;
@property (nonatomic, copy, readonly) NSString * cardNum;
@property (nonatomic, copy, readonly) NSString * cardCombination; //牌组合 ♥️A Debug
@property (nonatomic, copy, readonly) NSString * cardImage;
- (instancetype)initWithType:(NSInteger)type num:(NSInteger)num;
@end
