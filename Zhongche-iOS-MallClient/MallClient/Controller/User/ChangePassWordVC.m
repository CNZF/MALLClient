//
//  ChangePassWordVC.m
//  MallClient
//
//  Created by lxy on 2017/2/7.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "ChangePassWordVC.h"
#import "UserViewModel.h"
#import "YMKJVerificationTools.h"

@interface ChangePassWordVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfOldPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPwd;
@property (weak, nonatomic) IBOutlet UITextField *tfNewPwdAgain;
@property (weak, nonatomic) IBOutlet UIButton *btnCentain;

@end

@implementation ChangePassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    if (textField == self.tfNewPwd) {
        if (![YMKJVerificationTools  isAvailableA_Z:textField.text]) {
            if (textField.text.length>0) {
                if (textField.text.length ==1) {
                    textField.text = [textField.text substringToIndex:textField.text.length-1];
                }
            }
        }
    }
    if (textField == self.tfNewPwdAgain) {
        if (![YMKJVerificationTools  isAvailableA_Z:textField.text]) {
            if (textField.text.length>0) {
                if (textField.text.length ==1) {
                    textField.text = [textField.text substringToIndex:textField.text.length-1];
                }
            }
        }
    }
    
}
- (void)bindView {

    self.title =@"修改密码";

    [ self.tfOldPwd setSecureTextEntry:YES];
    [ self.tfNewPwd setSecureTextEntry:YES];
    [ self.tfNewPwdAgain setSecureTextEntry:YES];
    self.btnCentain.layer.cornerRadius = 5.0f;
    self.btnCentain.layer.masksToBounds = YES;

}

//确认按钮事件
- (IBAction)centainAction:(id)sender {

    if ([self.tfOldPwd.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"原密码不能为空" aDuration:1];
        return;
    }else if ([self.tfNewPwd.text isEqualToString:@""]) {
        [[Toast shareToast]makeText:@"新密码不能为空" aDuration:1];
        return;
    }else if (![self.tfNewPwd.text isEqualToString:self.tfNewPwdAgain.text]) {
        [[Toast shareToast]makeText:@"两次密码不一致" aDuration:1];
        return;
    }
    
    if (![YMKJVerificationTools  isValid6_Account:self.tfNewPwd.text] || ![YMKJVerificationTools  isValid6_Account:self.tfNewPwdAgain.text]) {
        [[Toast shareToast] makeText:@"密码为字母开头，数字或符号组合\n 6-20个字符" aDuration:1.5];
        return;
    }
    
    UserViewModel *vm = [UserViewModel new];
    WS(ws);
    [vm changePWDWithOldPWD:self.tfOldPwd.text WithNewPWD:self.tfNewPwd.text callback:^(NSString *st) {
        if ([st isEqualToString:@"10000"]) {
            [[Toast shareToast] makeText:@"修改密码成功" aDuration:1];
        }
        [ws.navigationController popViewControllerAnimated:YES];
    }];
}

@end
