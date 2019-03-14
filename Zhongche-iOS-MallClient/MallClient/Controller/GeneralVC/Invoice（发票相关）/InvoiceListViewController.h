//
//  InvoiceListViewController.h
//  MallClient
//
//  Created by lxy on 2016/12/15.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "InvoiceModel.h"

typedef void (^ReturnTextBlock)(InvoiceModel *invoiceModel);

@interface InvoiceListViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *viCommonInvoice;
@property (strong, nonatomic) IBOutlet UIView *ViVATinvoice;

@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
@property (nonatomic, strong) InvoiceModel *currentmodel;

@property (nonatomic, assign) BOOL isSelect;//进入页面是否可点击

- (void)returnText:(ReturnTextBlock)block;

@end
