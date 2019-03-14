
//  UserHeadView.m
//  MallClient/Users/lxy/Desktop/zhongche/mall/v3/Zhongche-iOS-MallClient/MallClient/View/Cell/UserCell/MyFunctionCell.m
//
//  Created by lxy on 2018/6/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "UserHeadView.h"
#import "MLNavigationController.h"
#import "LoginViewController.h"
#import "SetViewController.h"
#import "UserViewController.h"
#import "MessageViewController.h"
#import "UserInfoVC.h"
#import "AccontInfoController.h"
#import "RegisterVC.h"

@interface UserHeadView ()

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;
@property (weak, nonatomic) IBOutlet UIView *loginOutStateView;
@property (weak, nonatomic) IBOutlet UIView *loginInStateView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userStateLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *messageAlertView;

@end

@implementation UserHeadView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self addTapGesture];
    [self setStatus];
    self.messageAlertView.layer.cornerRadius = 4.0f;
    self.messageAlertView.layer.masksToBounds = YES;
    
}

- (void)setStatus
{
    if (USER_INFO) {
        UserInfoModel * info = (UserInfoModel *)USER_INFO;
        
        NSString * icon = [NSString stringWithFormat:@"%@%@",BASEIMGURL,info.icon];
        [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:[@"user_head" adS]]];
        
        self.userNameLabel.text = info.loginName;
        if ([info.userType isEqualToString:@"1"]) {
            self.userStateLabel.text = @"认证承运商司机";
        }
        if ([info.userType isEqualToString:@"2"]) {
            self.userStateLabel.text = @"签约承运商司机";
        }
        if ([info.userType isEqualToString:@"3"]) {
            self.userStateLabel.text = @"注册用户";
        }
        if ([info.userType isEqualToString:@"4"]) {
            self.userStateLabel.text = @"实名用户";
        }
        if ([info.userType isEqualToString:@"5"]) {
            self.userStateLabel.text = @"认证用户";
        }
        if ([info.userType isEqualToString:@"6"]) {
            self.userStateLabel.text = @"企业账户";
        }
        if ([info.userType isEqualToString:@"7"]) {
            self.userStateLabel.text = @"企业子账户";
        }
        if ([info.userType isEqualToString:@"8"]) {
            self.userStateLabel.text = @"boss平台用户";
        }
        if ([info.userType isEqualToString:@"9"]) {
            self.userStateLabel.text = @"注册企业用户司机";
        }
        if ([info.userType isEqualToString:@"10"]) {
            self.userStateLabel.text = @"实名企业用户司机";
        }
        if ([info.userType isEqualToString:@"11"]) {
            self.userStateLabel.text = @"个人用户";
        }
        self.loginOutStateView.hidden = YES;
        self.loginInStateView.hidden = !self.loginOutStateView.hidden;
        self.rightImageView.hidden = !self.loginOutStateView.hidden;
        
        //消息
        if ([info.notReadMessageCount intValue] >0) {
            self.messageAlertView.backgroundColor = [UIColor redColor];
        }else{
            self.messageAlertView.backgroundColor = [UIColor clearColor];
        }
    }else{
        self.loginOutStateView.hidden = NO;
        self.messageAlertView.backgroundColor = [UIColor clearColor];
        self.loginInStateView.hidden = !self.loginOutStateView.hidden;
        self.rightImageView.hidden = !self.loginOutStateView.hidden;
    }
    
}

- (void)addTapGesture
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onLoginOutViewTap:)];
    [self addGestureRecognizer:tap];
}

- (void)onLoginOutViewTap:(UITapGestureRecognizer *)tap
{
    if (USER_INFO) {
        AccontInfoController *vc = [AccontInfoController new];
        UserViewController * user = self.target;
        [user.navigationController pushViewController:vc animated:YES];
    }else{
        

    }

}


- (IBAction)pressSelectBtn:(id)sender {
    
    if (USER_INFO) {
        AccontInfoController *vc = [AccontInfoController new];
        UserViewController * user = self.target;
        [user.navigationController pushViewController:vc animated:YES];
    }else{
        [self pushToNextView];
    }
}

//登录
- (IBAction)pressLoginBtn:(UIButton *)sender {
    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.target presentViewController:vc animated:YES completion:^{
        
    }];
}
//注册
- (IBAction)pressRegisterBtn:(id)sender {
    RegisterVC * controller = [[RegisterVC alloc] initWithNibName:@"RegisterVC" bundle:nil];
//    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:controller];
//    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    UserViewController * user = self.target;
//    [self.target presentViewController:vc animated:YES completion:^{
//
//    }];
    [user.navigationController pushViewController:controller animated:YES];
}
//设置
- (IBAction)pressSetBtn:(id)sender {
    UserViewController * user = self.target;
    [user.navigationController pushViewController:[SetViewController new] animated:YES];
}
//消息中心

- (IBAction)onMessageBtn:(id)sender {
    if (!USER_INFO) {
        [self pushLogoinVC];
    }else{
        UserViewController * user = self.target;
        [user.navigationController pushViewController:[MessageViewController new] animated:YES];
    }
}
//跳转页面事件
- (void)pushToNextView {
    
    if (USER_INFO) {
        
    }else {
        MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
        [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
        [self.target presentViewController:vc animated:YES completion:^{
            
        }];
        
    }
}
//登录跳转
-(void)pushLogoinVC {
    
    MLNavigationController * vc = [[MLNavigationController alloc] initWithRootViewController:[LoginViewController new]];
    [vc.navigationBar setBackgroundImage:[UIImage getImageWithColor:[UIColor whiteColor] andSize:CGSizeMake(SCREEN_W * 3, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.target presentViewController:vc animated:YES completion:^{
        
    }];
}
@end
