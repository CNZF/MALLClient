//
//  MyNeedDetailCell.h
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyNeedModel.h"
@interface MyNeedDetailCellTwoLine : UITableViewCell

- (void) setModel:(MyNeedModel*)model index:(NSInteger)index;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel1;
@property (weak, nonatomic) IBOutlet UILabel *detialLabel2;

@end
