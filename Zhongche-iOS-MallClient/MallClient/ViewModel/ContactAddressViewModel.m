//
//  ContactAddressViewModel.m
//  MallClient
//
//  Created by lxy on 2016/12/27.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "ContactAddressViewModel.h"

@implementation ContactAddressViewModel

/**
 *  添加地址
 *
 *  @param name    联系人姓名
 *  @param phone   手机号
 *  @param address 地址
 *  @param code    城市code
 *  @param type    1、起始地 2、抵运地
 */

- (void)addAddressWithName:(NSString *)name WithPhone:(NSString *)phone WithAddress:(AMapPOI *)address WithCityCode:(NSString *)code WithType:(NSString *)type callback:(void(^)(NSString *status))callback {

    UserInfoModel * info = USER_INFO;

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];


    [params setNoNullObject:phone forKey:@"contactsPhone"];
    [params setNoNullObject:name forKey:@"contacts"];
    if (address.name == nil) {
        [params setNoNullObject:@"" forKey:@"detailAddress"];
    }else{
        [params setNoNullObject:address.name forKey:@"detailAddress"];
    }
    if (code == nil) {
        [params setNoNullObject:@"" forKey:@"regionCode"];
    }else{
        [params setNoNullObject:code forKey:@"regionCode"];
    }
    [params setNoNullObject:[NSString stringWithFormat:@"%f",address.location.longitude] forKey:@"lng"];
    [params setNoNullObject:[NSString stringWithFormat:@"%f",address.location.latitude] forKey:@"lat"];
    [params setValue:info.iden forKey:@"userId"];

    [params setObject:phone forKey:@"contactsPhone"];
//    [params setNoNullObject:type forKey:@"type"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"addUserAddress" forKey:@"method"];
    [self.dicHead setValue:@"address" forKey:@"action"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            /**
             *  {
             header =     {
             device = "iphone 5s(GSM),9.3.5";
             encrpy = 0;
             platform = IOS;
             version = "0.0.0.1";
             zip = 0;
             };
             response =     {
             message = "\U6267\U884c\U6210\U529f";
             result =         {
             currentPage = 0;
             data = "{\"addressId\":66}";
             size = 0;
             };
             status = 10000;
             };
             token = "";
             }
             */
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

    /**
     *  {
     header =     {
     device = "iphone 5s(Global),8.3";
     encrpy = 0;
     platform = IOS;
     version = "0.0.0.1";
     zip = 0;
     };
     response =     {
     message = "\U6267\U884c\U6210\U529f";
     result =         {
     currentPage = 0;
     data = "{\"goods\":[{\"batchExpressGoods\":0,\"code\":\"2040006\",\"createTime\":1471949939000,\"createUserId\":1,\"goodsCategoryId\":268,\"id\":3102,\"ltlPriceCode\":24,\"name\":\"\U725b\U5976\",\"phoneticCode\":\"NN\",\"status\":1,\"tlPriceCode\":6}]}";
     pageCount = 0;
     };
     status = 10000;
     };
     token = "";
     }
     */


}



/**
 *  修改地址
 *
 *  @param name    联系人姓名
 *  @param phone   手机号
 *  @param address 地址
 *  @param code    城市code
 *  @param ID      联系方式ID
 */

- (void)updateAddressWithName:(NSString *)name WithPhone:(NSString *)phone WithAddress:(AMapPOI *)address WithCityCode:(NSString *)code WithId:(NSString *)ID callback:(void(^)(NSString *status))callback {



    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"contactsPhone"];
    [params setObject:name forKey:@"contacts"];
    [params setObject:address.name forKey:@"detailAddress"];
    if (code == nil) {
        [params setNoNullObject:@"" forKey:@"regionCode"];
    }else{
        [params setNoNullObject:code forKey:@"regionCode"];
    }
    [params setObject:[NSString stringWithFormat:@"%f",address.location.longitude] forKey:@"lng"];
    [params setObject:[NSString stringWithFormat:@"%f",address.location.latitude] forKey:@"lat"];

    [params setObject:ID forKey:@"id"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"modifyUserAddress" forKey:@"method"];
    [self.dicHead setValue:@"address" forKey:@"action"];


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

    /**
     *  {
     header =     {
     device = "iphone 5s(Global),8.3";
     encrpy = 0;
     platform = IOS;
     version = "0.0.0.1";
     zip = 0;
     };
     response =     {
     message = "\U6267\U884c\U6210\U529f";
     result =         {
     currentPage = 0;
     data = "{\"goods\":[{\"batchExpressGoods\":0,\"code\":\"2040006\",\"createTime\":1471949939000,\"createUserId\":1,\"goodsCategoryId\":268,\"id\":3102,\"ltlPriceCode\":24,\"name\":\"\U725b\U5976\",\"phoneticCode\":\"NN\",\"status\":1,\"tlPriceCode\":6}]}";
     pageCount = 0;
     };
     status = 10000;
     };
     token = "";
     }
     */


}

/**
 *  搜索地址
 */

- (void)selectAddressWithType:(NSString *)type callback:(void(^)(NSArray *arr))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

//    [params setNoNullObject:@1 forKey:@"type"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getUserAddress" forKey:@"method"];
    [self.dicHead setValue:@"address" forKey:@"action"];


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
                NSArray *arr = dicData[@"address"];

                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    AddressInfo *model = [AddressInfo yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                callback(arrModel);

            }else {

                [[Toast shareToast]makeText:message aDuration:1];
            }


        }



        [SVProgressHUD dismiss];

    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
    /**
     *  {
     "address": "\U5317\U4eac\U5e02\U6d77\U6dc0\U533a\U4e2d\U5173\U6751",
     "companyId": 780,
     "contacts": "312",
     "contactsPhone": "022-78181181",
     "contactsTel": "18515589999",
     "id": 300,
     "isDefault": 0,
     "remark": "\U771f\U8c6a"
     }
     *
     
     */
    
}

- (void)delegateAddressWithType:(NSString *)type IdArray:(NSArray *)idArray callback:(void(^)(BOOL ret))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    
    [params setObject:idArray forKey:@"addressList"];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"batchDeleteUserAddress" forKey:@"method"];
    [self.dicHead setValue:@"address" forKey:@"action"];
    
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                callback(YES);
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
