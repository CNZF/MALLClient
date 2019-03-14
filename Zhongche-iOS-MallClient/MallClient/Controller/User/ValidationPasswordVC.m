

//
//  ValidationPasswordVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/13.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "ValidationPasswordVC.h"
#import "UserViewModel.h"
#import "ModifyTheManagersVC.h"
#import "MLNavigationController.h"

@interface ValidationPasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *passwordTfd;
- (IBAction)nextBtnAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ValidationPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号管理者";
    self.view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    
    [self.btn setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_BLUE_BTN andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.btn setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_GRAY_BTN_1 andSize:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
    self.btn.enabled = NO;
}

//提交按钮事件
- (IBAction)nextBtnAction:(id)sender {
    //密码正则
    NSString *searchText = self.passwordTfd.text;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z]\\w{3,20}$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    if (!result) {
        [[Toast shareToast]makeText:@"密码错误" aDuration:1];
        return ;
    }
    
    WS(ws);
    UserInfoModel * user = USER_INFO;
    
    
//    [[UserViewModel new] loginWithPhone:user.loginName WithPassWord:self.passwordTfd.text callback:^(UserInfoModel *userInfo) {
//        [[Toast shareToast]makeText:@"验证成功" aDuration:1];
//
//        NSMutableArray * array =[[NSMutableArray alloc]initWithArray:ws.navigationController.viewControllers];
//        //删除最后一个，也就是自己
//        [array removeObjectAtIndex:array.count-1];
//        ModifyTheManagersVC *vc= [ModifyTheManagersVC new];
//        //添加要跳转的controller
//        [array addObject:vc];
//        [ws.navigationController pushViewController:vc animated:YES];
//        [ws.navigationController setViewControllers:array animated:YES];
//        MLNavigationController *nv= (MLNavigationController *)ws.navigationController;
//        [nv.screenShotsList removeObjectAtIndex:nv.screenShotsList.count - 1];
//    }];

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    int num = 1;
    if ([string isEqualToString:@""]) {
        num = -1;
    }
    if (textField.text.length + num >= 6) {
        self.btn.enabled = YES;
    }else {
        self.btn.enabled = NO;
    }
    
    return YES;
}

@end
