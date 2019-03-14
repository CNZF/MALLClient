//
//  EnterpriseNameAuthenticationManagerVC.m
//  MallClient
//
//  Created by lxy on 2017/3/14.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EnterpriseNameAuthenticationManagerVC.h"
#import "EnterpriseNameAuthenticationVC.h"

@interface EnterpriseNameAuthenticationManagerVC ()

@end

@implementation EnterpriseNameAuthenticationManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"企业实名认证";
}

- (void)onBackAction {

    if (self.status == 1) {

        [self.navigationController popViewControllerAnimated:YES];

    }else {

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//三证合一
- (IBAction)newCredentialsAction:(id)sender {

    EnterpriseNameAuthenticationVC *vc= [EnterpriseNameAuthenticationVC new];
    vc.status = self.status;
    vc.type = 1;
    vc.title = @"三证合一";
    [self.navigationController pushViewController:vc animated:YES];
    
}

//三证提交
- (IBAction)credentialsAction:(id)sender {

    EnterpriseNameAuthenticationVC *vc= [EnterpriseNameAuthenticationVC new];
    vc.status = self.status;
    vc.type = 0;
    vc.title = @"企业三证";
    [self.navigationController pushViewController:vc animated:YES];

}

@end
