//
//  KNOrderSubmitHeaderView.h
//  MallClient
//
//  Created by 沙漠 on 2018/5/3.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface KNOrderSubmitHeaderView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *arriveButton;
//镇距离
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//街道距离
@property (weak, nonatomic) IBOutlet UILabel *descSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;

@property (weak, nonatomic) IBOutlet UILabel *endAddress;

@end

