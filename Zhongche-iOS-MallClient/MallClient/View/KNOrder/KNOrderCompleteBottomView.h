//
//  KNOrderCompleteBottomView.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface KNOrderCompleteBottomView : BaseView
//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//明细按钮
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
//提交订单
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
//明细图片
@property (weak, nonatomic) IBOutlet UIButton *arrowIcon;

//价格文字
@property (nonatomic, copy) NSString *price;

@end
