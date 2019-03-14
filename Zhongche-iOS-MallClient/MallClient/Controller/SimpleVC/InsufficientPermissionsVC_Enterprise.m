//
//  InsufficientPermissionsVC_Enterprise.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/2.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "InsufficientPermissionsVC_Enterprise.h"

@interface InsufficientPermissionsVC_Enterprise ()

@property (nonatomic, strong) UIImageView * igv;
@property (nonatomic, strong) UILabel     * labTitle1;
@property (nonatomic, strong) UILabel     * labTitle2;
@property (nonatomic, strong) UILabel     * labtext;
@property (nonatomic, strong) UILabel     * promptText;
@property (nonatomic, strong) UIButton    * urlBtn;

@end

@implementation InsufficientPermissionsVC_Enterprise

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"权限不足";
    
    self.btnLeft.hidden = YES;
    self.btnRight.hidden = YES;
}

-(void)bindView {
    self.igv.frame = CGRectMake(SCREEN_W / 2 - 133, 110, 266, 110);
    [self.view addSubview:self.igv];
    
    self.labTitle1.frame = CGRectMake(0, self.igv.bottom + 60, SCREEN_W, 30);
    [self.view addSubview:self.labTitle1];
    self.labTitle2.frame = CGRectMake(0, self.labTitle1.bottom, SCREEN_W, 30);
    [self.view addSubview:self.labTitle2];
    
    self.labtext.frame = CGRectMake(0, self.labTitle2.bottom + 30, SCREEN_W, 16);
    [self.view addSubview:self.labtext];
    
    
    CGFloat width_plab = [self.promptText.text sizeWithAttributes:@{NSFontAttributeName:self.promptText.font}].width + 10;
    CGFloat width_ubtn = [self.urlBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.urlBtn.titleLabel.font}].width + 10;
    CGFloat x = (SCREEN_W - (width_plab + width_ubtn) - 10) / 2;
    
    self.promptText.frame = CGRectMake(x, self.labtext.bottom + 15, width_plab, 44);
    [self.view addSubview:self.promptText];
    self.urlBtn.frame = CGRectMake(self.promptText.right + 10, self.promptText.top, width_ubtn, 44);
    [self makeButton:self.urlBtn];
    [self.view addSubview:self.urlBtn];
}

- (void)bindAction {
    
    //WS(ws);
    
    //网址Url
    [[self.urlBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
    }];
}

/**
 *  懒加载
 *
 *  @return getter
 */

-(UIImageView *)igv {
    if (!_igv)
    {
        _igv = [UIImageView new];
        _igv.image = [UIImage imageNamed:[@"qiye" adS]];
    }
    return _igv;
}

-(UILabel *)labTitle1 {
    if (!_labTitle1) {
        _labTitle1 = [UILabel new];
        _labTitle1.text = @"企业账号尚未通过认证";
        _labTitle1.textAlignment = NSTextAlignmentCenter;
        _labTitle1.font = [UIFont systemFontOfSize:18.f];
        _labTitle1.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _labTitle1;
}

-(UILabel *)labTitle2 {
    if (!_labTitle2) {
        _labTitle2 = [UILabel new];
        _labTitle2.text = @"无法进入该版块";
        _labTitle2.textAlignment = NSTextAlignmentCenter;
        _labTitle2.font = [UIFont systemFontOfSize:18.f];
        _labTitle2.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _labTitle2;
}

-(UILabel *)labtext {
    if (!_labtext) {
        _labtext = [UILabel new];
        _labtext.text = @"您可以通过网上商城进行企业账号认证";
        _labtext.textAlignment = NSTextAlignmentCenter;
        _labtext.font = [UIFont systemFontOfSize:14.f];
        _labtext.textColor = APP_COLOR_GRAY2;
    }
    return _labtext;
}

-(UILabel *)promptText {
    if (!_promptText) {
        _promptText = [UILabel new];
        _promptText.text = @"商城地址";
        _promptText.textAlignment = NSTextAlignmentRight;
        _promptText.font = [UIFont systemFontOfSize:14.f];
        _promptText.textColor = APP_COLOR_GRAY_TEXT_1;
    }
    return _promptText;
}

-(UIButton *)urlBtn {
    if (!_urlBtn) {
        _urlBtn = [UIButton new];
        [_urlBtn setTitle:@"www.unitransdata.com" forState:UIControlStateNormal];
        [_urlBtn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        _urlBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _urlBtn;
}

- (void)makeButton:(UIButton *)btn {
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,-(btn.width -  [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width), 0.0,0.0)];
}

@end
