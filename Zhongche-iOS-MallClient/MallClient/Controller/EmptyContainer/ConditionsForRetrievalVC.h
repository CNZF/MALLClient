//
//  ConditionsForRetrievalVC.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/19.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "FilterModel.h"

@protocol  ConditionsForRetrievalVCDelegate <NSObject>
-(void)chooseCompleteNeedLoadingData;
@end
@interface ConditionsForRetrievalVC : BaseViewController

@property (nonatomic, strong)FilterModel * filterModel;

@property (nonatomic, weak)id<ConditionsForRetrievalVCDelegate> conditionsForRetrievalVCDelegate;
@end


@interface ConditionsForRetrievalVC_Rent : ConditionsForRetrievalVC

@end


@interface ConditionsForRetrievalVC_Buy : ConditionsForRetrievalVC

@end
