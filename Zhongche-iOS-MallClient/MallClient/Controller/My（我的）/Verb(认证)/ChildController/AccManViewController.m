//
//  AccManViewController.m
//  MallClient
//
//  Created by lxy on 2018/7/18.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "AccManViewController.h"
#import "UserViewModel.h"
#import "UserInfoModel.h"
#import "PersonalAuthenticationVC.h"

@interface AccManViewController ()
@property (weak, nonatomic) IBOutlet UITextField *field;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation AccManViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号联系人";
    self.view.backgroundColor = APP_COLOR_WHITE_BTN;
    self.nextBtn.layer.cornerRadius = 4.0f;
    self.nextBtn.layer.masksToBounds =YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressBtn:(id)sender {
    UserInfoModel * info = USER_INFO;
    
    UserViewModel * us = [UserViewModel new];
    [us loginWithPhone:info.loginName WithPassWord:self.field.text state:1 callback:^(UserInfoModel *userInfo) {
        
    } tokenback:^(BOOL ret) {
        if (ret) {
            PersonalAuthenticationVC *vc = [PersonalAuthenticationVC new];
            if (info.userName) {
                vc.status = 1;
            }
            [self.navigationController pushViewController:vc animated:YES];

        }
    }];
                                                                          
                            
    
}


@end
