//
//  PaymentBillVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/15.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "PaymentBillVC.h"
#import "PaymentBillVCCell.h"

@interface PaymentBillVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic  ) IBOutlet UITableView    *tbv;
@end

@implementation PaymentBillVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付流水";
    [self.tbv registerNib:[UINib nibWithNibName:NSStringFromClass([PaymentBillVCCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PaymentBillVCCell class])];
    self.tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.btnRight.hidden = NO;
    

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _paymentFlowModelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentBillVCCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PaymentBillVCCell class]) forIndexPath:indexPath];
    if (!cell) {
        cell = [[PaymentBillVCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([PaymentBillVCCell class])];
    }
    PaymentFlowModel * model = _paymentFlowModelArray[indexPath.row];
    cell.tradingNumberLab.text = [NSString stringWithFormat:@"流水号:%@",model.tradeOrderNo];
    cell.tradingTypeLab.text = model.statusStr;
    if (!model.price) {
        model.price = @"";
    }
    NSMutableAttributedString * tradingAmountLabText = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"¥%@",[model.price NumberStringToMoneyString]]];
    [tradingAmountLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0,tradingAmountLabText.length)];
    [tradingAmountLabText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0f] range:[tradingAmountLabText.string rangeOfString:[model.price NumberStringToMoneyStringGetLastThree]]];
    cell.tradingAmountLab.attributedText = tradingAmountLabText;
    NSDateFormatter * outputFormatter = [NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    cell.tradingtimeLab.text = [outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[model.updateTime doubleValue] / 1000]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 126;
}

@end
