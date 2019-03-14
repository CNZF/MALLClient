//
//  SubGoodsInfomationCell.m
//  MallClient
//
//  Created by lxy on 2018/8/3.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "SubGoodsInfomationCell.h"

@implementation SubGoodsInfomationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSString *)dateTransformToTimeString:(NSDate *)date
{
    //    NSDate *currentDate = [NSDate date];//获得当前时间为UTC时间 2014-07-16 07:54:36 UTC  (UTC时间比标准时间差8小时)
    //转为字符串
    NSDateFormatter*df = [[NSDateFormatter alloc]init];//实例化时间格式类
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//格式化
    [df setDateFormat:@"yyyy-MM-dd"];//格式化
    //2014-07-16 07:54:36(NSString类)
    NSString *timeString = [df stringFromDate:date];
    return timeString;
}
- (void)setModel:(CapacityEntryModel *)model requeseModel:(TransportationModel *)requeseModel
{
    self.goodName.text = model.goodsInfo.name == nil?@"无":model.goodsInfo.name;
    if (model.noGoodsName.length>0) {
        self.writeGoodName.text = model.noGoodsName;
    }else{
        self.writeGoodName.text = @"无";
    }
    self.box.text = model.box.name;
    self.boxnum.text = [NSString stringWithFormat:@"%@个",model.boxNum];
    self.getTime.text = [NSString stringWithFormat:@"%@",model.carryGoodsTime];
    self.songTime.text = model.stStartTime;
//    [NSString stringWithFormat:@"%@",[self dateTransformToTimeString:model.startDate]];
    NSInteger days = [requeseModel.expectTime intValue]/1440;
    NSTimeInterval time = [model.shipmentsTime timeIntervalSince1970];
    
    NSTimeInterval allTime = time + days*24*3600;
    NSDate *dd = [NSDate dateWithTimeIntervalSince1970:allTime];
    self.arriveTime.text = [NSString stringWithFormat:@"%@",[self dateTransformToTimeString:dd]];
    if (model.remark ==nil || [model.remark isEqualToString:@""]) {
        self.remark.text = @"无";
    }else{
        self.remark.text  = model.remark;
    }
}

@end
