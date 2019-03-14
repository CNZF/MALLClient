//
//  RegisterVC.m
//  MallClient
//
//  Created by lxy on 2017/1/17.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "RegisterVC.h"
#import "UserViewModel.h"
#import "GuideVi.h"
#import "DynamicDetailsViewController.h"
#import "MallViewController.h"

@interface RegisterVC ()<UITextFieldDelegate>

@property (nonatomic, strong) NSTimer * validationTimer;
@property (nonatomic, assign) int validationSurplusTime;
@property (nonatomic, assign) RegisClass state;
@end

@implementation RegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = APP_COLOR_WHITE_BTN;
    
    [self.tfUserName lc_wordLimit:20];
    [self.tfPassWord lc_wordLimit:20];
    [self.tfPassWordAgain lc_wordLimit:20];
    [self.tfPhone lc_wordLimit:11];
    [self.tfCode lc_wordLimit:4];
    
    [self.personCode lc_wordLimit:4];
    [self.personPhone lc_wordLimit:11];
    [self.personPassWord lc_wordLimit:20];
    
    self.btnResist.layer.cornerRadius = 4.0f;
    self.btnResist.layer.masksToBounds = YES;
    self.personBtnResist.layer.cornerRadius = 4.0f;
    self.personBtnResist.layer.masksToBounds = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldValueChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (textField.markedTextRange != nil) {
        return;
    }
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    
    //输入用户名
    if (textField == self.tfUserName) {
        if (![YMKJVerificationTools  isAvailableA_Z:textField.text]) {
            if (textField.text.length>0) {
                if (textField.text.length ==1) {
                    textField.text = [textField.text substringToIndex:textField.text.length-1];
                    [[Toast shareToast] makeText:@"用户名必须以字母开头" aDuration:1];
                }
            }
            
        }
    }

    
    if (textField == self.tfPhone || textField == self.tfCode || textField == self.personCode || textField == self.personPhone) {
        if (![YMKJVerificationTools  isAvailableNumber:textField.text]) {
            if (textField.text.length>0) {
                if (textField.text.length ==1) {
                    textField.text = [textField.text substringToIndex:textField.text.length-1];
                }
            }
        }
        
    }
    //企业
    if ([self.tfUserName.text isEqualToString:@""]||[self.tfPassWord.text isEqualToString:@""]||[self.tfPassWordAgain.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]||[self.tfCode.text isEqualToString:@""]) {
        [self.btnResist setBackgroundColor:APP_COLOR_GRAY_BTN_1];
        
    }else {
        [self.btnResist setBackgroundColor:APP_COLOR_BLUE_BTN];
    }
    //个人
    if ([self.personPhone.text isEqualToString:@""]||[self.personPassWord.text isEqualToString:@""]||[self.personCode.text isEqualToString:@""]) {
        [self.personBtnResist setBackgroundColor:APP_COLOR_GRAY_BTN_1];
        
    }else {
        [self.personBtnResist setBackgroundColor:APP_COLOR_BLUE_BTN];
    }
}
- (void)bindView {

    self.title = @"注册";
    self.state = CompanyRegis;
    [ self.tfPassWord setSecureTextEntry:YES];
//    [ self.tfPassWordAgain setSecureTextEntry:YES];

    [self.btnResist setBackgroundColor:APP_COLOR_GRAY_BTN_1];
    [self.personBtnResist setBackgroundColor:APP_COLOR_GRAY_BTN_1];
    self.viPersonForbiden.frame=CGRectMake(0, 41, SCREEN_W, SCREEN_H);
    self.viPersonForbiden.hidden = YES;
    [self.view addSubview:self.viPersonForbiden];
}

- (void)validationButAction {
     self.validationSurplusTime = 60;
    switch (self.state) {
        case CompanyRegis:
             self.btnGetCode.userInteractionEnabled = NO;
             [self.btnGetCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
            break;
        case UserRegis:
             self.personBtnGetCode.userInteractionEnabled = NO;
             [self.personBtnGetCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    [_validationTimer invalidate];
    _validationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerificatetime) userInfo:nil repeats:YES];

}

/**
 *  更新验证码时间
 */
-(void)updateVerificatetime {

    self.validationSurplusTime --;
    switch (self.state) {
        case CompanyRegis:
            [self.btnGetCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
            if (self.validationSurplusTime == 0) {
                [self.btnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_validationTimer invalidate];
                self.btnGetCode.userInteractionEnabled = YES;
            }
            break;
        case UserRegis:
            [self.personBtnGetCode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
            if (self.validationSurplusTime == 0) {
                [self.personBtnGetCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [_validationTimer invalidate];
                self.personBtnGetCode.userInteractionEnabled = YES;
            }
            break;
        default:
            break;
    }
    
}

/**
 *  textField 代理
 */

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//
//
//    if ([self.tfUserName.text isEqualToString:@""]||[self.tfPassWord.text isEqualToString:@""]||[self.tfPassWordAgain.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]||[self.tfCode.text isEqualToString:@""]) {
//
//        [self.btnResist setBackgroundColor:APP_COLOR_GRAY_BTN_1];
//
//    }else {
//        [self.btnResist setBackgroundColor:APP_COLOR_BLUE_BTN];
//    }
//}

//获取验证码
- (IBAction)sentCodeAction:(id)sender {
    
    NSString *searchText;
    switch (self.state) {
        case CompanyRegis:
            searchText = self.tfPhone.text;
            break;
        case UserRegis:
            searchText = self.personPhone.text;
            break;
        default:
            break;
    }
   
    NSError *error = NULL;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"1\\d{10}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];

    
    switch (self.state) {
        case CompanyRegis:
            if ([self.tfPhone.text isEqualToString:@""]) {
                
                [[Toast shareToast]makeText:@"电话号码为空" aDuration:1];
                return;
            }
            break;
        case UserRegis:
            if ([self.personPhone.text isEqualToString:@""]) {
                
                [[Toast shareToast]makeText:@"电话号码为空" aDuration:1];
                return;
            }
            break;
        default:
            break;
    }
    
    if (!result) {
        
        [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];
        return;
    }
    UserViewModel *vm = [UserViewModel new];
    
    [vm getRCodeWithPhone:searchText callback:^(NSString *st) {
        
        [self validationButAction];
        
    }];

}


- (void)checkAllField
{
    //    用户名正则
    NSString *searchText1 = self.tfUserName.text;
    NSError *error1 = NULL;
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z][a-zA-Z0-9_]{3,20}$" options:NSRegularExpressionCaseInsensitive error:&error1];
    NSTextCheckingResult *result1 = [regex1 firstMatchInString:searchText1 options:0 range:NSMakeRange(0, [searchText1 length])];
    //
    //
    //    //密码正则
    //    NSString *searchText2 = self.tfUserName.text;
    //    NSError *error2 = NULL;
    //    NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z]\\w{3,20}$" options:NSRegularExpressionCaseInsensitive error:&error2];
    //    NSTextCheckingResult *result2 = [regex2 firstMatchInString:searchText2 options:0 range:NSMakeRange(0, [searchText2 length])];
    
    
    if (self.tfUserName.text.length <4) {
        [[Toast shareToast]makeText:@"用户名长度为4~20字符之间" aDuration:2];
        return;
    }
    
    if (!result1){
        
        [[Toast shareToast]makeText:@"用户名格式错误" aDuration:1];
        return;
    }
    
    
    //密码正则校验
    if (self.tfPassWord.text.length <8) {
        [[Toast shareToast]makeText:@"密码长度为8~20字符之间" aDuration:2];
        return;
    }
    
    if (![YMKJVerificationTools  isValid6_Account:self.tfPassWord.text]) {
        [[Toast shareToast] makeText:@"密码格式错误" aDuration:2];
        return;
    }
    //手机号
    if (![YMKJVerificationTools isMobileNumber:self.tfPhone.text]) {
        [[Toast shareToast] makeText:@"手机号格式错误" aDuration:2];
        return;
    }
    
    if ([self.tfUserName.text isEqualToString:@""]||[self.tfPassWord.text isEqualToString:@""]||[self.tfPassWordAgain.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]||[self.tfCode.text isEqualToString:@""]) {
        
        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
        return;
    }
    if (!self.agreeBtn.selected) {
        [[Toast shareToast] makeText:@"请同意相关协议及隐私策略" aDuration:1];
        return;
    }
    UserViewModel *vm = [UserViewModel new];
    [vm registerWithPhone:self.tfPhone.text WithPassWord:self.tfPassWord.text WithVerifycode:self.tfCode.text WithUserName:self.tfUserName.text callback:^(UserInfoModel *userInfo) {
        
//        AppDelegate * app =(AppDelegate *) [UIApplication sharedApplication].delegate;
//        app.window.rootViewController = [[MallViewController alloc] init];
//        [app.window  makeKeyAndVisible];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}


- (void)checkPersonFeild
{
    //手机号
    if (![YMKJVerificationTools isMobileNumber:self.personPhone.text]) {
        [[Toast shareToast] makeText:@"手机号格式错误" aDuration:2];
        return;
    }
    //密码正则校验
    if (self.personPassWord.text.length <8) {
        [[Toast shareToast]makeText:@"密码长度为8~20字符之间" aDuration:2];
        return;
    }
    
    if (![YMKJVerificationTools  isValid6_Account:self.personPassWord.text]) {
        [[Toast shareToast] makeText:@"密码格式错误" aDuration:2];
        return;
    }
    if ([self.personPhone.text isEqualToString:@""]||[self.personPassWord.text isEqualToString:@""]||[self.personCode.text isEqualToString:@""]) {
        
        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
        return;
    }
    if (!self.personAgressBtn.selected) {
        [[Toast shareToast] makeText:@"请同意相关协议及隐私策略" aDuration:1];
        return;
    }
#pragma mark -- TODU  个人注册接口
    UserViewModel *vm = [UserViewModel new];
    [vm PersonRegisterWithPhone:self.personPhone.text WithPassWord:self.personPassWord.text WithVerifycode:self.personCode.text WithUserName:self.personPhone.text callback:^(UserInfoModel *userInfo) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//同意框

- (IBAction)pressAgressBtn:(id)sender {
    
    switch (self.state) {
        case CompanyRegis:
            self.agreeBtn.selected = !self.agreeBtn.selected;
            break;
        case UserRegis:
            self.personAgressBtn.selected = !self.personAgressBtn.selected;
            break;
        default:
            break;
    }
}
#pragma mark -- TODU
//用户协议
- (IBAction)pressUserProtocalBtn:(id)sender {
    DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
    vc.title = @"用户协议";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"/mallrest/html/serviceitem.html"];
    [self.navigationController pushViewController:vc animated:YES];
}

//服务条款
- (IBAction)showServiceIteratiom:(id)sender {
    
    DynamicDetailsViewController *vc = [DynamicDetailsViewController new];
    vc.title = @"隐私策略";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",BASEURL,@"/mallrest/html/privacy.html"];
    [self.navigationController pushViewController:vc animated:YES];

}
//公司注册
- (IBAction)companyAction:(id)sender {
    self.agreeBtn.selected = NO;
    self.state = CompanyRegis;
    self.viPersonForbiden.hidden=YES;
    self.lbPerson.textColor=APP_COLOR_GRAY_TEXT_1;
    self.lbCompany.textColor=APP_COLOR_BLUE_BTN_;
}

//个人注册
- (IBAction)personAction:(id)sender {
    self.personAgressBtn.selected = NO;
    self.state = UserRegis;
    self.viPersonForbiden.hidden=NO;
    self.lbPerson.textColor=APP_COLOR_BLUE_BTN_;
    self.lbCompany.textColor=APP_COLOR_GRAY_TEXT_1;
}

//注册
- (IBAction)resistAction:(id)sender {
    
    switch (self.state) {
        case CompanyRegis:
            [self checkAllField];
            
            break;
         case UserRegis:
             [self checkPersonFeild];
            
         break;
        default:
            break;
    }
}

@end
