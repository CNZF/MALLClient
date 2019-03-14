//
//  KNOrderCompleteMenuPopView.h
//  MallClient
//
//  Created by 沙漠 on 2018/5/3.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

typedef void (^KNOrderCompleteMenuPopViewSelectBlock)(NSString *title);

@interface KNOrderCompleteMenuPopView : BaseView

@property (nonatomic, copy) KNOrderCompleteMenuPopViewSelectBlock selectBlock;

- (instancetype)initWithFrame:(CGRect)frame Array:(NSArray *)array;

- (void)show;

@end
