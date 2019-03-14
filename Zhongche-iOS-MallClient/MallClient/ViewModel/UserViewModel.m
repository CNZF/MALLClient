//
//  UserViewModel.m
//  MallClient
//
//  Created by lxy on 2016/12/8.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "UserViewModel.h"
#import "MyFilePlist.h"
#import "AcountDetail.h"

@implementation UserViewModel

/**
 *  登录
 *
 *  @param telephoneNumber 手机号
 *  @param passWord        密码
 *  @param callback        登录用户对象
 */
-(void)loginWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord state:(int)state callback:(void(^)(UserInfoModel *userInfo))callback tokenback:(void(^)(BOOL ret))tokenback{

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:telephoneNumber forKey:@"username"];
    NSString *stMd5 = [self stringWithMd5:passWord];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"login" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    NSDictionary * diccc = @{@"data":st};
    
    
    [[self POST:CHILEDURL Param:diccc]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([message isEqualToString:@"执行成功"]) {
                NSString  * dicStr = result[@"data"];
              
                NSDictionary *dicDate= [self dictionaryWithJsonString:dicStr];
                NSString *token = dicDate[@"token"];
                if (state == 1) {
                    tokenback(YES);
                }else{
                    [self loginWithToken:token callback:^(UserInfoModel *userInfo) {
                        callback(userInfo);
                    }];
                }
            }else{
//                UserInfoModel * user = USER_INFO;
//                if(![telephoneNumber isEqualToString:user.loginName]){
//                    [[Toast shareToast]makeText:message aDuration:1];
//                }
//                else {
                    [[Toast shareToast]makeText:@"密码错误" aDuration:1];
//
//                }
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

-(void)loginWithToken:(NSString *)token callback:(void(^)(UserInfoModel *userInfo))callback
{
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [self.dicHead setValue:@"getUserInfo" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    [self.dicHead setValue:token forKey:@"token"];
    
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        NSLog(@"%@",responseData);
        if (responseData) {
            NSString *message = responseData[@"response"][@"message"];
            if ([message isEqualToString:@"执行成功"]) {
                NSString *dicUserStr = responseData[@"response"][@"result"][@"data"];
                NSDictionary *dicDate= [self dictionaryWithJsonString:dicUserStr];
                NSDictionary * infoDic = dicDate[@"userInfo"];
                UserInfoModel *Info = [UserInfoModel yy_modelWithJSON:infoDic];
                Info.token = token;
                
                BOOL ret = [NSKeyedArchiver archiveRootObject:Info toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
                if (ret) {
                    callback(Info);
                }
            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }else{
             [[Toast shareToast]makeText:BUSY aDuration:1];
        }
        
        [SVProgressHUD dismiss];
    }error:^(NSError *error) {
        
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}


/**
 *  获取验证码
 */

- (void)getRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback {


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:phone forKey:@"phone"];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getRegistVerifyCode" forKey:@"method"];
    [self.dicHead setValue:@"smsAction" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"验证码发送成功,请等待" aDuration:1];

                callback (status);


            }else{
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
 *  提交个人信息
 *
 *  @param name     名字
 *  @param phone    手机号
 *  @param email    邮箱
 *  @param code     验证码
 *  @param callback 返回状态
 */
- (void)submitUserMessageWithName:(NSString *)name WithPhone:(NSString *)phone WithEmail:(NSString *)email WithCode:(NSString *)code callback:(void(^)(NSString *st))callback {

    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:name forKey:@"name"];
    [params setValue:phone forKey:@"phone"];
    [params setValue:email forKey:@"email"];

    if([code isEqualToString:@""]){
        [params setValue:@1 forKey:@"type"];

    }else {
        [params setValue:@0 forKey:@"type"];
        [params setValue:code forKey:@"verifyCode"];
    }

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"improvedUserInfo" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {

                [[Toast shareToast]makeText:@"提交成功" aDuration:1];
                callback (status);


            }else{
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
 *  注册
 *
 *  @param telephoneNumber 用户手机号
 *  @param passWord        密码
 *  @param verifycode      验证码
 *  @param username        用户名
 *  @param callback        抛出
 */
-(void)registerWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithUserName:(NSString *)username callback:(void(^)(UserInfoModel *userInfo))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:telephoneNumber forKey:@"phone"];
    [params setValue:verifycode forKey:@"verifyCode"];
    [params setValue:username forKey:@"loginName"];
    [params setValue:@6 forKey:@"type"];

    NSString *stMd5 = [self stringWithMd5:passWord];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];

    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];

    [self.dicHead setValue:@"register" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];


    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        NSLog(@"%@",responseData);
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            
            if ([status isEqualToString:@"10000"]) {
                NSDictionary * result = response[@"result"];
                NSString * data = result[@"data"];
                 NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSString * token = dicData[@"token"];
                [[UserViewModel  new] loginWithToken:token callback:^(UserInfoModel *userInfo) {
                     callback(userInfo);
                }];
//                [[Toast shareToast]makeText:@"注册成功" aDuration:1];
//                callback(status);

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
}

-(void)PersonRegisterWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithUserName:(NSString *)username callback:(void(^)(UserInfoModel *userInfo))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:telephoneNumber forKey:@"phone"];
    [params setValue:verifycode forKey:@"verifyCode"];
    [params setValue:username forKey:@"loginName"];
    [params setValue:@11 forKey:@"type"];
    
    NSString *stMd5 = [self stringWithMd5:passWord];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];
    
    [self.dicRequest setObject:[self stringZipWithDic:params withZip:NO withisEncrypt:NO] forKey:@"params"];
    
    [self.dicHead setValue:@"register" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":self.dicRequest};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        NSLog(@"%@",responseData);
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            
            if ([status isEqualToString:@"10000"]) {
                NSDictionary * result = response[@"result"];
                NSString * data = result[@"data"];
                NSDictionary *dicData = [self dictionaryWithJsonString:data];
                NSString * token = dicData[@"token"];
                [[UserViewModel  new] loginWithToken:token callback:^(UserInfoModel *userInfo) {
                    callback(userInfo);
                }];
                //                [[Toast shareToast]makeText:@"注册成功" aDuration:1];
                //                callback(status);
                
            }else{
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
 *  获取用户信息
 */

-(void)getUserInfoWithUserId:(void(^)(UserInfoModel *userInfo))callback{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getUserInfo" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
               
                NSString *stInfo = result[@"data"];
                NSDictionary *dicDate= [self dictionaryWithJsonString:stInfo];
                NSDictionary *dicUser = dicDate[@"userInfo"];


                UserInfoModel *userInfo = [UserInfoModel yy_modelWithJSON:dicUser];

                UserInfoModel *userInfoOld = USER_INFO;
                userInfo.organization_id =userInfoOld.organization_id;
                userInfo.token = userInfoOld.token;
                userInfo.iden = dicUser[@"userId"];

                [NSKeyedArchiver archiveRootObject:userInfo toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];

               

                callback(userInfo);

            }else{

                callback(nil);
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
    
}

/**
 *  获取用户账单
 */

-(void)getUserAccountListcallback:(void(^)(NSArray *arr))callback {
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"getAccountList" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {

                NSString *stInfo = result[@"data"];
                NSDictionary *dicDate= [self dictionaryWithJsonString:stInfo];
                NSArray *arrAccountList = dicDate[@"accountList"];

                NSMutableArray *arrModel = [NSMutableArray array];
                    for (NSDictionary *dic in arrAccountList) {
                        AcountDetail *model = [AcountDetail yy_modelWithJSON:dic];
                        [arrModel addObject:model];
                    }

                    callback(arrModel);


            }else{

                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
    
    
}


/**
 *  更改密码
 *
 *  @param OldPWD   老密码
 *  @param NewPWD   新密码
 *  @param callback 更改状态
 */

- (void)changePWDWithOldPWD:(NSString *)OldPWD WithNewPWD:(NSString *)NewPWD callback:(void(^)(NSString *st))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    NSString *stMd5 = [self stringWithMd5:OldPWD];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];

    NSString *stMd5New = [self stringWithMd5:NewPWD];
    [params setValue:[self stringWithMd5:stMd5New] forKey:@"newPassword"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"resetPassword" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {


                callback(status);



            }else{

                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {
        
        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];

}


/**
 *  上传企业实名认证图片
 *
 *  @param info     图片对象
 *  @param callback 状态
 */

- (void)submitPhotoForEnterpriseNameAuthenticationWithPhoto:(PhotoInfo *)info callback:(void(^)(NSString *st))callback{


    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"authEnterpriseInfo" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {


        /**
         *  businessLetteImage   公函照片
         *  businessLicenceImage  营业执照照片
         *  img_organization_licence  组织机构代码证
         *  img_tax_doc  税务登记证照片
         */

        if (info.img1) {

            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.img1,0.1)
                                        name:@"businessLetteImage"
                                    fileName:[self imgNameWith:@"businessLetteImage"]
                                    mimeType:@"image/jpg"];
        }

        if (info.img2) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.img2,0.1)
                                        name:@"businessLicenceImage"
                                    fileName:[self imgNameWith:@"businessLicenceImage"]
                                    mimeType:@"image/jpg"];
        }


        if (info.img3) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.img3,0.1)
                                        name:@"organizationCodeImage"
                                    fileName:[self imgNameWith:@"organizationCodeImage"]
                                    mimeType:@"image/jpg"];
        }

        if (info.img4) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(info.img4,0.1)
                                        name:@"taxCertificateImage"
                                    fileName:[self imgNameWith:@"taxCertificateImage"]
                                    mimeType:@"image/jpg"];
        }





    }] subscribeNext:^(id tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                [[Toast shareToast]makeText:@"图片上传成功" aDuration:1];
                callback(status);
            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
            [SVProgressHUD dismiss];

        }
    } error:^(NSError *error) {
        [[Toast shareToast]makeText:@"网络不好，上传超时，请删除大照片重试" aDuration:1];
        [SVProgressHUD dismiss];
        callback(nil);
    }];


}


/**
 *  上传企业资质认证图片
 *
 *  @param img     图片对象
 *  @param callback 状态
 */

- (void)submitPhotoForEnterpriseValueAuthenticationWithPhoto:(UIImage *)img callback:(void(^)(NSString *st))callback{

    NSMutableDictionary *params= [NSMutableDictionary dictionary];




    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"authEnterpriseQualification" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {


        if (img) {


            [formData appendPartWithFileData:UIImageJPEGRepresentation(img,0.1)
                                        name:@"qualificationImage"
                                    fileName:@"qualificationImage"
                                    mimeType:@"image/jpg"];
        }
    }] subscribeNext:^(id tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                callback(status);
            }else {
                [[Toast shareToast]makeText:message aDuration:1];

            }

            [SVProgressHUD dismiss];

        }
    } error:^(NSError *error) {
        [[Toast shareToast]makeText:@"网络不好，上传超时，请删除大照片重试" aDuration:1];
        [SVProgressHUD dismiss];
        callback(nil);
    }];



}


/**
 *  上传头像
 *
 *  @param driverid 用户ID
 *  @param avatar   头像图片
 *  @param callback 回调信息
 */

- (void)submitUserAvatarwithId:(int)driverid withAvatar:(UIImage *)avatar callback:(void(^)(NSString *st))callback {
    NSMutableDictionary *params= [NSMutableDictionary dictionary];

    NSString *stId  = [NSString stringWithFormat:@"%i",driverid];
    //[params setValue:[NSString stringWithFormat:@"%@",stId] forKey:@"userId"];


    [self.dicRequest setObject:params forKey:@"params"];

    [self.dicHead setValue:@"uploadAvatar" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];

    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    [[self POST:CHILEDURL Param:@{@"data":st} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {


        if (avatar) {

            NSString *fileName = [NSString stringWithFormat:@"%@avatarImage",stId];
            NSData *data =[fileName dataUsingEncoding:NSUTF8StringEncoding];
            NSString *filejpgName = [NSString stringWithFormat:@"%@.jpg",[data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]];

            
            UIGraphicsBeginImageContext(CGSizeMake(300.0, avatar.size.height * 300.0 / avatar.size.width));
            [avatar drawInRect:CGRectMake(0, 0,300.0, avatar.size.height * 300.0/avatar.size.width)];
            UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [formData appendPartWithFileData:UIImageJPEGRepresentation(scaledImage,.5f)
                                        name:@"avatarImage"
                                    fileName:filejpgName
                                    mimeType:@"image/jpg"];
        }
    }] subscribeNext:^(id tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {

            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            NSDictionary *result = response[@"result"];
            
            if ([status isEqualToString:@"10000"]) {

                NSString *stInfo = result[@"data"];
                NSDictionary *dicDate= [self dictionaryWithJsonString:stInfo];
                NSString *url = dicDate[@"imagePath"];

                callback(url);
            }else {
                [[Toast shareToast]makeText:message aDuration:1];

            }

            [SVProgressHUD dismiss];

        }
    } error:^(NSError *error) {
        [[Toast shareToast]makeText:@"网络不好，上传超时，请删除大照片重试" aDuration:1];
        [SVProgressHUD dismiss];
        callback(nil);
    }];
    
    
}
-(void)getUserOrderList:(UserInfoModel *)info callback:(void(^)(NSDictionary * orderDic))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"countOrderGroupByStatus" forKey:@"method"];
    [self.dicHead setValue:@"capacity" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSString * version = @"0.0.0.2";
    [self.dicHead setValue:version forKey:@"version"];
    
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSDictionary *result = response[@"result"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {
                
                NSString *stInfo = result[@"data"];
                NSDictionary *dicDate= [self dictionaryWithJsonString:stInfo];
                callback(dicDate);
                
                
            }else{
                
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}


/**
 *  提交意见
 *
 *  @param idea  意见
 *  @param phone 电话
 */

- (void)submitIdeaWithIdeaText:(NSString *)idea WithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback {



    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    [params setValue:idea forKey:@"advice"];
    [params setValue:phone forKey:@"phone"];
    if (USER_INFO) {

        UserInfoModel *us = USER_INFO;
        [params setValue:us.userName forKey:@"userName"];

    }else {

        [params setValue:@"匿名用户" forKey:@"userName"];
    }

    [self.dicHead setValue:@"feedback" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };

    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];

    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:REQUESTSUCCESS]) {

                callback(status);

            }else{

                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];

    }error:^(NSError *error) {

        callback(nil);
        //[[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];

}


- (void)forgetPWDWithOldPWD:(NSString *)pwd Tel:(NSString *)tel name:(NSString *)name WithCode:(NSString *)code callback:(void(^)(NSString *st))callback
{
    [SVProgressHUD showWithStatus:LOADING];
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    
    NSString *stMd5 = [self stringWithMd5:pwd];
    [params setValue:[self stringWithMd5:stMd5] forKey:@"password"];
    [params setValue:tel forKey:@"phone"];
    [params setValue:name forKey:@"loginName"];
    [params setValue:code forKey:@"phoneCode"];
    
    
    [self.dicRequest setObject:params forKey:@"params"];
    
    [self.dicHead setValue:@"resetPasswords" forKey:@"method"];
    [self.dicHead setValue:@"user" forKey:@"action"];
    [self.dicHead setValue:@"0" forKey:@"zip"];
    [self.dicHead setValue:@"0" forKey:@"encrpy"];
    
    NSDictionary *request = @{@"params":[self stringZipWithDic:params withZip:NO withisEncrypt:NO] };
    
    NSDictionary *dic=  @{@"header":self.dicHead,@"request":request};
    NSString *st = [self dictionaryToJson:dic];
    
    [[self POST:CHILEDURL Param:@{@"data":st}]subscribeNext:^(RACTuple *tuple) {
        id responseData = [self getResponseData:tuple];
        if (responseData) {
            NSDictionary *response = responseData[@"response"];
            NSString *status = response[@"status"];
            NSString *message = response[@"message"];
            if ([status isEqualToString:@"10000"]) {
                callback(status);

            }else{
                [[Toast shareToast]makeText:message aDuration:1];
            }
        }
        [SVProgressHUD dismiss];
        
    }error:^(NSError *error) {
        
        callback(nil);
        [[Toast shareToast]makeText:BUSY aDuration:1];
        [SVProgressHUD dismiss];
    }];
}

@end
