//
//  KNOrderSubmitVC.m
//  MallClient
//
//  Created by 沙漠 on 2018/5/3.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNOrderSubmitVC.h"
#import "KNOrderSubmitHeaderView.h"
#import "KNOrderSubmitNormalCell.h"
#import "KNOrderSubmitAddressCell.h"
#import "CapacityEntryModel.h"
#import "EntrepotModel.h"
#import "KNOrderSubmitRemarkCell.h"
#import "CapacityViewModel.h"
#import "SubmitOrderSuccessViewController.h"
#import "NSString+Money.h"
#import "OrderSubmitDetailCell.h"
#import "OrderDeyaillnCell.h"
#import "OrderSubCoastCell.h"
#import "OrderDeyailNoAddressCell.h"
#import "NomalInvoiceCell.h"
#import "AddInvoiceCell.h"
#import "PlaceAddressCell.h"
#import "SubGoodsInfomationCell.h"

@interface KNOrderSubmitVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *KNTableView;

@property (nonatomic, strong) KNOrderSubmitHeaderView *headerView;

@property (nonatomic, strong) UIButton *buttomButton;

@end

@implementation KNOrderSubmitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    CapacityEntryModel * model =self.requestModel;
   
    NSLog(@"model %@",model);
}

- (void)bindModel{
//    self.headerView.distanceLabel.text = [NSString stringWithFormat:@"%@ - %@",self.detailModel.startName,self.detailModel.endName];
    
//    NSInteger days = [self.transportModel.expectTime intValue]/1440;
////
//    if (days % 1 > 0 || days == 0) {
//        days  = days/1+1;
//    }
//
//    self.headerView.descSubLabel.text = [NSString stringWithFormat:@"%li日达",days];
//    [self.headerView.priceLabel setAttributedText:[NSString getFormartPrice:[self.requestModel.priceInfo.orderTotalMoney floatValue]]];
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"KNOderSubmit" ofType:@"plist"];
//    [self.dataArray addObjectsFromArray:[[NSArray alloc] initWithContentsOfFile:path]];
    
    [self.dataArray addObjectsFromArray:@[@"",@"货品及服务信息",@"增值服务",@"运输网点",@"发票信息",@"费用明细",@"备注信息"]];
    
//    if (!_isShowInvoice) {
//        [self.dataArray removeObjectAtIndex:2];
//    }
    [self.KNTableView reloadData];
}

- (void)bindView{
    [self.view addSubview:self.KNTableView];
//    self.KNTableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.buttomButton];
}

- (void)bindAction{
    WS(weakSelf)
    [[self.buttomButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        weakSelf.requestModel.ticketType = weakSelf.transportModel.ticketType;
        
        [[[CapacityViewModel alloc] init] makeSureOrderOfCapacityWithCapacityInfo:weakSelf.requestModel TicketsDetailModel:self.detailModel callback:^(NSString *orderNo) {
            //通知订单中心进行更新
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshOrderCenter"
                                                               object:@{
                                                                        @"orderType":@"全部",
                                                                        @"viewTitle":@"我要运力"
                                                                        }];
            
            SubmitOrderSuccessViewController *vc = [[SubmitOrderSuccessViewController alloc] init];
            vc.stOrderNo = orderNo;
            vc.type = capacity;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }] ;
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.requestModel.remark.length>0) {
        return 7;
    }else{
        return 6;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ( section == 2) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PlaceAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PlaceAddressCell class]) forIndexPath:indexPath];
        cell.distanceLabel.text = [NSString stringWithFormat:@"%@ - %@",self.detailModel.startName,self.detailModel.endName];
        NSInteger days = [self.transportModel.expectTime intValue]/1440;
        //
        if (days % 1 > 0 || days == 0) {
            days  = days/1+1;
        }
        [cell.descSubLabel setTitle:[NSString stringWithFormat:@"%li日达",days] forState:UIControlStateNormal];
        cell.startPlace.text = self.detailModel.startEntrepotName.name;
        cell.stateAddress.text = self.detailModel.startEntrepotName.address;
        cell.endPlace.text = self.detailModel.endEntrepotName.name;
        cell.endAddress.text = self.detailModel.endEntrepotName.address;
        return cell;
        
    }else if (indexPath.section == 1){
        SubGoodsInfomationCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SubGoodsInfomationCell class]) forIndexPath:indexPath];
//        cell.transportModel = self.transportModel;
        [cell setModel:self.requestModel requeseModel:self.transportModel];
        return cell;
    }else if(indexPath.section == 2){
        if ([self.requestModel.serviceWay isEqualToString:@"无"]) {
            OrderDeyailNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class]) forIndexPath:indexPath];
            [cell requestModel:self.requestModel AndIndex:indexPath.row];
            
            return cell;
        }else if ([self.requestModel.serviceWay isEqualToString:@"上门取货"]){
            if (indexPath.row == 0) {
                OrderDeyaillnCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyaillnCell class]) forIndexPath:indexPath];
                [cell requestModel:self.requestModel AndIndex:indexPath.row];
                
                return cell;
            }else{
                OrderDeyailNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class]) forIndexPath:indexPath];
                [cell requestModel:self.requestModel AndIndex:indexPath.row];
                
                return cell;
            }
        }else if ([self.requestModel.serviceWay isEqualToString:@"送货上门"]){
            if (indexPath.row == 0) {
                OrderDeyailNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class]) forIndexPath:indexPath];
                [cell requestModel:self.requestModel AndIndex:indexPath.row];
                
                return cell;
            }else{
                OrderDeyaillnCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyaillnCell class]) forIndexPath:indexPath];
                [cell requestModel:self.requestModel AndIndex:indexPath.row];
                return cell;
            }
        }else{
            OrderDeyaillnCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyaillnCell class]) forIndexPath:indexPath];
            [cell requestModel:self.requestModel AndIndex:indexPath.row];
            
            return cell;
        }
        
    }else if(indexPath.section == 3){
        OrderSubmitDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSubmitDetailCell class]) forIndexPath:indexPath];
         [cell setTicketModel:self.detailModel Index:indexPath.section];
        return cell;
    }else if (indexPath.section == 4){
        if (self.requestModel.invoice) {
            NomalInvoiceCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NomalInvoiceCell class]) forIndexPath:indexPath];
            cell.model = self.requestModel;
            return cell;
        }else{
            UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.textLabel.text = @"无";
            cell.textLabel.textColor = APP_COLOR_GRAY_TEXT_1;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if(indexPath.section == 5){
        OrderSubCoastCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSubCoastCell class]) forIndexPath:indexPath];
        cell.model = self.requestModel;
        return cell;
    }else
    {
        OrderSubmitDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSubmitDetailCell class]) forIndexPath:indexPath];
        [cell setModel:self.requestModel Index:indexPath.section];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1) {
//        if ([self.requestModel.serviceWay isEqualToString:@"无"]) {
//            return 35;
//        }else if ([self.requestModel.serviceWay isEqualToString:@"上门取货"]){
//            if (indexPath.row == 0) {
//                return UITableViewAutomaticDimension;
//            }else{
//                return 35;
//            }
//        }else if ([self.requestModel.serviceWay isEqualToString:@"送货上门"]){
//            if (indexPath.row == 0) {
//                return 35;
//            }else{
//                return UITableViewAutomaticDimension;
//            }
//        }else{
//            return UITableViewAutomaticDimension;
//        }
//
//    }else{
//
//    }
    if (indexPath.row == 4) {
        if (self.requestModel.invoice) {
             return UITableViewAutomaticDimension;
        }else{
            return 40;
        }
    }
    return UITableViewAutomaticDimension;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UITableViewHeaderFooterView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    if (sectionHeader) {
        for (UIView *view in sectionHeader.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
    }
    sectionHeader.contentView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, SCREEN_W-30, 20)];
    titleLabel.textColor = APP_COLOR_GRAY999;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = self.dataArray[section];
    [sectionHeader addSubview:titleLabel];
    return sectionHeader;
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *sectionFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    sectionFooter.contentView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    if (sectionFooter) {
        for (UIView *view in sectionFooter.subviews) {
            if ([view isKindOfClass:[UILabel class]]) {
                [view removeFromSuperview];
            }
        }
    }
    return sectionFooter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGFLOAT_MIN ;
    }
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 6) {
        return 20;
    }
    return CGFLOAT_MIN;
}

#pragma mark -- Getter
- (UITableView *)KNTableView {
    if (!_KNTableView) {
        _KNTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-kNavBarHeaderHeight - kiPhoneFooterHeight-80) style:UITableViewStyleGrouped];
        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        _KNTableView.rowHeight = UITableViewAutomaticDimension;
        _KNTableView.estimatedRowHeight = 100.0f;
        _KNTableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNOrderSubmitNormalCell" bundle:nil] forCellReuseIdentifier:@"KNOrderSubmitNormalCell"];
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNOrderSubmitAddressCell" bundle:nil] forCellReuseIdentifier:@"KNOrderSubmitAddressCell"];
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNOrderSubmitRemarkCell" bundle:nil] forCellReuseIdentifier:@"KNOrderSubmitRemarkCell"];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderSubmitDetailCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderSubmitDetailCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDeyaillnCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDeyaillnCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDeyailNoAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderSubCoastCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderSubCoastCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NomalInvoiceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([NomalInvoiceCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([AddInvoiceCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddInvoiceCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PlaceAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([PlaceAddressCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubGoodsInfomationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SubGoodsInfomationCell class])];
    }
    return _KNTableView;
}

//- (KNOrderSubmitHeaderView *)headerView{
//    if (!_headerView) {
//        _headerView = [[NSBundle mainBundle] loadNibNamed:@"KNOrderSubmitHeaderView" owner:self options:nil][0];
//        _headerView.frame = CGRectMake(0, 0, SCREEN_W,45);
////        _headerView.startPlace.text = @"北京市大西南领";
////        _headerView.endPlace.text = @"北京";
////        _headerView.startAddress.text = @"天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线";
////        _headerView.endAddress.text = @"天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线天灵低领，灵气再线";
//    }
//    return _headerView;
//}

- (UIButton *)buttomButton{
    if (!_buttomButton) {
        _buttomButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_H-65-kNavBarHeaderHeight-kiPhoneFooterHeight, SCREEN_W-30, 50)];
        _buttomButton.layer.cornerRadius = 4.0f;
        _buttomButton.layer.masksToBounds = YES;
        [_buttomButton setBackgroundColor:[HelperUtil colorWithHexString:@"3BA0F3"]];
        [_buttomButton setTitle:@"确认下单" forState:UIControlStateNormal];
        _buttomButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _buttomButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
