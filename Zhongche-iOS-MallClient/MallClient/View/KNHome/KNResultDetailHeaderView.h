//
//  KNResultDetailHeaderView.h
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface KNResultDetailHeaderView : BaseView

@property (weak, nonatomic) IBOutlet UIView *dateBGView;
// 几日达
@property (weak, nonatomic) IBOutlet UILabel *dayNumLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

// 距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
