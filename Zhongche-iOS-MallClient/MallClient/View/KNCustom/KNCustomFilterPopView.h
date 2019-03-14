//
//  KNCustomFilterPopView.h
//  MallClient
//
//  Created by dushenke on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

typedef void (^KNCustomFilterPopViewSelectBlock)(NSDictionary *dict,kKNCustomFilterType filterType);


@interface KNCustomFilterPopView : BaseView

@property (nonatomic, copy) KNCustomFilterPopViewSelectBlock selectBlock;

- (void)show;

@end
