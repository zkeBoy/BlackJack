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
@property (nonatomic, strong) UIImageView * coinMainView;
@property (nonatomic, strong) UIImageView * coinImageView;
@property (nonatomic, strong) UILabel     * coinLabel;   //玩家金币
@property (nonatomic, strong) ZKHelperView* helperView;
@property (nonatomic, strong) UIButton    * menuBtn; //菜单按钮
@property (nonatomic, strong) UIButton    * voiceBtn; //声音按钮
@end

@implementation ZKGameScreen

#pragma mark - Button Action
//下注方法
- (void)betBtnAction:(UIButton *)button {
    //判断金币是否>=倍数
    if (self.coinLabel.text.integerValue<self.betlabel.text.integerValue) {
        [self.helperView showResultWithType:resultTypeLack toView:self hiddenBlock:^{
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
    [cardView1 animateWithDuration:0.5 translationX:-bEndX translationY:pEndY completion:nil];
    [cardView2 animateWithDuration:0.7 translationX:-pEndX translationY:pEndY completion:^{
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
    [cardView3 animateWithDuration:0.5 translationX:-bEndX translationY:bEndY completion:^{
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
    NSInteger banker_ = self.bankerScore.text.integerValue;
    if(banker_>playerAll){ //有可能玩家停牌时的数就小于庄家
        //停止
        [ZKBankerDefaultManager stopCard];
        //玩家输了
        [weakself.helperView showResultWithType:resultTypeLose toView:weakself hiddenBlock:^{
            //重新游戏
            [weakself restartGame];
            weakself.helperView = nil;
        }];
        [weakself playerLoseUpdateCoin];
        return ;
    }
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
            if((bankerAll>playerAll)&&(bankerAll<=21)){ //发牌过程中发现庄家牌大于玩家牌时
                //停止
                [ZKBankerDefaultManager stopCard];
                //玩家输了
                [weakself.helperView showResultWithType:resultTypeLose toView:weakself hiddenBlock:^{
                    //重新游戏
                    [weakself restartGame];
                    weakself.helperView = nil;
                }];
                [weakself playerLoseUpdateCoin];
                return ;
            }
            
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
            }else if ((15<bankerAll&&bankerAll<21)){
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

- (void)selectMenuAction:(UIButton *)btn {
    [self.delegate clickMenu];
    [self restartGame];
}

- (void)exchangeVoiceAction:(UIButton *)btn {
    self.voiceBtn.selected = !btn.selected;
}

#pragma mark - 重新开始游戏
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

#pragma mark - 改变Btn状态,切换图片
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
        
        [self exchangeChipBtnStatus:YES];
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
        
        [self exchangeChipBtnStatus:NO];
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
        
        [self exchangeChipBtnStatus:NO];
    }
}

- (void)exchangeChipBtnStatus:(BOOL)enable {
    UIButton * bet20  = [self viewWithTag:20];
    UIButton * bet100 = [self viewWithTag:100];
    UIButton * bet500 = [self viewWithTag:500];
    UIButton * bet1K  = [self viewWithTag:1000];
    
    bet20.enabled = enable;
    bet20.selected = !enable;
    bet100.enabled = enable;
    bet100.selected = !enable;
    bet500.enabled = enable;
    bet500.selected = !enable;
    bet1K.enabled = enable;
    bet1K.selected = !enable;
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
        make.width.height.mas_equalTo(ZScale(W_H));
        make.left.equalTo(self).offset(ZScale(100));
        make.bottom.equalTo(self).offset(ZScale(-50));
    }];
    
    [self addSubview:self.doubleBtn];
    [self.doubleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(ZScale(W_H));
        make.left.equalTo(self).offset(ZScale(200));
        make.bottom.equalTo(self).offset(ZScale(-30));
    }];
    
    [self addSubview:self.stopCardBtn];
    [self.stopCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(ZScale(W_H));
        make.right.equalTo(self).offset(ZScale(-200));
        make.bottom.equalTo(self).offset(ZScale(-30));
    }];
     
    [self addSubview:self.moreCardBtn];
    [self.moreCardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(ZScale(W_H));
        make.right.equalTo(self).offset(ZScale(-100));
        make.bottom.equalTo(self).offset(ZScale(-50));
    }];
    
    [self addSubview:self.betlabel];
    [self.betlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.doubleBtn.mas_centerY);
        make.left.equalTo(self.doubleBtn.mas_right).offset(ZScale(20));
        make.right.equalTo(self.stopCardBtn.mas_left).offset(ZScale(-20));
        make.height.mas_equalTo(ZScale(40));
    }];
    
    [self addSubview:self.cardView];
    
    [self addSubview:self.coinMainView];
    [self.coinMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ZScale(40));
        make.top.equalTo(self).offset(ZScale(10));
        make.left.equalTo(self).offset(S_WIDTH/5);
        make.width.mas_equalTo(ZScale(S_WIDTH/5+20));
    }];
    
    [self.coinMainView addSubview:self.coinImageView];
    [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(ZScale(25));
        make.left.equalTo(self.coinMainView).offset(5);
        make.centerY.equalTo(self.coinMainView);
    }];
    
    [self.coinMainView addSubview:self.coinLabel];
    [self.coinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.coinMainView);
        make.right.equalTo(self.coinMainView).offset(-4);
    }];
    
    [self addSubview:self.menuBtn];
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ZScale(10));
        make.width.height.mas_equalTo(ZScale(30));
        make.right.equalTo(self).offset(ZScale(-60));
    }];
    
    [self addSubview:self.voiceBtn];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ZScale(10));
        make.width.height.mas_equalTo(ZScale(30));
        make.right.equalTo(self.menuBtn.mas_left).offset(ZScale(-30));
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
        button.layer.cornerRadius = ZScale(W_H/2);
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
            make.width.height.mas_equalTo(ZScale(W_H));
            make.right.equalTo(self).offset(ZScale(-20));
            make.top.equalTo(self).offset(ZScale(70+index*(W_H+20)));
        }];
        index++;
    }
}

#pragma mark - Paivate Method 刷新用户金币
- (void)updatePlayerCoinNum {
    _coinLabel.text = [NSString stringWithFormat:@"%ld",(long)[ZKCardsManagerDefault playCoinNum]];
}

- (void)playerWinUpdateCoin {
    NSInteger coin = self.betlabel.text.integerValue;
    [ZKCardsManagerDefault playerWin:coin];
    [UIImageView imageView:self.coinImageView animationWithType:ZKAnimationTypeScale completionHandler:^{
       [self updatePlayerCoinNum];
    }];
}

- (void)playerLoseUpdateCoin{
    NSInteger coin = self.betlabel.text.integerValue;
    [ZKCardsManagerDefault playerlose:coin];
    [UIImageView imageView:self.coinImageView animationWithType:ZKAnimationTypeScale completionHandler:^{
        [self updatePlayerCoinNum];
    }];
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
        _betlabel.layer.cornerRadius = ZScale(10);
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

- (UIImageView *)coinMainView {
    if (!_coinMainView) {
        _coinMainView = [[UIImageView alloc] init];
        _coinMainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _coinMainView.layer.cornerRadius = 8.0f;
        _coinMainView.layer.masksToBounds = YES;
        _coinMainView.layer.borderWidth = 1.5f;
        _coinMainView.layer.borderColor = [UIColor blackColor].CGColor;
        _coinMainView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _coinMainView;
}

- (UIImageView *)coinImageView {
    if (!_coinImageView) {
        _coinImageView = [[UIImageView alloc] init];
        _coinImageView.image = [UIImage imageNamed:@"icon_coin"];
    }
    return _coinImageView;
}

- (UILabel *)coinLabel {
    if (!_coinLabel) {
        _coinLabel = [[UILabel alloc] init];
        _coinLabel.backgroundColor = [UIColor clearColor];
        _coinLabel.textAlignment = NSTextAlignmentRight;
        _coinLabel.textColor = [UIColor whiteColor];
        _coinLabel.font = [UIFont boldSystemFontOfSize:16];
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

- (UIButton *)menuBtn {
    if (!_menuBtn) {
        _menuBtn = [[UIButton alloc] init];
        _menuBtn.backgroundColor = [UIColor clearColor];
        [_menuBtn setImage:[UIImage imageNamed:@"icon_menu"] forState:UIControlStateNormal];
        [_menuBtn addTarget:self action:@selector(selectMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}

- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
        _voiceBtn = [[UIButton alloc] init];
        _voiceBtn.backgroundColor = [UIColor clearColor];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_voice"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"icon_voiceClose"] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(exchangeVoiceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceBtn;
}

- (UIButton *)loadButtonAddTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents nor:(UIImage *)norImage select:(UIImage *)selectImage {
    UIButton * button = [[UIButton alloc] init];
    button.layer.cornerRadius = ZScale(W_H/2);
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
    score.layer.cornerRadius = ZScale(15);
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
