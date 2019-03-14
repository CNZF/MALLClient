//
//  OrderCenterViewModel.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/19.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderCenterViewModel.h"

@implementation OrderCenterViewModel

- (void)getOrderWithType:(OrderStatus)type WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr))callback
{

//    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:type] forKey:@"status"];
    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"getOrderList" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    
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
                NSArray *arr = dicData[@"containerType"][@"data"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    OrderModel *model = [OrderModel yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                callback(arrModel);
                
            }else {
                
                [[Toast shareToast]makeText:message aDuration:1];
            }
            
            
            
        }
        
//        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
//        [SVProgressHUD dismiss];
    }];
    
    
}


@end
