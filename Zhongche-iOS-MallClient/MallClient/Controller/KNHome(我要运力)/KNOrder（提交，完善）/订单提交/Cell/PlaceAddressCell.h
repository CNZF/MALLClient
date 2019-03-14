//
//  PlaceAddressCell.h
//  MallClient
//
//  Created by lxy on 2018/8/3.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *stateAddress;
@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UIButton *descSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
