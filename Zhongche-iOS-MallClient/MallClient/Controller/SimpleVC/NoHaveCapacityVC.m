//
//  NoHaveCapacityVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/1/19.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "NoHaveCapacityVC.h"
#import "MLNavigationController.h"

@interface NoHaveCapacityVC ()
- (IBAction)buttonClick:(id)sender;

@end

@implementation NoHaveCapacityVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage getImageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)]];
    ((MLNavigationController *)self.navigationController).canDragBack = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setShadowImage:[UIImage getImageWithColor:APP_COLOR_GRAY_SEARCH_BG andSize:CGSizeMake(1, 1)]];
    ((MLNavigationController *)self.navigationController).canDragBack = YES;
    
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"定制运力";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonClick:(id)sender {
    
}
@end
