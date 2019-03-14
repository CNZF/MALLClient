//
//  CalViewModel.m
//  MallClient
//
//  Created by lxy on 2017/10/16.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "CoalViewModel.h"

@implementation CoalViewModel



/**
 *  查询煤
 *
 *  @param dicConditions 筛选条件
 *  @param callback      煤数组
 */

- (void)getCoalListWithConditions:(NSDictionary *)dicConditions callback:(void(^)(NSArray *arr))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
//    [params setObject:[NSNumber numberWithInt:type] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:0] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:100] forKey:@"pageSize"];
    [params setNoNullObject:dicConditions[@"type"] forKey:@"type"];
    [params setNoNullObject:dicConditions[@"startMoisture"] forKey:@"startMoisture"];
    [params setNoNullObject:dicConditions[@"endMoisture"] forKey:@"endMoisture"];
    [params setNoNullObject:dicConditions[@"startQnet"] forKey:@"startQnet"];
    [params setNoNullObject:dicConditions[@"endQnet"] forKey:@"endQnet"];

    [params setNoNullObject:dicConditions[@"startSulfur"] forKey:@"startSulfur"];
    [params setNoNullObject:dicConditions[@"endSulfur"] forKey:@"endSulfur"];
    [params setNoNullObject:dicConditions[@"startVolatilize"] forKey:@"startVolatilize"];
    [params setNoNullObject:dicConditions[@"endVolatilize"] forKey:@"endVolatilize"];
    [params setNoNullObject:dicConditions[@"startAsh"] forKey:@"startAsh"];
    [params setNoNullObject:dicConditions[@"endAsh"] forKey:@"endAsh"];
    [params setNoNullObject:dicConditions[@"particleType"] forKey:@"particleType"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getProduceList" forKey:@"method"];
    [self.dicHead setValue:@"produce" forKey:@"action"];

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
                NSArray *arr = dicData[@"produceList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {

                    CoalModel *model= [CoalModel yy_modelWithJSON:dic];
                    model.ID = dic[@"id"];

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
}



/**
 *  获取筛选条件
 */
- (void)getConditionscallback:(void(^)(NSDictionary *dic))callback  {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    //    [params setObject:[NSNumber numberWithInt:type] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:0] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:100] forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getProduceParameters" forKey:@"method"];
    [self.dicHead setValue:@"produce" forKey:@"action"];

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

                callback(dicData[@"produceParameters"]);


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
 *  查询煤详情
 *
 *  @param ID       ID
 *  @param callback 煤实体
 */
- (void)getCoalDesWithId:(NSString *)ID callback:(void(^)(CoalModel *model))callback  {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:ID forKey:@"produceId"];
    [params setObject:[NSNumber numberWithInt:0] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:100] forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getProduceInfoById" forKey:@"method"];
    [self.dicHead setValue:@"produce" forKey:@"action"];

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
                NSDictionary *dicModel = dicData[@"produceObj"];
                CoalModel *model = [CoalModel yy_modelWithJSON:dicModel];
                callback (model);




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
 *  提交订单
 */

-(void)saveOrderWithGoodsId:(NSString *)goodsId WithQty:(NSString *)qty WithConractsPhone:(NSString *)conractsPhone WithContactsName:(NSString *)contactsName WithPrice:(NSString *)price WithRemake:(NSString *)remake callback:(void(^)(NSString *orderNo))callback{




    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    NSDictionary *dicBean = @{@"qty":qty,@"price":price,@"goodsId":goodsId};
    [params setObject:dicBean forKey:@"goodsOrderDetailBean"];
    [params setObject:conractsPhone forKey:@"conractsPhone"];
    [params setObject:contactsName forKey:@"contactsName"];
    [params setObject:remake forKey:@"remake"];

    [params setObject:[NSNumber numberWithInt:0] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:100] forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"save" forKey:@"method"];
    [self.dicHead setValue:@"goodsOrder" forKey:@"action"];

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
                callback (dicData[@"goodsOrderCode"]);




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
