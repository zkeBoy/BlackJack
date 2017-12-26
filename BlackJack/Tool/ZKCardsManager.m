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

//庄家
@property (nonatomic, assign) CGSize  bankerPosition;
//玩家
@property (nonatomic, assign) CGSize  playerPosition;
@property (nonatomic, assign) CGFloat moveLength;

@property (nonatomic, assign) NSInteger playerCoin; //玩家的金币
@end

//所有牌的总数
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

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setManagerDefault];
        [self loadCards];
    }
    return self;
}

- (void)setManagerDefault {
    self.bankerPosition = CGSizeMake(ZScale(-bEndX), ZScale(bEndY));
    self.playerPosition = CGSizeMake(ZScale(-pEndX), ZScale(pEndY));
    self.moveLength = ZScale(20);
    NSNumber * coin = [userDefaults objectForKey:playerCoinNumKey];
    self.playerCoin = !coin?1000:coin.integerValue;
    [userDefaults synchronize];
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
        NSLog(@"第%ld张牌---%@",(long)index,card.cardCombination);
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

#pragma mark - Private Method
//获取一个随机整数，范围在[from,to]，包括from，包括to
- (int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma mark Publick Method
- (void)reCreateCards {
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

- (CGRect)cardDefaultFrame {
    CGFloat w = ZScale(110/2);
    CGFloat h = ZScale(165/2);
    CGFloat x = ZScale(577);
    CGFloat y = ZScale(60);
    return CGRectMake(x, y, w, h);
}

- (CGSize)theBankerCardPosition{
    return self.bankerPosition;
}

- (void)bankerAddCard{
    self.bankerPosition = CGSizeMake(self.bankerPosition.width+self.moveLength, ZScale(bEndY));
}

- (CGSize)thePlayerCardPosition{
    return self.playerPosition;
}

- (void)playerAddCard {
    self.playerPosition = CGSizeMake(self.playerPosition.width+self.moveLength, ZScale(pEndY));
}

- (NSInteger)playCoinNum {
    return self.playerCoin;
}

- (void)playerWin:(NSInteger)coin{
    self.playerCoin = self.playerCoin+coin;
    NSNumber * num = [NSNumber numberWithInteger:self.playerCoin];
    [userDefaults setObject:num forKey:playerCoinNumKey];
    [userDefaults synchronize];
}

- (void)playerlose:(NSInteger)coin{
    self.playerCoin = self.playerCoin-coin;
    NSNumber * num = [NSNumber numberWithInteger:self.playerCoin];
    [userDefaults setObject:num forKey:playerCoinNumKey];
    [userDefaults synchronize];
}

- (NSInteger)bankerMaxScore {
    //庄家的最大点数在16-21之间
    NSInteger max = [self getRandomNumber:16 to:21];
    return max;
}

- (void)reloadGame:(NSArray *)cards {
    [self.allCards addObjectsFromArray:cards];
    
    //重置牌的位置
    [self setManagerDefault];
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
