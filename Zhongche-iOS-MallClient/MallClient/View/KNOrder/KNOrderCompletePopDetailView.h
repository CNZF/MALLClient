//
//  KNOrderCompletePopDetailView.h
//  MallClient
//
//  Created by dushenke on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

 typedef void(^CloseBlock)(void);

@interface KNOrderCompletePopDetailView : BaseView


// 价格数组
@property (nonatomic, strong) NSArray *priceArray;
// 用箱数量
@property (nonatomic, copy) NSString *boxNum;

@property (nonatomic, copy) CloseBlock closeBlock;

- (void)show;

- (void)close;

@end


