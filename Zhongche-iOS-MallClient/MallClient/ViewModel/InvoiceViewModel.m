//
//  InvoiceViewModel.m
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "InvoiceViewModel.h"

@implementation InvoiceViewModel


/**
 *  发票查询
 *
 *  @param type     0 putongfap 1 增值税发票
 *  @param callback 发票数组
 */

- (void)selectInVoiceWithType:(int)type callback:(void(^)(NSArray *arr))callback{

    /**
     *  增值发票 : INVOICE_TYPE_VALUE_ADD_TAX
     普通发票 : INVOICE_TYPE_COMMON_TAX
     */


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    if (type == 0) {

        [params setObject:@"INVOICE_TYPE_COMMON_TAX" forKey:@"type"];

    }else {

        [params setObject:@"INVOICE_TYPE_VALUE_ADD_TAX" forKey:@"type"];
    }



    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getCompanyInvoice" forKey:@"method"];
    [self.dicHead setValue:@"company" forKey:@"action"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {

                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSArray *arrInvoice = dicData[@"companyInvoice"];
                NSMutableArray *arrInfo = [NSMutableArray array];
                for (NSDictionary *dic in arrInvoice) {

                    InvoiceModel *model= [InvoiceModel yy_modelWithDictionary:dic];
                    [arrInfo addObject:model];


//
                }

                callback(arrInfo);


            }else {

                [[Toast shareToast]makeText:message aDuration:1];
            }

        }



        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];



}

/**
 *  更新发票
 *
 *  @param info 发票对象
 */

- (void)updateInVoiceWithInvoiceInfo:(InvoiceModel* )info callback:(void(^)(NSString *status))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setObject:info.ID forKey:@"id"];
    [params setObject:info.title forKey:@"title"];
    [params setObject:@"运输费" forKey:@"content"];
    [params setObject:info.type forKey:@"type"];
    [params setObject:info.contactsTel forKey:@"contactsTel"];
    [params setObject:info.contactsName forKey:@"contactsName"];
    [params setObject:info.contactsAddress forKey:@"contactsAddress"];
    [params setObject:info.isDefault forKey:@"isDefault"];
//    if ([info.type isEqualToString:@"INVOICE_TYPE_VALUE_ADD_TAX"]) {
//
//        [params setObject:info.idCode forKey:@"idCode"];
//        [params setObject:info.regTel forKey:@"regTel"];
//        [params setObject:info.regBlank forKey:@"regBlank"];
//        [params setObject:info.regBlankAccount forKey:@"regBlankAccount"];
//        [params setObject:info.regAddress forKey:@"regAddress"];
//
//    }

    [params setObject:info.idCode forKey:@"idCode"];
    [params setObject:info.regTel forKey:@"regTel"];
    [params setObject:info.regBlank forKey:@"regBlank"];
    [params setObject:info.regBlankAccount forKey:@"regBlankAccount"];
    [params setObject:info.regAddress forKey:@"regAddress"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"updateCompanyInvoice" forKey:@"method"];
    [self.dicHead setValue:@"company" forKey:@"action"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {

                callback(status);


            }else {

                [[Toast shareToast]makeText:message aDuration:1];
            }

        }



        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];



}

/**
 *  添加发票
 *
 *  @param info     发票对象
 *  @param callback 状态
 */

- (void)addInVoiceWithInvoiceInfo:(InvoiceModel* )info callback:(void(^)(NSString *status))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];


    [params setObject:info.title forKey:@"title"];
    [params setObject:@"运输费" forKey:@"content"];
    [params setObject:info.type forKey:@"type"];
    [params setObject:info.contactsTel forKey:@"contactsTel"];
    [params setObject:info.contactsName forKey:@"contactsName"];
    [params setObject:info.contactsAddress forKey:@"contactsAddress"];

    if (!info.isDefault) {
        info.isDefault = @"0";
    }
    [params setObject:info.isDefault forKey:@"isDefault"];
//    if ([info.type isEqualToString:@"INVOICE_TYPE_VALUE_ADD_TAX"]) {
//
//        [params setObject:info.idCode forKey:@"idCode"];
//        [params setObject:info.regTel forKey:@"regTel"];
//        [params setObject:info.regBlank forKey:@"regBlank"];
//        [params setObject:info.regBlankAccount forKey:@"regBlankAccount"];
//        [params setObject:info.regAddress forKey:@"regAddress"];
//
//    }
    [params setObject:info.idCode forKey:@"idCode"];
    [params setObject:info.regTel forKey:@"regTel"];
    [params setObject:info.regBlank forKey:@"regBlank"];
    [params setObject:info.regBlankAccount forKey:@"regBlankAccount"];
    [params setObject:info.regAddress forKey:@"regAddress"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"addCompanyInvoice" forKey:@"method"];
    [self.dicHead setValue:@"company" forKey:@"action"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            /**
             *  {
             message = "\U6267\U884c\U6210\U529f";
             result =     {
             currentPage = 0;
             data = "{\"invoice\":57}";
             size = 0;
             };
             status = 10000;
             }
             */
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {

                callback (status);


            }else {

                [[Toast shareToast]makeText:message aDuration:1];
            }

        }



        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];



}

/**
 *  查询默认发票
 *
 *  @param type     INVOICE_TYPE_VALUE_ADD_TAX
 *  @param callback 发票对象
 */

-(void)getCompanyDefaultInvoiceWithType:(NSString *)type callback:(void(^)(InvoiceModel *info))callback{

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:type forKey:@"type"];
    [self.dicRequest setObject:params forKey:@"params"];
    [self.dicHead setValue:@"getCompanyDefaultInvoice" forKey:@"method"];
    [self.dicHead setValue:@"company" forKey:@"action"];
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSDictionary *dicInfo = dicData[@"companyInvoice"];
                InvoiceModel *model= [InvoiceModel yy_modelWithDictionary:dicInfo];
                callback(model);

            }else {

                if (![message isEqualToString:@"无默认发票"]) {
                    [[Toast shareToast]makeText:message aDuration:1];
                }

            }

        }
        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];


}

/**
 *  设置默认发票
 *
 *  @param Id 发票ID
 */

- (void)setDefaultInVoiceWithId:(NSString *)Id type:(NSString *)type callback:(void(^)(NSString *status))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setObject:Id forKey:@"invoiceId"];
     [params setObject:type forKey:@"type"];


    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"setDefaultCompanyInvoice" forKey:@"method"];
    [self.dicHead setValue:@"company" forKey:@"action"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                callback (status);
                
                
            }else {
                
                [[Toast shareToast]makeText:message aDuration:1];
            }
            
        }
        
        
        
        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
    
    
}

@end
