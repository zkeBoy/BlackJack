//
//  ZKCardsManager.m
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKCardsManager.h"

@interface ZKCardsManager()
@property (nonatomic, strong) NSMutableArray * allCards;
@property (nonatomic, strong) NSMutableArray * existCards;
@end

static NSInteger cards = 52;

@implementation ZKCardsManager
+ (ZKCardsManager *)shareCardsManager {
    static ZKCardsManager * cardManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cardManager = [[ZKCardsManager alloc] init];
    });
    return cardManager;
}

#pragma mark - Private Method
- (instancetype)init{
    self = [super init];
    if (self) {
        [self loadCards];
    }
    return self;
}

//生产牌 produce cards
- (void)loadCards {
    for (NSInteger time=0; time<cards; ) {
        NSInteger cardType = [self getRandomNumber:0 to:3];
        NSInteger cardNum  = [self getRandomNumber:1 to:13];
        ZKCard * card = [[ZKCard alloc] initWithType:cardType num:cardNum];
        //先判断这张牌是否已经存在
        if (![self compareThisCardExist:card]) {
            time++;
            [self.allCards addObject:card];
        }
    }

#ifdef ZKDebug
    NSInteger index=1;
    for (ZKCard * card in self.allCards) {
        NSLog(@"第%ld张牌---%@",index,card.cardCombination);
        index++;
    }
#endif
}

- (BOOL)compareThisCardExist:(ZKCard *)card {
    BOOL exist = NO;
    if (self.allCards.count) {
        for (ZKCard * target in self.allCards) {
            if ([target.cardImage isEqualToString:card.cardImage]) {
                exist = YES;
                break;
            }
        }
    }
    return exist;
}

//获取一个随机整数，范围在[from,to]，包括from，包括to
- (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark Publick Method
- (void)reAddCards {
    [self.allCards removeAllObjects];
    [self.existCards removeAllObjects];
    [self loadCards];
}

- (NSArray <ZKCard *>*)getAllCards {
    return [self.allCards mutableCopy];
}

- (NSArray <ZKCard *>*)getExistCards {
    return [self.existCards mutableCopy];
}

- (void)addCardToExist:(ZKCard *)card {
    [self.existCards addObject:card];
}

- (ZKCard *)getCard {
    if (self.allCards.count) {
        ZKCard * card = self.allCards.firstObject;
        [self.allCards removeObject:card];
        return card;
    }
    return nil;
}

- (NSInteger)getValueByCard:(ZKCard *)card {
    if ([card.cardNum isEqualToString:@"A"]) {
        return 1;
    }else if ([card.cardNum isEqualToString:@"J"]||[card.cardNum isEqualToString:@"Q"]||[card.cardNum isEqualToString:@"K"]) {
        return 10;
    }
    return card.cardNum.integerValue;
}

#pragma mark - lazy init
- (NSMutableArray *)allCards {
    if (!_allCards) {
        _allCards = [NSMutableArray arrayWithCapacity:cards];
    }
    return _allCards;
}

- (NSMutableArray *)existCards {
    if (_existCards) {
        _existCards = [NSMutableArray arrayWithCapacity:cards];
    }
    return _existCards;
}

@end
