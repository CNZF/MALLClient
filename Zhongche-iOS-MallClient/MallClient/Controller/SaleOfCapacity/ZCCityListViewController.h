//
//  ZCCityListViewController.h
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "BaseViewController.h"
#import "CityModel.h"


@protocol ZCCityListViewControllerDelagate<NSObject>

- (void)getCityModel:(CityModel *)cityModel;

@end

@interface ZCCityListViewController : BaseViewController
@property (nonatomic, copy) NSString * type;
@property (nonatomic, assign) int cityType;
@property (nonatomic,weak)id<ZCCityListViewControllerDelagate>getCityDelagate;

@property (nonatomic, assign)BOOL fromNaviC;//是否跳转自 NavigationController , default YES
@end
