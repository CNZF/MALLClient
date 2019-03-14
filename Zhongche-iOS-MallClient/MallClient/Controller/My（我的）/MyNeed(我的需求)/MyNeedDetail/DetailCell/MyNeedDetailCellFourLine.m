//
//  MyNeedDetailCellFourLine.m
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyNeedDetailCellFourLine.h"

@implementation MyNeedDetailCellFourLine

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
    if (index == 0) {
        self.titleLabel1.text = @"申报时间";
        self.titleLabel2.text = @"业务类型";
        self.titleLabel3.text = @"需求单号";
        self.titleLabel4.text = @"处理状态";
        self.detialLabel1.text = [NSString TimeGetDateHHmmDD:model.create_time];
        self.detailLabel2.text = model.business_type_name;
        self.detailLabel3.text = model.code;
        self.detailLabel4.text = model.statusName;
    }else{
        self.titleLabel1.text = @"发货人";
        self.titleLabel2.text = @"发货人电话";
        self.titleLabel3.text = @"收货人";
        self.titleLabel4.text = @"收货人电话";
        self.detialLabel1.text = model.start_contacts;
        self.detailLabel2.text = model.start_phone;
        self.detailLabel3.text = model.end_contacts;
        self.detailLabel4.text = model.end_phone;
        self.detailLabel4.textColor = [HelperUtil colorWithHexString:@"333333"];
    }
}
@end
