//
//  AddressManagerViewController.h
//  MallClient
//
//  Created by lxy on 2016/12/9.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "AddressInfo.h"

typedef void (^ReturnInfoBlock)(AddressInfo *info);
@interface AddressManagerViewController : BaseViewController
@property (nonatomic, strong) NSString *type; //1、起运地  2、抵运地
@property (nonatomic, strong) NSString *stCity;
@property (nonatomic, strong) AddressInfo         *currentInfo;
@property (nonatomic, strong) NSString *cityCode;

@property (nonatomic, assign) BOOL isSelect;//进入页面是否可点击

@property (nonatomic, assign)BOOL isGoBack;

@property (nonatomic, copy) ReturnInfoBlock returnInfoBlock;

- (void)returnInfo:(ReturnInfoBlock)block;

@end
