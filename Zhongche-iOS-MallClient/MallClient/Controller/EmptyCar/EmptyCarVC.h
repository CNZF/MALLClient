//
//  EmptyCarVC.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/28.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyCarViewModel.h"


@interface EmptyCarVC : BaseViewController

@property (nonatomic, assign)BOOL isRecommendedVC;//是否为推荐页面
@property (nonatomic, strong)EmptyCarFilterModel * filterModel;

@end
