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
@end

@implementation ZKGameScreen

#pragma mark - Button Action
//下注方法
- (void)betBtnAction:(UIButton *)button {
    button.enabled = NO;
    
    //玩家
    ZKCard * card1 = [ZKCardsManager shareCardsManager].getCard;
    ZKCard * card2 = [ZKCardsManager shareCardsManager].getCard;
    ZKCardView * cardView1 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    ZKCardView * cardView2 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:cardView1]; [self.allCards addObject:cardView1];
    [self addSubview:cardView2]; [self.allCards addObject:cardView2];
    [cardView1 animateWithDuration:0.5 translationX:-320 translationY:180];
    [cardView2 animateWithDuration:0.7 translationX:-300 translationY:180];
    
    
    //庄家
    ZKCard * card3 = [ZKCardsManager shareCardsManager].getCard;
    ZKCardView * cardView3 = [[ZKCardView alloc] initWithFrame:self.cardView.frame andBackViewName:@"icon_Card_Select"];
    [self addSubview:cardView3];
    [self.allCards addObject:cardView3];
    [cardView3 animateWithDuration:0.5 translationX:-320 translationY:50];
}

//双倍方法
- (void)doubleBtnAction:(UIButton *)button {
    NSInteger bet = self.betlabel.text.integerValue*2;
    self.betlabel.text = [NSString stringWithFormat:@"%ld",(long)bet];
    
    for (ZKCardView * card in self.allCards) {
        if ([card isKindOfClass:[ZKCardView class]]) {
            [card transitionFlipFromRightWithBlock:^{
                
            }];
        }
    }
}

//停牌方法
- (void)stopCardBtnAction:(UIButton *)button {
    
}

//要牌方法
- (void)moreCardAction:(UIButton *)button {
    
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
        _betlabel.text = NSLocalizedString(@"0", nil);
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
