//
//  KNResultListTableViewCell.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNResultListTableViewCell.h"
#import "TransportationModel.h"

@interface KNResultListTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *dateBGView;
// 几日
@property (weak, nonatomic) IBOutlet UILabel *dayNumLabel;
// 时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
// 价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation KNResultListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dateBGView.layer.borderWidth = 0.5;
    self.dateBGView.layer.cornerRadius = 2.0;
    self.dateBGView.layer.masksToBounds = YES;
    self.dateBGView.layer.borderColor = APP_COLOR_GRAY_CAPACITY_LINE.CGColor;
}

- (void)setCellModel:(TransportationModel *)cellModel{
    _cellModel = cellModel;
    NSInteger days = [cellModel.expectTime intValue]/1440;
    
    if (days % 1 > 0 || days == 0) {
        days  = days/1+1;
    }
    self.dayNumLabel.text = [NSString stringWithFormat:@"%li",days];
    NSString *str = [NSString stringWithFormat:@"￥%.2f",cellModel.oneTicketTotal];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSUInteger loc = str.length;
    [AttributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:11.0]
                          range:NSMakeRange(loc - 2, 2)];
    self.priceLabel.attributedText = AttributedStr;
    
//    long long time = [cellModel.departureTime longLongValue] + [cellModel.expectTime longLongValue]*60*1000+24*60*60*1000;
    long long time = [cellModel.departureTime longLongValue] + [cellModel.expectTime longLongValue]*60*1000;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[self stDateToString:[NSString stringWithFormat:@"%lli",time]]];
}

- (NSString *)stDateToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    return [outputFormatter stringFromDate:date];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
