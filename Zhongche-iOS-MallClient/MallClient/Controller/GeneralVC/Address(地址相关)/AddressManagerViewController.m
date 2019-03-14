//
//  AddressManagerViewController.m
//  MallClient
//
//  Created by lxy on 2016/12/9.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "AddressManagerViewController.h"
#import "ContactAddressViewModel.h"
#import "AddressListTableViewCell.h"
#import "SetAddressViewController.h"
#import "AddressInfo.h"
#import "MessageBottomView.h"

@interface AddressManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView         *tvList;

@property (nonatomic, strong) UIButton            *btnAddAddress;
@property (nonatomic, strong) NSArray             *arrAddressInfo;
@property (nonatomic, assign) int isReturn;

@property (nonatomic, strong) MessageBottomView * selectBottomView;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign) BOOL isEdite;

@property (nonatomic, strong)NSMutableArray * delegateArray;
@end

@implementation AddressManagerViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isEdite = NO;
    if (self.selectBottomView) {
        [self.selectBottomView removeFromSuperview];
    }
    for (AddressInfo * addressInfo in self.arrAddressInfo) {
         addressInfo.isSelect = NO;
    }
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated {

    if (self.isReturn == 1) {

        if (self.returnInfoBlock != nil) {
            self.returnInfoBlock(self.currentInfo);
        }
    }

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnRight.hidden = NO;
     [self.btnRight setFrame:CGRectMake(0, 0, 22, 22)];
    [self.btnRight setBackgroundImage:[UIImage imageNamed:@"adderssDelete"] forState:UIControlStateNormal];
    self.view.backgroundColor = APP_COLOR_WHITE_BTN;
}

- (void)returnInfo:(ReturnInfoBlock)block{
    self.returnInfoBlock = block;
}

- (void)bindView {


    self.tvList.frame = CGRectMake(0 ,0, SCREEN_W, SCREEN_H -kNavBarHeaderHeight - kiPhoneFooterHeight -70);
    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    [self.view addSubview:self.tvList];

    self.btnAddAddress.frame  =CGRectMake(15, self.tvList.bottom + 15, SCREEN_W - 30, 44);
    [self.view addSubview:self.btnAddAddress];

}

- (void)getData{

    ContactAddressViewModel *vm = [ContactAddressViewModel new];

    WS(ws);
    [vm selectAddressWithType:self.type callback:^(NSArray *arr) {
        
//        for (AddressInfo * addressInfo in arr) {
//            if([addressInfo.ID isEqual:self.currentInfo.ID]) {
//                addressInfo.isSelect = YES;
//            }
//        }
        ws.arrAddressInfo = arr;
        [ws.tvList reloadData];

    }];
    
}

- (void)addAction {


    SetAddressViewController *vc = [SetAddressViewController new];
    vc.type = self.type;
    vc.stCity = self.stCity;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)editAddressAction:(UIButton *)btn {

    SetAddressViewController *vc = [SetAddressViewController new];
    AddressInfo *address = [self.arrAddressInfo objectAtIndex:btn.tag];
    vc.info = address;
    vc.stCity = self.stCity;
    vc.cityCode = self.cityCode;

    [self.navigationController pushViewController:vc animated:YES];

    
}

/**
 *
 *  @param tableView delegate
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.arrAddressInfo.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//
//    return 77;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Celled";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddressListTableViewCell" owner:self options:nil];
    AddressInfo *address = [self.arrAddressInfo objectAtIndex:indexPath.row];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.lb1.text = [NSString stringWithFormat:@"%@    %@",address.contacts,address.contactsPhone];
    cell.lb2.text = address.address;
    
//    if([address.ID isEqual:self.currentInfo.ID]) {
//        cell.iv.image = [UIImage imageNamed:@"choose"];
//    }
//    if (address.isSelect) {
//        cell.iv.hidden = NO;
//        cell.leftConstraint.constant = 64.0f;
//        cell.iv.image = [UIImage imageNamed:@"choose"];
//    }else{
//        cell.iv.hidden = YES;
//        cell.leftConstraint.constant = 20.0f;
//    }
    if (self.isEdite) {
        cell.iv.hidden = NO;
        cell.leftConstraint.constant = 64.0f;
        if (address.isSelect) {
            cell.iv.image = [UIImage imageNamed:@"Oval Sel"];
        }else{
            cell.iv.image = [UIImage imageNamed:@"Oval all"];
        }
        
    }else{
        cell.iv.hidden = YES;
        cell.leftConstraint.constant = 15.0f;
    }
    cell.btnEdite.tag = indexPath.row;

    [cell.btnEdite addTarget:self action:@selector(editAddressAction:) forControlEvents:UIControlEventTouchUpInside];

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.isShow) {
        if (!self.isGoBack) {
            AddressInfo *address = [self.arrAddressInfo objectAtIndex:indexPath.row];
            address.isSelect = YES;
            self.currentInfo = address;
            self.isReturn =1;
            [self onBackAction];
        }
    }else{
        AddressInfo *address = self.arrAddressInfo[indexPath.row];
        address.isSelect = !address.isSelect;
        if (address.isSelect) {
            [self.delegateArray addObject:address.ID];
        }else{
            [self.delegateArray removeObject:address.ID];
        }
        [self.tvList reloadData];
    }

}

- (void)onRightAction
{
    if (self.arrAddressInfo.count == 0) {
        return;
    }
    if (self.isShow) {
        self.isEdite = NO;
        [self.selectBottomView removeFromSuperview];
        for (AddressInfo * info in self.arrAddressInfo) {
            info.isSelect = NO;
            [self.delegateArray removeObject:info.ID];
        }
    }else{
        [self.view addSubview:self.selectBottomView];
         self.isEdite = YES;
    }
    self.isShow = !self.isShow;
    [self.tvList reloadData];
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

//getter

- (NSMutableArray *)delegateArray
{
    if (!_delegateArray) {
        _delegateArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _delegateArray;
}

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 140-kiPhoneFooterHeight) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.backgroundColor = APP_COLOR_WHITE_BTN;
        tableView.estimatedRowHeight = 100.0f;
        _tvList = tableView;
    }
    return _tvList;
}

- (UIButton *)btnAddAddress {
    if (!_btnAddAddress) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"新增地址" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:APP_COLOR_BLUE_BTN];
        [button.layer setMasksToBounds:YES];
        button.layer.cornerRadius = 4.0;

        _btnAddAddress = button;
    }
    return _btnAddAddress;
}


- (MessageBottomView *)selectBottomView
{
    WS(weakSelf);
    if (!_selectBottomView) {
        _selectBottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MessageBottomView class]) owner:self options:nil] firstObject];
        _selectBottomView.frame = CGRectMake(0, SCREEN_H-kiPhoneFooterHeight- kNavBarHeaderHeight- 55, SCREEN_W, 55);
        _selectBottomView.readBtn.hidden =YES;
        [_selectBottomView setBlock:^(BOOL ret) {
            if (ret) {
                for (AddressInfo * info in weakSelf.arrAddressInfo) {
                    info.isSelect = YES;
                    [weakSelf.delegateArray addObject:info.ID];
                }
            }else{
                for (AddressInfo * info in weakSelf.arrAddressInfo) {
                    info.isSelect = NO;
                     [weakSelf.delegateArray removeObject:info.ID];
                }
            }
            [weakSelf.tvList reloadData];
        }];
        
        
        [_selectBottomView setDeleteBlock:^(NSString *state) {
            NSMutableArray * arrya = [[NSMutableArray alloc] init];
            for (NSString * IDStr in weakSelf.delegateArray) {
                [arrya addObject:@([IDStr integerValue])];
            }
            [[ContactAddressViewModel new] delegateAddressWithType:@"" IdArray:arrya callback:^(BOOL ret) {
                if (ret) {
                    [[Toast shareToast] makeText:@"地址删除成功" aDuration:1];
                    weakSelf.isEdite = NO;
                    weakSelf.isShow =NO;
                    if (weakSelf.selectBottomView) {
                        [weakSelf.selectBottomView removeFromSuperview];
                    }
                    for (AddressInfo * addressInfo in weakSelf.arrAddressInfo) {
                        addressInfo.isSelect = NO;
                    }
                     [weakSelf getData];
                   
                   
                }
            }];
        }];
        //全选事件
    }
    return _selectBottomView;
}

@end
