//
//  CoalDetailVC.m
//  MallClient
//
//  Created by lxy on 2017/10/13.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "CoalDetailVC.h"
#import "CoalViewModel.h"
#import "SubmitCoalVC.h"

@interface CoalDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *lbPriceDec;
@property (weak, nonatomic) IBOutlet UILabel *lbNo;
@property (weak, nonatomic) IBOutlet UILabel *lbInputAddress;
@property (weak, nonatomic) IBOutlet UILabel *lbProduceAddress;
@property (weak, nonatomic) IBOutlet UILabel *lb1;
@property (weak, nonatomic) IBOutlet UILabel *lb2;
@property (weak, nonatomic) IBOutlet UILabel *lb3;
@property (weak, nonatomic) IBOutlet UILabel *lb4;
@property (weak, nonatomic) IBOutlet UILabel *lb5;

@end

@implementation CoalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)getData {

    CoalViewModel *vm = [CoalViewModel new];

    WS(ws);
    [vm getCoalDesWithId:self.model.ID callback:^(CoalModel *model) {

        ws.title = model.name;
        ws.lbPrice.text = [NSString stringWithFormat:@"￥%@",model.price];
        ws.lbPriceDec.text = model.priceTypeDesc;
        ws.lbNo.text = model.sku;
        ws.lbInputAddress.text = model.deliveryAddress;
        ws.lbProduceAddress.text = model.productionAddress;
        ws.lb1.text = model.particleTypeDesc;
        ws.lb2.text = model.qnet;
        ws.lb3.text = model.moisture;
        ws.lb4.text = model.volatilize;
        ws.lb5.text = model.ash;

    }];

    

}

- (IBAction)buyAction:(id)sender {


    if (!USER_INFO) {
        [self pushLogoinVC];
    }else{

        SubmitCoalVC *vc = [SubmitCoalVC new];
        vc.model = self.model;

        [self.navigationController pushViewController:vc animated:YES];

    }

}

@end
