//
//  ViewController.m
//  BlackJack
//
//  Created by YellowBoy on 2017/12/17.
//  Copyright © 2017年 YellowBoy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<ZKGameScreenDelegate>
@property (nonatomic, strong) ZKGameStart  * startView;
@property (nonatomic, strong) ZKGameScreen * gameScreen;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //NSLog(@"%@",NSStringFromCGRect(self.view.frame));
    [ZKCardsManager shareCardsManager];
    [self setUpUI];
}

- (void)setUpUI {
    [self.view addSubview:self.gameScreen];
    [self.view addSubview:self.startView];
}

- (void)hiddenStartView {
    [self.gameScreen compareVoiceBtnStatus];
    [UIView animateWithDuration:0.25 animations:^{
        self.startView.transform = CGAffineTransformTranslate(self.startView.transform, 0, S_HEIGHT);
    }completion:^(BOOL finished) {
        self.startView.hidden = YES;
    }];
}

- (void)restoreStartView {
    self.startView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.startView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - ZKGameScreenDelegate
- (void)clickMenu {
    [self restoreStartView];
    [self.startView updatePlayerCoinNum];
}

#pragma mark - lazy init
- (ZKGameStart *)startView {
    if (!_startView) {
        WEAK_SELF(self);
        _startView = [ZKGameStart addGameStartView:self.view.bounds andClick:^{
            [weakself hiddenStartView];
        }];
    }
    return _startView;
}

- (ZKGameScreen *)gameScreen {
    if (!_gameScreen) {
        _gameScreen = [[ZKGameScreen alloc] initWithFrame:self.view.bounds];
        _gameScreen.delegate = self;
    }
    return _gameScreen;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
