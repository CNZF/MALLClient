//
//  ZCBranchesListViewController.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/5/26.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CityModel.h"


@protocol ZCBranchesListViewControllerDelagate<NSObject>

- (void)getBranchesModel:(CityModel *)cityModel;

@end
@interface ZCBranchesListViewController : BaseViewController

@property (nonatomic, weak)id<ZCBranchesListViewControllerDelagate>getCityDelagate;

@property (nonatomic, assign) int type; //0、一带一路  1、快速

@end
