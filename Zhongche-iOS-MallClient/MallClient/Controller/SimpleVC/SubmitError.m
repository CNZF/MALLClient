//
//  SubmitError.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "SubmitError.h"

@interface SubmitError ()
@property (nonatomic, strong)UIImageView * igv;
@property (nonatomic, strong)UILabel * labTitle;
@property (nonatomic, strong)UILabel * labtext;
@property (nonatomic, strong)UIButton * tryAgainBtn;
@property (nonatomic, strong)UIButton * goBackModifyBtn;

@end

@implementation SubmitError

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"提交状态";
    
    self.btnLeft.hidden = YES;
    self.btnRight.hidden = YES;
}

-(void)bindView {
    self.igv.frame = CGRectMake(SCREEN_W / 2 - 67.5, 20, 135, 135);
    [self.view addSubview:self.igv];
    
    self.labTitle.frame = CGRectMake(0, self.igv.bottom + 15, SCREEN_W, 20);
    [self.view addSubview:self.labTitle];
    self.labtext.frame = CGRectMake(0, self.labTitle.bottom + 30, SCREEN_W, 16);
    [self.view addSubview:self.labtext];
    
    self.tryAgainBtn.frame = CGRectMake(65, self.labtext.bottom + 50, SCREEN_W - 130, 44);
    [self.view addSubview:self.tryAgainBtn];
    self.goBackModifyBtn.frame = CGRectMake(65, self.tryAgainBtn.bottom + 20, SCREEN_W - 130, 44);
    [self.view addSubview:self.goBackModifyBtn];
}

- (void)bindAction {

    //再次提交
    [[self.tryAgainBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
    }];
    
    //返回修改
    [[self.goBackModifyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
    }];
}

/**
 *  懒加载
 *
 */

-(UIImageView *)igv {
    if (!_igv)
    {
        _igv = [UIImageView new];
        _igv.image = [UIImage imageNamed:[@"Group 2" adS]];
    }
    return _igv;
}

-(UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.text = @"提交失败";
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.font = [UIFont systemFontOfSize:20.f];
        _labTitle.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _labTitle;
}

-(UILabel *)labtext {
    if (!_labtext) {
        _labtext = [UILabel new];
        _labtext.text = @"貌似出现了一些不可抗拒的问题";
        _labtext.textAlignment = NSTextAlignmentCenter;
        _labtext.font = [UIFont systemFontOfSize:16.f];
        _labtext.textColor = APP_COLOR_GRAY_TEXT_1;
    }
    return _labtext;
}

-(UIButton *)tryAgainBtn {
    if (!_tryAgainBtn) {
        _tryAgainBtn = [UIButton new];
        [_tryAgainBtn setTitle:@"再次提交" forState:UIControlStateNormal];
        [_tryAgainBtn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        _tryAgainBtn.backgroundColor = APP_COLOR_BLUE_BTN;
        _tryAgainBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_tryAgainBtn.layer setMasksToBounds:YES];
        [_tryAgainBtn.layer setCornerRadius:22];//设置矩形四个圆角半径
        
    }
    return _tryAgainBtn;
}

-(UIButton *)goBackModifyBtn {
    if (!_goBackModifyBtn) {
        _goBackModifyBtn = [UIButton new];
        [_goBackModifyBtn setTitle:@"返回修改" forState:UIControlStateNormal];
        [_goBackModifyBtn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        _goBackModifyBtn.backgroundColor = APP_COLOR_WHITE;
        _goBackModifyBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_goBackModifyBtn.layer setMasksToBounds:YES];
        [_goBackModifyBtn.layer setCornerRadius:22];//设置矩形四个圆角半径
        _goBackModifyBtn.layer.borderColor = [APP_COLOR_BLUE_BTN CGColor];
        _goBackModifyBtn.layer.borderWidth = 0.5;
    }
    return _goBackModifyBtn;
}

@end
