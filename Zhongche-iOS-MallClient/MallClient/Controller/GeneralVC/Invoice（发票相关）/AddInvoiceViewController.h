//
//  AddInvoiceViewController.h
//  MallClient
//
//  Created by lxy on 2016/12/15.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "InvoiceModel.h"


@interface AddInvoiceViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *viCommenInvoice;
@property (strong, nonatomic) IBOutlet UIScrollView *svVATInvoice;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;
@property (strong, nonatomic) IBOutlet UIView *viVATInvoice;

@property (nonatomic, strong) InvoiceModel *invoiceModel;
@property (nonatomic, assign) int type; //0、普通房发票  1、增值税发票

@end
