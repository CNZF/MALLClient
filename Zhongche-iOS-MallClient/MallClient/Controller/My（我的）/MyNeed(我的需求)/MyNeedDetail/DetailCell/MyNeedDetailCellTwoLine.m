//
//  MyNeedDetailCell.m
//  MallClient
//
//  Created by lxy on 2018/9/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MyNeedDetailCellTwoLine.h"

@implementation MyNeedDetailCellTwoLine

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
    if (index == 3) {
        
        //集装箱
        //散堆装 总重量（吨）
        //大件  件数   总重量（吨）  最大单件尺寸（米）  最大单位重量（吨）
        //商品车  车型  数量（台）
        self.titleLabel1.text = @"货物品名";
        NSString * type_code;
        if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_CONTAINER"]) {
            type_code = @"箱数";
        }else if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {
            type_code = @"总重量(吨)";
        }else if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_LARGE_SIZE"]) {
            type_code = @"件数\n总重量（吨）\n最大单位重量（吨)\n最大单件长度（米）\n最大单件宽度（米）\n最大单件高度（米）";
        }else{
            type_code = @"车型\n数量（台)";
        }
      
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:type_code];
        NSMutableParagraphStyle* paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle1.alignment = self.titleLabel2.textAlignment;
        paragraphStyle1.lineBreakMode = self.titleLabel2.lineBreakMode;
        paragraphStyle1.allowsDefaultTighteningForTruncation = self.titleLabel2.allowsDefaultTighteningForTruncation;
        
        [paragraphStyle1 setParagraphSpacing:10.f];
        [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [type_code length])];
        [self.titleLabel2 setAttributedText:attributedString1];
//        self.titleLabel2.text = type_code;
        if (model.goods_name) {
            self.detailLabel1.text = model.goods_name;
        }else{
            self.detailLabel1.text = @"无";
        }
        
        
        NSString * type_code_detail;
        if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_CONTAINER"]) {
            if (model.container_number) {
                type_code_detail = model.container_number;
            }else{
                self.detialLabel2.text = @" ";
                return;
            }
            
        }else if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_BULK_STACK"]) {
            type_code_detail = model.weight;
        }else if ([model.business_type_code isEqualToString:@"BUSINESS_TYPE_LARGE_SIZE"]) {
            type_code_detail = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@",model.wrapper_number,model.weight,model.unit_max_weight,model.unit_max_length,model.unit_max_width,model.unit_max_high];
        }else{
            type_code_detail = [NSString stringWithFormat:@"%@\n%@",model.vehicle_type,model.vehicle_num];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:type_code_detail];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = self.detialLabel2.textAlignment;
        paragraphStyle.lineBreakMode = self.detialLabel2.lineBreakMode;
        paragraphStyle.allowsDefaultTighteningForTruncation = self.detialLabel2.allowsDefaultTighteningForTruncation;
        
        [paragraphStyle setParagraphSpacing:10.f];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [type_code_detail length])];
        [self.detialLabel2 setAttributedText:attributedString];
        
//        self.detialLabel2.text = type_code_detail;
    }else{
        self.titleLabel1.text = @"上门取货";
        self.titleLabel2.text = @"送货上门";
        self.detailLabel1.text = model.start_address;
        self.detialLabel2.text = model.end_address;
      
    }
}


@end
