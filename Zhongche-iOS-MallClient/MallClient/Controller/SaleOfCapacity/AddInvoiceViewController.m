//
//  AddInvoiceViewController.m
//  MallClient
//
//  Created by lxy on 2016/12/15.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "AddInvoiceViewController.h"
#import "InvoiceModel.h"
#import "InvoiceViewModel.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>

@interface AddInvoiceViewController ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tfTitle1;
@property (weak, nonatomic) IBOutlet UITextField *tfName1;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone1;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress1;
@property (weak, nonatomic) IBOutlet UITextField *tfTitle2;
@property (weak, nonatomic) IBOutlet UITextField *tfIdCode;
@property (weak, nonatomic) IBOutlet UITextField *tfRegAddress;
@property (weak, nonatomic) IBOutlet UITextField *tfRegTel;
@property (weak, nonatomic) IBOutlet UITextField *tfRegAccount;
@property (weak, nonatomic) IBOutlet UITextField *tfRegBlank;
@property (weak, nonatomic) IBOutlet UITextField *tfName2;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone2;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress2;
@property (weak, nonatomic) IBOutlet UISwitch *switchDefault;
@property (nonatomic, assign) int contactType;//1、普通发票 2、增值税发票

@end

@implementation AddInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)bindView {

    self.title = @"发票信息";
    self.viCommenInvoice.frame = CGRectMake(0, 50, SCREEN_W, SCREEN_H - 50 - 64 - 44);
    [self.view addSubview:self.viCommenInvoice];

     self.viCommenInvoice.hidden = YES;


    self.svVATInvoice.frame = CGRectMake(0, 50, SCREEN_W, SCREEN_H - 50 - 64 - 44);
    [self.view addSubview:self.svVATInvoice];

    self.svVATInvoice.contentSize = CGSizeMake(SCREEN_W, 580);
    self.btnChoose.adjustsImageWhenHighlighted = NO;

    self.viVATInvoice.frame = CGRectMake(0, 0, SCREEN_W, 580);
    [self.svVATInvoice addSubview:self.viVATInvoice];


    if(self.type == 0){

        self.viCommenInvoice.hidden = NO;
        self.svVATInvoice.hidden = YES;
        [self.btnChoose setImage:[UIImage imageNamed:@"Invoice2"] forState:UIControlStateNormal];
        self.invoiceModel.type = @"INVOICE_TYPE_COMMON_TAX";

    }else{

        self.viCommenInvoice.hidden = YES;
        self.svVATInvoice.hidden = NO;
        [self.btnChoose setImage:[UIImage imageNamed:@"Invoice1"] forState:UIControlStateNormal];
        self.invoiceModel.type = @"INVOICE_TYPE_VALUE_ADD_TAX";

    }
    
    if (self.invoiceModel) {


        self.btnChoose.enabled = NO;
        self.title = @"编辑发票";
        if ([self.invoiceModel.type isEqualToString:@"INVOICE_TYPE_VALUE_ADD_TAX"]) {


            self.tfTitle2.text = self.invoiceModel.title;
            self.tfName2.text = self.invoiceModel.contactsName;
            self.tfPhone2.text = self.invoiceModel.contactsTel;
            self.tfAddress2.text = self.invoiceModel.contactsAddress;
            self.tfIdCode.text = self.invoiceModel.idCode;
            self.tfRegAddress.text = self.invoiceModel.regAddress;
            self.tfRegTel.text = self.invoiceModel.regTel;
            self.tfRegAccount.text = self.invoiceModel.regBlankAccount;
            self.tfRegBlank.text = self.invoiceModel.regBlank;


        }else {

            self.viCommenInvoice.hidden = NO;
            self.svVATInvoice.hidden = YES;
            [self.btnChoose setImage:[UIImage imageNamed:@"Invoice2"] forState:UIControlStateNormal];
            self.tfTitle1.text = self.invoiceModel.title;
            self.tfName1.text = self.invoiceModel.contactsName;
            self.tfPhone1.text = self.invoiceModel.contactsTel;
            self.tfAddress1.text = self.invoiceModel.contactsAddress;

        }
    }else {
        self.invoiceModel = [InvoiceModel new];
        self.invoiceModel.type = @"INVOICE_TYPE_COMMON_TAX";
    }

}

- (void)bindAction {
    [self.switchDefault addTarget:self action:@selector(remarksAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)remarksAction:(UISwitch *)sw {

    if ([sw isOn]) {

        self.invoiceModel.isDefault = @"1";

    }else {
        self.invoiceModel.isDefault = @"0";

    }
    
}

- (IBAction)saveAction:(id)sender {

    InvoiceModel *model = self.invoiceModel;
    if (self.type == 0) {

        //添加普通发票

        model.title = self.tfTitle1.text;
            
        model.contactsName = self.tfName1.text;
        model.contactsTel = self.tfPhone1.text;
        model.contactsAddress = self.tfAddress1.text;
        model.type = @"INVOICE_TYPE_COMMON_TAX";




    }else{

        //添加增值税发票

        model.title = self.tfTitle2.text;
        model.contactsName = self.tfName2.text;
        model.contactsTel = self.tfPhone2.text;
        model.contactsAddress = self.tfAddress2.text;
        model.idCode = self.tfIdCode.text;
        model.regAddress = self.tfRegAddress.text;
        model.regTel = self.tfRegTel.text;
        model.regBlankAccount = self.tfRegAccount.text;
        model.regBlank = self.tfRegBlank.text;
        model.type = @"INVOICE_TYPE_VALUE_ADD_TAX";


    }


    InvoiceViewModel *vm = [InvoiceViewModel new];

    WS(ws);


    if (model.ID) {
        [vm updateInVoiceWithInvoiceInfo:model callback:^(NSString *status) {

            [[Toast shareToast]makeText:@"更新成功" aDuration:1];
            [ws.navigationController popViewControllerAnimated:YES];
            
        }];
    }else {

        [vm addInVoiceWithInvoiceInfo:model callback:^(NSString *status) {

            [[Toast shareToast]makeText:@"添加成功" aDuration:1];
            [ws.navigationController popViewControllerAnimated:YES];

        }];
        
    }




}

- (IBAction)chooseAction:(id)sender {

    if (![self.svVATInvoice isHidden]) {

        self.viCommenInvoice.hidden = NO;
        self.svVATInvoice.hidden = YES;
        [self.btnChoose setImage:[UIImage imageNamed:@"Invoice2"] forState:UIControlStateNormal];
        self.invoiceModel.type = @"INVOICE_TYPE_COMMON_TAX";

    }else  {

        self.viCommenInvoice.hidden = YES;
        self.svVATInvoice.hidden = NO;
        [self.btnChoose setImage:[UIImage imageNamed:@"Invoice1"] forState:UIControlStateNormal];
         self.invoiceModel.type = @"INVOICE_TYPE_VALUE_ADD_TAX";
    }
}

- (IBAction)chooseContactAction1:(id)sender {

    self.contactType = 1;

    [self addPhoneBookView];

}


- (IBAction)chooseContactAction2:(id)sender {

    self.contactType = 2;

    [self addPhoneBookView];
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

    if(self.contactType == 1){
        self.tfName1.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        self.tfPhone1.text = arrMPhoneNums[0];
    }else{

        self.tfName2.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        self.tfPhone2.text = arrMPhoneNums[0];

    }


    [picker dismissViewControllerAnimated:YES completion:nil];
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

    if(self.contactType == 1){

        self.tfName1.text = fullName;
        self.tfPhone1.text = value;
    }else{

        self.tfName2.text = fullName;
        self.tfPhone2.text = value;
    }


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

    if(self.contactType == 1){

        self.tfName1.text = fullName;
        self.tfPhone1.text = value;

    }else{

        self.tfName2.text = fullName;
        self.tfPhone2.text = value;
    }
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];

    return YES;
}
@end
