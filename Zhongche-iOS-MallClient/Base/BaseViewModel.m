//
//  BaseViewModel.m
//  Zhongche
//
//  Created by lxy on 16/7/11.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewModel.h"
#import "Toast.h"
#import "AFHTTPSessionManager.h"
#import "RACSignal.h"
#import "OrderedDictionary.h"
#import "SVProgressHUD.h"
#import "NSString+Extension.h"
#import <SDVersion/SDVersion.h>
#import "UserInfoModel.h"
#import "MyFilePlist.h"
#import "ZSEquipmentAttribute.h"


typedef BOOL(^WSTestBlock) (NSURLResponse *response, id responseObject, NSError *error);

@interface BaseViewModel ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, copy  ) WSTestBlock          wsTestBlock;

@end

@implementation BaseViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initManagerWithBaseURL:BASEURL];
        [self initParam];
        [self initHeadDic];
    }
    return self;
}

- (void)initParam {
    WS(ws)
    self.errorBlock = ^(NSError *error) {
        [ws handleError:error];
    };
    
    self.wsTestBlock = ^BOOL(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        if (httpResponse.statusCode >= 500) {
            return YES;
        }
        else {
            return NO;
        }
    };
}

- (void)initManagerWithBaseURL:(NSString *)URL {
    
    self.manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:URL]];
    self.manager.requestSerializer.timeoutInterval = INTERVAL;
    [self.manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpg", nil]];
}

/**
 *  加载头请求字典
 */
- (void)initHeadDic {
    self.dicHead = [NSMutableDictionary dictionary];
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //手机型号
    NSString* phoneModel = [ZSEquipmentAttribute getDeviceName];
    
    NSString *device = [[phoneModel append:@","]append:phoneVersion];
    
    NSString *platform = @"IOS";
    
    NSString * version = @"0.0.0.1";
    UserInfoModel * info = USER_INFO;
    
    [self.dicHead setValue:device forKey:@"device"];
    [self.dicHead setValue:platform forKey:@"platform"];
//    [self.dicHead setValue:clientid forKey:@"clientid"];
    [self.dicHead setValue:version forKey:@"version"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    
    if (info) {

        NSString *stId  = [NSString stringWithFormat:@"%@",info.iden];
        [self.dicHead setValue:stId forKey:@"userId"];
        [self.dicHead setValue:info.token forKey:@"token"];
    }else{

        [self.dicHead setValue:@"" forKey:@"userid"];
        [self.dicHead setValue:@"" forKey:@"token"];
    }
    
    self.dicRequest = [NSMutableDictionary dictionary];

}

- (RACSignal *)GETWithTimeSp:(NSString *)method Param:(NSDictionary *)param {
    NSMutableDictionary *mutiDict = [NSMutableDictionary dictionaryWithDictionary:param];
    [mutiDict setValue:[NSString timesp] forKey:@"timesp"];
    return [self GET:method Param:[mutiDict copy]];
}

- (RACSignal *)GET:(NSString *)method Param:(NSDictionary *)param {
    return [self.manager rac_GET:method parameters:param retries:RETRIES interval:INTERVAL test:self.wsTestBlock];
}

/**
 *  Post请求
 *
 */
- (RACSignal *)POST:(NSString *)method Param:(NSDictionary *)param {
  
    return [self.manager rac_POST:method parameters:param retries:RETRIES interval:INTERVAL test:self.wsTestBlock];
}
/**
 *  Post请求（传图片）
 *
 */
- (RACSignal *)POST:(NSString *)method
              Param:(NSDictionary *)param
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))formDataBlock{
    [self setRequestSerializer:param];
    self.manager.requestSerializer.timeoutInterval = IMGINTERVAL;
    return [self.manager rac_POST:method
                       parameters:param
        constructingBodyWithBlock:formDataBlock
                          retries:RETRIES
                         interval:INTERVAL
                             test:self.wsTestBlock];
    
}

- (void)handleError:(NSError *)error {
    NSLog(@"net error :%@",error);
    [SVProgressHUD dismiss];
}
/**
 *  设置请求头部
 *
 *  @param param 请求参数
 */
- (void)setRequestSerializer:(NSDictionary *)param
{
//    OrderedDictionary *dict = [self orderDict:param];
}

- (id)getResponseData:(RACTuple *)tuple
{
    return [tuple first];
}


//字典转换为字符串

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

/*
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */

- (id)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }

    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//压缩、AES加密
- (NSString *)stringZipWithDic:(NSDictionary *)dic withZip:(BOOL)isZip withisEncrypt:(BOOL)isEncrypt{

    NSString *stJson = [self dictionaryToJson:dic];
    //压缩
    if (isZip) {

        NSData *data =[stJson dataUsingEncoding:NSUTF8StringEncoding];
        zipAndUnzip *zipTools = [[zipAndUnzip alloc] init];

        NSData *datazip = [zipTools gzipDeflate:data];

        stJson = [datazip base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];

    }
    return stJson;
}

//MD5加密
- (NSString *)stringWithMd5:(NSString *)st {

    MD5Util *md5util = [MD5Util new];

    return  [md5util md5:st];
}
 
//图片命名
- (NSString *)imgNameWith:(NSString *)st
{
    UserInfoModel *info = [UserInfoModel new];
    NSString *stId = [NSString stringWithFormat:@"%@",info.iden];
    NSString *fileName = [NSString stringWithFormat:@"%@%@",stId,st];
    NSData *data =[fileName dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filejpgName = [NSString stringWithFormat:@"%@.jpg",[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];
    return filejpgName;
}

#pragma mark - utils

- (OrderedDictionary *)orderDict:(NSDictionary *)param
{
    
    NSArray *arr = [param keysSortedByValueUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch range:range];
    }];
    
    MutableOrderedDictionary *orderDicts = [MutableOrderedDictionary dictionaryWithCapacity:param.count];
    
    for (int i=0; i<arr.count; i++)
    {
        NSString *key = arr[i];
        [orderDicts insertObject:param[key] forKey:key atIndex:i];
    }
    return orderDicts;
}

@end
