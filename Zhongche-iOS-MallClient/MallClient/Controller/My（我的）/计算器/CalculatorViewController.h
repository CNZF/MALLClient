//
//  CalculatorViewController.h
//  MallClient
//
//  Created by lxy on 2018/6/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "CapacityEntryModel.h"

 typedef void(^BoxNumBlock)(NSInteger boxNum);

@interface CalculatorViewController : BaseViewController

@property (nonatomic, strong)CapacityEntryModel * entryModel;
@property (nonatomic, copy)BoxNumBlock Block;

@end
