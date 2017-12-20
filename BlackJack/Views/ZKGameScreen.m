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
@property (nonatomic, strong) NSMutableArray * allCards;
@property (nonatomic, strong) UILabel     * bankerScore; //庄家得分
@property (nonatomic, strong) UILabel     * playerScore; //玩家得分

@property (nonatomic, strong) UILabel     * coinLabel;  //玩家金币

@end

@implementation ZKGameScreen

#pragma mark - Button Action
//下注方法
- (void)betBtnAction:(UIButton *)button {
    button.enabled = NO;
    WEAK_SELF(self);
    //玩家
    ZKCard * card1 = [ZKCardsManager shareCardsManager].getCard;
    ZKCard * card2 = [ZKCardsManager shareCardsManager].getCard;
    ZKCardView * cardView1 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    ZKCardView * cardView2 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:cardView1]; [self.allCards addObject:cardView1];
    [self addSubview:cardView2]; [self.allCards addObject:cardView2];
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
    ZKCard * card3 = [ZKCardsManager shareCardsManager].getCard;
    ZKCardView * cardView3 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:cardView3];
    [self.allCards addObject:cardView3];
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
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"金币不足"
                                                             message:@""
                                                            delegate:nil
                                                   cancelButtonTitle:@"确定"
                                                   otherButtonTitles:@"取消",
                                   nil];
        [alertView show];
        return;
    }
    self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)bet];
}

//停牌方法
- (void)stopCardBtnAction:(UIButton *)button {
    //该庄家要牌了
}

//要牌方法
- (void)moreCardAction:(UIButton *)button {
    WEAK_SELF(self);
    [[ZKCardsManager shareCardsManager] playerAddCard];
    ZKCard * card = [ZKCardsManager shareCardsManager].getCard;
    ZKCardView * newCard = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:newCard];
    [self.allCards addObject:newCard];
    [newCard animateWithDuration:0.5 translation:[ZKCardsManager shareCardsManager].thePlayerCardPosition completion:^{
        NSInteger s1 = weakself.playerScore.text.integerValue;
        NSInteger s2 = [[ZKCardsManager shareCardsManager] getValueByCard:card];
        weakself.playerScore.text = [NSString stringWithFormat:@"%ld",(long)(s1+s2)];
        
        //比较玩家是否超过21
        NSInteger player = s1+s2;
        if (player>MaxScore) {
            //玩家输了
            NSInteger lose = self.betlabel.text.integerValue;
            [ZKCardsManagerDefault playerlose:lose];
            //更新玩家金币
            [self updatePlayerCoinNum];
            
            //重新发牌
            return ;
        }
    }];
}

- (void)chipButtonAction:(UIButton *)button {
    switch (button.tag) {
        case 20:{
            self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)20];
        }
            break;
        case 100:{
            self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)100];
        }
            break;
        case 500:{
            self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)500];
        }
            break;
        case 1000:{
            self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)1000];
        }
            break;
        default:
            break;
    }
}

//- (void)restart

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

- (NSMutableArray *)allCards {
    if (!_allCards) {
        _allCards = [[NSMutableArray alloc] init];
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
