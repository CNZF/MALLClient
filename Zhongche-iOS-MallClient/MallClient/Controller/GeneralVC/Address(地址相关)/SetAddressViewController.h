//
//  SetAddressViewController.h
//  MallClient
//
//  Created by lxy on 2016/11/25.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressInfo.h"

@interface SetAddressViewController : BaseViewController

@property (nonatomic, strong) NSString *type; //1、起运地  2、抵运地
@property (nonatomic, strong) AddressInfo *info;

@property (nonatomic, strong) NSString *stCity;
@property (nonatomic, strong) NSString *cityCode;

@end
