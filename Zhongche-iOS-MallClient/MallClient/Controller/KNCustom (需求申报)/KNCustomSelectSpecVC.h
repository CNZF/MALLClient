//
//  KNCustomSelectSpecVC.h
//  MallClient
//
//  Created by 沙漠 on 2018/5/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseViewController.h"
@class ContainerTypeModel;

typedef void (^KNCustomSelectSpecBlock)(ContainerTypeModel *model);

@interface KNCustomSelectSpecVC : BaseViewController

@property (nonatomic, copy) KNCustomSelectSpecBlock completeBlock;

@end
