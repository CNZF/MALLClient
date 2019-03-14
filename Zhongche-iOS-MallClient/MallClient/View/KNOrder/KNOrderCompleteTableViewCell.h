//
//  KNOrderCompleteTableViewCell.h
//  MallClient
//
//  Created by 沙漠 on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNOrderCompleteTableViewCell : UITableViewCell

//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//箭头
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
