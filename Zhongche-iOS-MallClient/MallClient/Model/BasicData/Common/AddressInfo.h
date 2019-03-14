//
//  AddressInfo.h
//  MallClient
//
//  Created by lxy on 2016/12/8.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface AddressInfo : BaseModel

/**
 address = "\U6c38\U5916\U5927\U8857\U8f66\U7ad9\U8def12\U53f7";
 companyId = 780;
 contacts = "\U8d75\U5e55\U6657";
 contactsTel = "139-8745-8658";
 id = 314;
 isDefault = 0;
 lat = "39.864881";
 lng = "116.379092";
 regionCode = 110100;
 type = 1;
 */
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *companyId;
@property (nonatomic, strong) NSString *contacts;
@property (nonatomic, strong) NSString *contactsPhone;
@property (nonatomic, strong) NSString *contactsTel;
@property (nonatomic, strong) NSString *isDefault;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lng;
@property (nonatomic, strong) NSString *contacts_Phone;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString * regionCode;
@property (nonatomic, assign) BOOL isSelect;

@end
