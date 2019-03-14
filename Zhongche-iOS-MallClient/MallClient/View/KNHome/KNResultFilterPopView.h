//
//  KNResultFilterPopView.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"
@class ContainerTypeModel;

typedef void (^KNResultFilterPopViewSelectBlock)(ContainerTypeModel *model);

@interface KNResultFilterPopView : BaseView

@property (nonatomic, copy) KNResultFilterPopViewSelectBlock selectBlock;

- (void)show;

@end
