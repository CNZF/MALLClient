//
//  ContactInfo.h
//  MallClient
//
//  Created by lxy on 2016/12/20.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface ContactInfo : BaseModel

@property (nonatomic, strong) NSString *startAddress;
@property (nonatomic, strong) NSString *startContacts;
@property (nonatomic, strong) NSString *startContactsPhone;
@property (nonatomic, strong) NSString *startID;


@property (nonatomic, strong) NSString *endAddress;
@property (nonatomic, strong) NSString *endContacts;
@property (nonatomic, strong) NSString *endContactsPhone;
@property (nonatomic, strong) NSString *endID;


@end
