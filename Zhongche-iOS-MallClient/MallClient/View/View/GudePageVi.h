//
//  GudePageVi.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/2/21.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

 typedef void(^GuideRemoveBlock)();

@interface GudePageVi : BaseView

@property (nonatomic, copy) GuideRemoveBlock guideBlock;

@end
