//
//  KNResultListTopViewSubCell.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNResultListTopViewSubCell : UICollectionViewCell

// 日期
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
// 星期
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLineLabel;

@property (nonatomic, assign) BOOL cellSelected;

@end
