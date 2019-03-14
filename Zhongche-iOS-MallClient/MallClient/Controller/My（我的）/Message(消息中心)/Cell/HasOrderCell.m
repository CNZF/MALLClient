//
//  HasOrderCell.m
//  MallClient
//
//  Created by lxy on 2018/6/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "HasOrderCell.h"
#import "NSString+Money.h"

@interface HasOrderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *chooseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageLeftConer;

@end

@implementation HasOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsEdite:(BOOL)isEdite
{
    _isEdite = isEdite;
}

//MESSAGE_AUTH,黄色、、MESSAGE_ORDER， MESSAGE_PAY，MESSAGE_DELIVER  蓝色。。MESSAGE_REGIST_SUCESSED，MESSAGE_PASSWORD_RESET，MESSAGE_PERMISSION_RESET，MESSAGE_TRANSPORT_REQUIREMENT
- (void)setModel:(MessageModel *)model
{
    //多选行为
    if (self.isEdite) {
        self.chooseImageView.hidden = NO;
        self.headImageLeftConer.constant = 30.0f;
        
    }else{
        self.chooseImageView.hidden = YES;
        self.headImageLeftConer.constant = 15.0f;
    }
    if (model.isSelect) {
        self.chooseImageView.image = [UIImage imageNamed:@"Group 32"];
    }else{
        self.chooseImageView.image = [UIImage imageNamed:@"Oval 2"];
    }

    //数据
    if ([model.message_categroy_code  isEqualToString: @"MESSAGE_AUTH"]) {
        self.headImageView.image = [UIImage imageNamed:@"Group 30"];
    }
    if ([model.message_categroy_code isEqualToString: @"MESSAGE_ORDER"]  || [model.message_categroy_code isEqualToString: @"MESSAGE_PAY"]  || [model.message_categroy_code isEqualToString: @"MESSAGE_DELIVER"] || [model.message_categroy_code isEqualToString: @"MESSAGE_TRANSPORT_REQUIREMENT"]) {
        self.headImageView.image = [UIImage imageNamed:@"Group 27"];
    }
    if ([model.message_categroy_code isEqualToString: @"MESSAGE_REGIST_SUCESSED"] || [model.message_categroy_code isEqualToString: @"MESSAGE_PASSWORD_RESET"] || [model.message_categroy_code isEqualToString: @"MESSAGE_PERMISSION_RESET"]  ) {
        self.headImageView.image = [UIImage imageNamed:@"Group 29"];
    }
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.body;
    NSString * nowDate = [self getNowDate];
    NSString * fwDate = [self TimeGetDateHHmmDD:model.send_time];
    if ([nowDate isEqualToString:fwDate]) {
        self.dateLabel.text = [NSString TimeGetHHmmSSDate:model.send_time];
    }else{
        self.dateLabel.text = fwDate;
    }
    [self layoutIfNeeded];
    
}
- (NSString *)TimeGetDateHHmmDD:(NSString *)times
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[times longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yy/MM/dd"];
    return [outputFormatter stringFromDate:date];
}
//- (NSString *) getNowDateHHSSMM
//{
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[times longLongValue]/1000];
//    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
//    [outputFormatter setDateFormat:@"yy/MM/dd"];
//    return [outputFormatter stringFromDate:date];
//}
- (NSString *) getNowDate
{
    NSDate * date = [NSDate date];
    NSDateFormatter * formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yy/MM/dd"];
    NSString * str = [formate stringFromDate:date];
    return str;
}

@end
