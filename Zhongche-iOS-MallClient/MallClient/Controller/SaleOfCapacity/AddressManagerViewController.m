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

@interface AddressManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView         *tvList;

@property (nonatomic, strong) UIButton            *btnAddAddress;
@property (nonatomic, strong) NSArray             *arrAddressInfo;




@end

@implementation AddressManagerViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getData];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (self.returnInfoBlock != nil) {
        self.returnInfoBlock(self.currentInfo);
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)returnInfo:(ReturnInfoBlock)block{
    self.returnInfoBlock = block;
}

- (void)bindView {

   

    self.tvList.frame = CGRectMake(0 ,0, SCREEN_W, SCREEN_H -64 - 90);
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tvList];

    self.btnAddAddress.frame  =CGRectMake(20, self.tvList.bottom + 25, SCREEN_W - 40, 44);
    [self.view addSubview:self.btnAddAddress];

}

- (void)getData {

    ContactAddressViewModel *vm = [ContactAddressViewModel new];

    WS(ws);
    [vm selectAddressWithType:self.type callback:^(NSArray *arr) {

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 77;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Celled";
    AddressListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddressListTableViewCell" owner:self options:nil];
    AddressInfo *address = [self.arrAddressInfo objectAtIndex:indexPath.row];
    cell = [array objectAtIndex:0];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.lb1.text = [NSString stringWithFormat:@"%@    %@",address.contacts,address.contactsTel];
    cell.lb2.text = address.address;

    if([address.ID isEqual:self.currentInfo.ID]) {
        cell.iv.image = [UIImage imageNamed:@"choose"];
    }

    cell.btnEdite.tag = indexPath.row;

    [cell.btnEdite addTarget:self action:@selector(editAddressAction:) forControlEvents:UIControlEventTouchUpInside];

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    AddressInfo *address = [self.arrAddressInfo objectAtIndex:indexPath.row];
    self.currentInfo = address;
    [self onBackAction];

}


//getter

- (UITableView *)tvList {
    if (!_tvList) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - 140) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;

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




@end
