//
//  KNOrderCompleteHeaderView.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNOrderCompleteHeaderView.h"
#import "AddressTableViewCell.h"
#import "KNOrderCompleteHeaderSubView.h"
#import "TicketsDetailModel.h"
#import "EntrepotModel.h"
#import "AddressInfo.h"

@interface KNOrderCompleteHeaderView ()

@property (nonatomic, strong) UIImageView *cuttingIcon;

@property (nonatomic, strong) KNOrderCompleteHeaderSubView *subHeaderView;

@property (nonatomic, strong) AddressTableViewCell *topAddressCell;

@property (nonatomic, strong) AddressTableViewCell *bottomAddressCell;

@end

@implementation KNOrderCompleteHeaderView

- (void)binView{
    self.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
//    [self addSubview:self.topAddressCell];
//    [self addSubview:self.bottomAddressCell];
//    [self addSubview:self.cuttingIcon];
    [self addSubview:self.subHeaderView];
}

- (void)topAddressCellTap:(UITapGestureRecognizer *)tap{
    if (self.topBlock) {
        self.topBlock();
    }
}

- (void)bottomAddressCellTap:(UITapGestureRecognizer *)tap{
    if (self.bottomBlock) {
        self.bottomBlock();
    }
}

#pragma mark -- Getter
- (AddressTableViewCell *)topAddressCell{
    if (!_topAddressCell) {
        _topAddressCell = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil][0];
        _topAddressCell.backgroundColor = [UIColor whiteColor];
        _topAddressCell.frame = CGRectMake(0, 0, SCREEN_W, 87);
        _topAddressCell.laAddress.text = @"提货地址:";
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topAddressCellTap:)];
        [_topAddressCell addGestureRecognizer:tap1];
    }
    return _topAddressCell;
}

- (AddressTableViewCell *)bottomAddressCell{
    if (!_bottomAddressCell) {
        _bottomAddressCell = [[NSBundle mainBundle] loadNibNamed:@"AddressTableViewCell" owner:self options:nil][0];
        _bottomAddressCell.lbAddressType.text = @"收";
        _bottomAddressCell.backgroundColor = [UIColor whiteColor];
        _bottomAddressCell.frame = CGRectMake(0, _topAddressCell.bottom, SCREEN_W, 87);
        _bottomAddressCell.laAddress.text = @"送货地址:";
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomAddressCellTap:)];
        [_bottomAddressCell addGestureRecognizer:tap2];
    }
    return _bottomAddressCell;
}
- (UIImageView *)cuttingIcon{
    if (!_cuttingIcon) {
        _cuttingIcon = [[UIImageView alloc] init];
        _cuttingIcon.image = [UIImage imageNamed:@"KN_colorLine"];
        _cuttingIcon.frame = CGRectMake(0, _bottomAddressCell.bottom - 2, SCREEN_W, 2);
    }
    return _cuttingIcon;
}
- (KNOrderCompleteHeaderSubView *)subHeaderView{
    if (!_subHeaderView) {
        _subHeaderView = [[NSBundle mainBundle] loadNibNamed:@"KNOrderCompleteHeaderSubView" owner:self options:nil][0];
        _subHeaderView.frame = CGRectMake(0, 0, SCREEN_W, 110);
    }
    return _subHeaderView;
}

- (void)setTopAddressInfo:(AddressInfo *)topAddressInfo{
    _topAddressInfo = topAddressInfo;
    self.topAddressCell.lbName.text = topAddressInfo.contacts;
    self.topAddressCell.lbPhone.text = topAddressInfo.contactsPhone;
    self.topAddressCell.laAddress.text = topAddressInfo.address;
}

- (void)setBottomAddressInfo:(AddressInfo *)bottomAddressInfo{
    _bottomAddressInfo = bottomAddressInfo;
    self.bottomAddressCell.lbName.text = bottomAddressInfo.contacts;
    self.bottomAddressCell.lbPhone.text = bottomAddressInfo.contactsPhone;
    self.bottomAddressCell.laAddress.text = bottomAddressInfo.address;
}

- (void)setTicketDetailModel:(TicketsDetailModel *)ticketDetailModel {
    _ticketDetailModel = ticketDetailModel;

    self.subHeaderView.distanceLabel.text = [NSString stringWithFormat:@"%@ - %@",ticketDetailModel.startName,ticketDetailModel.endName];
    self.subHeaderView.descLabel.text = [NSString stringWithFormat:@"%@ - %@",ticketDetailModel.startEntrepotName.name,ticketDetailModel.endEntrepotName.name];
    self.subHeaderView.descSubLabel.text = [NSString stringWithFormat:@"%@ - %@",ticketDetailModel.startEntrepotName.address,ticketDetailModel.endEntrepotName.address];

    
}

- (void)setTransportModel:(TransportationModel *)transportModel {
    _transportModel = transportModel;
    NSInteger days = [transportModel.expectTime intValue]/1440;
    
    if (days % 1 > 0 || days == 0) {
        days  = days/1+1;
    }
    [self.subHeaderView.dayButton setTitle:[NSString stringWithFormat:@"%li日达",days] forState:UIControlStateNormal];
     NSString *startTimeStr = [NSString stringWithFormat:@"%@",[self stDateToString:[NSString stringWithFormat:@"%lli",[transportModel.departureTime longLongValue]]]];
    self.subHeaderView.timeLabel.text = [NSString stringWithFormat:@"%@起运",startTimeStr];
}


- (NSString *)stDateToString:(NSString *)stDate {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[stDate longLongValue]/1000];
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *totalStr = [outputFormatter stringFromDate:date];
    return totalStr;
}
@end
