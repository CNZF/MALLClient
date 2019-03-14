//
//  KNOrderCompleteVC.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNOrderCompleteVC.h"
#import "KNOrderCompleteHeaderView.h"
#import "KNOrderCompleteTableViewCell.h"
#import "KNOrderCompleteOtherCell.h"
#import "KNOrderCompleteBottomView.h"
#import "KNOrderCompletePopDetailView.h"
#import "AddressManagerViewController.h"
#import "ZSSearchViewController.h"
#import "CapacityEntryModel.h"
#import "KNTableViewNumberCell.h"
#import "InvoiceListViewController.h"
#import "KNOrderCompleteMenuPopView.h"
#import "KNOrderSubmitVC.h"
#import "CapacityViewModel.h"
#import "KNOrderCompleteDatePicker.h"
#import "JisuanjiCell.h"
#import "OrderComplete_P_T_PCell.h"
#import "OrderSelectAddressCell.h"
#import "CalculatorViewController.h"
#import "OrderSelectNoAddressCell.h"
#import "InvoiceViewModel.h"
#import "NoGoodsCell.h"

@interface KNOrderCompleteVC ()<UITableViewDelegate,UITableViewDataSource,ZSSearchViewControllerDelegate>

@property (nonatomic, strong) UITableView *KNTableView;

@property (nonatomic, strong) KNOrderCompleteHeaderView *headerView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) NSInteger invoiceNum;

@property (nonatomic, assign) NSInteger remarkNum;
//用箱数量
@property (nonatomic, strong) KNTableViewNumberCell *numCell;
//发票信息
@property (nonatomic, strong) KNOrderCompleteOtherCell *invoiceCell;
//备注信息
@property (nonatomic, strong) KNOrderCompleteOtherCell *remarkCell;
//填写备注
@property (nonatomic, strong) KNOrderCompleteOtherCell *remarkDescCell;

@property (nonatomic, strong) KNOrderCompleteBottomView *bottomView;

@property (nonatomic, strong) KNOrderCompletePopDetailView *popView;
//支付类型弹框
@property (nonatomic, strong) KNOrderCompleteMenuPopView *payMenView;
//上门服务弹框
@property (nonatomic, strong) KNOrderCompleteMenuPopView *serviceMenuView;
//日期选择器
@property (nonatomic, strong) KNOrderCompleteDatePicker *datePicker;

@property (nonatomic, strong)InvoiceModel * defaultInvoceModel;//默认发票

@property (nonatomic, assign) BOOL isNoGoodSelect;//是否点击无商品

@end

@implementation KNOrderCompleteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"完善订单";
    self.invoiceNum = 1;
    self.remarkNum = 1;
    self.btnRight.hidden =NO;
    self.btnRight.frame = CGRectMake(0, 0, 30, 30);
    [self.btnRight setImage:[UIImage imageNamed:@"iconkefu"] forState:UIControlStateNormal];
    
    [self getInvoceData];
}


- (void)getInvoceData {
    InvoiceViewModel *vm = [InvoiceViewModel new];
    WS(ws);
    //默认增值发票
    [vm selectInVoiceWithType:1 callback:^(NSArray *arr) {
        if (arr.count>0) {
            for (InvoiceModel * model in arr) {
                if (model.isDefault) {
                    ws.defaultInvoceModel = model;

                    break;
                }
            }
        }else{
            //默认普通发票
            [vm selectInVoiceWithType:0 callback:^(NSArray *arr) {
                if (arr.count>0) {
                    for (InvoiceModel * model in arr) {
                        if (model.isDefault) {
                            ws.defaultInvoceModel = model;
    
                            break;
                        }
                    }
                }
            }];
        }
    }];
}

- (void)bindView{
    [self.view addSubview:self.KNTableView];
    self.KNTableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.bottomView];
}

- (void)bindModel{
    /**
     DELIVERY_TYPE_POINT_POINT 无
     DELIVERY_TYPE_DOOR_POINT 上门取货
     DELIVERY_TYPE_POINT_DOOR 送货上门
     DELIVERY_TYPE_DOOR_DOOR 上门取货+送货上门
     */
    self.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_POINT";
    self.requestModel.serviceWay = @"无";
//    self.requestModel.boxNum = @"1";
    self.popView.boxNum = self.requestModel.boxNum;
    self.requestModel.carryGoodsTime = @"08:00-18:00";
    self.requestModel.payStyle = @"预付款";
    self.bottomView.price = @"0.00";
    if (self.requestModel.contactInfo) {
        AddressInfo *startInfo = [[AddressInfo alloc] init];
        startInfo.address = self.requestModel.contactInfo.startAddress;
        startInfo.ID = self.requestModel.contactInfo.startID;
        startInfo.contacts  = self.requestModel.contactInfo.startContacts;
        startInfo.contactsPhone = self.requestModel.contactInfo.startContactsPhone;
        self.headerView.topAddressInfo = startInfo;
        AddressInfo *endInfo = [[AddressInfo alloc] init];
        endInfo.address = self.requestModel.contactInfo.endAddress;
        endInfo.ID = self.requestModel.contactInfo.endID;
        endInfo.contacts  = self.requestModel.contactInfo.endContacts;
        endInfo.contactsPhone = self.requestModel.contactInfo.endContactsPhone;
        self.headerView.bottomAddressInfo = endInfo;
    }
}

- (void)onRightAction
{
    [self callAction];
}

- (void)bindAction{
    WS(weakSelf)
    [[self.invoiceCell.switchButton rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        UISwitch *s = x;
        if (s.isOn) {
            self.requestModel.invoice = self.defaultInvoceModel;
        }else{
            self.requestModel.invoice = nil;
        }
        weakSelf.invoiceNum = s.isOn ? 2 : 1;
        [weakSelf.KNTableView reloadData];
    }];
    [[self.remarkCell.switchButton rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        UISwitch *s = x;
        weakSelf.remarkNum = s.isOn ? 2 : 1;
        [weakSelf.KNTableView reloadData];
    }];
    [[self.bottomView.detailButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        if (!weakSelf.bottomView.arrowIcon.selected) {
            [weakSelf.popView show];
             weakSelf.bottomView.arrowIcon.selected = YES;
        }else{
            weakSelf.bottomView.arrowIcon.selected = NO;
            [weakSelf.popView close];
        }
    }];
    [weakSelf.popView setCloseBlock:^{
        weakSelf.bottomView.arrowIcon.selected = NO;
    }];
    
    self.headerView.topBlock = ^{
        AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
        vc.title = @"提货地址";
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [vc returnInfo:^(AddressInfo *info) {
            weakSelf.headerView.topAddressInfo = info;
            weakSelf.requestModel.transportationModel.startAddress = info.address;
            weakSelf.requestModel.contactInfo.startAddress = info.address;
            weakSelf.requestModel.contactInfo.startID = info.ID;
            weakSelf.requestModel.contactInfo.startContacts = info.contacts;
            weakSelf.requestModel.contactInfo.startContactsPhone = info.contactsPhone;
            [weakSelf getData];
        }];
    };
    self.headerView.bottomBlock = ^{
        AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
        vc.title = @"送货地址";
        [weakSelf.navigationController pushViewController:vc animated:YES];
        [vc returnInfo:^(AddressInfo *info) {
            weakSelf.headerView.bottomAddressInfo = info;
            weakSelf.requestModel.transportationModel.endAddress = info.address;
            weakSelf.requestModel.contactInfo.endAddress = info.address;
            weakSelf.requestModel.contactInfo.endID = info.ID;
            weakSelf.requestModel.contactInfo.endContacts = info.contacts;
            weakSelf.requestModel.contactInfo.endContactsPhone = info.contactsPhone;
            [weakSelf getData];
        }];
    };
    self.payMenView.selectBlock = ^(NSString *title) {
        weakSelf.requestModel.payStyle = title;
        KNOrderCompleteTableViewCell *cell = (KNOrderCompleteTableViewCell *) [weakSelf.KNTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:5]];
        cell.contentLabel.text = title;
    };
    
    self.numCell.changeBlock = ^(NSString *num) {
        
        if ([num intValue] >=  self.requestModel.transport_minimum) {
            weakSelf.requestModel.boxNum = num;
            weakSelf.popView.boxNum = num;
            [weakSelf getData];
            [weakSelf.KNTableView reloadData];
        }else{
            [[Toast shareToast] makeText:@"不得少于最低起运数量" aDuration:1];
             weakSelf.requestModel.boxNum =[NSString stringWithFormat:@"%i",weakSelf.requestModel.transport_minimum];
            weakSelf.popView.boxNum =  weakSelf.requestModel.boxNum;
            [weakSelf getData];
            [weakSelf.KNTableView reloadData];
        }
        
        
    };
    self.serviceMenuView.selectBlock = ^(NSString *title) {
        if ([weakSelf.requestModel.serviceWay isEqualToString:title]) {
            return ;
        }
        weakSelf.requestModel.serviceWay = title;
        weakSelf.requestModel.contactInfo.startContacts = nil;
        weakSelf.requestModel.contactInfo.startAddress = nil;
        weakSelf.requestModel.contactInfo.startContactsPhone = nil;
        weakSelf.requestModel.contactInfo.endContacts = nil;
        weakSelf.requestModel.contactInfo.endContactsPhone = nil;
        weakSelf.requestModel.contactInfo.endAddress = nil;
//        KNOrderCompleteTableViewCell *cell = (KNOrderCompleteTableViewCell *) [weakSelf.KNTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
//        cell.contentLabel.text = title;
        /**
         DELIVERY_TYPE_POINT_POINT 无
         DELIVERY_TYPE_DOOR_POINT 上门取货
         DELIVERY_TYPE_POINT_DOOR 送货上门
         DELIVERY_TYPE_DOOR_DOOR 上门取货+送货上门
         */
        if ([title isEqualToString:@"无"]) {
            weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_POINT";
        }else if ([title isEqualToString:@"上门取货"]){
            weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_DOOR_POINT";
        }else if ([title isEqualToString:@"送货上门"]){
            weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_DOOR";
        }else if ([title isEqualToString:@"上门取货+送货上门"]){
            weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_DOOR_DOOR";
        }
        [weakSelf.KNTableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        [weakSelf getData];
    };
    self.datePicker.dateBlock = ^(NSString *dateStr) {
        KNOrderCompleteTableViewCell *cell = (KNOrderCompleteTableViewCell *) [weakSelf.KNTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        cell.contentLabel.text = dateStr;
        weakSelf.requestModel.carryGoodsTime = dateStr;
    };
    
#pragma mark -- 提交订单
    [[self.bottomView.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        
        if (isNullStr(weakSelf.requestModel.goodsInfo.name) && isNullStr(weakSelf.requestModel.noGoodsName)) {
            [[Toast shareToast] makeText:@"请选择运送货品" aDuration:1];
            return ;
        }
        if (isNullStr(weakSelf.requestModel.boxNum)) {
            [[Toast shareToast] makeText:@"请填写用箱数量" aDuration:1];
            return ;
        }
        if (isNullStr(weakSelf.requestModel.contactInfo.startContacts)) {
            [[Toast shareToast] makeText:@"请完善联系人信息" aDuration:1];
            return ;
        }
        if (isNullStr(weakSelf.requestModel.contactInfo.startContactsPhone)) {
            [[Toast shareToast] makeText:@"请完善联系人信息" aDuration:1];
            return ;
        }
        if (isNullStr(weakSelf.requestModel.contactInfo.endContactsPhone)) {
            [[Toast shareToast] makeText:@"请完善联系人信息" aDuration:1];
            return ;
        }
        if (isNullStr(weakSelf.requestModel.contactInfo.endContacts)) {
            [[Toast shareToast] makeText:@"请完善联系人信息" aDuration:1];
            return ;
        }
        if (isNullStr(weakSelf.requestModel.carryGoodsTime)) {
            [[Toast shareToast] makeText:@"请选择取货时间" aDuration:1];
            return ;
        }
        if (weakSelf.invoiceNum == 2) {
            if (!weakSelf.requestModel.invoice) {
                [[Toast shareToast] makeText:@"请选择发票信息" aDuration:1];
                return ;
            }
        }
        //用箱数量
        weakSelf.requestModel.boxNum = weakSelf.numCell.valueTextField.text;
        //备注信息
        weakSelf.requestModel.remark = weakSelf.remarkDescCell.textField.text;
        
        KNOrderSubmitVC *perfectVC = [[KNOrderSubmitVC alloc] init];
        perfectVC.isShowInvoice = weakSelf.invoiceNum == 2 ? YES : NO;
        perfectVC.requestModel = weakSelf.requestModel;
        perfectVC.detailModel = weakSelf.detailModel;
        perfectVC.transportModel = weakSelf.transportModel;
        [weakSelf.navigationController pushViewController:perfectVC animated:YES];
    }];
}

- (void)getData{
    self.requestModel.transportationModel = self.transportModel;
    //用箱数量
//    self.requestModel.boxNum = self.requestModel.boxNum;
    [[CapacityViewModel new] requestOrderPriceDataWithInfo:self.requestModel AndContainerModel:self.containerModel callback:^(PriceInfo *priceInfo) {
        self.bottomView.price = [NSString stringWithFormat:@"%@",priceInfo.orderTotalMoney];
        self.requestModel.priceInfo = priceInfo; 
        NSMutableArray *mutArr = [NSMutableArray array];
        [mutArr addObject:[NSString stringWithFormat:@"%.2f",self.containerModel.oneTicketTotal]];
        [mutArr addObject:priceInfo.startAdditionPrice];
        [mutArr addObject:priceInfo.endAdditionPrice];
        self.popView.priceArray = mutArr;
    }];
    
//    [[[CapacityViewModel alloc] init] requestOrderPriceDataWithInfo:self.requestModel callback:^(PriceInfo *priceInfo) {
//
//        self.bottomView.price = [NSString stringWithFormat:@"%@",priceInfo.orderTotalMoney];
//        self.requestModel.priceInfo = priceInfo;
//        NSMutableArray *mutArr = [NSMutableArray array];
//        [mutArr addObject:[NSString stringWithFormat:@"%.2f",self.containerModel.oneTicketTotal]];
//        [mutArr addObject:priceInfo.startAdditionPrice];
//        [mutArr addObject:priceInfo.endAdditionPrice];
//        self.popView.priceArray = mutArr;
//
//    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 6) {
        return self.invoiceNum;
    }else if (section == 7){
        return self.remarkNum;
    }else if (section ==2){
        return 2;
    }else if (section ==3){
//        if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_POINT"]) {
//            return 5;
//        }else if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_POINT"]){
//            return 4;
//        }else if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_DOOR"]){
//            return 4;
//        }else{
            return 3;
//        }
    }else if (section == 0){
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row ==0) {
            self.numCell.valueTextField.text = self.requestModel.boxNum;
            self.numCell.numberLabel.text = [NSString stringWithFormat:@"%i 箱起运",self.requestModel.transport_minimum];
            return self.numCell;
            
        }else{
            JisuanjiCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"JisuanjiCell" owner:self options:nil] firstObject];
            return cell;
        }
        
    }else if (indexPath.section == 6){
        if (indexPath.row == 0) {
            self.invoiceCell.switchButton.on = self.invoiceNum == 2;
            return self.invoiceCell;
        }else{
            KNOrderCompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNOrderCompleteTableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"发票类型";
            cell.contentLabel.textColor = [UIColor blackColor];
            if (self.requestModel.invoice) {
                if ([self.requestModel.invoice.type isEqualToString:@"INVOICE_TYPE_VALUE_ADD_TAX"]) {
                     cell.contentLabel.text = [NSString stringWithFormat:@"增值税 - %@", self.requestModel.invoice.title];
                }else{
                     cell.contentLabel.text = [NSString stringWithFormat:@"普通发票 - %@", self.requestModel.invoice.title];;
                }
            }else{
                cell.contentLabel.text = @"";
            }
            return cell;
        }
    }else if (indexPath.section == 7){
        if (indexPath.row == 0) {
            self.remarkCell.switchButton.on = self.remarkNum == 2;
            return self.remarkCell;
        }else{
            return self.remarkDescCell;
        }
    }else if (indexPath.section ==3){
        if (indexPath.row == 0) {
            KNOrderCompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNOrderCompleteTableViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = self.titleArray[indexPath.section];
            cell.contentLabel.text = self.requestModel.serviceWay;
            return cell;
        }else{
            if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_POINT"]) {
                OrderSelectNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSelectNoAddressCell class]) forIndexPath:indexPath];
                [cell setCapaModel:self.requestModel Index:indexPath.row type:self.requestModel.deliveryTypeCode];
                return cell;
            }else if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_POINT"]){
               
                if (indexPath.row ==1) {
                    OrderSelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSelectAddressCell class]) forIndexPath:indexPath];
                    [cell setCapaModel:self.requestModel Index:indexPath.row type:self.requestModel.deliveryTypeCode];
                    return cell;
                }else{
                     OrderSelectNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSelectNoAddressCell class]) forIndexPath:indexPath];
                    [cell setCapaModel:self.requestModel Index:indexPath.row type:self.requestModel.deliveryTypeCode];
                    return cell;
                }
            }else if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_DOOR"]){
                
                if (indexPath.row ==2) {
                    OrderSelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSelectAddressCell class]) forIndexPath:indexPath];
                    [cell setCapaModel:self.requestModel Index:indexPath.row type:self.requestModel.deliveryTypeCode];
                    return cell;
                }else{
                     OrderSelectNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSelectNoAddressCell class]) forIndexPath:indexPath];
                    [cell setCapaModel:self.requestModel Index:indexPath.row type:self.requestModel.deliveryTypeCode];
                    return cell;
                }
            }else{
                OrderSelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSelectAddressCell class]) forIndexPath:indexPath];
                [cell setCapaModel:self.requestModel Index:indexPath.row type:self.requestModel.deliveryTypeCode];
                return cell;
            }
//            OrderSelectAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderSelectAddressCell class]) forIndexPath:indexPath];
//            [cell setCapaModel:self.requestModel Index:indexPath.row type:self.requestModel.deliveryTypeCode];
//            return cell;

        }
    }
    else if (indexPath.section == 0){
        if (indexPath.row == 1) {
            NoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoGoodsCell class]) forIndexPath:indexPath];
            [cell setRequestModel:self.requestModel With:self.isNoGoodSelect];
            return cell;
        }
    }
    KNOrderCompleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNOrderCompleteTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArray[indexPath.section];
    if (indexPath.row == 0) {
        cell.contentLabel.text = self.requestModel.goodsInfo.name;
        cell.contentLabel.textColor = [UIColor blackColor];
    }
    if (indexPath.section == 1) {
//        if (self.detailModel.containerName) {
//            cell.contentLabel.text = self.detailModel.containerName;
//        }else{
//            cell.contentLabel.text = self.containerModel.containerName;
//        }
        cell.contentLabel.text = self.requestModel.box.name;
        cell.contentLabel.textColor = APP_COLOR_ORANGE;
        cell.arrowIcon.hidden = YES;
        
    }
    
    if (indexPath.section == 3) {
       cell.contentLabel.text = self.requestModel.serviceWay;
    }
    if (indexPath.section == 4) {
         cell.contentLabel.text = self.requestModel.carryGoodsTime;
    }
    if (indexPath.section == 5) {
       
        cell.contentLabel.text = self.requestModel.payStyle;
        cell.arrowIcon.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(weakSelf);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ZSSearchViewController *searchVC = [[ZSSearchViewController alloc] init];
            searchVC.vcDelegate = self;
            [self.navigationController pushViewController:searchVC animated:YES];
        }else{
            self.isNoGoodSelect = YES;
            [self.KNTableView reloadData];
        }
    }
    
    if (indexPath.section == 2) {
        
        if (self.requestModel.goodsInfo.name == nil || [self.requestModel.goodsInfo.name isEqualToString:@""]) {
            [[Toast shareToast] makeText:@"请先选择货品" aDuration:1];
        }else{
            CalculatorViewController * controller = [[CalculatorViewController alloc]initWithNibName:NSStringFromClass([CalculatorViewController class]) bundle:nil];
            controller.entryModel = self.requestModel;
            [controller setBlock:^(NSInteger boxNum) {
                self.requestModel.boxNum = [NSString stringWithFormat:@"%ld",(long)boxNum];
                self.popView.boxNum = [NSString stringWithFormat:@"%ld",(long)boxNum];
                self.numCell.valueTextField.text = [NSString stringWithFormat:@"%ld",(long)boxNum];
               
                [self getData];
                [self.KNTableView reloadData];
            }];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self.serviceMenuView show];
        }else{
            
            AddressManagerViewController * controller = [[AddressManagerViewController alloc]init];
            if (indexPath.row ==1) {
                controller.title = @"起运地";
            }else{
                controller.title = @"抵运地";
            }
            
            [controller returnInfo:^(AddressInfo *info) {
//                weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_POINT";
//            }else if ([title isEqualToString:@"上门取货"]){
//                weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_DOOR_POINT";
//            }else if ([title isEqualToString:@"送货上门"]){
//                weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_DOOR";
//            }else if ([title isEqualToString:@"上门取货+送货上门"]){
//                weakSelf.requestModel.deliveryTypeCode = @"DELIVERY_TYPE_DOOR_DOOR";
//            }
                if (indexPath.row == 1) {
                    if ([weakSelf.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_DOOR"] || [weakSelf.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_POINT"]) {
                        if (info.address.length) {
                            weakSelf.requestModel.transportationModel.startAddress = info.address;
                            weakSelf.requestModel.contactInfo.startAddress = info.address;
                        }else{
                            [[Toast shareToast] makeText:@"请选择带地址的联系人" aDuration:1];
                            return ;
                        }
                        
                    }
                    weakSelf.requestModel.contactInfo.startID = info.ID;
                    weakSelf.requestModel.contactInfo.startContacts = info.contacts;
                    weakSelf.requestModel.contactInfo.startContactsPhone = info.contactsPhone;
                    
                }else{
                    if ([weakSelf.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_DOOR"] || [weakSelf.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_DOOR"]) {
                        if (info.address.length) {
                            weakSelf.requestModel.transportationModel.endAddress = info.address;
                            weakSelf.requestModel.contactInfo.endAddress = info.address;
                        }else{
                            [[Toast shareToast] makeText:@"请选择带地址的联系人" aDuration:1];
                            return ;
                        }
                    }
                    weakSelf.headerView.bottomAddressInfo = info;
                    
                    weakSelf.requestModel.contactInfo.endID = info.ID;
                    weakSelf.requestModel.contactInfo.endContacts = info.contacts;
                    weakSelf.requestModel.contactInfo.endContactsPhone = info.contactsPhone;

                }
               
                [weakSelf getData];
                [weakSelf.KNTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            }];
            
            [self.navigationController pushViewController:controller animated:YES];
            
//            if ([self.requestModel.deliveryTypeCode  isEqualToString:@"DELIVERY_TYPE_POINT_POINT"]) {
//
//            }else if ([self.requestModel.deliveryTypeCode  isEqualToString:@"DELIVERY_TYPE_DOOR_POINT"]){
//                if (indexPath.row ==1) {
//                    AddressManagerViewController * controller = [[AddressManagerViewController alloc]init];
//                    controller.title = @"起运地";
//                    [controller returnInfo:^(AddressInfo *info) {
//                        //                    weakSelf.headerView.topAddressInfo = info;
//                        weakSelf.requestModel.transportationModel.startAddress = info.address;
//                        weakSelf.requestModel.contactInfo.startAddress = info.address;
//                        weakSelf.requestModel.contactInfo.startID = info.ID;
//                        weakSelf.requestModel.contactInfo.startContacts = info.contacts;
//                        weakSelf.requestModel.contactInfo.startContactsPhone = info.contactsPhone;
//                        [weakSelf getData];
//                        [weakSelf.KNTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    }];
//                    [self.navigationController pushViewController:controller animated:YES];
//                }
//            }else if ([self.requestModel.deliveryTypeCode  isEqualToString:@"DELIVERY_TYPE_POINT_DOOR"]){
//                if (indexPath.row ==3) {
//                    AddressManagerViewController * controller = [[AddressManagerViewController alloc]init];
//                    controller.title = @"抵运地";
//                    [controller returnInfo:^(AddressInfo *info) {
//                        weakSelf.headerView.bottomAddressInfo = info;
//                        weakSelf.requestModel.transportationModel.endAddress = info.address;
//                        weakSelf.requestModel.contactInfo.endAddress = info.address;
//                        weakSelf.requestModel.contactInfo.endID = info.ID;
//                        weakSelf.requestModel.contactInfo.endContacts = info.contacts;
//                        weakSelf.requestModel.contactInfo.endContactsPhone = info.contactsPhone;
//                        [weakSelf getData];
//                        [weakSelf.KNTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//                    }];
//                    [self.navigationController pushViewController:controller animated:YES];
//                }
//            }else if ([self.requestModel.deliveryTypeCode  isEqualToString:@"DELIVERY_TYPE_DOOR_DOOR"]){
//
//                AddressManagerViewController * controller = [[AddressManagerViewController alloc]init];
//                [controller returnInfo:^(AddressInfo *info) {
//                    if (indexPath.row ==1) {
//                        controller.title = @"起运地";
//                        weakSelf.requestModel.transportationModel.startAddress = info.address;
//                        weakSelf.requestModel.contactInfo.startAddress = info.address;
//                        weakSelf.requestModel.contactInfo.startID = info.ID;
//                        weakSelf.requestModel.contactInfo.startContacts = info.contacts;
//                        weakSelf.requestModel.contactInfo.startContactsPhone = info.contactsPhone;
//
//                    }else{
//                        controller.title = @"抵运地";
//                        weakSelf.headerView.bottomAddressInfo = info;
//                        weakSelf.requestModel.transportationModel.endAddress = info.address;
//                        weakSelf.requestModel.contactInfo.endAddress = info.address;
//                        weakSelf.requestModel.contactInfo.endID = info.ID;
//                        weakSelf.requestModel.contactInfo.endContacts = info.contacts;
//                        weakSelf.requestModel.contactInfo.endContactsPhone = info.contactsPhone;
//
//                    }
//                    [weakSelf getData];
//                    [weakSelf.KNTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
//                }];
//                [self.navigationController pushViewController:controller animated:YES];
//            }
        }
    }
    if (indexPath.section == 4) {
         [self.datePicker show];
    }
    if (indexPath.section == 5) {
       
//        [self.payMenView show];
    }
    if (indexPath.section == 6) {
        if (indexPath.row == 1) {
            InvoiceListViewController *vc  =[InvoiceListViewController new];
            vc.currentmodel = self.requestModel.invoice;
            [self.navigationController pushViewController:vc animated:YES];
            WS(ws);
            //选择发票回调发票
            [vc returnText:^(InvoiceModel *invoiceModel) {
                if (invoiceModel) {
//                    KNOrderCompleteTableViewCell *cell = (KNOrderCompleteTableViewCell *) [self.KNTableView cellForRowAtIndexPath:indexPath];
//                    if ([self.requestModel.invoice.type isEqualToString:@"INVOICE_TYPE_VALUE_ADD_TAX"]) {
//                        cell.contentLabel.text = [NSString stringWithFormat:@"增值税 - %@", invoiceModel.title];
//                    }else{
//                        cell.contentLabel.text = [NSString stringWithFormat:@"普通发票 - %@", invoiceModel.title];;
//                    }
//                    cell.contentLabel.text = invoiceModel.title;
                    //获取参数 发票信息
                    ws.defaultInvoceModel = invoiceModel;
                    ws.requestModel.invoice = ws.defaultInvoceModel;
                    [ws.KNTableView reloadData];
                }
            }];
        }
    }
}

#pragma mark --返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 44;
        }else{
            if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_POINT"]) {
                
                return 50;
                
            }else if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_POINT"]){
                if (indexPath.row ==1) {
                    return UITableViewAutomaticDimension;
                }else{
                    return 50.0f;
                }
            }else if ([self.requestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_DOOR"]){
                if (indexPath.row ==1) {
                    return 50;
                }else{
                    return UITableViewAutomaticDimension;
                }
            }else{
                return UITableViewAutomaticDimension;
            }
        }
    }else{
        return 44;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    sectionHeader.contentView.backgroundColor = APP_COLOR_WHITE_BG;
    return sectionHeader;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *sectionFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    sectionFooter.contentView.backgroundColor = APP_COLOR_WHITE_BG;
    return sectionFooter;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == self.titleArray.count - 1) {
        return 44;
    }
    return CGFLOAT_MIN;
}

#pragma mark -- ZSSearchViewControllerDelegate
- (void)getGood:(GoodsInfo *)goods{
    KNOrderCompleteTableViewCell *cell = (KNOrderCompleteTableViewCell *)[self.KNTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.contentLabel.text = goods.name;
    //获取参数 货品信息
    self.requestModel.goodsInfo = goods;
    
}

- (void)setDetailModel:(TicketsDetailModel *)detailModel {
    _detailModel = detailModel;
    self.headerView.ticketDetailModel = detailModel;
}

- (void)setTransportModel:(TransportationModel *)transportModel {
    _transportModel = transportModel;
    self.headerView.transportModel = transportModel;
}

#pragma mark -- Getter
- (UITableView *)KNTableView {
    if (!_KNTableView) {
        _KNTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-kNavBarHeaderHeight-kiPhoneFooterHeight-50) style:UITableViewStyleGrouped];
        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        _KNTableView.rowHeight = UITableViewAutomaticDimension;
        _KNTableView.estimatedRowHeight = 60.0f;
        _KNTableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNOrderCompleteTableViewCell" bundle:nil] forCellReuseIdentifier:@"KNOrderCompleteTableViewCell"];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderComplete_P_T_PCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderComplete_P_T_PCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderSelectAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderSelectAddressCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderSelectNoAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderSelectNoAddressCell class])];
        [_KNTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoGoodsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([NoGoodsCell class])];
    }
    return _KNTableView;
}

- (KNOrderCompleteHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[KNOrderCompleteHeaderView alloc] init];
        _headerView.frame = CGRectMake(0, 0, SCREEN_W, 110);
    }
    return _headerView;
}

- (KNTableViewNumberCell *)numCell{
    if (!_numCell) {
        _numCell = [[NSBundle mainBundle] loadNibNamed:@"KNTableViewNumberCell" owner:self options:nil][0];
        _numCell.nameLabel.text = @"用箱数量";
        _numCell.nameLabel.font = [UIFont systemFontOfSize:14];
        _numCell.nameLabeLeft.constant = 20;
        _numCell.valueTextField.text = self.requestModel.boxNum;
    }
    return _numCell;
}
- (KNOrderCompleteOtherCell *)invoiceCell{
    if (!_invoiceCell) {
        _invoiceCell = [[NSBundle mainBundle] loadNibNamed:@"KNOrderCompleteOtherCell" owner:self options:nil][1];
        _invoiceCell.titleLabel.text = @"发票信息";
    }
    return _invoiceCell;
}
- (KNOrderCompleteOtherCell *)remarkCell{
    if (!_remarkCell) {
        _remarkCell = [[NSBundle mainBundle] loadNibNamed:@"KNOrderCompleteOtherCell" owner:self options:nil][1];
        _remarkCell.titleLabel.text = @"备注信息";
    }
    return _remarkCell;
}
- (KNOrderCompleteOtherCell *)remarkDescCell{
    if (!_remarkDescCell) {
        _remarkDescCell = [[NSBundle mainBundle] loadNibNamed:@"KNOrderCompleteOtherCell" owner:self options:nil][2];
        _remarkDescCell.textField.text = self.requestModel.remark;
    }
    return _remarkDescCell;
}

- (KNOrderCompleteBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"KNOrderCompleteBottomView" owner:self options:nil][0];
        _bottomView.frame = CGRectMake(0, SCREEN_H-kiPhoneFooterHeight-kNavBarHeaderHeight - 50, SCREEN_W, 50);
    }
    return _bottomView;
}

- (KNOrderCompletePopDetailView *)popView{
    if (!_popView) {
        _popView = [[KNOrderCompletePopDetailView alloc] initWithFrame:CGRectZero];
    }
    return _popView;
}

- (KNOrderCompleteMenuPopView *)payMenView{
    if (!_payMenView) {
        _payMenView = [[KNOrderCompleteMenuPopView alloc] initWithFrame:CGRectZero Array:@[@"预付款",@"后付款"]];
    }
    return _payMenView;
}

- (KNOrderCompleteMenuPopView *)serviceMenuView{
    if (!_serviceMenuView) {
        _serviceMenuView = [[KNOrderCompleteMenuPopView alloc] initWithFrame:CGRectZero Array:@[@"无",@"上门取货",@"送货上门",@"上门取货+送货上门"]];
    }
    return _serviceMenuView;
}

- (KNOrderCompleteDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[KNOrderCompleteDatePicker alloc] initWithFrame:CGRectZero];
    }
    return _datePicker;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"货品名称",@"箱型规格",@"用箱数量",@"请选择送货类型",@"取货时间",@"支付类型",@"发票信息",@"备注"];
    }
    return _titleArray;
}
- (CapacityEntryModel *)requestModel{
    if (!_requestModel) {
        _requestModel = [[CapacityEntryModel alloc] init];
    }
    return _requestModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
