//
//  ZSSearchViewController.h
//  LogisticsAssistant
//
//  Created by 中车_LL_iMac on 16/8/28.
//  Copyright © 2016年 com.chongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "ContainerViewModel.h"
@protocol ZSSearchViewControllerDelegate <NSObject>

-(void)getGood:(GoodsInfo *)goods;

@end

@interface ZSSearchViewController : BaseViewController

@property (nonatomic, weak)id<ZSSearchViewControllerDelegate>vcDelegate;
@end
