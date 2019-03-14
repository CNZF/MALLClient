//
//  KNOrderCompleteHeaderSubView.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface KNOrderCompleteHeaderSubView : BaseView
//图片
@property (weak, nonatomic) IBOutlet UIImageView *orderIcon;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//镇距离
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//街道距离
@property (weak, nonatomic) IBOutlet UILabel *descSubLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//几日达
@property (weak, nonatomic) IBOutlet UIButton *dayButton;

@end
