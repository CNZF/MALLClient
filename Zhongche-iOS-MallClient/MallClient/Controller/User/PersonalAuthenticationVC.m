//
//  PersonalAuthenticationVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/1/18.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "PersonalAuthenticationVC.h"
#import "UserViewModel.h"
#import "EnterpriseNameAuthenticationVC.h"
#import "EnterpriseNameAuthenticationManagerVC.h"
#import "VerbViewController.h"
#import "UITextField+LCWordLimit.h"

@interface PersonalAuthenticationVC ()<UITextFieldDelegate>

@property (weak, nonatomic  ) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic  ) IBOutlet UITextField        *tfName;
@property (weak, nonatomic  ) IBOutlet UITextField        *tfPhone;
@property (weak, nonatomic  ) IBOutlet UITextField        *tfCode;
@property (weak, nonatomic  ) IBOutlet UITextField        *tfMail;
@property (weak, nonatomic  ) IBOutlet UIButton           *btnGetcode;
@property (weak, nonatomic  ) IBOutlet UIButton           *btnSubmit;
@property (nonatomic, strong) NSTimer * validationTimer;
@property (nonatomic, assign) int     validationSurplusTime;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end

@implementation PersonalAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tfPhone lc_wordLimit:11];
    [self.tfCode lc_wordLimit:4];
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
    if (textField == self.tfPhone || textField  == self.tfCode) {
        if (![YMKJVerificationTools  isAvailableNumber:textField.text]) {
            if (textField.text.length>0) {
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
        }
    }
    
    if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]) {
        
        [self.btnSubmit setBackgroundColor:APP_COLOR_GRAY_BTN_1];
    }else{
        
        [self.btnSubmit setBackgroundColor:APP_COLOR_BLUE_BTN];
    }
}

-(void)bindView {

    self.title = @"联系人认证";
    
    UserInfoModel * info = USER_INFO;
    self.tfName.delegate = self;
    self.tfPhone.delegate = self;
    self.tfMail.delegate = self;
    self.tfCode.delegate = self;
    
    self.btnSubmit.frame = CGRectMake(15, SCREEN_H- kNavBarHeaderHeight- kiPhoneFooterHeight-65, SCREEN_W-30, 50);
    self.btnSubmit.layer.cornerRadius = 4.0f;
    self.btnSubmit.layer.masksToBounds = YES;
    
    if (self.status == 1) {
        self.tfName.text  = info.userName;
        self.tfPhone.text = info.companyPhone;
        self.tfMail.text = info.email;
        self.topConstraint.constant = -48;
        [self.btnSubmit setBackgroundColor:APP_COLOR_BLUE_BTN];
    }else{
        self.topConstraint.constant = 10;
    }

}

- (void)validationButAction {

    self.btnGetcode.userInteractionEnabled = NO;
    self.validationSurplusTime = 60;
    [self.btnGetcode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    [_validationTimer invalidate];
    _validationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerificatetime) userInfo:nil repeats:YES];
    
}


/**
 *  更新验证码时间
 */
-(void)updateVerificatetime {

    self.validationSurplusTime --;
    [self.btnGetcode setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    if (self.validationSurplusTime == 0) {
        [self.btnGetcode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_validationTimer invalidate];
        self.btnGetcode.userInteractionEnabled = YES;
    }
}

//提交按钮事件
- (IBAction)submitAction:(id)sender {


//    NSString *searchText = self.tfMail.text;
//    NSError *error = NULL;
//    ;
//    NSString *st = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
//
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:st options:NSRegularExpressionCaseInsensitive error:&error];
//    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    if (self.status == 1) {
        if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]) {
            
            [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
            return;
        }
    }else{
        if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""] || [self.tfCode.text isEqualToString:@""]) {
            
            [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
            return;
        }
    }
    
    if (self.tfPhone.text.length!=11) {
        [[Toast shareToast]makeText:@"错误的手机格式!" aDuration:1];
        return;
    }else if (![YMKJVerificationTools isAvailablePhoneNumber:self.tfPhone.text]){
        [[Toast shareToast]makeText:@"错误的手机格式!" aDuration:1];
        return;
    }
    
    UserViewModel *vm = [UserViewModel new];
    WS(ws);
    
    [vm submitUserMessageWithName:self.tfName.text WithPhone:self.tfPhone.text WithEmail:self.tfMail.text WithCode:self.tfCode.text callback:^(NSString *st) {
        
        if (st) {
            if (self.status == 1) {
                [ws.navigationController popToViewControllerWithClassName:NSStringFromClass([VerbViewController class]) animated:YES];
            }else
            {
                [ws.navigationController popViewControllerAnimated:YES];
            }
            
        }
        
    }];



}

//获取验证码
- (IBAction)getCodeAction:(id)sender {

    if (self.tfPhone.text.length!=11) {
        [[Toast shareToast]makeText:@"错误的手机格式!" aDuration:1];
        return;
    }else if (![YMKJVerificationTools isAvailablePhoneNumber:self.tfPhone.text]){
        [[Toast shareToast]makeText:@"错误的手机格式!" aDuration:1];
        return;
    }
    
    UserViewModel *vm = [UserViewModel new];
    
    [vm getRCodeWithPhone:self.tfPhone.text callback:^(NSString *st) {
        
        [self validationButAction];
        
    }];



}

//填写代理
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//
//    if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]) {
//
//        [self.btnSubmit setBackgroundColor:APP_COLOR_GRAY_BTN_1];
//
//
//    }else{
//
//        [self.btnSubmit setBackgroundColor:APP_COLOR_BLUE_BTN];
//
//    }
//
//
//    return YES;
//
//}

@end
