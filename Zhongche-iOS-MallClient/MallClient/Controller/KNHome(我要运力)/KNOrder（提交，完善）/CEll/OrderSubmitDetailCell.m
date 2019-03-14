//
//  OrderSubmitDetailCell.m
//  MallClient
//
//  Created by lxy on 2018/6/12.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderSubmitDetailCell.h"
#import "EntrepotModel.h"

@implementation OrderSubmitDetailCell

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

- (void) setModel:(CapacityEntryModel *)model Index:(NSInteger)index
{
    _model = model;
    _index = index;
    if (index == 0) {
        NSString * contentStr;
        contentStr = @"货品类型  ";
        contentStr = [contentStr stringByAppendingString:@"集装箱\n"];
        contentStr = [contentStr stringByAppendingString:@"货品名称  "];
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.goodsInfo.name]];
        contentStr = [contentStr stringByAppendingString:@"箱型箱类  "];
        NSString * temp = [NSString stringWithFormat:@"%@\n", model.box.name];
        contentStr = [contentStr stringByAppendingString:temp];
        contentStr = [contentStr stringByAppendingString:@"用箱数量  "];
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.boxNum]];
        contentStr = [contentStr stringByAppendingString:@"发货时间  "];
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",[self dateTransformToTimeString:model.startDate]]];
        contentStr = [contentStr stringByAppendingString:@"到达时间  "];
        
        NSInteger days = [self.transportModel.expectTime intValue]/1440;
        NSTimeInterval time = [model.startDate timeIntervalSince1970];
        
        NSTimeInterval allTime = time + days*24*3600;
        NSDate *dd = [NSDate dateWithTimeIntervalSince1970:allTime];
        contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",[self dateTransformToTimeString:dd]]];
        contentStr = [contentStr stringByAppendingString:@"备注  "];
        if (model.remark ==nil || [model.remark isEqualToString:@""]) {
            contentStr = [contentStr stringByAppendingString:@"无"];
        }else{
            contentStr = [contentStr stringByAppendingString:model.remark];
        }
        
        // 调整行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:14];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
        self.label.attributedText = attributedString;
        
//        _shipmentsTime    __NSDate *    2018-06-13 01:28:18 UTC    0x000000015cf3bc40
    }
//发票信息
    if (index ==3) {
        //INVOICE_TYPE_COMMON_TAX
        
        NSString * contentStr = @"";
        if (model.invoice.title!=nil) {
            contentStr = [contentStr stringByAppendingString:@"发票抬头："];
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice.title]];
            contentStr = [contentStr stringByAppendingString:@"发票类型："];
            if ([model.invoice.type isEqualToString:@"INVOICE_TYPE_COMMON_TAX"]) {
                contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"普通发票"]];
            }else{
                contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",@"增值税发票"]];
            }
            contentStr = [contentStr stringByAppendingString:@"发票内容："];
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice.content]];
            contentStr = [contentStr stringByAppendingString:@"收票人姓名："];
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice.contactsName]];
            contentStr = [contentStr stringByAppendingString:@"收票人电话："];
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@\n",model.invoice.contactsTel]];
            contentStr = [contentStr stringByAppendingString:@"收票人地址："];
            contentStr = [contentStr stringByAppendingString:[NSString stringWithFormat:@"%@",model.invoice.contactsAddress]];
            
            // 调整行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:contentStr];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:14];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentStr length])];
             self.label.attributedText = attributedString;
        }
       
    }
    if(index == 6){
        if (model.remark) {
            self.label.text  =model.remark;
        }else{
            self.label.text = @"无";
        }
    }
}


- (void)setTransportModel:(TransportationModel *)transportModel
{
    _transportModel = transportModel;
}

//运输网点
- (void) setTicketModel:(TicketsDetailModel *)Ticketmodel Index:(NSInteger)index
{
    EntrepotModel * startModel = Ticketmodel.startEntrepotName;
    
    NSString * contentStr = @"";
    contentStr = [contentStr stringByAppendingString:startModel.name];
    contentStr = [contentStr stringByAppendingString:@"  "];
    contentStr = [contentStr stringByAppendingString:startModel.address];
    
    contentStr = [contentStr stringByAppendingString:@"\n"];
    contentStr = [contentStr stringByAppendingString:@"\n"];
    
    EntrepotModel * endModel = Ticketmodel.endEntrepotName;
    contentStr = [contentStr stringByAppendingString:endModel.name];
    contentStr = [contentStr stringByAppendingString:@"  "];
    contentStr = [contentStr stringByAppendingString:endModel.address];
    self.label.text = contentStr;
}
@end
