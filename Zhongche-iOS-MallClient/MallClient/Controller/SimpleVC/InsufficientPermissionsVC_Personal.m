//
//  InsufficientPermissionsVC_Personal.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "InsufficientPermissionsVC_Personal.h"

@interface InsufficientPermissionsVC_Personal ()
@property (nonatomic, strong) UIImageView * igv;
@property (nonatomic, strong) UILabel     * labTitle;
@property (nonatomic, strong) UILabel     * labtext;
@property (nonatomic, strong) UIButton    * registeredBtn;

@end

@implementation InsufficientPermissionsVC_Personal

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title               = @"权限不足";

    self.btnLeft.hidden      = YES;
    self.btnRight.hidden     = YES;
}

-(void)bindView {
    self.igv.frame           = CGRectMake(SCREEN_W / 2 - 133, 110, 266, 110);
    [self.view addSubview:self.igv];

    self.labTitle.frame      = CGRectMake(0, self.igv.bottom + 60, SCREEN_W, 20);
    [self.view addSubview:self.labTitle];
    self.labtext.frame       = CGRectMake(0, self.labTitle.bottom + 20, SCREEN_W, 16);
    [self.view addSubview:self.labtext];

    self.registeredBtn.frame = CGRectMake(65, self.labtext.bottom + 50, SCREEN_W - 130, 44);
    [self.view addSubview:self.registeredBtn];
}

- (void)bindAction {

    //WS(ws);

    //注册企业账号
    [[self.registeredBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {


    }];
}


/**
 *  懒加载
 */

-(UIImageView *)igv {
    if (!_igv)
    {
        _igv = [UIImageView new];
        _igv.image = [UIImage imageNamed:[@"geren" adS]];
    }
    return _igv;
}

-(UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [UILabel new];
        _labTitle.text = @"个人用户无法进入该板块";
        _labTitle.textAlignment = NSTextAlignmentCenter;
        _labTitle.font = [UIFont systemFontOfSize:18.f];
        _labTitle.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _labTitle;
}

-(UILabel *)labtext {
    if (!_labtext) {
        _labtext = [UILabel new];
        _labtext.text = @"只有用过认证的企业用户方可进入";
        _labtext.textAlignment = NSTextAlignmentCenter;
        _labtext.font = [UIFont systemFontOfSize:14.f];
        _labtext.textColor = APP_COLOR_GRAY2;
    }
    return _labtext;
}

-(UIButton *)registeredBtn {
    if (!_registeredBtn) {
        _registeredBtn = [UIButton new];
        [_registeredBtn setTitle:@"注册企业账号" forState:UIControlStateNormal];
        [_registeredBtn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        _registeredBtn.backgroundColor = APP_COLOR_ORANGE_BTN_TEXT;
        _registeredBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_registeredBtn.layer setMasksToBounds:YES];
        [_registeredBtn.layer setCornerRadius:22];//设置矩形四个圆角半径
    }
    return _registeredBtn;
}

@end
