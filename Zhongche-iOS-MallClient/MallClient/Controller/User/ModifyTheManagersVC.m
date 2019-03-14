//
//  ModifyTheManagersVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/14.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "ModifyTheManagersVC.h"
#import "UserViewModel.h"

@interface ModifyTheManagersVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTfd;
@property (weak, nonatomic) IBOutlet UITextField *phoneTfd;
@property (weak, nonatomic) IBOutlet UITextField *emailTfd;
- (IBAction)submitBtnAction:(id)sender;

@end

@implementation ModifyTheManagersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号信息认证";
    self.view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    
}

-(void)bindModel {
    UserInfoModel * user = USER_INFO;
    self.nameTfd.text = user.userName;
    self.phoneTfd.text = user.phone;
    self.emailTfd.text = user.email;
}

//提价按钮事件
- (IBAction)submitBtnAction:(id)sender {
    
    NSString *searchText = self.emailTfd.text;
    NSError *error = NULL;
    
    NSString *st = @"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:st options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    if ([self.nameTfd.text isEqualToString:@""]||[self.phoneTfd.text isEqualToString:@""]||[self.emailTfd.text isEqualToString:@""]) {
        
        [[Toast shareToast]makeText:@"信息不完善" aDuration:1];
        
    }else if(!result){
        
        [[Toast shareToast]makeText:@"邮箱格式不正确" aDuration:1];
        
    }else {
        
        
        UserViewModel *vm = [UserViewModel new];
        WS(ws);
        
        [vm submitUserMessageWithName:self.nameTfd.text WithPhone:self.phoneTfd.text WithEmail:self.emailTfd.text WithCode:@"" callback:^(NSString *st) {
            //通知用户详情页进行更新
            [[NSNotificationCenter defaultCenter]postNotificationName:@"needUpdataUserData" object:nil];
            [ws.navigationController popViewControllerAnimated:YES];
        }];
    }

}


@end
