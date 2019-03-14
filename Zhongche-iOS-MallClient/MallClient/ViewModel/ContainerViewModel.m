//
//  ContainerViewModel.m
//  MallClient
//
//  Created by lxy on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "ContainerViewModel.h"




@implementation ContainerViewModel

/**
 *  获取箱型
 *
 *  @param callback 箱型数组
 */

- (void)getContainerTypecallback:(void(^)(NSArray *arr))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setObject:@"382" forKey:@"driverId"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getContainerType" forKey:@"method"];
    [self.dicHead setValue:@"container" forKey:@"action"];


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
                NSArray *arr = dicData[@"containerType"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    ContainerTypeModel *model = [ContainerTypeModel yy_modelWithJSON:dic];
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
 *  货品联想搜索
 *
 *  @param keyWords 关键字
 *  @param callback 搜索结果
 */

- (void)getGoodsWithKeyWords:(NSString *)keyWords callback:(void(^)(NSArray *arr,NSString *keywords))callback {



//    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [params setNoNullObject:@"382" forKey:@"driverId"];
    [params setNoNullObject:keyWords forKey:@"keywords"];

    [self.dicRequest setNoNullObject:params forKey:@"params"];

    [self.dicHead setNoNullObject:@"getGoods" forKey:@"method"];
    [self.dicHead setNoNullObject:@"goods" forKey:@"action"];


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
                NSArray *arr = dicData[@"goods"];

                NSString *keywords = dicData[@"keywords"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    GoodsInfo *model = [GoodsInfo yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                callback(arrModel,keywords);

            }else {

                [[Toast shareToast]makeText:message aDuration:1];
            }
            

        }

        

//        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
//        [SVProgressHUD dismiss];
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




@end
