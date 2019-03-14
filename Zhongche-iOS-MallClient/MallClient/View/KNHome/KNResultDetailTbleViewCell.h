//
//  KNResultDetailTbleViewCell.h
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void (^KNResultDetailTbleViewCellOrderActionBlock)(void);

@interface KNResultDetailTbleViewCell : BaseTableViewCell

// 预定
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@property (nonatomic, copy) KNResultDetailTbleViewCellOrderActionBlock actionBlock;

@end
