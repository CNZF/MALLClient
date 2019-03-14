//
//  UserInfoModel.m
//  Zhongche
//
//  Created by lxy on 16/7/13.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

-(void)setSex:(NSString *)sex {
    if ([sex intValue] == 1) {
        _sex = @"男";
    }
    else
    {
        _sex = @"女";
    }
}

+ (NSDictionary *)modelCustomPropertyMapper {

    return @{@"iden":@"userId",
             @"organization_id":@"companyId",
             @"email":@[@"companyEmail"],
             @"phone":@[@"companyPhone"],
             @"userName":@[@"contacts"],
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //调用NSCoder的方法归档该对象的每一个属性
    [aCoder encodeObject:_token forKey:@"token"];
    [aCoder encodeObject:_first_login forKey:@"first_login"];
    [aCoder encodeObject:_iden forKey:@"iden"];
    [aCoder encodeObject:_id_card_back_url forKey:@"id_card_back_url"];
    [aCoder encodeObject:_id_card_code forKey:@"id_card_code"];
    [aCoder encodeObject:_id_card_front_url forKey:@"id_card_front_url"];
    [aCoder encodeObject:_login_name forKey:@"login_name"];
    [aCoder encodeObject:_organization_name forKey:@"organization_name"];
    [aCoder encodeObject:_companyId forKey:@"companyId"];
    [aCoder encodeObject:_phone forKey:@"phone"];
    [aCoder encodeObject:_real_name forKey:@"real_name"];
    [aCoder encodeObject:_sex forKey:@"sex"];
    [aCoder encodeObject:_userStatus forKey:@"userStatus"];
    [aCoder encodeObject:_user_code forKey:@"user_code"];
    [aCoder encodeObject:_organization_id forKey:@"organization_id"];
    [aCoder encodeObject:_userName forKey:@"userName"];
    [aCoder encodeObject:_icon forKey:@"icon"];
    [aCoder encodeObject:_authStatus forKey:@"authStatus"];
    [aCoder encodeObject:_loginName forKey:@"loginName"];
    //authStatus

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        //使用NSCoder的方法从归档中依次恢复该对象的每一个属性
        _token=[[aDecoder decodeObjectForKey:@"token"] copy];
        _first_login=[[aDecoder decodeObjectForKey:@"first_login"] copy];
        _iden=[[aDecoder decodeObjectForKey:@"iden"] copy];
        _id_card_back_url=[[aDecoder decodeObjectForKey:@"id_card_back_url"] copy];
        _id_card_code=[[aDecoder decodeObjectForKey:@"id_card_code"] copy];
        _id_card_front_url=[[aDecoder decodeObjectForKey:@"id_card_front_url"] copy];
        _login_name=[[aDecoder decodeObjectForKey:@"login_name"] copy];
        _organization_name=[[aDecoder decodeObjectForKey:@"organization_name"] copy];
        _password = [[aDecoder decodeObjectForKey:@"password"] copy];
        _phone = [[aDecoder decodeObjectForKey:@"phone"] copy];
        _real_name = [[aDecoder decodeObjectForKey:@"real_name"] copy];
        _sex = [[aDecoder decodeObjectForKey:@"sex"] copy];
        _userStatus = [[aDecoder decodeObjectForKey:@"userStatus"] copy];
        _user_code = [[aDecoder decodeObjectForKey:@"user_code"] copy];
        _organization_id = [[aDecoder decodeObjectForKey:@"organization_id"] copy];
        _userName = [[aDecoder decodeObjectForKey:@"userName"] copy];
        _icon = [[aDecoder decodeObjectForKey:@"icon"] copy];
        _companyId = [[aDecoder decodeObjectForKey:@"companyId"] copy];
        _authStatus = [[aDecoder decodeObjectForKey:@"authStatus"] copy];
        _loginName = [[aDecoder decodeObjectForKey:@"loginName"] copy];

    }
    return self;
}

@end
