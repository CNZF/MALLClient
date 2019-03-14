
//
//  LoginViewController.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/15.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "LoginViewController.h"
#import "UserViewModel.h"
#import "RegisterVC.h"
#import "ForgetPWDVC.h"
#import "ForgetPwdController.h"
#import "SelectNormalMenuView.h"
#import "YMKJVerificationTools.h"

#define deleMax 100
#define RGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0    \
green:((c>>8)&0xFF)/255.0    \
blue:(c&0xFF)/255.0         \
alpha:a]

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong)UIView * userBg;

//视图
@property (nonatomic, strong) SelectNormalMenuView * menuView;

@property (nonatomic, strong) UILabel     * userNameLab;
@property (nonatomic, strong) UITextField * userNameTfd;
@property (nonatomic, strong) UILabel     * userPasswordLab;
@property (nonatomic, strong) UITextField * userPasswordTfd;
@property (nonatomic, strong) UIButton    * loginBtn;

@property (nonatomic, strong) UIButton    * forgetPasswordBtn;
@property (nonatomic, strong) UIButton    * registeredBtn;
@property (nonatomic, strong) UILabel     * textLab;
//变量
@property (nonatomic, assign) NSInteger index;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    self.btnRight.hidden = YES;
    self.index = 0;
    self.view.backgroundColor = APP_COLOR_WHITE_BTN;
     [self configureMenuView];
    [self.btnLeft setImage:[UIImage imageNamed:[@"Cancle" adS]] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.view endEditing:YES];
    if(USER_INFO){

        [self dismissViewControllerAnimated:NO completion:^{

        }];
    }
}

-(void)bindView {

    self.userBg.frame = CGRectMake(0, 44, SCREEN_W, 100);
    [self.view addSubview:self.userBg];
    
    self.userNameLab.frame = CGRectMake(20, 15, 50, 20);
    [self.userBg addSubview:self.userNameLab];

    
    self.userNameTfd.frame = CGRectMake(100, 3, SCREEN_W - 120, 44);
    [self.userBg addSubview:self.userNameTfd];

    
    self.userPasswordLab.frame = CGRectMake(20, 65, 50, 20);
    [self.userBg addSubview:self.userPasswordLab];

    self.userPasswordTfd.frame = CGRectMake(100, 53, SCREEN_W - 120, 44);
    [self.userBg addSubview:self.userPasswordTfd];
    
    
    self.loginBtn.frame = CGRectMake(20, self.userBg.bottom + 30, SCREEN_W - 40, 44);
    [self.view addSubview:self.loginBtn];
    
    self.forgetPasswordBtn.frame = CGRectMake(20, self.loginBtn.bottom, 58, 42);
    [self.view addSubview:self.forgetPasswordBtn];
    
    self.registeredBtn.frame = CGRectMake(SCREEN_W - 20 - 58, self.loginBtn.bottom, 58, 42);
    [self.view addSubview:self.registeredBtn];
    
    self.textLab.frame = CGRectMake(0, SCREEN_H - kNavBarHeaderHeight - kiPhoneFooterHeight-37, SCREEN_W, 17);
    [self.view addSubview:self.textLab];


    [ self.userPasswordTfd setSecureTextEntry:YES];
}

-(void)bindAction {

    WS(ws);
    //登录按钮
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        if (self.index == 1 && ![YMKJVerificationTools isMobileNumber:self.userNameTfd.text]) {
            [[Toast shareToast] makeText:@"手机号格式错误" aDuration:1];
            return ;
        }
        if (self.index == 0) {
            //    用户名正则
            NSString *searchText1 = self.userNameTfd.text;
            NSError *error1 = NULL;
            NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z][a-zA-Z0-9_]{3,20}$" options:NSRegularExpressionCaseInsensitive error:&error1];
            NSTextCheckingResult *result1 = [regex1 firstMatchInString:searchText1 options:0 range:NSMakeRange(0, [searchText1 length])];
            if (!result1) {
                [[Toast shareToast] makeText:@"用户名4~20字符，只能使用字母，数字和下划线" aDuration:1];
                 return ;
            }
        }
        
        [[UserViewModel new] loginWithPhone:ws.userNameTfd.text WithPassWord:ws.userPasswordTfd.text state:0 callback:^(UserInfoModel *userInfo) {
            UserInfoModel * info = USER_INFO;
            [[Toast shareToast]makeText:@"登录 成功" aDuration:1];
            if ([userInfo.firstLogin isEqualToString:@"1"]) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"setSelectedViewController"
                                                                   object:@{
                                                                            @"className":@"KNWantTransportVC",
                                                                            @"isShow":@YES
                                                                            }];
            }
            [ws onBackAction];
        } tokenback:^(BOOL ret) {
           
        }];
    }];

    //注册按钮
    [[self.registeredBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

        [ws.navigationController pushViewController:[RegisterVC new] animated:YES];

    }];
   
    //忘记密码按钮
    [[self.forgetPasswordBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        ForgetPwdController * controller = [[ForgetPwdController alloc] initWithNibName:NSStringFromClass([ForgetPwdController class]) bundle:nil];
        [controller setForgetBlock:^(NSString *userName) {
            ws.userNameTfd.text = userName;
        }];
        [ws.navigationController pushViewController:controller animated:YES];
        
    }];
}

-(void)onBackAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


/**
 *  TextFieldDelegate
 */

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.userPasswordTfd) {
        int num = (int)string.length;
        if ([string isEqualToString:@""]) {
            
            num = -1;
            
        }
        
        if ( textField.text.length + num < 6) {
            self.loginBtn.enabled = NO;
        }else {
            self.loginBtn.enabled = YES;
        }
    }

    if (textField == self.userNameTfd) {
        int num = (int)string.length;
        if ([string isEqualToString:@""]) {
            
            num = -1;
            
        }
        
        if ( textField.text.length + num < 1) {
            self.loginBtn.enabled = NO;
        }else {
            self.loginBtn.enabled = YES;
        }
    }
    
    return YES;
}


/**
 *  getter
 *
 */

//配置菜单
-(void)configureMenuView{
    self.menuView = [[SelectNormalMenuView alloc] initWithFrame:CGRectMake(0,0, SCREEN_W, 44)];
    self.menuView.textColor = RGBA(0x333333, 1);
    self.menuView.selectedTextColor = RGBA(0x329AF0, 1);
    self.menuView.sliderColor = RGBA(0x329AF0, 1);
    WS(weakSelf);
    [self.menuView setTitles:@[@"企业用户",@"个人用户"] selectedBlock:^(NSInteger index) {
        weakSelf.index = index;
        weakSelf.userNameTfd.text = @"";
        weakSelf.userPasswordTfd.text = @"";
        switch (index) {
            case 0:
                weakSelf.userNameLab.text = @"用户名";
                weakSelf.userNameTfd.placeholder = @"请输入您的用户名";
                break;
            case 1:
                weakSelf.userNameLab.text = @"手机号";
                weakSelf.userNameTfd.placeholder = @"请输入您的手机号";
                break;
            default:
                break;
        }
       
    }];
    
    [self.view addSubview:self.menuView];
}

- (UIView *)userBg {
    if (!_userBg) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;

        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line.frame = CGRectMake(20, 49, SCREEN_W - 20, 0.5);
        [view addSubview:line];

        _userBg = view;
    }
    return _userBg;
}

-(UILabel *)userNameLab {
    if (!_userNameLab) {
        UILabel * lab = [UILabel new];
        lab.text = @"账户名";
        lab.font = [UIFont systemFontOfSize:15.0f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.textAlignment = NSTextAlignmentLeft;

        _userNameLab = lab;

    }
    return _userNameLab;
}

-(UITextField *)userNameTfd {
    if (!_userNameTfd) {
        UITextField * tfd = [UITextField new];
        tfd.font = [UIFont systemFontOfSize:15.0f];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.placeholder = @"请输入您的用户名";
        tfd.delegate = self;
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];
        [tfd setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        tfd.keyboardType = UIKeyboardTypeAlphabet;
        _userNameTfd = tfd;
    }
    return _userNameTfd;
}

-(UILabel *)userPasswordLab {
    if (!_userPasswordLab) {
        UILabel * lab = [UILabel new];
        lab.text = @"密码";
        lab.font = [UIFont systemFontOfSize:15.0f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.textAlignment = NSTextAlignmentLeft;

        _userPasswordLab = lab;
    }
    return _userPasswordLab;
}

-(UITextField *)userPasswordTfd {
    if (!_userPasswordTfd) {
        UITextField * tfd = [UITextField new];
        tfd.font = [UIFont systemFontOfSize:15.0f];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.placeholder = @"密码为6-20位的数字与字母的组合";
        tfd.delegate = self;
        [tfd setValue:APP_COLOR_GRAY2 forKeyPath:@"_placeholderLabel.textColor"];
        [tfd setValue:[UIFont systemFontOfSize:15.0f] forKeyPath:@"_placeholderLabel.font"];

        _userPasswordTfd = tfd;
    }
    return _userPasswordTfd;
}

-(UILabel *)textLab {
    if (!_textLab) {
        UILabel * lab = [UILabel new];
        lab.text = @"客服电话 400-900-6667";
        lab.font = [UIFont systemFontOfSize:15.0f];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.textAlignment = NSTextAlignmentCenter;
        _textLab = lab;

    }
    return _textLab;
}

-(UIButton *)loginBtn{
    if (!_loginBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_GRAY_BTN_1 andSize:CGSizeMake(SCREEN_W - 40, 44)] createRadius:5] forState:UIControlStateDisabled];
        [button setBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_BLUE_BTN andSize:CGSizeMake(SCREEN_W - 40, 44)] createRadius:5] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        button.enabled = NO;
        _loginBtn = button;
    }
    return _loginBtn;
}

-(UIButton *)forgetPasswordBtn{
    if (!_forgetPasswordBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"忘记密码" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];

        _forgetPasswordBtn = button;
    }
    return _forgetPasswordBtn;
}

-(UIButton *)registeredBtn{
    if (!_registeredBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"立即注册" forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];

        _registeredBtn = button;
    }
    return _registeredBtn;
}

@end
