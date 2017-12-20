//
//  ZKGameSceen.m
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ZKGameScreen.h"
@interface ZKGameScreen()
@property (nonatomic, strong) UIImageView * backgrodundView;
@property (nonatomic, strong) UIButton    * betBtn;      //下注
@property (nonatomic, strong) UIButton    * doubleBtn;   //加倍
@property (nonatomic, strong) UIButton    * stopCardBtn; //停牌
@property (nonatomic, strong) UIButton    * moreCardBtn; //要牌
@property (nonatomic, strong) UILabel     * betlabel;    //现实倍数
@property (nonatomic, strong) UIImageView * cardView;
@property (nonatomic, strong) UILabel     * bankerScore; //庄家得分
@property (nonatomic, strong) UILabel     * playerScore; //玩家得分
@property (nonatomic, strong) NSMutableArray * allCardViews; //桌面上所有的牌
@property (nonatomic, strong) NSMutableArray * allCards;
@property (nonatomic, strong) UILabel     * coinLabel;   //玩家金币
@property (nonatomic, strong) ZKHelperView* helperView;
@end

@implementation ZKGameScreen

#pragma mark - Button Action
//下注方法
- (void)betBtnAction:(UIButton *)button {
    //判断金币是否>=倍数
    if (self.coinLabel.text.integerValue<self.betlabel.text.integerValue) {
        [self.helperView showResultWithType:resultTypeLack hiddenBlock:^{
            self.helperView = nil;
        }];
        return;
    }
    
    [self exchangeBtnEnable:clickTypeBet];
    WEAK_SELF(self);
    //玩家
    ZKCard * card1 = [ZKCardsManager shareCardsManager].getCard; [self.allCards addObject:card1];
    ZKCard * card2 = [ZKCardsManager shareCardsManager].getCard; [self.allCards addObject:card2];
    ZKCardView * cardView1 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    ZKCardView * cardView2 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:cardView1]; [self.allCardViews addObject:cardView1];
    [self addSubview:cardView2]; [self.allCardViews addObject:cardView2];
    [cardView1 animateWithDuration:0.5 translationX:-320 translationY:180 completion:nil];
    [cardView2 animateWithDuration:0.7 translationX:-300 translationY:180 completion:^{
        //加载玩家分数
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger s1 = [[ZKCardsManager shareCardsManager] getValueByCard:card1];
            NSInteger s2 = [[ZKCardsManager shareCardsManager] getValueByCard:card2];
            NSInteger pScore = s1+s2;
            weakself.playerScore.text = [NSString stringWithFormat:@"%ld",(long)pScore];
            weakself.playerScore.hidden = NO;
            weakself.playerScore.frame = CGRectMake(ZScale((S_WIDTH-100-119/2-335)), ZScale(220+165/4-15), ZScale(30), ZScale(30));
            [weakself addSubview:weakself.playerScore];
        });
    }];
    
    //庄家
    ZKCard * card3 = [ZKCardsManager shareCardsManager].getCard; [self.allCards addObject:card3];
    ZKCardView * cardView3 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:cardView3];
    [self.allCardViews addObject:cardView3];
    [cardView3 animateWithDuration:0.5 translationX:-320 translationY:50 completion:^{
        //加载庄家分数
        dispatch_async(dispatch_get_main_queue(), ^{
            NSInteger bScore = [[ZKCardsManager shareCardsManager] getValueByCard:card3];
            weakself.bankerScore.text = [NSString stringWithFormat:@"%ld",(long)bScore];
            weakself.bankerScore.hidden = NO;
            weakself.bankerScore.frame = CGRectMake(ZScale((S_WIDTH-100-119/2-335)), ZScale(90+165/4-15), ZScale(30), ZScale(30));
            [weakself addSubview:weakself.bankerScore];
        });
    }];
}

//双倍方法
- (void)doubleBtnAction:(UIButton *)button {
    //判断玩家的金币是否够
    NSInteger coin = [ZKCardsManagerDefault playCoinNum];
    NSInteger bet = self.betlabel.text.integerValue*2;
    if (coin<bet) {
        //玩家金币不足,提醒用户
        [self.helperView showResultWithType:resultTypeLack toView:self hiddenBlock:^{
            self.helperView = nil;
        }];
        return;
    }
    self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)bet];
}

//停牌方法
- (void)stopCardBtnAction:(UIButton *)button {
    [self exchangeBtnEnable:clickTypeStop];
    WEAK_SELF(self);
    NSInteger playerAll = self.playerScore.text.integerValue;
    //该庄家要牌了
    [ZKBankerDefaultManager hitCardWithBlock:^{
        [ZKCardsManagerDefault bankerAddCard]; //改变位置
        ZKCard * card = [ZKCardsManagerDefault getCard]; [self.allCards addObject:card];
        ZKCardView * newCardView = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
        [self addSubview:newCardView];
        [self.allCardViews addObject:newCardView];
        [newCardView animateWithDuration:0.5 translation:[ZKCardsManager shareCardsManager].theBankerCardPosition completion:^{
            NSInteger bScore = [[ZKCardsManager shareCardsManager] getValueByCard:card];
            NSInteger score = self.bankerScore.text.integerValue;
            NSInteger bankerAll = bScore+score;
            weakself.bankerScore.text = [NSString stringWithFormat:@"%ld",(long)bankerAll];
            
            //比较结果
            if (bankerAll==21) {
                //停止
                [ZKBankerDefaultManager stopCard];
                //与玩家比较大小
                if (bankerAll==playerAll) {//平局
                    [weakself.helperView showResultWithType:resultTypePush toView:weakself hiddenBlock:^{
                        //重新游戏
                        [weakself restartGame];
                        weakself.helperView = nil;
                    }];
                }else {//玩家输了
                    [weakself.helperView showResultWithType:resultTypeLose toView:weakself hiddenBlock:^{
                        //重新游戏
                        [weakself restartGame];
                        weakself.helperView = nil;
                    }];
                    [weakself playerLoseUpdateCoin];
                }
            }else if (bankerAll>21){
                //停止
                [ZKBankerDefaultManager stopCard];
                //玩家赢了
                [weakself.helperView showResultWithType:resultTypeWin toView:weakself hiddenBlock:^{
                    //重新游戏
                    [weakself restartGame];
                    weakself.helperView = nil;
                }];
                [weakself playerWinUpdateCoin];
            }else if (17<bankerAll&&bankerAll<21){
                //停止
                [ZKBankerDefaultManager stopCard];
                //比较大小
                if (bankerAll==playerAll) {//平局
                    [weakself.helperView showResultWithType:resultTypePush toView:weakself hiddenBlock:^{
                        [weakself restartGame];
                        weakself.helperView = nil;
                    }];
                }else if(bankerAll>playerAll){//玩家输了
                    [weakself.helperView showResultWithType:resultTypeLose toView:weakself hiddenBlock:^{
                        [weakself restartGame];
                        weakself.helperView = nil;
                    }];
                    [weakself playerLoseUpdateCoin];
                }else {//玩家赢了
                    [weakself.helperView showResultWithType:resultTypeWin toView:weakself hiddenBlock:^{
                        [weakself restartGame];
                        weakself.helperView = nil;
                    }];
                    [weakself playerWinUpdateCoin];
                }
            }
        }];
    }];
}

//要牌方法
- (void)moreCardAction:(UIButton *)button {
    WEAK_SELF(self);
    [[ZKCardsManager shareCardsManager] playerAddCard];
    ZKCard * card = [ZKCardsManager shareCardsManager].getCard; [self.allCards addObject:card];
    ZKCardView * newCard = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:newCard];
    [self.allCardViews addObject:newCard];
    [newCard animateWithDuration:0.5 translation:[ZKCardsManager shareCardsManager].thePlayerCardPosition completion:^{
        NSInteger s1 = weakself.playerScore.text.integerValue;
        NSInteger s2 = [[ZKCardsManager shareCardsManager] getValueByCard:card];
        weakself.playerScore.text = [NSString stringWithFormat:@"%ld",(long)(s1+s2)];
        
        //比较玩家是否超过21
        NSInteger player = s1+s2;
        if (player>MaxScore) {
            //玩家输了
            [weakself.helperView showResultWithType:resultTypeLose toView:weakself hiddenBlock:^{
                //重新发牌
                [weakself restartGame];
                weakself.helperView = nil;
            }];
            //更新玩家金币
            [weakself playerLoseUpdateCoin];
            return ;
        }
    }];
}

- (void)chipButtonAction:(UIButton *)button {
    NSInteger tag = button.tag;
    NSInteger coin = [ZKCardsManagerDefault playCoinNum];
    if (coin<tag) {
        //玩家金币不足,提醒用户
        [self.helperView showResultWithType:resultTypeLack toView:self hiddenBlock:^{
            self.helperView = nil;
        }];
        return;
    }
    self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)tag];
}

//重新开始游戏
- (void)restartGame {
    for (ZKCardView * card in self.allCardViews) {
        if ([card isKindOfClass:[ZKCardView class]]) {
            [card removeFromSuperview];
        }
    }
    self.bankerScore.hidden = YES;
    self.playerScore.hidden = YES;

    [ZKCardsManagerDefault reloadGame:self.allCards];
    
    [self exchangeBtnEnable:clickTypeEnd];
}

- (void)exchangeBtnEnable:(clickType)type{
    if (type==clickTypeEnd) {
        self.betBtn.enabled = YES;
        self.betBtn.selected = NO;
        self.doubleBtn.enabled = YES;
        self.doubleBtn.selected = NO;
        
        self.stopCardBtn.enabled = NO;
        self.stopCardBtn.selected = YES;
        self.moreCardBtn.enabled = NO;
        self.moreCardBtn.selected = YES;
    }
    
    if (type==clickTypeBet) {
        self.betBtn.enabled = NO;
        self.betBtn.selected = YES;
        self.doubleBtn.enabled = NO;
        self.doubleBtn.selected = YES;
        
        self.stopCardBtn.enabled = YES;
        self.stopCardBtn.selected = NO;
        self.moreCardBtn.enabled = YES;
        self.moreCardBtn.selected = NO;
    }
    
    if (type==clickTypeStop||type==clickTypeMore) {
        self.betBtn.enabled = NO;
        self.betBtn.selected = YES;
        self.doubleBtn.enabled = NO;
        self.doubleBtn.selected = YES;
        
        self.stopCardBtn.enabled = NO;
        self.stopCardBtn.selected = YES;
        self.moreCardBtn.enabled = NO;
        self.moreCardBtn.selected = YES;
    }
}

#pragma mark - setUI
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        [self setChipButtons];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.backgrodundView];
    [self.backgrodundView setFrame:self.bounds];
    
    [self addSubview:self.betBtn];
    [self.betBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(W_H);
        make.left.equalTo(self).offset(100);
        make.bottom.equalTo(self).offset(-50);
    }];
    
    [self addSubview:self.doubleBtn];
    [self.doubleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(W_H);
        make.left.equalTo(self).offset(200);
        make.bottom.equalTo(self).offset(-30);
    }];
    
    [self addSubview:self.stopCardBtn];
    [self.stopCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(W_H);
        make.right.equalTo(self).offset(-200);
        make.bottom.equalTo(self).offset(-30);
    }];
     
    [self addSubview:self.moreCardBtn];
    [self.moreCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(W_H);
        make.right.equalTo(self).offset(-100);
        make.bottom.equalTo(self).offset(-50);
    }];
    
    [self addSubview:self.betlabel];
    [self.betlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.doubleBtn.mas_centerY);
        make.left.equalTo(self.doubleBtn.mas_right).offset(20);
        make.right.equalTo(self.stopCardBtn.mas_left).offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.cardView];
    
    [self addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ZScale(40));
        make.top.equalTo(self).offset(ZScale(10));
        make.left.equalTo(self.betBtn.mas_left);
        make.width.equalTo(self.betlabel.mas_width);
    }];
}

//设置筹码
- (void)setChipButtons{
    NSInteger index = 0;
    NSArray * tags = @[@20,@100,@500,@1000];
    NSArray * chips = @[@"20",@"100",@"500",@"1K"];
    NSMutableArray * btns = [NSMutableArray array];
    for (NSString * chip in chips) {
        UIButton * button = [[UIButton alloc] init];
        NSNumber * tag = tags[index];
        button.layer.cornerRadius = W_H/2;
        button.layer.masksToBounds = YES;
        button.tag = tag.integerValue;
        button.backgroundColor = [UIColor blackColor];
        [button setTitle:chip forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chipButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [btns addObject:button];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(W_H);
            make.right.equalTo(self).offset(-20);
            make.top.equalTo(self).offset(60+index*(W_H+20));
        }];
        index++;
    }
}

#pragma mark - Paivate Method
- (void)updatePlayerCoinNum {
    _coinLabel.text = [NSString stringWithFormat:@"%ld",(long)[ZKCardsManagerDefault playCoinNum]];
}

- (void)playerWinUpdateCoin {
    NSInteger coin = self.betlabel.text.integerValue;
    [ZKCardsManagerDefault playerWin:coin];
    [self updatePlayerCoinNum];
}

- (void)playerLoseUpdateCoin{
    NSInteger coin = self.betlabel.text.integerValue;
    [ZKCardsManagerDefault playerlose:coin];
    [self updatePlayerCoinNum];
}

#pragma mark - lazy init
- (UIImageView *)backgrodundView {
    if (!_backgrodundView) {
        _backgrodundView = [[UIImageView alloc] init];
        _backgrodundView.image = [UIImage imageNamed:@""];
        _backgrodundView.backgroundColor = [UIColor greenColor];
    }
    return _backgrodundView;
}

- (UIButton *)betBtn {
    if (!_betBtn) {
        _betBtn = [self loadButtonAddTarget:self action:@selector(betBtnAction:) forControlEvents:UIControlEventTouchUpInside nor:[UIImage imageNamed:@""] select:[UIImage imageNamed:@""]];
        [_betBtn setTitle:NSLocalizedString(@"下注", nil) forState:UIControlStateNormal];
    }
    return _betBtn;
}

- (UIButton *)doubleBtn {
    if (!_doubleBtn) {
        _doubleBtn = [self loadButtonAddTarget:self action:@selector(doubleBtnAction:) forControlEvents:UIControlEventTouchUpInside nor:[UIImage imageNamed:@""] select:[UIImage imageNamed:@""]];
        [_doubleBtn setTitle:NSLocalizedString(@"双倍", nil) forState:UIControlStateNormal];
    }
    return _doubleBtn;
}

- (UIButton *)stopCardBtn {
    if (!_stopCardBtn) {
        _stopCardBtn = [self loadButtonAddTarget:self action:@selector(stopCardBtnAction:) forControlEvents:UIControlEventTouchUpInside nor:[UIImage imageNamed:@""] select:[UIImage imageNamed:@""]];
        [_stopCardBtn setTitle:NSLocalizedString(@"停牌", nil) forState:UIControlStateNormal];
    }
    return _stopCardBtn;
}
- (UIButton *)moreCardBtn {
    if (!_moreCardBtn) {
        _moreCardBtn = [self loadButtonAddTarget:self action:@selector(moreCardAction:) forControlEvents:UIControlEventTouchUpInside nor:[UIImage imageNamed:@""] select:[UIImage imageNamed:@""]];
        [_moreCardBtn setTitle:NSLocalizedString(@"要牌", nil) forState:UIControlStateNormal];
    }
    return _moreCardBtn;
}

- (UILabel *)betlabel {
    if (!_betlabel) {
        _betlabel = [[UILabel alloc] init];
        _betlabel.backgroundColor = [UIColor clearColor];
        _betlabel.textColor = [UIColor whiteColor];
        _betlabel.textAlignment = NSTextAlignmentCenter;
        _betlabel.layer.borderWidth = 2;
        _betlabel.layer.borderColor = [UIColor yellowColor].CGColor;
        _betlabel.layer.cornerRadius = 10;
        _betlabel.layer.masksToBounds = YES;
        _betlabel.font = [UIFont boldSystemFontOfSize:18];
        _betlabel.text = NSLocalizedString(@"20", nil);
    }
    return _betlabel;
}

- (UIImageView *)cardView {
    if (!_cardView) {
        _cardView = [self cardDefaultView];
        _cardView.frame = [ZKCardsManager shareCardsManager].cardDefaultFrame;
    }
    return _cardView;
}

- (UIImageView *)cardDefaultView {
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_Card"]];
    return imageView;
}

- (NSMutableArray *)allCardViews {
    if (!_allCardViews) {
        _allCardViews = [[NSMutableArray alloc] init];
    }
    return _allCardViews;
}

- (NSMutableArray *)allCards {
    if (!_allCards) {
        _allCards = [NSMutableArray array];
    }
    return _allCards;
}

- (UILabel *)bankerScore {
    if (!_bankerScore) {
        _bankerScore = [self loadScoreLabel];
    }
    return _bankerScore;
}

- (UILabel *)playerScore {
    if (!_playerScore) {
        _playerScore = [self loadScoreLabel];
    }
    return _playerScore;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.backgroundColor = [UIColor clearColor];
        _coinLabel.textAlignment = NSTextAlignmentRight;
        _coinLabel.textColor = [UIColor whiteColor];
        _coinLabel.layer.borderWidth = 2;
        _coinLabel.layer.borderColor = [UIColor yellowColor].CGColor;
        _coinLabel.layer.cornerRadius = 10;
        _coinLabel.layer.masksToBounds = YES;
        _coinLabel.font = [UIFont boldSystemFontOfSize:18];
        [self updatePlayerCoinNum];
    }
    return _coinLabel;
}

- (ZKHelperView *)helperView {
    if (!_helperView) {
        _helperView = [[ZKHelperView alloc] initWithFrame:CGRectMake(0, S_HEIGHT, S_WIDTH, S_HEIGHT)];
    }
    return _helperView;
}

- (UIButton *)loadButtonAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents nor:(UIImage *)norImage select:(UIImage *)selectImage {
    UIButton * button = [[UIButton alloc] init];
    button.layer.cornerRadius = W_H/2;
    button.layer.masksToBounds = YES;
    button.backgroundColor = [UIColor blackColor];
    [button addTarget:target action:action forControlEvents:controlEvents];
    [button setImage:norImage forState:UIControlStateNormal];
    [button setImage:selectImage forState:UIControlStateSelected];
    return button;
}

- (UILabel *)loadScoreLabel {
    UILabel * score = [[UILabel alloc] init];
    score.textColor = [UIColor whiteColor];
    score.textAlignment = NSTextAlignmentCenter;
    score.backgroundColor = [UIColor purpleColor];
    score.layer.cornerRadius = 15;
    score.layer.masksToBounds = YES;
    score.font = [UIFont boldSystemFontOfSize:18];
    score.hidden = YES;
    return score;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
