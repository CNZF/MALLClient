//
//  UserHeadView.h
//  MallClient
//
//  Created by lxy on 2018/6/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AUTH_CARRIER_DRIVER, //(1,"认证承运商司机")
    CONTRACT_CARRIER_DRIVER,// (2,"签约承运商司机")
    REGISTER_USER,// (3,"注册用户")
    REAL_NAME_USER,// (4,"实名用户")
    AUTH_USER,// (5,"认证用户")
    COMPANY_USER,// (6,"企业账户")
    COMPANY_SUB_USER,// (7,"企业子账户"),
    BOSS,// (8, "boss平台用户")
    REGISTER_COMPANY_CARRIER,// (9,"注册企业用户司机")
    REAL_NAME_COMPANY_CARRIER,// (10,"实名企业用户司机")
    PersonDriVer,// (11,"个人用户")
} AUTH_UserStatusType;

@interface UserHeadView : UIView

@property (nonatomic, strong)id target;
@property (nonatomic, assign) AUTH_UserStatusType AUTHUserType;
@end
