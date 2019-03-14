//
//  UserInfoModel.h
//  Zhongche
//
//  Created by lxy on 16/7/13.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel<NSCoding>

@property (nonatomic, copy) NSString * token;
@property (nonatomic, copy) NSString * first_login;
@property (nonatomic, copy) NSString * iden;
@property (nonatomic, copy) NSString * id_card_back_url;
@property (nonatomic, copy) NSString * id_card_code;
@property (nonatomic, copy) NSString * id_card_front_url;
@property (nonatomic, copy) NSString * login_name;//登录账号
@property (nonatomic, copy) NSString * organization_name;//部门
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * phone;//手机
@property (nonatomic, copy) NSString * real_name;
@property (nonatomic, copy) NSString * sex;//性别
@property (nonatomic, copy) NSString * userStatus;// 用户状态
@property (nonatomic, copy) NSString * user_code;
@property (nonatomic, copy) NSString * organization_id;//拉取网点列表使用
@property (nonatomic, copy) NSString * userName;//用户名
@property (nonatomic, copy) NSString * icon;//用户头像
@property (nonatomic, copy) NSString *accountAmount;
@property (nonatomic, copy) NSString *creditLimit;
@property (nonatomic, copy) NSString *usedCredit;
@property (nonatomic, copy) NSString *loginName;//登陆名
@property (nonatomic, copy) NSString *email;//邮箱
@property (nonatomic, copy) NSString *companyName;//公司全名
@property (nonatomic, copy) NSString *companyId;//公司id
@property (nonatomic, copy) NSString *userFreeze;// 用户冻结状态
@property (nonatomic, copy) NSString *userType;// 用户类型
@property (nonatomic, copy) NSString *authType;// 认证类型
@property (nonatomic, copy) NSString *registerOrigin;// 用户来源
@property (nonatomic, copy) NSString *companyShortName;// 公司简称
@property (nonatomic, copy) NSString *companyStatus;// 公司状态 
@property (nonatomic, copy) NSString *companyFreeze;// 公司冻结
@property (nonatomic, copy) NSString *companyType;//判断认证状态
@property (nonatomic, copy) NSString *propertyType;// 公司类型
@property (nonatomic, copy) NSString *isSign;// 是否签约
@property (nonatomic, copy) NSString *companyEmail;// 公司email
@property (nonatomic, copy) NSString *businessLicenseCode;//企业营业执照号
@property (nonatomic, copy) NSString *organizationCodeCode;//组织机构代码证号
@property (nonatomic, copy) NSString *taxCertificateCode;//税务登记证号
@property (nonatomic, copy) NSString *certificateCode;//货运从业资格证号
@property (nonatomic, copy) NSString *authStatus;//企业实名认证状态
@property (nonatomic, copy) NSString *quaAuthStatus;//企业资格认状态
@property (nonatomic, copy) NSString *authStatusDesc;//企业实名认证状态
@property (nonatomic, copy) NSString *quaAuthStatusDesc;//企业资格认状态
@property (nonatomic, copy) NSString *accountBaseStatusDesc;//管理者基本资料
@property (nonatomic, copy) NSString *firstLogin;
@property (nonatomic, copy) NSString *notReadMessageCount;//未读消息数
@property (nonatomic, copy) NSString * companyPhone;//公司电话
//0:未提交、1:待审核、2:审核通过、3:审核不通过


@end
