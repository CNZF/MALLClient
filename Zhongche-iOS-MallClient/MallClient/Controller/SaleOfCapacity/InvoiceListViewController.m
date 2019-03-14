//
//  InvoiceListViewController.m
//  MallClient
//
//  Created by lxy on 2016/12/15.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "InvoiceListViewController.h"
#import "VIAInvoiceTableViewCell.h"
#import "VATInvoiceTableViewCell.h"
#import "InvoiceViewModel.h"
#import "InvoiceModel.h"

#import "AddInvoiceViewController.h"



@interface InvoiceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tvVIAInvoiceList;
@property (weak, nonatomic) IBOutlet UIButton *btnChoose;
@property (nonatomic, assign) int isEdite;//0、取消 1、编辑状态
@property (weak, nonatomic) IBOutlet UITableView *tvCommenInvoiceList;
@property (nonatomic, assign) int showAll;
@property (nonatomic, strong) NSArray *arrCommenInvoice;
@property (nonatomic, strong) NSArray *arrAddInvoice;

@property (nonatomic, strong) InvoiceModel *invoiceModel;

@end

@implementation InvoiceListViewController

- (void)viewWillDisappear:(BOOL)animated {
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(self.invoiceModel);
    }
    [super viewWillDisappear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self getData];
    self.isEdite = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)returnText:(ReturnTextBlock)block {
    self.returnTextBlock = block;
}

- (void)bindView {


    self.title = @"发票信息";

    self.ViVATinvoice.frame = CGRectMake(0, 50, SCREEN_W, SCREEN_H - 50 - 64 - 64);
    [self.view addSubview:self.ViVATinvoice];

    self.ViVATinvoice.hidden = YES;

    self.viCommonInvoice.frame = CGRectMake(0, 50, SCREEN_W, SCREEN_H - 50 - 64 -64);
    [self.view addSubview:self.viCommonInvoice];

    self.btnChoose.adjustsImageWhenHighlighted = NO;
    self.tvVIAInvoiceList.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tvCommenInvoiceList.separatorStyle = UITableViewCellSelectionStyleNone;
    self.btnRight.hidden = NO;
    [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(10, 0, 33, 22);






}

- (void)getData {

    InvoiceViewModel *vm = [InvoiceViewModel new];

    WS(ws);
    [vm selectInVoiceWithType:0 callback:^(NSArray *arr) {

        ws.arrCommenInvoice = arr;
        [ws.tvCommenInvoiceList reloadData];

    }];

    [vm selectInVoiceWithType:1 callback:^(NSArray *arr) {

        ws.arrAddInvoice = arr;
        [ws.tvVIAInvoiceList reloadData];
        
    }];


}

- (void)onRightAction {


    self.isEdite = self.isEdite == 0?1:0;

    if (![self.ViVATinvoice isHidden]) {

        [self.tvCommenInvoiceList reloadData];

    }else  {

        [self.tvVIAInvoiceList reloadData];
    }

    if(self.isEdite == 1){

        [self.btnRight setTitle:@"完成" forState:UIControlStateNormal];

    }else {

        [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];
    }


}

- (void)showAllAction:(UIButton *)btn {

    self.showAll = (int)btn.tag;

    InvoiceModel *model;
    model = [self.arrAddInvoice objectAtIndex:btn.tag];

    if (model.isShowAll == 1) {
        model.isShowAll = 0;
    }else {
        model.isShowAll = 1;
    }

    [self.tvCommenInvoiceList reloadData];
    [self.tvVIAInvoiceList reloadData];


}

- (void)setDefaultAction:(UIButton *)btn {

    InvoiceModel *model;
    if (![self.ViVATinvoice isHidden]) {

        model = [self.arrCommenInvoice objectAtIndex:btn.tag];

    }else  {

        model = [self.arrAddInvoice objectAtIndex:btn.tag];
    }


    InvoiceViewModel *vm = [InvoiceViewModel new];

    WS(ws);

    [vm setDefaultInVoiceWithId:model.ID callback:^(NSString *orderNo) {

        [ws.tvCommenInvoiceList reloadData];
        [ws.tvVIAInvoiceList reloadData];

    }];


}

- (void)editeAction:(UIButton *)btn {

     InvoiceModel *model;
    if (![self.ViVATinvoice isHidden]) {

        model = [self.arrCommenInvoice objectAtIndex:btn.tag];

    }else  {

        model = [self.arrAddInvoice objectAtIndex:btn.tag];
    }

    AddInvoiceViewController *vc = [AddInvoiceViewController new];
    vc.invoiceModel = model;

     [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)addInvoiceAction:(id)sender {

//    ContainerViewModel *vm = [ContainerViewModel new];
//    [vm addInVoice];



    AddInvoiceViewController *vc = [AddInvoiceViewController new];

    if (![self.ViVATinvoice isHidden]) {

        vc.type =0;

    }else {

        vc.type =1;
    }

    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)chooseAction:(id)sender {

    self.isEdite = 0;

    if (![self.ViVATinvoice isHidden]) {

        self.viCommonInvoice.hidden = NO;
        self.ViVATinvoice.hidden = YES;
        [self.btnChoose setImage:[UIImage imageNamed:@"Invoice1"] forState:UIControlStateNormal];



    }else  {

        self.viCommonInvoice.hidden = YES;
        self.ViVATinvoice.hidden = NO;
        [self.btnChoose setImage:[UIImage imageNamed:@"Invoice2"] forState:UIControlStateNormal];

    }

    [self.tvVIAInvoiceList reloadData];
    [self.tvCommenInvoiceList reloadData];

    [self.btnRight setTitle:@"编辑" forState:UIControlStateNormal];




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

    if (tableView.tag == 11) {

        return self.arrAddInvoice.count;
    }



    return self.arrCommenInvoice.count;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{




    if (tableView.tag == 11) {

        InvoiceModel *model;

        model = [self.arrAddInvoice objectAtIndex:indexPath.row];
        if (model.isShowAll ==1) {
             return self.isEdite == 0?238 - 45 + 170 - 8:408 - 8;
        }

        return self.isEdite == 0?230 - 45:230;
        

    }

    return self.isEdite == 0?155-8:230;




}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView.tag == 11 ) {


        InvoiceModel *model;

        model = [self.arrAddInvoice objectAtIndex:indexPath.row];
        if (model.isShowAll == 1) {
            static NSString *CellIdentifier = @"Celled";
            VATInvoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VATInvoiceTableViewCell" owner:self options:nil];


            cell = [array objectAtIndex:0];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.viButton.hidden = self.isEdite == 0?YES:NO;

            cell.lbName.text = model.contactsName;
            cell.lbPhone.text = model.contactsTel;
            cell.lbAddress.text = model.contactsAddress;
            //cell.lbAddress.text = @"厚度是短促的内存金额的不能军Eric呢滴女词人发男人非你让你";


            CGFloat labelHeight = [cell.lbAddress sizeThatFits:CGSizeMake(cell.lbAddress.frame.size.width, MAXFLOAT)].height;
            NSNumber *count = @((labelHeight) / cell.lbAddress.font.lineHeight);
            if ([count intValue] == 1) {
                cell.lbAddress.text = [NSString stringWithFormat:@"%@\n",model.contactsAddress];
            }

            cell.lbCompany.text = model.title;
            cell.lbRegTel.text = model.regTel;
            cell.lbRegBank.text = model.regBlankAccount;
            cell.lbRegAcount.text = model.regBlank;
            cell.lbRegAddress.text = model.regAddress;
            cell.lbIdCode.text = model.idCode;

            cell.btnShowAll.tag = (int)indexPath.row;
            [cell.btnShowAll addTarget:self action:@selector(showAllAction:) forControlEvents:UIControlEventTouchUpInside];

            cell.btnSetDefault.tag = (int)indexPath.row;
            [cell.btnSetDefault addTarget:self action:@selector(setDefaultAction:) forControlEvents:UIControlEventTouchUpInside];

            cell.btnEditbtn.tag = (int)indexPath.row;
            [cell.btnEditbtn addTarget:self action:@selector(editeAction:) forControlEvents:UIControlEventTouchUpInside];
            if (indexPath.row == 0) {
                cell.ivDefault.hidden = NO;
            }

            if ([self.currentmodel isEqual:model]) {
                cell.ivChoose.hidden = NO;
            }

            return cell;

        }
    }




    static NSString *CellIdentifier = @"Celled";
    VIAInvoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"VIAInvoiceTableViewCell" owner:self options:nil];
    cell = [array objectAtIndex:0];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.viButton.hidden = self.isEdite == 0?YES:NO;

    InvoiceModel *model;

    if (tableView.tag == 11) {

        model = [self.arrAddInvoice objectAtIndex:indexPath.row];
        cell.viButton.hidden = self.isEdite == 0?YES:NO;
    }else{

        model = [self.arrCommenInvoice objectAtIndex:indexPath.row];
        cell.viButton.hidden = self.isEdite == 0?YES:NO;
        cell.btnShowAll.hidden = YES;


    }
    cell.lbName.text = model.contactsName;
    cell.lbPhone.text = model.contactsTel;
    cell.lbAddress.text = model.contactsAddress;

    CGFloat labelHeight = [cell.lbAddress sizeThatFits:CGSizeMake(cell.lbAddress.frame.size.width, MAXFLOAT)].height;
    NSNumber *count = @((labelHeight) / cell.lbAddress.font.lineHeight);
    if ([count intValue] == 1) {
        cell.lbAddress.text = [NSString stringWithFormat:@"%@\n",model.contactsAddress];
    }
    cell.lbCompany.text = model.title;

    cell.btnShowAll.tag = (int)indexPath.row;
    [cell.btnShowAll addTarget:self action:@selector(showAllAction:) forControlEvents:UIControlEventTouchUpInside];

    cell.btnSetDefault.tag = (int)indexPath.row;
    [cell.btnSetDefault addTarget:self action:@selector(setDefaultAction:) forControlEvents:UIControlEventTouchUpInside];

    cell.btnEditbtn.tag = (int)indexPath.row;
    [cell.btnEditbtn addTarget:self action:@selector(editeAction:) forControlEvents:UIControlEventTouchUpInside];

    if (indexPath.row == 0) {
        cell.ivDefault.hidden = NO;
    }
    if ([self.currentmodel.ID isEqual:model.ID]) {
        cell.ivChoose.hidden = NO;
    }

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    InvoiceModel *model;

    if (tableView.tag == 11) {

        model = [self.arrAddInvoice objectAtIndex:indexPath.row];

    }else{

        model = [self.arrCommenInvoice objectAtIndex:indexPath.row];

        
    }

    self.currentmodel = model;
    self.invoiceModel = model;

    [self.navigationController popViewControllerAnimated:YES];
//
//    [self.tvVIAInvoiceList reloadData];
//    [self.tvCommenInvoiceList reloadData];
    
}

@end
