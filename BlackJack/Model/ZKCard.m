//
//  ZKCard.m
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKCard.h"

@implementation ZKCard
- (instancetype)initWithType:(NSInteger)type num:(NSInteger)num {
    self = [super init];
    if (self) {
        self.type = type;
        self.num = num;
        _cardCombination = [NSString stringWithFormat:@"%@%@",_cardType,_cardNum];
        _cardImage = [NSString stringWithFormat:@"%@_%@",[self getCardEngType:type],_cardNum]; //readHeart_A
    }
    return self;
}

- (void)setType:(NSInteger)type {
    if (type==cardTypeRedHeart) {
        _cardType = @"♥️";
    }else if (type==cardTypeRedBlock) {
        _cardType = @"♦️";
    }else if (type==cardTypeBlackHeart) {
        _cardType = @"♠️";
    }else if (type==cardTypeBlackPlum) {
        _cardType = @"♣️";
    }
}
- (void)setNum:(NSInteger)num {
    if (num==1) {
        _cardNum = @"A";
    }else if(num==11) {
        _cardNum = @"J";
    }else if(num==12) {
        _cardNum = @"Q";
    }else if(num==13) {
        _cardNum = @"K";
    }else{
        _cardNum = [NSString stringWithFormat:@"%ld",(long)num];
    }
}

- (NSString *)getCardEngType:(NSInteger)type{
    if (type==cardTypeRedHeart) {
        return @"readHeart"; // ♥️
    }else if (type==cardTypeRedBlock) {
        return @"block";  // ♦️
    }else if (type==cardTypeBlackHeart) {
        return @"blackHeart";//♠️
    }else if (type==cardTypeBlackPlum) {
        return @"plum"; //♣️
    }
    return @"None";
}

@end
