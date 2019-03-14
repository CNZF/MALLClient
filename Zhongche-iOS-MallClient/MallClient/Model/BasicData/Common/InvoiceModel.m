//
//  InvoiceModel.m
//  MallClient
//
//  Created by lxy on 2016/12/21.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "InvoiceModel.h"

@implementation InvoiceModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"ID":@"id",
             @"contactsAddress":@[@"invoiceContactsAddress",@"contactsAddress"],
             @"contactsName":@[@"invoiceContactsName",@"contactsName"],
             @"contactsTel":@[@"invoiceContactsTel",@"contactsTel"],
             @"content":@[@"invoiceContent",@"content"],
             @"title":@[@"invoiceTitle",@"title"],
             @"type":@[@"invoiceType",@"type"]};
}
-(void)setType:(NSString *)type
{
    _type = [type copy];
    if ([_type isEqualToString:@"INVOICE_TYPE_COMMON_TAX"]) {
        _typeStr = @"普通发票";
    }
    else if ([_type isEqualToString:@"INVOICE_TYPE_VALUE_ADD_TAX"])
    {
        _typeStr = @"增值发票";
    }
}

@end
