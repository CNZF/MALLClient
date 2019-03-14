//
//  GoodsDetailVC.h
//  MallClient
//
//  Created by lxy on 2017/1/6.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsDetailVC : BaseViewController

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, assign) int style;      //0租用     //1购买

@end
