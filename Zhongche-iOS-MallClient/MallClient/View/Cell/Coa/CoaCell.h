//
//  CoaCell.h
//  MallClient
//
//  Created by lxy on 2017/10/12.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface CoaCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbPrice;
@property (weak, nonatomic) IBOutlet UILabel *leDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbPriceDesc;

@end
