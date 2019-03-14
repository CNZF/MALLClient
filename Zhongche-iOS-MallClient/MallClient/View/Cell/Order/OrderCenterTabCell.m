//
//  OrderCenterTabCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/5.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "OrderCenterTabCell.h"
#import "MGSwipeTableCell.h"
#import "UIImageView+WebCache.h"

@interface OrderCenterTabCell_Header : BaseTableViewCell
@property (nonatomic,strong)UIView * lineVi;
@property (nonatomic,strong)UIView * verticalBarVi;
@property (nonatomic,strong)UIView * deleteBtn;
@property (nonatomic,strong)UILabel* orderIDLab;
@property (nonatomic,strong)UILabel* ordetTypeLab;

@end

@implementation OrderCenterTabCell_Header
-(void)loadUIWithmodel:(id)model
{
    if ([model isKindOfClass:[OrderModelForCapacity class]]) {
        self.deleteBtn.hidden = YES;
        self.verticalBarVi.hidden = YES;
        
        OrderModelForCapacity * dataModel = (OrderModelForCapacity*)model;
        self.orderIDLab.text = [NSString stringWithFormat:@"订单号:%@",dataModel.orderID];
        
        self.ordetTypeLab.text = dataModel.ordetType;
        
        if([self.ordetTypeLab.text isEqualToString:@"待付款"]||[self.ordetTypeLab.text isEqualToString:@"待发货"]||[self.ordetTypeLab.text isEqualToString:@"待收货"]||[self.ordetTypeLab.text isEqualToString:@"待确认"]||[self.ordetTypeLab.text isEqualToString:@"待退款"])
        {
            self.ordetTypeLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
        }
        else if([self.ordetTypeLab.text isEqualToString:@"已完成"]||[self.ordetTypeLab.text isEqualToString:@"已取消"])
        {
            self.ordetTypeLab.textColor = APP_COLOR_GRAY2;
            
        }
        float width = [self.ordetTypeLab.text sizeWithAttributes:@{NSFontAttributeName:self.ordetTypeLab.font}].width;
        self.ordetTypeLab.frame = CGRectMake(SCREEN_W - width - 15, self.ordetTypeLab.top, width, self.ordetTypeLab.height);
        self.orderIDLab.frame = CGRectMake(self.orderIDLab.left, self.orderIDLab.top, self.ordetTypeLab.left - self.orderIDLab.left - 15, self.orderIDLab.height);
    }else if ([model isKindOfClass:[OrderModelForEmptyCar class]]) {
        OrderModelForEmptyCar * dataModel = (OrderModelForEmptyCar*)model;
        self.orderIDLab.text = [NSString stringWithFormat:@"订单号:%@",dataModel.orderID];
        
        self.ordetTypeLab.text = dataModel.orderState;
        
         float width = [self.ordetTypeLab.text sizeWithAttributes:@{NSFontAttributeName:self.ordetTypeLab.font}].width;
        if([self.ordetTypeLab.text isEqualToString:@"待支付"]||[self.ordetTypeLab.text isEqualToString:@"待审核"]||[self.ordetTypeLab.text isEqualToString:@"待调度"]||[self.ordetTypeLab.text isEqualToString:@"待装载"])
        {
            self.deleteBtn.hidden = YES;
            self.verticalBarVi.hidden = YES;
            self.ordetTypeLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
            
            self.ordetTypeLab.frame = CGRectMake(SCREEN_W - 15 - width, self.ordetTypeLab.top, width, self.ordetTypeLab.height);
        }
        else if([self.ordetTypeLab.text isEqualToString:@"已完成"]||[self.ordetTypeLab.text isEqualToString:@"已取消"])
        {
            self.deleteBtn.hidden = YES;
            self.verticalBarVi.hidden = YES;
            self.ordetTypeLab.textColor = APP_COLOR_GRAY2;
            
            self.ordetTypeLab.frame = CGRectMake(SCREEN_W - 15 - width, self.ordetTypeLab.top, width, self.ordetTypeLab.height);
//            self.deleteBtn.hidden = NO;
//            self.verticalBarVi.hidden = NO;
//            self.ordetTypeLab.textColor = APP_COLOR_GRAY2;
//            self.ordetTypeLab.frame = CGRectMake(SCREEN_W - 15 - width - 45, self.ordetTypeLab.top, width, self.ordetTypeLab.height);
        }
        self.orderIDLab.frame = CGRectMake(self.orderIDLab.left, self.orderIDLab.top, self.ordetTypeLab.left - self.orderIDLab.left - 15, self.orderIDLab.height);
    }else if ([model isKindOfClass:[OrderModelForEmptyContainer class]]) {
        OrderModelForEmptyContainer * dataModel = (OrderModelForEmptyContainer*)model;
        self.orderIDLab.text = [NSString stringWithFormat:@"订单号:%@",dataModel.orderID];
        
        self.ordetTypeLab.text = dataModel.orderState;
        
        float width = [self.ordetTypeLab.text sizeWithAttributes:@{NSFontAttributeName:self.ordetTypeLab.font}].width;
        if([self.ordetTypeLab.text isEqualToString:@"待支付"]||[self.ordetTypeLab.text isEqualToString:@"待审核"]||[self.ordetTypeLab.text isEqualToString:@"待箱主发箱"]||[self.ordetTypeLab.text isEqualToString:@"待买家收箱"]||[self.ordetTypeLab.text isEqualToString:@"待箱主收箱"])
        {
            self.deleteBtn.hidden = YES;
            self.verticalBarVi.hidden = YES;
            self.ordetTypeLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
            
            self.ordetTypeLab.frame = CGRectMake(SCREEN_W - 15 - width, self.ordetTypeLab.top, width, self.ordetTypeLab.height);
        }
        else if([self.ordetTypeLab.text isEqualToString:@"已完成"]||[self.ordetTypeLab.text isEqualToString:@"已取消"])
        {
            self.deleteBtn.hidden = YES;
            self.verticalBarVi.hidden = YES;
            self.ordetTypeLab.textColor = APP_COLOR_GRAY2;
            
            self.ordetTypeLab.frame = CGRectMake(SCREEN_W - 15 - width, self.ordetTypeLab.top, width, self.ordetTypeLab.height);
//            self.deleteBtn.hidden = NO;
//            self.verticalBarVi.hidden = NO;
//            self.ordetTypeLab.textColor = APP_COLOR_GRAY2;
//            self.ordetTypeLab.frame = CGRectMake(SCREEN_W - 15 - width - 45, self.ordetTypeLab.top, width, self.ordetTypeLab.height);
        }
        self.orderIDLab.frame = CGRectMake(self.orderIDLab.left, self.orderIDLab.top, self.ordetTypeLab.left - self.orderIDLab.left - 15, self.orderIDLab.height);
    }
}

-(void)bindView
{
    self.lineVi.frame = CGRectMake(0, 0, SCREEN_W, 10);
    [self addSubview:self.lineVi];
    
    self.orderIDLab.frame = CGRectMake(15, self.lineVi.bottom + 15, SCREEN_W * 2 / 3 - 15, 17);
    [self addSubview:self.orderIDLab];
    
    self.ordetTypeLab.frame = CGRectMake(self.orderIDLab.right, self.lineVi.bottom + 12, SCREEN_W * 1 / 3 - 15, 17);
    [self addSubview:self.ordetTypeLab];
    
    self.deleteBtn.frame = CGRectMake(SCREEN_W - 44, self.lineVi.bottom, 44, 44);
    [self addSubview:self.deleteBtn];
    
    self.verticalBarVi.frame = CGRectMake(SCREEN_W - 45, self.lineVi.bottom, 1, 44);
    [self addSubview:self.verticalBarVi];
    
    self.deleteBtn.hidden = YES;
    self.verticalBarVi.hidden = YES;
}

-(UIView *)lineVi
{
    if (!_lineVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _lineVi = vi;
        
    }
    return _lineVi;
}

-(UIView *)verticalBarVi
{
    if (!_verticalBarVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _verticalBarVi = vi;
        
    }
    return _verticalBarVi;
}

-(UIView *)deleteBtn {
    if (!_deleteBtn) {
        UIButton * btn = [UIButton  new];
        [btn setImage:[UIImage imageNamed:[@"删除 copy 2" adS]] forState:UIControlStateNormal];
        _deleteBtn = btn;
    }
    return _deleteBtn;
}

-(UILabel *)orderIDLab
{
    if (!_orderIDLab) {
        _orderIDLab = [UILabel new];
        _orderIDLab.font = [UIFont systemFontOfSize:14.0f];
        _orderIDLab.textAlignment = NSTextAlignmentLeft;
        _orderIDLab.textColor = APP_COLOR_BLACK_TEXT;
    }
    return _orderIDLab;
}

-(UILabel *)ordetTypeLab
{
    if (!_ordetTypeLab) {
        _ordetTypeLab = [UILabel new];
        _ordetTypeLab.font = [UIFont systemFontOfSize:14.0f];
        _ordetTypeLab.textAlignment = NSTextAlignmentRight;
        _ordetTypeLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
    }
    return _ordetTypeLab;
}


@end

@interface OrderCenterTabCell_Center : MGSwipeTableCell
@property (nonatomic, strong)UIImageView * imageVe;
@property (nonatomic, strong)UILabel * titleLab;
@property (nonatomic, strong)UILabel * typeLab;

@property (nonatomic, strong)UILabel * linesCapacityLab;
@property (nonatomic, strong)UILabel * goodsCapacityLab;

@property (nonatomic, strong)UILabel * rentDateEmptyCarLab;
@property (nonatomic, strong)UILabel * detailsEmptyCarLab;

@property (nonatomic, strong)UILabel * rentDateEmptycontainerLab;
@property (nonatomic, strong)UILabel * companyEmptycontainerLab;
@property (nonatomic, strong)UILabel * phoneEmptycontainerLab;

@end

@implementation OrderCenterTabCell_Center
-(void)loadUIWithmodel:(OrderModelForCapacity *)model
{

    if ([model isKindOfClass:[OrderModelForCapacity class]]) {

        self.linesCapacityLab.hidden = NO;
        self.goodsCapacityLab.hidden = NO;
        self.rentDateEmptyCarLab.hidden = YES;
        self.detailsEmptyCarLab.hidden = YES;
        self.rentDateEmptycontainerLab.hidden = YES;
        self.companyEmptycontainerLab.hidden = YES;
        self.phoneEmptycontainerLab.hidden = YES;
        self.typeLab.hidden = YES;
        self.titleLab.frame = CGRectMake(self.imageVe.right + 15, 18, SCREEN_W - self.imageVe.right - 30, 15);

        OrderModelForCapacity * data = (OrderModelForCapacity *)model;
        [self.imageVe sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEIMGURL,data.imgUrl]]  placeholderImage:[UIImage imageNamed:@"001.png"]];
        
        self.titleLab.text = data.capacityType;
        
        self.linesCapacityLab.text = [NSString stringWithFormat:@"%@ - %@",data.startPlace,data.endPlace];
        
        
        if ([data.capacityType isEqualToString:@"集装箱运力"]) {
            self.goodsCapacityLab.text = [NSString stringWithFormat:@"%@ / %@箱",data.goodsName,data.goodsNum];
            
        }
        else if ([data.capacityType isEqualToString:@"散堆装运力"]) {
            self.goodsCapacityLab.text = [NSString stringWithFormat:@"%@ / %@吨 / %@立方",data.goodsName,data.weight,data.volume];
            
        }
        else if ([data.capacityType isEqualToString:@"三农化肥运力"]) {
            self.goodsCapacityLab.text = [NSString stringWithFormat:@"%@ / %@吨",data.goodsName,data.weight];

        }else if ([data.capacityType isEqualToString:@"液态运力"]) {
            self.goodsCapacityLab.text = [NSString stringWithFormat:@"%@ / %@吨",data.goodsName,data.weight];

        }else if ([data.capacityType isEqualToString:@"冷链运力"]) {
            self.goodsCapacityLab.text = [NSString stringWithFormat:@"%@ / %@箱",data.goodsName,data.goodsNum];

        }else if ([data.capacityType isEqualToString:@"商品车运力"]) {
            self.goodsCapacityLab.text = [NSString stringWithFormat:@"%@ / %@台",data.vehicleType,data.vehicleNum];

        }else {

            self.goodsCapacityLab.text = [NSString stringWithFormat:@"%@ / %@箱",data.goodsName,data.goodsNum];

        }

    }else if ([model isKindOfClass:[OrderModelForEmptyCar class]]) {

        self.linesCapacityLab.hidden = YES;
        self.goodsCapacityLab.hidden = YES;
        self.rentDateEmptyCarLab.hidden = NO;
        self.detailsEmptyCarLab.hidden = NO;
        self.rentDateEmptycontainerLab.hidden = YES;
        self.companyEmptycontainerLab.hidden = YES;
        self.phoneEmptycontainerLab.hidden = YES;
        self.typeLab.hidden = NO;
        self.titleLab.frame = CGRectMake(self.imageVe.right + 50, 18, SCREEN_W - self.imageVe.right - 30, 15);
        OrderModelForEmptyCar * data = (OrderModelForEmptyCar *)model;
        [self.imageVe sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEIMGURL,data.imgUrl]]  placeholderImage:[UIImage imageNamed:@"001.png"]];
        self.typeLab.text = data.transportType;
        NSString * line = @"";
        if (data.startParentAddress) {
            line = [NSString stringWithFormat:@"%@%@",line,data.startParentAddress];
        }
        if (data.startPlace) {
            line = [NSString stringWithFormat:@"%@%@",line,data.startPlace];
        }
        line = [NSString stringWithFormat:@"%@ - ",line];
        if (data.endParentAddress) {
            line = [NSString stringWithFormat:@"%@%@",line,data.endParentAddress];
        }
        if (data.endPlace) {
            line = [NSString stringWithFormat:@"%@%@",line,data.endPlace];
        }
        self.titleLab.text = line;
        NSDateFormatter *outputFormatter = [ NSDateFormatter new];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        self.rentDateEmptyCarLab.text = [NSString stringWithFormat:@"租用日期：%@",[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[data.rentTime longLongValue] / 1000]]];
        self.detailsEmptyCarLab.text = data.details;
        if (self.titleLab.width < [self.titleLab.text sizeWithAttributes:@{NSFontAttributeName:self.titleLab.font}].width) {
            self.titleLab.frame = CGRectMake(self.imageVe.right + 50, 18, SCREEN_W - self.imageVe.right - 30, 30);
            self.rentDateEmptyCarLab.frame = CGRectMake(self.imageVe.right + 15, 10 + self.titleLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
            self.detailsEmptyCarLab.frame = CGRectMake(self.imageVe.right + 15, 10 + self.rentDateEmptyCarLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);

           
        }else {
            self.titleLab.frame = CGRectMake(self.imageVe.right + 50, 18, SCREEN_W - self.imageVe.right - 30, 15);
            self.rentDateEmptyCarLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.titleLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
            self.detailsEmptyCarLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.rentDateEmptyCarLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
        }
    }else if ([model isKindOfClass:[OrderModelForEmptyContainer class]]) {

        self.linesCapacityLab.hidden = YES;
        self.goodsCapacityLab.hidden = YES;
        self.rentDateEmptyCarLab.hidden = YES;
        self.detailsEmptyCarLab.hidden = YES;
        self.rentDateEmptycontainerLab.hidden = NO;
        self.companyEmptycontainerLab.hidden = NO;
        self.phoneEmptycontainerLab.hidden = NO;
        self.typeLab.hidden = NO;
        self.titleLab.frame = CGRectMake(self.imageVe.right + 50, 18, SCREEN_W - self.imageVe.right - 30, 15);
        OrderModelForEmptyContainer * data = (OrderModelForEmptyContainer *)model;

        [self.imageVe sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASEIMGURL,data.imgUrl]]  placeholderImage:[UIImage imageNamed:@"001.png"]];
        self.typeLab.text = data.orderType;
        self.titleLab.text = data.containerType;
        if (data.orderTypeEnum == rentContainer) {
            NSDateFormatter *outputFormatter = [ NSDateFormatter new];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
            self.rentDateEmptycontainerLab.text = [NSString stringWithFormat:@"租赁日期：%@至%@",[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[data.startTime longLongValue] / 1000]],[outputFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[data.endTime longLongValue] / 1000]]];
            self.rentDateEmptycontainerLab.hidden = NO;
            
            self.rentDateEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 10 + self.titleLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
            self.companyEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 7 + self.rentDateEmptycontainerLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
            self.phoneEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 7 + self.companyEmptycontainerLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);

        }else {
            self.rentDateEmptycontainerLab.hidden = YES;
            
            self.companyEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.titleLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
            self.phoneEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.companyEmptycontainerLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
        }
        self.companyEmptycontainerLab.text = data.companyName;
        self.phoneEmptycontainerLab.text = data.phone;
    }
}

-(void)bindView
{
    self.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    
    self.imageVe.frame = CGRectMake(19, 19, 70, 70);
    [self addSubview:self.imageVe];
    
    self.titleLab.frame = CGRectMake(self.imageVe.right + 15, 18, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.titleLab];
    self.typeLab.frame = CGRectMake(self.imageVe.right + 15, 16,30, 18);
    [self addSubview:self.typeLab];

    self.linesCapacityLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.titleLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.linesCapacityLab];
    
    self.goodsCapacityLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.linesCapacityLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.goodsCapacityLab];
    
    
    self.rentDateEmptyCarLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.titleLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.rentDateEmptyCarLab];
    self.detailsEmptyCarLab.frame = CGRectMake(self.imageVe.right + 15, 5 + self.rentDateEmptyCarLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.detailsEmptyCarLab];
    
    self.rentDateEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 15 + self.titleLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.rentDateEmptycontainerLab];
    self.companyEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 5 + self.rentDateEmptycontainerLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.companyEmptycontainerLab];
    self.phoneEmptycontainerLab.frame = CGRectMake(self.imageVe.right + 15, 5 + self.companyEmptycontainerLab.bottom, SCREEN_W - self.imageVe.right - 30, 15);
    [self addSubview:self.phoneEmptycontainerLab];
    
    self.linesCapacityLab.hidden = YES;
    self.goodsCapacityLab.hidden = YES;
    self.rentDateEmptyCarLab.hidden = YES;
    self.detailsEmptyCarLab.hidden = YES;
    self.rentDateEmptycontainerLab.hidden = YES;
    self.companyEmptycontainerLab.hidden = YES;
    self.phoneEmptycontainerLab.hidden = YES;
    self.typeLab.hidden = YES;
}

-(UIImageView *)imageVe
{
    if (!_imageVe) {
        _imageVe = [UIImageView new];
    }
    return _imageVe;
}
-(UILabel *)titleLab
{
    if (!_titleLab) {
        UILabel * lab = [UILabel new];
        lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:16.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.numberOfLines = 0;
        _titleLab = lab;
    }
    return _titleLab;
}
-(UILabel *)linesCapacityLab
{
    if (!_linesCapacityLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        
        _linesCapacityLab = lab;
    }
    return _linesCapacityLab;
}

-(UILabel *)goodsCapacityLab
{
    if (!_goodsCapacityLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        
        _goodsCapacityLab = lab;
    }
    return _goodsCapacityLab;
}

-(UILabel *)rentDateEmptyCarLab
{
    if (!_rentDateEmptyCarLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        
        _rentDateEmptyCarLab = lab;
    }
    return _rentDateEmptyCarLab;
}

-(UILabel *)detailsEmptyCarLab
{
    if (!_detailsEmptyCarLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        
        _detailsEmptyCarLab = lab;
    }
    return _detailsEmptyCarLab;
}

-(UILabel *)rentDateEmptycontainerLab
{
    if (!_rentDateEmptycontainerLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        
        _rentDateEmptycontainerLab = lab;
    }
    return _rentDateEmptycontainerLab;
}

-(UILabel *)companyEmptycontainerLab
{
    if (!_companyEmptycontainerLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        
        _companyEmptycontainerLab = lab;
    }
    return _companyEmptycontainerLab;
}

-(UILabel *)phoneEmptycontainerLab
{
    if (!_phoneEmptycontainerLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        
        _phoneEmptycontainerLab = lab;
    }
    return _phoneEmptycontainerLab;
}

-(UILabel *)typeLab
{
    if (!_typeLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:11.0f];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = APP_COLOR_RED1;
        lab.layer.borderWidth = 0.5;
        lab.layer.borderColor = APP_COLOR_RED1.CGColor;
        _typeLab = lab;
    }
    return _typeLab;
}
@end

@interface OrderCenterTabCell_Footer : BaseTableViewCell
@property (nonatomic, strong)UILabel * priceLab;

@property (nonatomic, strong)UILabel * numLab;
@end

@implementation OrderCenterTabCell_Footer

-(void)loadUIWithmodel:(id)model
{
    NSMutableAttributedString * attrString;
    
    if ([model isKindOfClass:[OrderModelForCapacity class]]) {
        OrderModelForEmptyCar * dataModel = (OrderModelForEmptyCar*)model;
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计: ¥%@",[dataModel.price NumberStringToMoneyString]]];
        self.numLab.hidden = YES;
    }else if ([model isKindOfClass:[OrderModelForEmptyCar class]]) {
        OrderModelForEmptyCar * dataModel = (OrderModelForEmptyCar*)model;
        if([dataModel.price intValue]) {
            attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计: ¥%@",[dataModel.price NumberStringToMoneyString]]];
        }
        else {
            attrString = [[NSMutableAttributedString alloc] initWithString:@"总计: 电询"];
        }
        if (dataModel.transportTypeEnum == landTransportation) {
            self.numLab.text = @"";
        }else {
            self.numLab.text = [NSString stringWithFormat:@"共%@TEU",dataModel.buyNum];
        }
        self.numLab.hidden = NO;
        
    }else if ([model isKindOfClass:[OrderModelForEmptyContainer class]]) {
        OrderModelForEmptyContainer * dataModel = (OrderModelForEmptyContainer*)model;
        attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总计: ¥%@",[dataModel.price NumberStringToMoneyString]]];
        self.numLab.text = [NSString stringWithFormat:@"共%@个集装箱",dataModel.containerNum];
        self.numLab.hidden = NO;
    }

    //设置字体
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f]
                       range:NSMakeRange(0, 4)];
    if(attrString.length >= 7) {
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f]
                           range:NSMakeRange(4,attrString.length - 7)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f]
                           range:NSMakeRange(attrString.length - 3, 3)];
    } else {
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f]
                           range:NSMakeRange(4,attrString.length - 4)];
    }
    
    // 设置颜色
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:APP_COLOR_GRAY_TEXT_1
                       range:NSMakeRange(0, 3)];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:APP_COLOR_BLACK_TEXT
                       range:NSMakeRange(4, attrString.length - 4)];
    
    self.priceLab.attributedText = attrString;
}
-(void)bindView
{
    self.priceLab.frame = CGRectMake(15, 14, SCREEN_W - 30, 16);
    [self addSubview:self.priceLab];
    
    self.numLab.frame = CGRectMake(15, 14, SCREEN_W - 30, 16);
    [self addSubview:self.numLab];
}

-(UILabel *)priceLab
{
    if (!_priceLab) {
        _priceLab = [UILabel new];
        _priceLab.font = [UIFont systemFontOfSize:14.0f];
        _priceLab.textAlignment = NSTextAlignmentRight;
        _priceLab.textColor = APP_COLOR_GRAY2;
    }
    return _priceLab;
}

-(UILabel *)numLab
{
    if (!_numLab) {
         UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        _numLab = lab;
    }
    return _numLab;
}
@end


@interface OrderCenterTabCell()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate>

@property (nonatomic, strong)UITableView * tbv;
@property (nonatomic,strong)OrderModelForCapacity * model;

@end

@implementation OrderCenterTabCell
-(void)loadUIWithmodel:(id)model
{
    self.model = model;
    [self.tbv reloadData];
}
-(void)bindView
{
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, 210);
    [self addSubview:self.tbv];
}
-(UITableView *)tbv
{
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = APP_COLOR_WHITE;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[OrderCenterTabCell_Header class] forCellReuseIdentifier:NSStringFromClass([OrderCenterTabCell_Header class])];
        [tableView registerClass:[OrderCenterTabCell_Center class] forCellReuseIdentifier:NSStringFromClass([OrderCenterTabCell_Center class])];
        [tableView registerClass:[OrderCenterTabCell_Footer class] forCellReuseIdentifier:NSStringFromClass([OrderCenterTabCell_Footer class])];
        _tbv = tableView;
    }
    return _tbv;
}
-(OrderModelForCapacity *)model
{
    if (!_model) {
        _model = [OrderModelForCapacity new];
    }
    return _model;
}
#pragma mark - Tabview Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell * cell;
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCenterTabCell_Header class]) forIndexPath:indexPath];
            
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCenterTabCell_Center class]) forIndexPath:indexPath];
            ((OrderCenterTabCell_Center *)cell).delegate = self;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderCenterTabCell_Footer class]) forIndexPath:indexPath];
            
            break;
            
        default:
            break;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell loadUIWithmodel:self.model];
    return cell;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 56;
            break;
        case 1:
            height = 112;
            break;
        case 2:
            height = 44;
            break;
        default:
            break;
    }
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.cellDelegate getCellClick:self.cellIndexPath];
}
#pragma mark - MGSwipeTableCellDelegate
//决定是否可以使用划动手势。
- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell canSwipe:(MGSwipeDirection)direction
{
//    if (direction == MGSwipeDirectionLeftToRight) {
//        return NO;
//    }
//    else if (direction == MGSwipeDirectionRightToLeft)
//    {
//        return YES;
//    }

    return NO;
}
//当前swipe state状态改变时使用。
- (void)swipeTableCell:(MGSwipeTableCell*)cell
   didChangeSwipeState:(MGSwipeState)state
       gestureIsActive:(BOOL) gestureIsActive
{
    if ([cell isKindOfClass:[OrderCenterTabCell_Center class]]) {
        cell.hidden = !cell.hidden;
    }
}
//用户点击按钮时回调。
- (BOOL)swipeTableCell:(MGSwipeTableCell*)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL) fromExpansion
{
    return YES;
}
//设置swipe button 和 swipe/expansion 的设置。
- (NSArray*)swipeTableCell:(MGSwipeTableCell*)cell
  swipeButtonsForDirection:(MGSwipeDirection)direction
             swipeSettings:(MGSwipeSettings*)swipeSettings
         expansionSettings:(MGSwipeExpansionSettings*)expansionSettings
{
    WS(ws);
    if(self.beenPlacedAtTheTop)
    {
        return @[[MGSwipeButton buttonWithTitle:@"取消置顶"
                            backgroundColor:APP_COLOR_GRAY1
                                   callback:^BOOL(MGSwipeTableCell *sender){
                                       [ws.cellDelegate getTheTopCancelButtonClickWithCellIndexPath:ws.cellIndexPath];
                                       return YES;
                                   }]
             ];
    }
    else
    {
        return @[[MGSwipeButton buttonWithTitle:@"置顶"
                                backgroundColor:APP_COLOR_BLUE_BTN
                                       callback:^BOOL(MGSwipeTableCell *sender){
                                           [ws.cellDelegate getTheTopButtonClickWithCellIndexPath:ws.cellIndexPath];
                                           return YES;
                                       }]
                 ];
    }
}
@end
