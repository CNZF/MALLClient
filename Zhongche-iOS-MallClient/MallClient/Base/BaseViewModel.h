//
//  BaseViewModel.h
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager+RACRetrySupport.h"
#import "Toast.h"
#import "SVProgressHUD.h"
#import "zipAndUnzip.h"
#import "MD5Util.h"
#import "CapacityEntryModel.h"
#import "MyFilePlist.h"

typedef void(^WSNetErrorBlack)(NSError* error);

@interface BaseViewModel : NSObject

@property (nonatomic, copy) WSNetErrorBlack errorBlock;
@property (nonatomic, strong) NSMutableDictionary  *dicHead;
@property (nonatomic, strong) NSMutableDictionary  *dicRequest;

- (RACSignal *)POST:(NSString *)method Param:(NSDictionary *)param;
/**
 *  Post请求（传图片）
 *
 */
- (RACSignal *)POST:(NSString *)method
              Param:(NSDictionary *)param
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock;

- (id)getResponseData:(RACTuple *)tuple;

- (NSString*)dictionaryToJson:(NSDictionary *)dic;

//压缩
- (NSString *)stringZipWithDic:(NSDictionary *)dic withZip:(BOOL)isZip withisEncrypt:(BOOL)isEncrypt;

//MD5加密
- (NSString *)stringWithMd5:(NSString *)st;

//图片命名
- (NSString *)imgNameWith:(NSString *)st;

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

@interface NSMutableDictionary(ZCDictionary)

- (void)setNoNullObject:(id)anObject forKey:(id <NSCopying>)aKey;

@end
