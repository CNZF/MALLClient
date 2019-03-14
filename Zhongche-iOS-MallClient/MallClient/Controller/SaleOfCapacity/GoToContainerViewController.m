//
//  GoToContainerViewController.m
//  MallClient
//
//  Created by lxy on 2017/5/27.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "GoToContainerViewController.h"
#import "ContainerCapacityController.h"

@interface GoToContainerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnGoto;

@end

@implementation GoToContainerViewController

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    self.lbPlace.text = self.stPlace;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)bindView{

    self.title = @"一带一路运力";

    self.btnGoto.layer.masksToBounds = YES;
    self.btnGoto.layer.cornerRadius = 10;
    [self.btnGoto setBackgroundColor:APP_COLOR_ORANGE_BTN_TEXT];
}

- (IBAction)gotoAction:(id)sender {

    ContainerCapacityController_Container *vc = [ContainerCapacityController_Container new];
    vc.isReturnToFirst = YES;
    [self.navigationController pushViewController:vc animated:YES];


}

-(void)onBackAction {

    [self.navigationController popToViewControllerWithClassName:@"ContainerCapacityController_OneBeltOneRoad" animated:YES];
}

@end
