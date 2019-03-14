//
//  EmptyContainerAddressVC.h
//  MallClient
//
//  Created by lxy on 2017/1/3.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyContainerViewModel.h"
#import "ContainerOrderInfo.h"


typedef void (^ReturnInfoBlock)(NSString *name,NSString *phone,StationModel *startStation,StationModel *endStation,NSString *startFullName,NSString *endFullName,CityModel *endCity);

@interface EmptyContainerAddressVC : BaseViewController

@property (nonatomic, copy  ) ReturnInfoBlock    returnInfoBlock;
@property (nonatomic, strong) ContainerOrderInfo *containerOrderInfo;
@property (nonatomic, strong) CityModel *endCity;


- (void)returnInfo:(ReturnInfoBlock)block;

@end
