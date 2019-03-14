//
//  KNCodeViewController.m
//  MallClient
//
//  Created by lxy on 2018/11/7.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNCodeViewController.h"

@interface KNCodeViewController ()

@end

@implementation KNCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二维码";
    self.codeImageView.image = self.image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
