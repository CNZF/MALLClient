//
//  UserViewModel.h
//  MallClient
//
//  Created by lxy on 2016/12/8.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewModel.h"
#import "PhotoInfo.h"

@interface UserViewModel : BaseViewModel

/**
 *  登录
 *
 *  @param telephoneNumber 手机号
 *  @param passWord        密码
 *  @param callback        token
 */
-(void)loginWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord state:(int)state callback:(void(^)(UserInfoModel *userInfo))callback tokenback:(void(^)(BOOL ret))tokenback;

/**
 *  登录
 *
 *  @param token 手机号
 *  @param callback        用户对象
 */
-(void)loginWithToken:(NSString *)token callback:(void(^)(UserInfoModel *userInfo))callback;

/**
 *  获取验证码
 */

- (void)getRCodeWithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback;


/**
 *  注册
 *
 *  @param telephoneNumber 用户手机号
 *  @param passWord        密码
 *  @param verifycode      验证码
 *  @param username        用户名
 *  @param callback        抛出
 */
-(void)registerWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithUserName:(NSString *)username callback:(void(^)(UserInfoModel *userInfo))callback;
/**
 *  个人注册
 *
 *  @param telephoneNumber 用户手机号
 *  @param passWord        密码
 *  @param verifycode      验证码
 *  @param username        用户名
 *  @param callback        抛出
 */
-(void)PersonRegisterWithPhone:(NSString *)telephoneNumber WithPassWord:(NSString *)passWord WithVerifycode:(NSString *)verifycode WithUserName:(NSString *)username callback:(void(^)(UserInfoModel *userInfo))callback;


/**
 *  获取用户信息
 */

-(void)getUserInfoWithUserId:(void(^)(UserInfoModel *userInfo))callback;


/**
 *  更改密码
 *
 *  @param OldPWD   老密码
 *  @param NewPWD   新密码
 *  @param callback 更改状态
 */

- (void)changePWDWithOldPWD:(NSString *)OldPWD WithNewPWD:(NSString *)NewPWD callback:(void(^)(NSString *st))callback;

/**
 *  忘记密码
 *
 *  @param pwd   密码
 *  @param code  验证码
 *  @param callback 更改状态
 */
- (void)forgetPWDWithOldPWD:(NSString *)pwd Tel:(NSString *)tel name:(NSString *)name WithCode:(NSString *)code callback:(void(^)(NSString *st))callback;

/**
 *  上传企业实名认证图片
 *
 *  @param info     图片对象
 *  @param callback 状态
 */

- (void)submitPhotoForEnterpriseNameAuthenticationWithPhoto:(PhotoInfo *)info callback:(void(^)(NSString *st))callback;

/**
 *  上传企业资质认证图片
 *
 *  @param img     图片对象
 *  @param callback 状态
 */

- (void)submitPhotoForEnterpriseValueAuthenticationWithPhoto:(UIImage *)img callback:(void(^)(NSString *st))callback;


/**
 *  上传头像
 *
 *  @param driverid 用户ID
 *  @param avatar   头像图片
 *  @param callback 回调信息
 */

- (void)submitUserAvatarwithId:(int)driverid withAvatar:(UIImage *)avatar callback:(void(^)(NSString *st))callback;


/**
 *  提交个人信息
 *
 *  @param name     名字
 *  @param phone    手机号
 *  @param email    邮箱
 *  @param code     验证码
 *  @param callback 返回状态
 */
- (void)submitUserMessageWithName:(NSString *)name WithPhone:(NSString *)phone WithEmail:(NSString *)email WithCode:(NSString *)code callback:(void(^)(NSString *st))callback;


/**
 *  获取用户账单
 */

-(void)getUserAccountListcallback:(void(^)(NSArray *arr))callback;

/**
 *  获取用户订单数量
 */

-(void)getUserOrderList:(UserInfoModel *)info callback:(void(^)(NSDictionary * orderDic))callback;


/**
 *  提交意见
 *
 *  @param idea  意见
 *  @param phone 电话
 */

- (void)submitIdeaWithIdeaText:(NSString *)idea WithPhone:(NSString *)phone callback:(void(^)(NSString *st))callback;

@end
