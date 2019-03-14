//
//  KNCustomTransportVC.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNCustomTransportVC.h"
#import "KNCustomFilterPopView.h"
#import "CapacityViewModel.h"
#import "KNTableViewTypeChooseCell.h"
#import "KNTableViewTextFieldCell.h"
#import "KNTableViewBigCell.h"
#import "KNTableViewNumberCell.h"
#import "KNTableViewUserInfoCell.h"
#import "KNTableViewTipsCell.h"
#import "KNTableViewTransportHeaderView.h"
#import "AddressManagerViewController.h"
#import <Masonry.h>
#import "CalendarView.h"
#import "SetAddressViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ZSSearchViewController.h"
#import "KNCustomSelectSpecVC.h"
#import "ZCCityListViewController.h"
#import "OrderTransportSuccessViewController.h"
#import "TransportCell.h"
#import "ZiXunCell.h"
#import "MLNavigationController.h"
#import "NSString+Money.h"
#import "YMKJVerificationTools.h"
#import "NoGoodsCell.h"
#import "OrderSelectNoAddressCell.h"
#import "OrderSelectAddressCell.h"
#import "KNOrderCompleteTableViewCell.h"
#import "KNOrderCompleteMenuPopView.h"
#import "StatrAndCell.h"

@interface KNCustomTransportVC ()<UITableViewDelegate, UITableViewDataSource,chooseDateDelegate,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,ZSSearchViewControllerDelegate>

@property (nonatomic, assign) BOOL ceshi1;
@property (nonatomic, assign) BOOL ceshi2;

@property (nonatomic, strong) KNCustomFilterPopView *menuView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *filterTypeDic;
@property (nonatomic, assign) kKNCustomFilterType filterType;

@property (nonatomic, strong) CapacityViewModel *viewModel;
@property (nonatomic, strong) CapacityViewModel *reRequestModel;
@property (nonatomic, strong) GoodsInfo *goods;

@property (nonatomic, strong) ContainerTypeModel *containModel;//箱型

@property (nonatomic, strong)AddressInfo * startAddreaaInfo;
@property (nonatomic, strong)AddressInfo * endAddreaaInfo;
//上门服务弹框
@property (nonatomic, strong) KNOrderCompleteMenuPopView *serviceMenuView;
//@property (nonatomic, assign) BOOL isNoGoodsSelect;

@property (nonatomic, strong) CityModel * defaultModel;
@end

@implementation KNCustomTransportVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isClearCapModel) {
        self.reRequestModel = nil;
        
        self.goods = nil;
        self.startAddreaaInfo = nil;
        self.endAddreaaInfo = nil;
        self.containModel = nil;
        //        TransportCell * cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
        //        TransportCell * cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:4]];
        //        cell1.info = nil;
        //        cell2.info = nil;
        //        cell1 = NULL;
        //        cell2 = NULL;
        self.ceshi1 = NO;
        self.ceshi2 = NO;
        self.filterTypeDic = @{
                               @"code":@"BUSINESS_TYPE_CONTAINER",
                               @"name":@"集装箱"
                               };
        
        self.reRequestModel.businessTypeCode = @"BUSINESS_TYPE_CONTAINER";
        self.reRequestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_POINT";
        self.reRequestModel.serviceWay = @"无";
        self.filterType = kKNCustomFilterTypeCONTAINER;
        [self.tableView reloadData];
        app.isClearCapModel = NO;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"定制运力";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    
    [self.view addSubview:self.tableView];
    
    self.defaultModel = [CityModel new];
    self.defaultModel.name = @"唐山";
    self.defaultModel.code = @"130200";
    
    self.btnLeft.hidden = !_isNotTabBarSubVC;
    self.btnRight.hidden = NO;
    [self.btnRight setTitle:@"提交" forState:UIControlStateNormal];
    self.reRequestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_POINT";
    self.reRequestModel.serviceWay = @"无";
    self.filterTypeDic = @{
                           @"code":@"BUSINESS_TYPE_CONTAINER",
                           @"name":@"集装箱"
                           };
    
    self.reRequestModel.businessTypeCode = @"BUSINESS_TYPE_CONTAINER";
    self.filterType = kKNCustomFilterTypeCONTAINER;
    [self.tableView reloadData];
    // 设置默认
    if (self.requestModel) {
        self.reRequestModel.startRegionName = self.requestModel.startPlace.name;
        self.reRequestModel.endRegionName = self.requestModel.endPlace.name;
        self.reRequestModel.startRegionCode = self.requestModel.startPlace.code;
        self.reRequestModel.endRegionCode = self.requestModel.endPlace.code;
    }
    
    
    
    
    
    __weak typeof(self) weakSelf = self;
    self.menuView.selectBlock = ^(NSDictionary *dict, kKNCustomFilterType filterType) {
        if(weakSelf.filterType == filterType)
            return;
        
        weakSelf.goods = nil;
        weakSelf.containModel = nil;
        weakSelf.reRequestModel.isNoGoodSelect = NO;
        weakSelf.reRequestModel.noGoodName =@"";
        weakSelf.reRequestModel.containerNumber = [@"" intValue];
        weakSelf.reRequestModel.vehicleNum =      [@"" intValue];
        weakSelf.reRequestModel.weight =          [@"" intValue];
        weakSelf.reRequestModel.wrapperNumber =   [@"" intValue];
        weakSelf.reRequestModel.unitMaxLength =   [@"" intValue];
        weakSelf.reRequestModel.unitMaxWidth =    [@"" intValue];
        weakSelf.reRequestModel.unitMaxHigh =     [@"" intValue];
        weakSelf.reRequestModel.vehicleType =     @"";
        weakSelf.reRequestModel.containerId =     [@"" intValue];
        weakSelf.reRequestModel.unitMaxWeight =   [@"" intValue];
        weakSelf.reRequestModel.businessTypeCode = [dict objectForKey:@"code"];
        weakSelf.filterTypeDic = dict;
        weakSelf.filterType = filterType;
        
        [weakSelf.tableView reloadData];
        
    };
    
    
}


#pragma mark- Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRow = 0;
    switch (self.filterType) {
        case kKNCustomFilterTypeCONTAINER://集装箱
            //            case kKNCustomFilterTypeVECHICLE://商品车
        {
            switch (section) {
                case 0:
                    numberOfRow = 1;
                    break;
                case 1:
                    //                    case 3:
                    numberOfRow = 4;
                    break;
                case 2:
                    numberOfRow = 1;
                    break;
                case 3:
                    numberOfRow = 2;
                    break;
                case 4:
                    numberOfRow = 4;
                    
            }
        }
            break;
        case kKNCustomFilterTypeBULK_STACK://散堆装
        {
            switch (section) {
                case 0:
                    numberOfRow = 1;
                    break;
                case 1:
                    numberOfRow = 4;
                    break;
                case 2:
                    numberOfRow = 1;
                    break;
                case 3:
                    numberOfRow = 2;
                    break;
                    //                    case 3:
                case 4:
                    numberOfRow = 4;
            }
        }
            break;
        case kKNCustomFilterTypeLARGE_SIZE://大件
        {
            switch (section) {
                case 0:
                    numberOfRow = 1;
                    break;
                case 1:
                    numberOfRow = 5;
                    break;
                case 2:
                    numberOfRow = 1;
                    break;
                case 3:
                    numberOfRow = 2;
                    break;
                    //                    case 3:
                case 4:
                    numberOfRow = 4;
            }
        }
            break;
        case kKNCustomFilterTypeOther://其他
        {
            switch (section) {
                case 0:
                    numberOfRow = 1;
                    break;
                case 1:
                    numberOfRow = 2;
                    break;
                case 2:
                    numberOfRow = 1;
                    break;
                case 3:
                    numberOfRow = 2;
                    break;
                    //                    case 3:
                case 4:
                    numberOfRow = 4;
            }
        }
            break;
    }
    return numberOfRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            if (self.ceshi1) {
                return UITableViewAutomaticDimension;
            }else{
                return 60.0f;
            }
        }else if (indexPath.row == 1) {
            if (self.ceshi2) {
                return UITableViewAutomaticDimension;
            }else{
                return 60.0f;
            }
        }else if(indexPath.row == 2){
            return 160;
        }else{
            return 60.0f;
        }
        
    }else{
        
        if (self.filterType == kKNCustomFilterTypeLARGE_SIZE) {
            if (indexPath.row == 4) {
                return 88.0f;
            }else{
                return UITableViewAutomaticDimension;
            }
        }
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            KNTableViewTypeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTypeChooseCell" forIndexPath:indexPath];
            cell.nameLabel.text = @"请选择类型";
            cell.nameValueLabel.text =  [self.filterTypeDic objectForKey:@"name"];
            return cell;
        }
            break;
            
        case 1:
        {
            switch (self.filterType) {
                case kKNCustomFilterTypeCONTAINER:
                {
                    switch (indexPath.row) {
                        case 0:
                        {
                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"货品名称";
                            cell.nameTextField.placeholder = @"输入货品名";
                            cell.nameTextField.enabled = NO;
                            cell.nameTextField.text = self.goods.name;
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            NoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoGoodsCell class]) forIndexPath:indexPath];
                            [cell setCapacityViewModelRequestModel:self.reRequestModel With:self.reRequestModel.isNoGoodSelect];
                            return cell;
                        }
                            break;
                        case 2:
                        {
                            KNTableViewTypeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTypeChooseCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"箱型规格";
                            cell.nameValueLabel.textAlignment = NSTextAlignmentLeft;
                            cell.nameValueLabel.text = self.containModel.name;
                            return cell;
                        }
                            break;
                        case 3:
                        {
                            KNTableViewNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewNumberCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"用箱数量";
                            cell.reRequestModel = self.reRequestModel;
                            cell.valueTextField.text = [NSString stringWithFormat:@"%ld",self.reRequestModel.containerNumber];
                            return cell;
                        }
                            break;
                    }
                }
                    break;
                    //                    case kKNCustomFilterTypeVECHICLE:
                    //                {
                    //                    switch (indexPath.row) {
                    //                            case 0:
                    //                        {
                    //                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                    //                            cell.nameLabel.text = @"品牌";
                    //                            cell.nameTextField.placeholder = @"输入品牌名";
                    //                            cell.nameTextField.keyboardType = UIKeyboardTypeDefault;
                    //                            cell.nameTextField.enabled = YES;
                    //                            cell.nameTextField.text = self.goods.name;
                    //                            [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
                    //                            return cell;
                    //                        }
                    //                            break;
                    ////                            case 1:
                    ////                        {
                    ////                            NoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoGoodsCell class]) forIndexPath:indexPath];
                    ////                            [cell setCapacityViewModelRequestModel:self.reRequestModel With:self.reRequestModel.isNoGoodSelect];
                    ////                            return cell;
                    ////                        }
                    ////                            break;
                    //                            case 1:
                    //                        {
                    //                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                    //                            cell.nameLabel.text = @"车型";
                    //                            cell.nameTextField.placeholder = @"输入车型";
                    //                            cell.nameTextField.keyboardType = UIKeyboardTypeDefault;
                    //                            cell.nameTextField.enabled = YES;
                    //
                    //                            [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
                    //                            return cell;
                    //                        }
                    //                            break;
                    //                            case 2:
                    //                        {
                    //                            KNTableViewNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewNumberCell" forIndexPath:indexPath];
                    //                            cell.nameLabel.text = @"数量(台)";
                    //                            cell.valueTextField.text = [NSString stringWithFormat:@"%ld",self.reRequestModel.vehicleNum];
                    //
                    //                            return cell;
                    //                        }
                    //                            break;
                    //                    }
                    //                }
                    //                    break;
                case kKNCustomFilterTypeBULK_STACK:
                {
                    switch (indexPath.row) {
                        case 0:
                        {
                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"货品名称";
                            cell.nameTextField.placeholder = @"输入货品名";
                            cell.nameTextField.enabled = NO;
                            cell.nameTextField.text = self.goods.name;
                            [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            NoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoGoodsCell class]) forIndexPath:indexPath];
                            [cell setCapacityViewModelRequestModel:self.reRequestModel With:self.reRequestModel.isNoGoodSelect];
                            return cell;
                        }
                            break;
                        case 2:
                        {
                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"总体积(m³)";
                            cell.nameTextField.placeholder = @"输入总体积";
                            cell.nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
                            cell.nameTextField.enabled = YES;
                            if (self.reRequestModel.m3 >0) {
                                cell.nameTextField.text = [NSString stringWithFormat:@"%.0f", self.reRequestModel.m3] ;
                            }else{
                                cell.nameTextField.text = @"";
                            }
                            [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
                            return cell;
                            
                        }
                            break;
                        case 3:
                        {
                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"总重量(吨)";
                            cell.nameTextField.placeholder = @"输入总重量";
                            cell.nameTextField.keyboardType = UIKeyboardTypeDecimalPad;
                            cell.nameTextField.enabled = YES;
                            if (self.reRequestModel.weight>0) {
                                cell.nameTextField.text = [NSString stringWithFormat:@"%.0f", self.reRequestModel.weight] ;
                            }else{
                                cell.nameTextField.text = @"";
                            }
                            
                            [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
                            return cell;
                            
                        }
                    }
                }
                    break;
                case kKNCustomFilterTypeLARGE_SIZE:
                {
                    switch (indexPath.row) {
                        case 0:
                        {
                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"货品名称";
                            cell.nameTextField.placeholder = @"输入品牌名";
                            cell.nameTextField.enabled = NO;
                            cell.nameTextField.text = self.goods.name;
                            [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            NoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoGoodsCell class]) forIndexPath:indexPath];
                            [cell setCapacityViewModelRequestModel:self.reRequestModel With:self.reRequestModel.isNoGoodSelect];
                            return cell;
                        }
                            break;
                        case 2:
                        {
                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"总重量(吨)";
                            cell.nameTextField.placeholder = @"输入总重量";
                            cell.nameTextField.keyboardType = UIKeyboardTypeNumberPad;
                            cell.nameTextField.enabled = YES;
                            if (self.reRequestModel.weight>0) {
                                cell.nameTextField.text = [NSString stringWithFormat:@"%.2f",self.reRequestModel.weight];
                            }else{
                                cell.nameTextField.text = @"";
                            }
                            [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
                            return cell;
                        }
                            break;
                        case 3:
                        {
                            KNTableViewNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewNumberCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"件数";
                            cell.valueTextField.text = [NSString stringWithFormat:@"%ld",self.reRequestModel.wrapperNumber];
                            return cell;
                        }
                            break;
                        case 4:
                        {
                            KNTableViewBigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewBigCell" forIndexPath:indexPath];
                            if (self.reRequestModel.unitMaxLength>0) {
                                cell.longTF.text = [NSString stringWithFormat:@"%.2f",self.reRequestModel.unitMaxLength];
                            }else{
                                cell.longTF.text = @"";
                            }
                            if (self.reRequestModel.unitMaxWidth>0) {
                                cell.widthTF.text = [NSString stringWithFormat:@"%.2f",self.reRequestModel.unitMaxWidth];
                            }else{
                                cell.widthTF.text = @"";
                            }
                            if (self.reRequestModel.unitMaxHigh>0) {
                                cell.heightTF.text = [NSString stringWithFormat:@"%.2f",self.reRequestModel.unitMaxHigh];
                            }else{
                                cell.heightTF.text = @"";
                            }
                            if (self.reRequestModel.unitMaxWeight>0) {
                                cell.weightTF.text = [NSString stringWithFormat:@"%.2f",self.reRequestModel.unitMaxWeight];
                            }else{
                                cell.weightTF.text = @"";
                            }
                            cell.reRequestModel = self.reRequestModel;
                            return cell;
                        }
                            break;
                    }
                }
                    break;
                case kKNCustomFilterTypeOther:
                {
                    switch (indexPath.row) {
                        case 0:
                        {
                            KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                            cell.nameLabel.text = @"货品名称";
                            cell.nameTextField.placeholder = @"输入货品名";
                            cell.nameTextField.enabled = NO;
                            cell.nameTextField.text = self.goods.name;
                            return cell;
                        }
                            break;
                        case 1:
                        {
                            NoGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NoGoodsCell class]) forIndexPath:indexPath];
                            [cell setCapacityViewModelRequestModel:self.reRequestModel With:self.reRequestModel.isNoGoodSelect];
                            return cell;
                        }
                            break;
                    }
                }
                    break;
            }
        }
            break;
        case 2:
        {
            KNTableViewUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewUserInfoCell" forIndexPath:indexPath];
            cell.reRequestModel = self.reRequestModel;
            cell.mobileTextField.keyboardType = UIKeyboardTypePhonePad;
            cell.nameTextField.text = self.reRequestModel.contacts;
            cell.mobileTextField.text = self.reRequestModel.contactsPhone;
            WS(weakSelf)
            [[cell.concatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [weakSelf addPhoneBookView];
            }];
            return cell;
        }
            break;
            //        case 3:
            //        {
            //            switch (indexPath.row) {
            //                case 0:
            //                {
            //                    KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
            //                    cell.nameLabel.text = @"收货人        ";
            //
            //                    cell.nameTextField.placeholder = @"输入收货人";
            //                    cell.nameTextField.enabled = YES;
            //                    cell.nameTextField.text = self.reRequestModel.shouPerson;
            //                    [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
            //                    return cell;
            //
            //                }
            //                    break;
            //                case 1:
            //                {
            //                    KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
            //                    cell.nameLabel.text = @"收货人电话";
            //                    cell.nameTextField.placeholder = @"输入收货人电话";
            //                    cell.nameTextField.enabled = YES;
            //                    cell.nameTextField.text = self.reRequestModel.shouTel;
            //                    [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
            //                    return cell;
            //                }
            //                    break;
            //                case 2:
            //                {
            //                    KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
            //                    cell.nameLabel.text = @"发货人        ";
            //                    cell.nameTextField.placeholder = @"输入发货人";
            //                    cell.nameTextField.enabled = YES;
            //                    cell.nameTextField.text = self.reRequestModel.faPerson;
            //                    [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
            //                    return cell;
            //
            //                }
            //                    break;
            //                case 3:
            //                {
            //                    KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
            //                    cell.nameLabel.text = @"发货人电话";
            //                    cell.nameTextField.placeholder = @"输入发货人电话";
            //                    cell.nameTextField.enabled = YES;
            //                    cell.nameTextField.text = self.reRequestModel.faTel;
            //                    [cell setGoods:self.goods reRequestModel:self.reRequestModel section:indexPath.section index:indexPath.row];
            //                    return cell;
            //                }
            //            }
            //        }
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    StatrAndCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StatrAndCell" forIndexPath:indexPath];
                    [cell.statrBtn setTitle:self.reRequestModel.startRegionName forState:UIControlStateNormal];
                    [cell.endBtn setTitle:self.reRequestModel.endRegionName forState:UIControlStateNormal];
                    [cell setFildBlock:^(int tag) {
                        if (tag ==1 ||tag ==2) {
                            ZCCityListViewController * vc = [[ZCCityListViewController alloc] init];
                            vc.fromNaviC = NO;
                            vc.completeBlock = ^(CityModel *model) {
                                //                    KNTableViewTextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                                //                    cell.nameTextField.text = model.name;
                                //获取参数
                                //                    self.viewModel.startRegionCode = model.code;
                                if (tag == 1) {
                                    self.reRequestModel.startRegionName = model.name;
                                    self.reRequestModel.startRegionCode = model.code;
//                                    self.reRequestModel.endRegionName = self.defaultModel.name;
//                                    self.reRequestModel.endRegionCode = self.defaultModel.code;
                                    [self.tableView reloadData];
                                }
                                if (tag == 2) {
                                    self.reRequestModel.endRegionName = model.name;
                                    self.reRequestModel.endRegionCode = model.code;
//                                    self.reRequestModel.startRegionName = self.defaultModel.name;
//                                    self.reRequestModel.startRegionCode = self.defaultModel.code;
                                    [self.tableView reloadData];
                                }
                                
                            };
                            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
                        }else{
                            NSString * tempName = self.reRequestModel.startRegionName;
                            NSString * tempCode = self.reRequestModel.startRegionCode;
                            self.reRequestModel.startRegionName = self.reRequestModel.endRegionName;
                            self.reRequestModel.startRegionCode = self.reRequestModel.endRegionCode;
                            self.reRequestModel.endRegionName = tempName;
                            self.reRequestModel.endRegionCode = tempCode;
                            [self.tableView reloadData];
                        }
                        
                    }];
                    //                    cell.nameLabel.text = @"起运地点";
                    //                    cell.nameTextField.placeholder = @"输入起运地";
                    //                    cell.nameTextField.enabled = NO;
                    //                    cell.nameTextField.text = self.reRequestModel.startRegionName;
                    return cell;
                    
                }
                    break;
                    //                    case 1:
                    //                {
                    //                    KNTableViewTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTextFieldCell" forIndexPath:indexPath];
                    //                    cell.nameLabel.text = @"抵运地点";
                    //                    cell.nameTextField.placeholder = @"输入抵运地";
                    //                    cell.nameTextField.enabled = NO;
                    //                    cell.nameTextField.text = self.reRequestModel.endRegionName;
                    //                    return cell;
                    //                }
                    //                    break;
                case 1:
                {
                    KNTableViewTypeChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTypeChooseCell" forIndexPath:indexPath];
                    cell.nameLabel.text = @"发货日期";
                    cell.nameValueLabel.textAlignment = NSTextAlignmentLeft;
                    if ([self.reRequestModel.estimateDepartureTime intValue] == 0) {
                        cell.nameValueLabel.text = @"";
                    }else{
                        cell.nameValueLabel.text =  [NSString TimeGetDate:self.reRequestModel.estimateDepartureTime] ;
                    }
                    return cell;
                }
                    break;
            }
        }
            break;
        case 4:
        {
            switch (indexPath.row) {
                case 0:
                case 1:
                {
                    TransportCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TransportCell class]) forIndexPath:indexPath];
                    __weak typeof(self)WeakSelf = self;
                    [cell setBlcok:^(NSInteger row, BOOL isShow) {
                        NSIndexPath *indexPath;
                        if (row ==0) {
                            WeakSelf.ceshi1 = !WeakSelf.ceshi1;
                            if (!self.ceshi1) {
                                self.startAddreaaInfo = nil;
                                
                                //获取参数
                                self.reRequestModel.startPhone = nil;
                                self.reRequestModel.startAddress = nil;
                                self.reRequestModel.startContacts = nil;
                            }
                            indexPath=[NSIndexPath indexPathForRow:row inSection:4];
                        }else{
                            
                            WeakSelf.ceshi2 = !WeakSelf.ceshi2;
                            if (!self.ceshi2) {
                                self.endAddreaaInfo = nil;
                                
                                //获取参数
                                self.reRequestModel.endPhone = nil;
                                self.reRequestModel.endAddress = nil;
                                self.reRequestModel.endContacts = nil;
                            }
                            indexPath=[NSIndexPath indexPathForRow:row inSection:4];
                        }
                        
                        [WeakSelf.tableView reloadData];
                        
                    }];
                    
                    if (indexPath.row ==0) {
                        [cell setIndexSectionAndIndexRow:indexPath.section row:indexPath.row And:self.ceshi1 addressInfo:self.startAddreaaInfo];
                    }else if (indexPath.row == 1){
                        [cell setIndexSectionAndIndexRow:indexPath.section row:indexPath.row And:self.ceshi2 addressInfo:self.endAddreaaInfo];
                    }
                    return cell;
                    
                }
                    break;
                    
                case 2:
                {
                    KNTableViewTipsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNTableViewTipsCell" forIndexPath:indexPath];
                    return cell;
                }
                    break;
                case 3:
                {
                    ZiXunCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZiXunCell" forIndexPath:indexPath];
                    return cell;
                }
                    break;
            }
        }
            break;
    }
    
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return CGFLOAT_MIN;
    }
    
    return 30.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 4){
        return CGFLOAT_MIN;
    }
    return 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return nil;
    }
    
    KNTableViewTransportHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"KNTableViewTransportHeaderView"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    view.backgroundColor = [UIColor whiteColor];
    headView.backgroundView = view;
    switch (section) {
        case 1:
            headView.headerTitleLabel.text = @"货品信息";
            break;
        case 2:
            headView.headerTitleLabel.text = @"联系人信息";
            break;
            //            case 3:
            //                headView.headerTitleLabel.text = @"收/发货人信息";
            //                break;
        case 3:
            headView.headerTitleLabel.text = @"发运信息";
            break;
        case 4:
            headView.headerTitleLabel.text = @"上门服务";
            break;
    }
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 13)];
    view.backgroundColor = APP_COLOR_WHITE_BTN;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        [self.view endEditing:YES];
        [self.menuView show];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (self.filterType == kKNCustomFilterTypeCONTAINER || self.filterType == kKNCustomFilterTypeBULK_STACK || self.filterType == kKNCustomFilterTypeOther || self.filterType == kKNCustomFilterTypeLARGE_SIZE) {
                ZSSearchViewController *searchVC = [[ZSSearchViewController alloc] init];
                searchVC.vcDelegate = self;
                [self.navigationController pushViewController:searchVC animated:YES];
            }
        }
        else if (indexPath.row == 1){
            self.reRequestModel.isNoGoodSelect = YES;
            [self.tableView reloadData];
            
        }
        else if (indexPath.row == 2){
            if (self.filterType == kKNCustomFilterTypeCONTAINER) {
                KNCustomSelectSpecVC *selectSpecVC = [[KNCustomSelectSpecVC alloc] init];
                selectSpecVC.completeBlock = ^(ContainerTypeModel *model) {
                    //                    KNTableViewTypeChooseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                    //                    cell.nameValueLabel.text = model.name;
                    //获取参数 箱型id
                    self.reRequestModel.containerId = [model.ID integerValue];
                    self.containModel = model;
                    [self.tableView reloadData];
                };
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:selectSpecVC]  animated:YES completion:nil];
            }
        }
        
    }
    
    if(indexPath.section == 3) {
        
        //        switch (indexPath.row) {
        //                case 0:
        //            {
        //                ZCCityListViewController * vc = [[ZCCityListViewController alloc] init];
        //                vc.fromNaviC = NO;
        //                vc.completeBlock = ^(CityModel *model) {
        ////                    KNTableViewTextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ////                    cell.nameTextField.text = model.name;
        //                    //获取参数
        ////                    self.viewModel.startRegionCode = model.code;
        //                    self.reRequestModel.startRegionName = model.name;
        //                    self.reRequestModel.startRegionCode = model.code;
        //                    [self.tableView reloadData];
        //                };
        //                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
        //            }
        //                break;
        //                case 1:
        //                {
        //                    ZCCityListViewController * vc = [[ZCCityListViewController alloc] init];
        //                    vc.fromNaviC = NO;
        //                    vc.completeBlock = ^(CityModel *model) {
        ////                        KNTableViewTextFieldCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ////                        cell.nameTextField.text = model.name;
        //                        //获取参数
        //                        self.reRequestModel.endRegionName = model.name;
        //                        self.reRequestModel.endRegionCode = model.code;
        //                        [self.tableView reloadData];
        //                    };
        //                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:vc]  animated:YES completion:nil];
        //                }
        //                break;
        //        }
        //日期为代理获得参数
        if(indexPath.row == 1 && indexPath.section == 3) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            CalendarView *view = [[CalendarView alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isFourDays" object:@"YES"];
            view.frame = CGRectMake(0, SCREEN_H, SCREEN_W, SCREEN_H);
            view.backgroundAlpha = 0;
            view.chooseDateInfo = self;
            [UIView animateWithDuration:0.5 animations:^{
                view.frame = CGRectMake(view.left,0, view.width, view.height);
            } completion:^(BOOL finished) {
            }];
            [window addSubview:view];
        }
        
    }
    //没问题
    if (indexPath.section == 4) {
        switch (indexPath.row) {
            case 0:
            {
                if (self.ceshi1) {
                    AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
                    vc.title = @"起运地";
                    vc.currentInfo = self.startAddreaaInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc returnInfo:^(AddressInfo *info) {
                        //                        TransportCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                        if (info.address.length) {
                            //                            self.reRequestModel.startAddress = info.address;
                        }else{
                            [[Toast shareToast] makeText:@"请选择带地址的联系人" aDuration:1];
                            return ;
                        }
                        
                        //                        cell.info= info;
                        self.startAddreaaInfo = info;
                        
                        //获取参数
                        self.reRequestModel.startPhone = info.contactsPhone;
                        self.reRequestModel.startAddress = info.address;
                        self.reRequestModel.startContacts = info.contacts;
                        [self.tableView reloadData];
                    }];
                }
                
            }
                break;
            case 1:
            {
                if (self.ceshi2) {
                    AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
                    vc.title = @"抵运地";
                    vc.currentInfo = self.endAddreaaInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc returnInfo:^(AddressInfo *info) {
                        self.endAddreaaInfo = info;
                        if (info.address.length) {
                            //                            self.reRequestModel.startAddress = info.address;
                        }else{
                            [[Toast shareToast] makeText:@"请选择带地址的联系人" aDuration:1];
                            return ;
                        }
                        //                        TransportCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                        
                        //获取参数
                        //                        cell.info= info;
                        self.endAddreaaInfo = info;
                        self.reRequestModel.endPhone = info.contactsPhone;
                        self.reRequestModel.endAddress = info.address;
                        self.reRequestModel.endContacts = info.contacts;
                        [self.tableView reloadData];
                    }];
                }
                
            }
                break;
            case 3:
            {
                [self callAction];
            }
                break;
                //        switch (indexPath.row) {
                //            case 0:
                //            {
                ////                if (self.ceshi1) {
                ////                    AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
                ////                    vc.title = @"起运地";
                ////                    vc.currentInfo = self.startAddreaaInfo;
                ////                    [self.navigationController pushViewController:vc animated:YES];
                ////                    [vc returnInfo:^(AddressInfo *info) {
                //////                        TransportCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                //////                        cell.info= info;
                ////                        self.startAddreaaInfo = info;
                ////
                ////                        //获取参数
                ////                        self.reRequestModel.startPhone = info.contactsPhone;
                ////                        self.reRequestModel.startAddress = info.address;
                ////                        self.reRequestModel.startContacts = info.contacts;
                ////                        [self.tableView reloadData];
                ////                    }];
                ////                }
                //                [self.serviceMenuView show];
                //            }
                //                break;
                //            case 1:
                //            {
                //                AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
                //                vc.title = @"起运地";
                //                vc.currentInfo = self.startAddreaaInfo;
                //                [self.navigationController pushViewController:vc animated:YES];
                //                [vc returnInfo:^(AddressInfo *info) {
                //                    if ([self.reRequestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_DOOR"] || [self.reRequestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_POINT"]) {
                //                        if (info.address.length) {
                //                             self.reRequestModel.startAddress = info.address;
                //                        }else{
                //                            [[Toast shareToast] makeText:@"请选择带地址的联系人" aDuration:1];
                //                            return ;
                //                        }
                //
                //                    }
                //                    self.startAddreaaInfo = info;
                //
                //                    //获取参数
                //                    self.reRequestModel.startPhone = info.contactsPhone;
                //                    self.reRequestModel.startContacts = info.contacts;
                //                    [self.tableView reloadData];
                //                }];
                ////                if (self.ceshi2) {
                ////                    AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
                ////                    vc.title = @"抵运地";
                ////                    vc.currentInfo = self.endAddreaaInfo;
                ////                    [self.navigationController pushViewController:vc animated:YES];
                ////                    [vc returnInfo:^(AddressInfo *info) {
                ////                        self.endAddreaaInfo = info;
                //////                        TransportCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                ////
                ////                        //获取参数
                //////                        cell.info= info;
                ////                        self.reRequestModel.endPhone = info.contactsPhone;
                ////                        self.reRequestModel.endAddress = info.address;
                ////                        self.reRequestModel.endContacts = info.contacts;
                ////                        [self.tableView reloadData];
                ////                    }];
                ////                }
                //
                //            }
                //                break;
                //            case 2:
                //            {
                //                AddressManagerViewController * vc = [[AddressManagerViewController alloc] init];
                //                vc.title = @"抵运地";
                //                vc.currentInfo = self.endAddreaaInfo;
                //                [self.navigationController pushViewController:vc animated:YES];
                //                [vc returnInfo:^(AddressInfo *info) {
                //
                //                    if ([self.reRequestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_DOOR_DOOR"] || [self.reRequestModel.deliveryTypeCode isEqualToString: @"DELIVERY_TYPE_POINT_DOOR"]) {
                //                        if (info.address.length) {
                //                            self.reRequestModel.endAddress = info.address;
                //                        }else{
                //                            [[Toast shareToast] makeText:@"请选择带地址的联系人" aDuration:1];
                //                            return ;
                //                        }
                //                    }
                //                     self.endAddreaaInfo = info;
                //                    self.reRequestModel.endPhone = info.contactsPhone;
                //                    self.reRequestModel.endContacts = info.contacts;
                //                    [self.tableView reloadData];
                //                }];
                //            }
                //                break;
                //                break;
                //            case 4:
                //            {
                //                [self callAction];
                //            }
                //                break;
        }
    }
    
}

#pragma mark -- ZSSearchViewControllerDelegate
- (void)getGood:(GoodsInfo *)goods{
    //    KNTableViewTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //    cell.nameTextField.text = goods.name;
    //获取参数 商品code
    //    self.viewModel.goodsCode = goods.code;
    self.reRequestModel.goodsCode  = goods.code;
    self.goods = goods;
    [self.tableView reloadData];
}

#pragma mark- chooseDateActionWithDate
- (void)chooseDateActionWithDate:(NSDate *)date
{
    //    KNTableViewTypeChooseCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:3]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy年MM月dd日"];
    //    cell.nameValueLabel.text = [dateFormatter stringFromDate:date];
    //获取参数 发货日期
    //    self.viewModel.estimateDepartureTime =
    self.reRequestModel.estimateDepartureTime = [NSString stringWithFormat:@"%ld000",(long)[date timeIntervalSince1970]];
    [self.tableView reloadData];
}



#pragma mark - 通讯录

-(void)addPhoneBookView {
    float version = EQUIPMENTVERSION;
    if (version >= 9.0) {
        CNContactPickerViewController * contactVc = [CNContactPickerViewController new];
        contactVc.delegate = self;
        [self presentViewController:contactVc animated:YES completion:^{
            
        }];
    }
    else
    {
        ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
        picker.peoplePickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - ios>= 9.0
#pragma mark - 用户点击联系人获取方法 两个方法都写只调用此方法

-(void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
    //获取通讯录某个人所有电话并存入数组中
    NSMutableArray * arrMPhoneNums = [NSMutableArray array];
    for (CNLabeledValue * labValue in contact.phoneNumbers) {
        NSString * strPhoneNums = [labValue.value stringValue];
        [arrMPhoneNums addObject:strPhoneNums];
    }
    
    //    KNTableViewUserInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //    cell.nameTextField.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    //    cell.mobileTextField.text = [arrMPhoneNums[0] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //
    
    NSString * telStr = [arrMPhoneNums[0] stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.reRequestModel.contacts = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    self.reRequestModel.contactsPhone = [telStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}
//取消回调
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ios < 9.0
#pragma mark - 实现代理方法
/// 当选择了联系人的时候调用此方法
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    
    NSString *fullName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    //获取联系人电话
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //  电话
    NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, 0));
    //释放CF对象.如果没有纪录电话，phone是nil，不能释放。
    if (phones != nil) {
        CFRelease(phones);
    }
    //    KNTableViewUserInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //    cell.nameTextField.text = fullName;
    //    cell.mobileTextField.text = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.reRequestModel.contacts = fullName;
    self.reRequestModel.contactsPhone = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.tableView reloadData];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    NSString *fullName = CFBridgingRelease(ABRecordCopyCompositeName(person));
    //获取联系人电话
    ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //  电话
    NSString *value = CFBridgingRelease(ABMultiValueCopyValueAtIndex(phones, 0));
    //释放CF对象.如果没有纪录电话，phone是nil，不能释放。
    if (phones != nil) {
        CFRelease(phones);
    }
    //    KNTableViewUserInfoCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //    cell.nameTextField.text = fullName;
    //    cell.mobileTextField.text = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
    self.reRequestModel.contacts = fullName;
    self.reRequestModel.contactsPhone = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.tableView reloadData];
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}

#pragma mark -- Action
- (void)onRightAction{
    [self.view endEditing:YES];
    //获取参数 用箱数量
    //    if (self.filterType == kKNCustomFilterTypeCONTAINER) {
    //        //获取参数 数量
    //        KNTableViewNumberCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    //        self.reRequestModel.containerNumber = [cell.valueTextField.text integerValue];
    //    } else  if (self.filterType == kKNCustomFilterTypeBULK_STACK) {
    //        //获取参数 总重量
    //        KNTableViewTextFieldCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    //        self.reRequestModel.weight = [cell.nameTextField.text doubleValue];
    //    }else if (self.filterType == kKNCustomFilterTypeVECHICLE){
    //        //获取车辆品牌
    //         KNTableViewTextFieldCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    //        //获取参数 车型
    //        KNTableViewTextFieldCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    //        self.reRequestModel.vehicleType = [NSString stringWithFormat:@"%@%@",cell1.nameTextField.text,cell2.nameTextField.text];
    //        //获取参数 台数
    //        KNTableViewNumberCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    //        self.reRequestModel.vehicleNum = [cell3.valueTextField.text integerValue];
    //    }else if (self.filterType == kKNCustomFilterTypeLARGE_SIZE){
    //        //获取参数 总重量
    //        KNTableViewTextFieldCell *cell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    //        self.reRequestModel.weight = [cell1.nameTextField.text doubleValue];
    //        //获取参数 件数
    //        KNTableViewNumberCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    //        self.reRequestModel.wrapperNumber = [cell2.valueTextField.text integerValue];
    //        //获取参数 长宽高 单件重量
    //        KNTableViewBigCell *cell3 =  [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    //        self.reRequestModel.unitMaxLength = [cell3.longTF.text doubleValue];
    //        self.reRequestModel.unitMaxWidth = [cell3.widthTF.text doubleValue];
    //        self.reRequestModel.unitMaxHigh = [cell3.heightTF.text doubleValue];
    //        self.reRequestModel.unitMaxWeight = [cell3.weightTF.text doubleValue];
    //    }
    //获取参数 联系人 联系方式
    //    KNTableViewUserInfoCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    //    self.reRequestModel.contacts = cell2.nameTextField.text;
    //    self.reRequestModel.contactsPhone = cell2.mobileTextField.text;
    
    //    if (self.filterType == kKNCustomFilterTypeVECHICLE){
    //        self.reRequestModel.vehicleType = [NSString stringWithFormat:@"%@%@",self.goods.name,self.reRequestModel.vehicleType];
    //    }
    
    if (self.goods.name.length <1 && self.reRequestModel.noGoodName.length <1) {
        [[Toast shareToast] makeText:@"请完善货品信息" aDuration:1];
        return;
    }
    if ([YMKJVerificationTools stringContrainsEmoji:self.reRequestModel.noGoodName]) {
        [[Toast shareToast]makeText:@"输入的货品名包含非法字符" aDuration:1];
        return;
    }
    if (self.filterType == kKNCustomFilterTypeCONTAINER) {
        if (self.containModel.name.length <1) {
            [[Toast shareToast] makeText:@"请完善货品信息" aDuration:1];
            return;
        }
        if (self.reRequestModel.containerNumber <1) {
            [[Toast shareToast] makeText:@"请输入大于0的箱数" aDuration:1];
            return;
        }
    }
    
    if (self.filterType == kKNCustomFilterTypeBULK_STACK) {
        if (self.reRequestModel.weight <1) {
            [[Toast shareToast] makeText:@"请完善货品信息" aDuration:1];
            return;
        }
    }
    //    if (self.filterType == kKNCustomFilterTypeVECHICLE) {
    //        if (self.reRequestModel.vehicleType.length<1) {
    //            [[Toast shareToast] makeText:@"请完善货品信息" aDuration:1];
    //            return;
    //        }
    //        if (self.reRequestModel.vehicleNum <=0) {
    //            [[Toast shareToast] makeText:@"请输入大于0的台数" aDuration:1];
    //            return;
    //        }
    //    }
    if (self.filterType == kKNCustomFilterTypeLARGE_SIZE) {
        if (self.reRequestModel.weight<=0) {
            [[Toast shareToast] makeText:@"请完善货品信息" aDuration:1];
            return;
        }
        if (self.reRequestModel.wrapperNumber <=0) {
            [[Toast shareToast] makeText:@"请输入大于0的件数" aDuration:1];
            return;
        }
        if (self.reRequestModel.unitMaxLength <=0) {
            [[Toast shareToast] makeText:@"请输入最大单件尺寸（长）" aDuration:1];
            return;
        }
        if (self.reRequestModel.unitMaxWidth <=0) {
            [[Toast shareToast] makeText:@"请输入最大单件尺寸（宽）" aDuration:1];
            return;
        }
        if (self.reRequestModel.unitMaxHigh <=0) {
            [[Toast shareToast] makeText:@"请输入最大单件尺寸（高）" aDuration:1];
            return;
        }
        if (self.reRequestModel.unitMaxWeight <=0) {
            [[Toast shareToast] makeText:@"请输最大单件重量" aDuration:1];
            return;
        }
    }
    
    
    
    
    if (self.reRequestModel.contacts.length < 1) {
        [[Toast shareToast]makeText:@"请输入联系人" aDuration:1];
        return;
    }
    
    if ([YMKJVerificationTools stringContrainsEmoji:self.reRequestModel.contacts]) {
        [[Toast shareToast]makeText:@"联系人信息包含非法字符" aDuration:1];
        return;
    }
    //    if (self.reRequestModel.shouPerson.length < 1) {
    //        [[Toast shareToast]makeText:@"请输入收货人" aDuration:1];
    //        return;
    //    }
    //    if (self.reRequestModel.shouTel.length < 1) {
    //        [[Toast shareToast]makeText:@"请输入收货人电话" aDuration:1];
    //        return;
    //    }
    //    if (self.reRequestModel.faPerson.length < 1) {
    //        [[Toast shareToast]makeText:@"请输入发货人" aDuration:1];
    //        return;
    //    }
    //    if (self.reRequestModel.faTel.length < 1) {
    //        [[Toast shareToast]makeText:@"请输入发货人电话" aDuration:1];
    //        return;
    //    }
    if (self.reRequestModel.contactsPhone.length < 1) {
        [[Toast shareToast]makeText:@"请输入手机号" aDuration:1];
        return;
    }
    if (self.reRequestModel.contactsPhone.length != 11) {
        [[Toast shareToast]makeText:@"手机号格式不正确" aDuration:1];
        return;
    }
    
    if (![YMKJVerificationTools isAvailablePhoneNumber:self.reRequestModel.contactsPhone]) {
        [[Toast shareToast]makeText:@"手机号格式不正确" aDuration:1];
        return;
    }
    
    if (!self.ceshi1) {
        
    }
    if (!self.ceshi2) {
        
    }
    //    NSString *searchText = self.reRequestModel.contactsPhone;
    //    NSError *error = NULL;
    //
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"1\\d{10}$" options:NSRegularExpressionCaseInsensitive error:&error];
    //    NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
    
    
    //    if ([self.reRequestModel.contactsPhone isEqualToString:@""]) {
    //
    //        [[Toast shareToast]makeText:@"手机号码不能为空" aDuration:1];
    //        return;
    //    }else if (!result) {
    //
    //        [[Toast shareToast]makeText:@"手机号格式错误" aDuration:1];
    //        return;
    //    }
    //获取参数 备注
    //    KNTableViewTipsCell *cell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:4]];
    //    self.reRequestModel.remark = cell3.textView.text;
    
    WS(weakSelf)
    [self.viewModel requestCustomTransportWithType:self.filterType Model:self.reRequestModel callback:^(BOOL success) {
        if (success) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                self.viewModel = nil;
                weakSelf.goods = nil;
                weakSelf.containModel = nil;
                weakSelf.reRequestModel = nil;
                [weakSelf.navigationController pushViewController:[[OrderTransportSuccessViewController alloc] init] animated:YES];
            });
        }
    }];
}

#pragma mark -- Getter
- (KNCustomFilterPopView *)menuView{
    if (!_menuView) {
        _menuView = [[KNCustomFilterPopView alloc] initWithFrame:CGRectZero];
    }
    return _menuView;
}

- (CapacityViewModel *)reRequestModel{
    if (!_reRequestModel) {
        _reRequestModel = [[CapacityViewModel alloc] init];
    }
    return _reRequestModel;
}

- (UITableView *)tableView
{
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-kiPhoneFooterHeight-kNavBarHeaderHeight-kTabbarHight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.backgroundColor = APP_COLOR_WHITE_BTN;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"KNTableViewTypeChooseCell" bundle:nil] forCellReuseIdentifier:@"KNTableViewTypeChooseCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"KNTableViewTextFieldCell" bundle:nil] forCellReuseIdentifier:@"KNTableViewTextFieldCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"KNTableViewBigCell" bundle:nil] forCellReuseIdentifier:@"KNTableViewBigCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"KNTableViewNumberCell" bundle:nil] forCellReuseIdentifier:@"KNTableViewNumberCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"KNTableViewUserInfoCell" bundle:nil] forCellReuseIdentifier:@"KNTableViewUserInfoCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"KNTableViewTipsCell" bundle:nil] forCellReuseIdentifier:@"KNTableViewTipsCell"];
        [_tableView registerNib:[UINib nibWithNibName:@"KNTableViewTransportHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"KNTableViewTransportHeaderView"];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TransportCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([TransportCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZiXunCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ZiXunCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoGoodsCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([NoGoodsCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderSelectAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderSelectAddressCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderSelectNoAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderSelectNoAddressCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KNOrderCompleteTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([KNOrderCompleteTableViewCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StatrAndCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([StatrAndCell class])];
        
    }
    return _tableView;
}
- (CapacityViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[CapacityViewModel alloc] init];
    }
    return _viewModel;
}

- (KNOrderCompleteMenuPopView *)serviceMenuView{
    WS(weakSelf);
    if (!_serviceMenuView) {
        
        _serviceMenuView = [[KNOrderCompleteMenuPopView alloc] initWithFrame:CGRectZero Array:@[@"无",@"上门取货",@"送货上门",@"上门取货+送货上门"]];
        _serviceMenuView.selectBlock = ^(NSString *title) {
            if ([weakSelf.reRequestModel.serviceWay isEqualToString:title]) {
                return ;
            }
            weakSelf.reRequestModel.serviceWay = title;
            weakSelf.reRequestModel.startPhone = nil;
            weakSelf.reRequestModel.startAddress = nil;
            weakSelf.reRequestModel.startContacts = nil;
            weakSelf.reRequestModel.endPhone = nil;
            weakSelf.reRequestModel.endContacts = nil;
            weakSelf.reRequestModel.endAddress = nil;
            //        KNOrderCompleteTableViewCell *cell = (KNOrderCompleteTableViewCell *) [weakSelf.KNTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            //        cell.contentLabel.text = title;
            /**
             DELIVERY_TYPE_POINT_POINT 无
             DELIVERY_TYPE_DOOR_POINT 上门取货
             DELIVERY_TYPE_POINT_DOOR 送货上门
             DELIVERY_TYPE_DOOR_DOOR 上门取货+送货上门
             */
            if ([title isEqualToString:@"无"]) {
                weakSelf.reRequestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_POINT";
            }else if ([title isEqualToString:@"上门取货"]){
                weakSelf.reRequestModel.deliveryTypeCode = @"DELIVERY_TYPE_DOOR_POINT";
            }else if ([title isEqualToString:@"送货上门"]){
                weakSelf.reRequestModel.deliveryTypeCode = @"DELIVERY_TYPE_POINT_DOOR";
            }else if ([title isEqualToString:@"上门取货+送货上门"]){
                weakSelf.reRequestModel.deliveryTypeCode = @"DELIVERY_TYPE_DOOR_DOOR";
            }
            //            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView reloadData];
            [weakSelf getData];
        };
    }
    return _serviceMenuView;
}

- (GoodsInfo *)goods{
    if (!_goods) {
        _goods = [[GoodsInfo alloc] init];
    }
    return _goods;
}

- (ContainerTypeModel *)containModel{
    if (!_containModel) {
        _containModel = [[ContainerTypeModel alloc] init];
    }
    return _containModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
