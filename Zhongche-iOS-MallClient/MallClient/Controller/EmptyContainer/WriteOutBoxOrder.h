//
//  WriteOutBoxOrder.h
//  MallClient
//
//  Created by lxy on 2017/3/21.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
#import "ContainerOrderInfo.h"

@interface WriteOutBoxOrder : BaseViewController

@property (nonatomic, strong) ContainerOrderInfo *containerOrderInfo;

@property (nonatomic, assign) int style;      //0租用     //1购买

@property (nonatomic, strong) UIImageView        *ivBoxGoods;//箱子图片

@end
