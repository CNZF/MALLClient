//
//  CapacityOrderDetailVC.m
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "CapacityOrderDetailVC.h"
#import "OrderDetailHeadView.h"
#import "OrderDetailFootView.h"
#import "OrderDetailAddressCell.h"
#import "OrderDetailNomalCell.h"
#import "OrderDeyailIncreaseCell.h"
#import "OrderDetailInVoiveCell.h"
#import "OrderProgressWaitConfirmCell.h"
#import "OrderDeyaillnCell.h"
#import "OrderDetailAdjectiveView.h"
#import "OrderViewModel.h"
#import "SendOrderController.h"
#import "OrderPayDetailController.h"
#import "OrderDeyailNoAddressCell.h"
#import "KNCodeViewController.h"
#import "DetailZeroHeadView.h"

#define iOS10Later ([UIDevice currentDevice].systemVersion.floatValue >= 10.0f)

@interface CapacityOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)OrderDetailHeadView * headView;
@property (nonatomic, strong)OrderDetailFootView * footView;
@property (nonatomic, strong)OrderProgressWaitConfirmCell * orderProgressWaitConfirmCell;
@property (nonatomic, strong)OrderDetailAddressCell * orderDetailAddressCell;
@property (nonatomic, strong)OrderModelForCapacity * refreModel;
@property (nonatomic, strong)OrderDetailAdjectiveView * AdjectiveView;
@property (nonatomic, strong)DetailZeroHeadView * zeroHeadView;
@end

@implementation CapacityOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200.0f;
    self.tableView.tableHeaderView = self.headView;
    [self.btnRight setTitle:@"取消订单" forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(0, 0, 100, 30);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self asyncOrderDetailData];
}

- (void) setNaviRight
{
    if ([self.refreModel.ordetType isEqualToString:@"待确认"] || [self.refreModel.ordetType isEqualToString:@"待付款"]) {
        self.btnRight.hidden = NO;
    }
   
}


- (void)onRightAction
{
    NSString * title;
    NSString * defaultTitle;
    NSString * cancelTitle;
    NSString * message;
    if ([self.model.ordetType isEqualToString:@"待确认"]) {
        title = @"取消订单";
        defaultTitle = @"否";
        cancelTitle = @"是";
        message  = @"\n是否取消订单？\n";
    }
    if ([self.model.ordetType isEqualToString:@"待付款"]) {
        title = @"取消订单";
        defaultTitle = @"再想想";
        cancelTitle = @"联系客服";
        message  = @"\n取消订单请联系客服\n";
    }
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:defaultTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             if ([self.model.ordetType isEqualToString:@"待确认"]) {
                                                                 [[OrderViewModel new]emptyContainerOrderOperateWithOrderId:self.model.ID WithType:CANCEL callback:^(NSString *str) {
                                                                     
                                                                     if ([str isEqualToString:@"10000"]) {
                                                                         [[Toast shareToast] makeText:@"取消订单成功" aDuration:1];
                                                                         [self.navigationController popViewControllerAnimated:YES];
                                                                         if (self.cancelBlcok) {
                                                                             self.cancelBlcok(self.model);
                                                                         }
                                                                     }
                                                                     
                                                                 }];
                                                             }else{
//                                                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",APP_CUSTOMER_SERVICE_NO_]]];
                                                                 NSString * tel = [NSString stringWithFormat:@"tel://%@",APP_CUSTOMER_SERVICE_NO_];
                                                                 if (iOS10Later) {
                                                                     /// 大于等于10.0系统使用此openURL方法
                                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel] options:@{} completionHandler:nil];
                                                                 }else{
                                                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
                                                                 }
                                                                     
                                                             }
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)asyncOrderDetailData
{
    WS(WeakSelf);
    [[OrderViewModel new] getSaleOfCapacityOrderDetailsWithOrderId:self.model.ID callback:^(OrderModelForCapacity *model) {
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.footView];
         WeakSelf.refreModel =model;
         [WeakSelf setNaviRight];
         [WeakSelf.tableView reloadData];
         WeakSelf.headView.model = model;
         WeakSelf.footView.model = model;
        
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //判断有无发票
    if (self.refreModel.invoice_0.title == nil) {
        return 6;
    }else{
        return 7;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 4?3:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
//        self.orderDetailAddressCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailAddressCell class]) forIndexPath:indexPath];
        [self.orderDetailAddressCell setNewModel:self.refreModel WithModel:self.model];
        return self.orderDetailAddressCell;
    }else if(indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3){
        OrderDetailNomalCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailNomalCell class]) forIndexPath:indexPath];
        if (indexPath.section == 1) {
            cell.contentLabel.text = @"取货时间";
            
            cell.rightImageView.hidden = YES;
            cell.timaLabel.text = [NSString stringWithFormat:@"%@-%@",self.refreModel.pickup_start_time,self.refreModel.pickup_end_time];
        }else if (indexPath.section == 2) {
            cell.contentLabel.text = @"发货批次";
        }else{
            cell.contentLabel.text = @"支付明细";
        }
        return cell;
    }else if(indexPath.section == 4){
        if (indexPath.row == 0) {
            OrderDeyailIncreaseCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyailIncreaseCell class]) forIndexPath:indexPath];
            cell.model = self.refreModel;
            return cell;
        }else{
            if ([self.refreModel.serviceType isEqualToString:@"无"]) {
                OrderDeyailNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class]) forIndexPath:indexPath];
                [cell setModel:self.refreModel AndIndex:indexPath.row-1];
                return cell;
            }else if([self.refreModel.serviceType isEqualToString:@"上门取货"]){
                if (indexPath.row == 1) {
                    OrderDeyaillnCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyaillnCell class]) forIndexPath:indexPath];
                    [cell setModel:self.refreModel AndIndex:indexPath.row];
                    return cell;
                }else{
                    OrderDeyailNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class]) forIndexPath:indexPath];
                    [cell setModel:self.refreModel AndIndex:indexPath.row];
                    return cell;
                }
            }else if ([self.refreModel.serviceType isEqualToString:@"送货上门"]){
                if (indexPath.row == 1) {
                    OrderDeyailNoAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class]) forIndexPath:indexPath];
                    [cell setModel:self.refreModel AndIndex:indexPath.row];
                    return cell;
                }else{
                    OrderDeyaillnCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyaillnCell class]) forIndexPath:indexPath];
                    [cell setModel:self.refreModel AndIndex:indexPath.row];
                    return cell;
                }
            } else{
                OrderDeyaillnCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDeyaillnCell class]) forIndexPath:indexPath];
                [cell setModel:self.refreModel AndIndex:indexPath.row];
                return cell;
            }

        }
        
    }else if(indexPath.section == 5){
        
        if (self.refreModel.invoice_0.title == nil) {
            if (self.refreModel.orderProgress.count>0) {
                self.orderProgressWaitConfirmCell.model = self.refreModel;
                return self.orderProgressWaitConfirmCell;
            }else{
                return [UITableViewCell new];
            }
        }else{
            OrderDetailInVoiveCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailInVoiveCell class]) forIndexPath:indexPath];
            [cell setNewModel:self.refreModel WithModel:self.model];
            return cell;
        }
        
    }else{
        if (self.refreModel.orderProgress.count>0) {
            self.orderProgressWaitConfirmCell.model = self.refreModel;
            return self.orderProgressWaitConfirmCell;
        }else{
            return [UITableViewCell new];
        }
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        SendOrderController * controller = [SendOrderController new];
        controller.model = self.refreModel;
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (indexPath.section == 3) {
        OrderPayDetailController * controller = [OrderPayDetailController new];
        controller.model = self.refreModel;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 26;
    }else if (section == 4 || section == 5) {
        return CGFLOAT_MIN;
    }else{
        return 12;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        self.zeroHeadView.model = self.model;
        return self.zeroHeadView;
        
    }else{
         return [UIView new];
    }
   
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 5?15:CGFLOAT_MIN;
}

- (OrderDetailHeadView *)headView
{
    WS(weakSelf);
    if (!_headView) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderDetailHeadView class]) owner:self options:nil] firstObject];
        _headView.frame = CGRectMake(0, 0, SCREEN_W, 80);
        [_headView setClickBlcok:^(UIImage *image) {
           
            KNCodeViewController * controller = [[KNCodeViewController alloc] initWithNibName:NSStringFromClass([KNCodeViewController class]) bundle:nil];
            controller.image  = image;
            [weakSelf.navigationController pushViewController:controller animated:YES];
        }];
    }
    return _headView;
}



- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-kNavBarHeaderHeight-kiPhoneFooterHeight- 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = APP_COLOR_WHITE_BTN;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDetailAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDetailAddressCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDetailNomalCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDetailNomalCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDeyailIncreaseCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDeyailIncreaseCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDeyaillnCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDeyaillnCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDeyailNoAddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDeyailNoAddressCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDetailInVoiveCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderDetailInVoiveCell class])];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderProgressWaitConfirmCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([OrderProgressWaitConfirmCell class])];
    }
    return _tableView;
}

- (OrderDetailAddressCell *)orderDetailAddressCell
{
    if (!_orderDetailAddressCell) {
        if (self.refreModel.startEntrepotName.length>0 || self.refreModel.endEntrepotName.length>0) {
            _orderDetailAddressCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderDetailAddressCell class]) owner:self options:nil] lastObject];
        }else{
            _orderDetailAddressCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderDetailAddressCell class]) owner:self options:nil] firstObject];
        }
    }
    return _orderDetailAddressCell;
}


- (OrderProgressWaitConfirmCell *)orderProgressWaitConfirmCell
{
    if (!_orderProgressWaitConfirmCell) {
        if (self.refreModel.orderProgress.count>0) {
            if (self.refreModel.orderProgress.count == 1) {
                _orderProgressWaitConfirmCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderProgressWaitConfirmCell class]) owner:self options:nil] objectAtIndex:0];
            }
            if (self.refreModel.orderProgress.count == 2) {
                _orderProgressWaitConfirmCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderProgressWaitConfirmCell class]) owner:self options:nil] objectAtIndex:1];
            }
            if (self.refreModel.orderProgress.count == 3) {
                _orderProgressWaitConfirmCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderProgressWaitConfirmCell class]) owner:self options:nil] objectAtIndex:2];
            }
            if (self.refreModel.orderProgress.count == 4) {
                _orderProgressWaitConfirmCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderProgressWaitConfirmCell class]) owner:self options:nil] objectAtIndex:3];
            }
            if (self.refreModel.orderProgress.count == 5) {
                _orderProgressWaitConfirmCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderProgressWaitConfirmCell class]) owner:self options:nil] objectAtIndex:4];
            }
        }else{
            _orderProgressWaitConfirmCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderProgressWaitConfirmCell class]) owner:self options:nil] objectAtIndex:0];
        }
    }
    return _orderProgressWaitConfirmCell;
}

- (OrderDetailFootView *)footView
{
    WS(WeakSelf);
    if (!_footView) {
        _footView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderDetailFootView class]) owner:self options:nil] firstObject];
        _footView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), SCREEN_W, 50);
        _footView.targat = WeakSelf;
        [_footView setBlock:^(BOOL isShow) {
            NSLog(@"%@",isShow?@"YES":@"NO");
            if (isShow) {
                [WeakSelf.view addSubview:WeakSelf.AdjectiveView];
                WeakSelf.AdjectiveView.frame = CGRectMake(0, 0, SCREEN_W,CGRectGetMaxY(WeakSelf.tableView.frame));
                [WeakSelf.AdjectiveView setNewModel:WeakSelf.refreModel WithModel:WeakSelf.model];
            }else{
                [WeakSelf.AdjectiveView removeFromSuperview];
            }
        }];
        [_footView setCancelBlock:^(OrderModelForCapacity *orderModel) {
            [WeakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _footView;
}

- (OrderDetailAdjectiveView *)AdjectiveView
{
    WS(WeakSelf);
    if (!_AdjectiveView) {
        _AdjectiveView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderDetailAdjectiveView class]) owner:self options:nil] firstObject];
        _AdjectiveView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _AdjectiveView.frame = CGRectMake(0, 0, SCREEN_W, 0);
        [_AdjectiveView setBlock:^{
            WeakSelf.footView.isShow = NO;
        }];
    }
    return _AdjectiveView;
}

- (DetailZeroHeadView *)zeroHeadView
{
    if (!_zeroHeadView) {
        _zeroHeadView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DetailZeroHeadView class]) owner:self options:nil] firstObject];
        
    }
    return _zeroHeadView;
}

@end
