
//
//  NeedViewModel.m
//  MallClient
//
//  Created by lxy on 2018/9/11.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "NeedViewModel.h"
#import "MyNeedModel.h"

@implementation NeedViewModel

-(void)getEmptyContainerArrWith:(NSString *)userId Page:(int)page limite:(int)limite  callback:(void(^)(NSArray *arr,BOOL isLastPage))callback;
{
//    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
//    [params setNoNullObject:@"BUSINESS_TYPE_CONTAINER" forKey:@"bizType"];
//    NSString *time = [NSString stringWithFormat:@"%ld000", (long)[info.shipmentsTime timeIntervalSince1970]];
//    [params setNoNullObject:time forKey:@"departureTime"];
//    [params setNoNullObject:info.endPlace.code forKey:@"endCode"];
//    [params setNoNullObject:info.transportationModel.expectTime forKey:@"expectTime"];
//    [params setNoNullObject:info.startPlace.code forKey:@"startCode"];
//    if (isSelect) {
//        [params setNoNullObject:@(info.box.containerId) forKey:@"containerId"];
//    }
    [params setNoNullObject:@[@"1",@"2",@"3"] forKey:@"statuses"];
    [params setNoNullObject:userId forKey:@"createUserId"];
    [params setNoNullObject:[NSString stringWithFormat:@"%i",limite] forKey:@"limit"];
    [params setNoNullObject:[NSString stringWithFormat:@"%i",page] forKey:@"page"];
    [self.dicRequest setObject:params forKey:@"params"];
    [self.dicHead setValue:@"0.0.0.2" forKey:@"version"];
    [self.dicHead setValue:@"getTransportRequimentList" forKey:@"method"];
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
                NSArray *arr = dicData[@"transportRequimentList"];
                NSMutableArray *arrModel = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    MyNeedModel *model = [MyNeedModel yy_modelWithJSON:dic];
                    [arrModel addObject:model];
                }
                int dada  = [result[@"size"] intValue];
                NSLog(@"resultdada :%d",dada);
                if ([result[@"size"] intValue] < page) {
                    callback(arrModel,YES);
                }
                else
                {
                    callback(arrModel,NO);
                }
               
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
