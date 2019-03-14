//
//  MyNeedDetailCellThreeLine.m
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyNeedDetailCellThreeLine.h"

@implementation MyNeedDetailCellThreeLine

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setModel:(MyNeedModel*)model index:(NSInteger)index;
{
    if (index == 1) {
        self.titleLabel1.text = @"起运地";
        self.titleLabel2.text = @"抵运地";
        self.titleLabel3.text = @"发货时间";
        self.detailLabel1.text = model.start_region_name;
        self.detailLabel2.text = model.end_region_name;
        self.detailLabel3.text = [NSString TimeGetDate:model.estimate_departure_time];
      
    }else{
        self.titleLabel1.text = @"托运人";
        self.titleLabel2.text = @"联系人";
        self.titleLabel3.text = @"联系电话";
        self.detailLabel1.text = model.create_user_name;
        self.detailLabel2.text = model.contacts;
        self.detailLabel3.text = model.contacts_phone;
     
    }
}
@end
