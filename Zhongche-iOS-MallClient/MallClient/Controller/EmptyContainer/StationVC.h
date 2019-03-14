//
//  StationVC.h
//  MallClient
//
//  Created by lxy on 2017/3/23.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyContainerViewModel.h"


@protocol ZCStationListViewControllerDelagate<NSObject>

- (void)getStationModel:(StationModel *)stationModel;

@end

@interface StationVC : BaseViewController

@property (nonatomic, strong) NSString *code;

@property (nonatomic,weak)id<ZCStationListViewControllerDelagate>stationDelegate;

@end
