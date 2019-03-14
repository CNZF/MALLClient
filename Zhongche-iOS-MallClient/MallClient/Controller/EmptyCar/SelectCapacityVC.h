//
//  SelectCapacityVC.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "EmptyCarFilterModel.h"

@protocol  SelectCapacityVCDelegate <NSObject>
-(void)chooseCompleteNeedLoadingData;
@end
@interface SelectCapacityVC : BaseViewController

@property (nonatomic, strong)EmptyCarFilterModel * model;

@property (nonatomic, weak)id<SelectCapacityVCDelegate> vcDelegate;
@end
