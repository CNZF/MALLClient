//
//  MessageViewModel.m
//  MallClient
//
//  Created by lxy on 2018/6/28.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MessageViewModel.h"
#import "MessageModel.h"

@implementation MessageViewModel

- (void)getUserMessageListWithType:(int)status WithCurrentPage:(int)currentPage WithPageSize:(int)pageSize callback:(void(^)(NSArray *arr,BOOL isLastPage))callback {
    
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    if (status == 0 ||status == 1) {
        [params setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    }
    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSLog(@"params :%@",params);
    
    [self.dicRequest setObject:params forKey:@"params"];
    [self.dicHead setValue:@"getUserMessage" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
      
//        NSDictionary *dicData1 = [self dictionaryWithJsonString:str];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSDictionary *result = response[@"result"];
                NSString *data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSArray *arr = dicData[@"messageList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    MessageModel *model = [[MessageModel alloc]initWithDictionary:dic];
                    [arrModel addObject:model];
                }
                int dada  = [result[@"size"] intValue];
                NSLog(@"resultdada :%d",dada);
                if ([result[@"size"] intValue] < currentPage) {
                    callback(arrModel,YES);
                }
                else
                {
                    callback(arrModel,NO);
                }
            }else {
                callback(nil,NO);
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        else
        {
            callback(nil,NO);
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        callback(nil,NO);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

- (void)detailWithMessageStatus:(int)status MessageArray:(NSArray <MessageModel *> *)messageVArray callback:(void(^)(BOOL result))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:status] forKey:@"status"];
    [params setObject:messageVArray forKey:@"messageId"];
    
//    [params setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
//    [params setObject:[NSNumber numberWithInt:pageSize] forKey:@"pageSize"];
    
    NSLog(@"params :%@",params);
    
    [self.dicRequest setObject:params forKey:@"params"];
    [self.dicHead setValue:@"operateMessage" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        
        //        NSDictionary *dicData1 = [self dictionaryWithJsonString:str];
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
        else
        {
        
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

- (void) asyncNotReadMessage
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [self.dicRequest setObject:params forKey:@"params"];
    [self.dicHead setValue:@"getNotReadMessage" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        
        //        NSDictionary *dicData1 = [self dictionaryWithJsonString:str];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
              
                
            }else {
                
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        else
        {
            
        }
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

@end
