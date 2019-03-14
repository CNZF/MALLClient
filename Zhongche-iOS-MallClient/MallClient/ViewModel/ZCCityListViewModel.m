//
//  ZCCityListViewModel.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCCityListViewModel.h"
#import "CityModel.h"

@implementation ZCCityListViewModel
/**
 *  拉取城市列表
 *
 */
-(void)getCityListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback {
    //缓存(日更)路径
//    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
//    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString * path = [NSString stringWithFormat:@"%@/city/%@",(NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]),[outputFormatter stringFromDate:[NSDate date]]];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if([fileManager fileExistsAtPath:path]) {
//        //文件存在则读取缓存
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//            NSData * data = [NSData dataWithContentsOfFile:path];
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSMutableArray * cityArray = [[NSMutableArray alloc]init];
//            CityModel  * model;
//            NSArray * cityArr = [self dictionaryWithJsonString:result[@"data"]][@"regions"];
//            for (NSDictionary * city in cityArr)
//            {
//                model = [CityModel yy_modelWithJSON:city];
//                [cityArray addObject:model];
//            }
//            dispatch_async(dispatch_get_main_queue (), ^{
//                callback(cityArray);
//                
//            });
//        });
//    } else {
    
        //进行网路请求,拉取新数据
        [SVProgressHUD showWithStatus:LOADING];

        NSMutableDictionary *params= [NSMutableDictionary dictionary];
        [self.dicRequest setObject:params forKey:@"params"];
        
        [self.dicHead setValue:@"getRegions" forKey:@"method"];
        [self.dicHead setValue:@"region" forKey:@"action"];
        
        NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
        NSString *st = [self dictionaryToJson:dic];
        [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
            id responseData = [self getResponseData:tuple];
            if (responseData) {
                NSDictionary *response = responseData[@"response"];
                NSDictionary *result = response[@"result"];
                NSString *status = response[@"status"];
                NSString *message = response[@"message"];
                if ([status isEqualToString:@"10000"]) {
                    [[Toast shareToast]makeText:@"拉取列表成功" aDuration:1];
                    NSMutableArray * cityArray = [[NSMutableArray alloc]init];
                    CityModel  * model;
                    NSArray * cityArr = [self dictionaryWithJsonString:result[@"data"]][@"regions"];
                    for (NSDictionary * city in cityArr)
                    {
                        model = [CityModel yy_modelWithJSON:city];
                        [cityArray addObject:model];
                    }
                    callback(cityArray);
                    
//                    //对新数据进行缓存
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        
//                        NSString * cityFolder = [NSString stringWithFormat:@"%@/city",(NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])];
//                        NSError *error = nil;
//                        NSArray *fileList = [[NSArray alloc] init];
//                        fileList = [fileManager contentsOfDirectoryAtPath:cityFolder error:&error];
//                        for (NSString * file in fileList) {
//                            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",cityFolder,file] error:NULL];
//                        }
//                        NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
//                        [fileManager createDirectoryAtPath:cityFolder
//                               withIntermediateDirectories:YES
//                                                attributes:@{NSFileAppendOnly:@0,
//                                                             }
//                                                     error:nil];
//
//                        [fileManager createFileAtPath:path contents:data attributes:nil];
//                    });
                    
                }else{
                    [[Toast shareToast]makeText:message aDuration:1];
                }
            }
            [SVProgressHUD dismiss];
            
        }error:^(NSError *error) {
            
            [[Toast shareToast]makeText:BUSY aDuration:1];
            [SVProgressHUD dismiss];
        }];

//    }
}

/**
 *  拉取网点、城市列表
 *
 */
-(void)getCityAndBranchesListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback {
//    //缓存(日更)路径
//    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
//    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
//    NSString * path = [NSString stringWithFormat:@"%@/regionAndEntrepot/%@",(NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]),[outputFormatter stringFromDate:[NSDate date]]];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    if([fileManager fileExistsAtPath:path]) {
//        //文件存在则读取缓存
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSData * data = [NSData dataWithContentsOfFile:path];
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            NSMutableArray * cityArray = [[NSMutableArray alloc]init];
//            CityModel  * model;
//            NSArray * cityArr = [self dictionaryWithJsonString:result[@"data"]][@"regionAndEntrepot"];
//            for (NSDictionary * city in cityArr)
//            {
//                model = [CityModel yy_modelWithJSON:city];
//                [cityArray addObject:model];
//            }
//            dispatch_async(dispatch_get_main_queue (), ^{
//                callback(cityArray);
//                
//            });
//        });
//    } else {
//        
        //进行网路请求,拉取新数据
        [SVProgressHUD showWithStatus:LOADING];
        
        NSMutableDictionary *params= [NSMutableDictionary dictionary];
        [self.dicRequest setObject:params forKey:@"params"];
        
        [self.dicHead setValue:@"getRegionAndEntrepotOfBr" forKey:@"method"];
        [self.dicHead setValue:@"region" forKey:@"action"];
        
        NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
        NSString *st = [self dictionaryToJson:dic];
        [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
            
            id responseData = [self getResponseData:tuple];
            if (responseData) {
                NSDictionary *response = responseData[@"response"];
                NSDictionary *result = response[@"result"];
                NSString *status = response[@"status"];
                NSString *message = response[@"message"];
                if ([status isEqualToString:REQUESTSUCCESS]) {
                    [[Toast shareToast]makeText:@"拉取列表成功" aDuration:1];
                    NSMutableArray * cityArray = [[NSMutableArray alloc]init];
                    CityModel  * model;
                    NSArray * cityArr = [self dictionaryWithJsonString:result[@"data"]][@"regionAndEntrepot"];
                    for (NSDictionary * city in cityArr)
                    {
                        model = [CityModel yy_modelWithJSON:city];
                        [cityArray addObject:model];
                    }
                    callback(cityArray);
                    
//                    //对新数据进行缓存
//                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                        
//                        NSString * cityFolder = [NSString stringWithFormat:@"%@/regionAndEntrepot",(NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])];
//                        NSError *error = nil;
//                        NSArray *fileList = [[NSArray alloc] init];
//                        fileList = [fileManager contentsOfDirectoryAtPath:cityFolder error:&error];
//                        for (NSString * file in fileList) {
//                            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",cityFolder,file] error:NULL];
//                        }
//                        NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
//                        [fileManager createDirectoryAtPath:cityFolder
//                               withIntermediateDirectories:YES
//                                                attributes:@{NSFileAppendOnly:@0,
//                                                             }
//                                                     error:nil];
//                        
//                        [fileManager createFileAtPath:path contents:data attributes:nil];
//                    });
                    
                }else{
                    [[Toast shareToast]makeText:message aDuration:1];
                }
            }
            [SVProgressHUD dismiss];
            
        }error:^(NSError *error) {
            
            [[Toast shareToast]makeText:BUSY aDuration:1];
            [SVProgressHUD dismiss];
        }];
        
//    }
}

/**
 *  拉取网点、城市列表
 *
 */
-(void)getQuickCityAndBranchesListWithType:(NSString *)type WithCallback:(void (^)(NSArray * cityArray))callback {
    //    //缓存(日更)路径
    //    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    //    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSString * path = [NSString stringWithFormat:@"%@/regionAndEntrepot/%@",(NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]),[outputFormatter stringFromDate:[NSDate date]]];
    //
    //    NSFileManager *fileManager = [NSFileManager defaultManager];
    //
    //    if([fileManager fileExistsAtPath:path]) {
    //        //文件存在则读取缓存
    //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //            NSData * data = [NSData dataWithContentsOfFile:path];
    //            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //            NSMutableArray * cityArray = [[NSMutableArray alloc]init];
    //            CityModel  * model;
    //            NSArray * cityArr = [self dictionaryWithJsonString:result[@"data"]][@"regionAndEntrepot"];
    //            for (NSDictionary * city in cityArr)
    //            {
    //                model = [CityModel yy_modelWithJSON:city];
    //                [cityArray addObject:model];
    //            }
    //            dispatch_async(dispatch_get_main_queue (), ^{
    //                callback(cityArray);
    //
    //            });
    //        });
    //    } else {
    //
    //进行网路请求,拉取新数据
    [SVProgressHUD showWithStatus:LOADING];

    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getRegionAndEntrepotOfMt" forKey:@"method"];
    [self.dicHead setValue:@"region" forKey:@"action"];

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {

        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                [[Toast shareToast]makeText:@"拉取列表成功" aDuration:1];
                NSMutableArray * cityArray = [[NSMutableArray alloc]init];
                CityModel  * model;
                NSArray * cityArr = [self dictionaryWithJsonString:result[@"data"]][@"regionAndEntrepot"];
                for (NSDictionary * city in cityArr)
                {
                    model = [CityModel yy_modelWithJSON:city];
                    [cityArray addObject:model];
                }
                callback(cityArray);

                //                    //对新数据进行缓存
                //                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //
                //                        NSString * cityFolder = [NSString stringWithFormat:@"%@/regionAndEntrepot",(NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0])];
                //                        NSError *error = nil;
                //                        NSArray *fileList = [[NSArray alloc] init];
                //                        fileList = [fileManager contentsOfDirectoryAtPath:cityFolder error:&error];
                //                        for (NSString * file in fileList) {
                //                            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",cityFolder,file] error:NULL];
                //                        }
                //                        NSData *data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
                //                        [fileManager createDirectoryAtPath:cityFolder
                //                               withIntermediateDirectories:YES
                //                                                attributes:@{NSFileAppendOnly:@0,
                //                                                             }
                //                                                     error:nil];
                //
                //                        [fileManager createFileAtPath:path contents:data attributes:nil];
                //                    });

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
    //    }
}

@end
