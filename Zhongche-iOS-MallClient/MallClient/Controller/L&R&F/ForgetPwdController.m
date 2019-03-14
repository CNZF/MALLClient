//
//  ForgetPwdController.m
//  MallClient
//
//  Created by lxy on 2018/7/11.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "ForgetPwdController.h"
#import "UserViewModel.h"
#import "UITextField+LCWordLimit.h"
#import "YMKJVerificationTools.h"

@interface ForgetPwdController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameFeild;
@property (weak, nonatomic) IBOutlet UITextField *telField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UITextField *pwsField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *securtyBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (nonatomic, strong) NSTimer * validationTimer;
@property (nonatomic, assign) int validationSurplusTime;

@end

@implementation ForgetPwdController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重设密码";
    
    self.confirmBtn.layer.cornerRadius = 4.0f;
    self.confirmBtn.layer.masksToBounds = YES;
    [self.telField lc_wordLimit:11];
    [self.pwsField lc_wordLimit:20];
    [self.nameFeild lc_wordLimit:20];
    [ self.pwsField setSecureTextEntry:YES];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField
- (void)textFieldValueChanged:(NSNotification *)notification {
    UITextField *textField = notification.object;
    if (textField.markedTextRange != nil) {
        return;
    }
    if ([textField.text containsString:@" "]) {
        textField.text = [textField.text substringToIndex:textField.text.length-1];
    }
    if (textField == self.telField) {
        if (![YMKJVerificationTools isAvailableNumber:textField.text]) {
            if (textField.text.length>0) {
                textField.text = [textField.text substringToIndex:textField.text.length-1];
            }
        }
    }
    
    if (textField == self.pwsField) {
        if (![YMKJVerificationTools  isAvailableA_Z:textField.text]) {
            if (textField.text.length>0) {
                if (textField.text.length ==1) {
                    textField.text = [textField.text substringToIndex:textField.text.length-1];
                }
            }
        }
    }
}

- (void)validationButAction {
    
    self.codeBtn.userInteractionEnabled = NO;
    self.validationSurplusTime = 60;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    [_validationTimer invalidate];
    _validationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateVerificatetime) userInfo:nil repeats:YES];
    
}

/**
 *  更新验证码时间
 */
-(void)updateVerificatetime {
    
    self.validationSurplusTime --;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒后重发",self.validationSurplusTime] forState:UIControlStateNormal];
    if (self.validationSurplusTime == 0) {
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_validationTimer invalidate];
        self.codeBtn.userInteractionEnabled = YES;
    }
}


- (IBAction)pressCodeBtm:(id)sender {
    [self.view endEditing:YES];
    if (self.telField.text.length!= 11) {
        [[Toast shareToast] makeText:@"错误的手机格式" aDuration:1];
        return;
    }else if (![YMKJVerificationTools isAvailablePhoneNumber:self.telField.text]){
        [[Toast shareToast] makeText:@"错误的手机格式" aDuration:1];
        return;
    }
    
    UserViewModel *vm = [UserViewModel new];
    
    [vm getRCodeWithPhone:self.telField.text callback:^(NSString *st) {
        
        [self validationButAction];
        
    }];
}

- (IBAction)pressSecurtyBtn:(id)sender {
    
    self.securtyBtn.selected = !self.securtyBtn.selected;
    self.pwsField.secureTextEntry = !self.pwsField.secureTextEntry;
    
    //解决光标问题
    NSString *tempStr = self.pwsField.text;
    self.pwsField.text = nil;
    self.pwsField.text = tempStr;

}

- (void)checkTelAndPws
{
    [self.view endEditing:YES];
    if (self.telField.text.length!= 11) {
        [[Toast shareToast] makeText:@"错误的手机格式" aDuration:1];
        return;
    }else if (![YMKJVerificationTools isAvailablePhoneNumber:self.telField.text]){
        [[Toast shareToast] makeText:@"错误的手机格式" aDuration:1];
        return;
    }
    if (self.pwsField.text.length<6) {
        [[Toast shareToast] makeText:@"密码格式错误，应为8-20位字符" aDuration:1];
        return;
    }
    if (![YMKJVerificationTools  isValid6_Account:self.pwsField.text]) {
        [[Toast shareToast] makeText:@"密码为字母开头，数字或符号组合8-20个字符" aDuration:1.5];
        return;
    }
}

//
- (IBAction)pressConfirmBtn:(id)sender {
    
    [self checkTelAndPws];
    
    [self setEditing:YES];
    [[UserViewModel new] forgetPWDWithOldPWD:self.pwsField.text Tel:self.telField.text name:self.nameFeild.text WithCode:self.codeField.text callback:^(NSString *st) {
        if (st) {
            [[Toast shareToast] makeText:@"修改成功" aDuration:1];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (self.forgetBlock) {
            self.forgetBlock(self.nameFeild.text);
        }
    }];
}

@end
