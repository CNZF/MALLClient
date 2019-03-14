//
//  SetAddressViewController.m
//  MallClient
//
//  Created by lxy on 2016/11/25.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "SetAddressViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressSearch.h"
#import "ContactAddressViewModel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "ZCCityListViewController.h"
#import "UITextField+LCWordLimit.h"

@interface SetAddressViewController ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UITextField *tfName1;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone1;
@property (weak, nonatomic) IBOutlet UITextField *tfAddress1;
@property (weak, nonatomic) IBOutlet UITextField *tfAdPlaceHolder1;
@property (weak, nonatomic) IBOutlet UILabel *lbCity1;
@property (weak, nonatomic) IBOutlet UITableView *tvList;

@property (weak, nonatomic) IBOutlet UITextField *CityField;


@property (nonatomic, strong) NSArray *arrPois;//地址列表
@property (nonatomic, strong) ContactAddressViewModel *vm;
@property (nonatomic, strong) AMapPOI *point;

@end

@implementation SetAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tfPhone1 lc_wordLimit:11];
    self.btnSave.layer.cornerRadius = 4.0f;
    self.btnSave.layer.masksToBounds = YES;
    self.view.backgroundColor = [HelperUtil colorWithHexString:@"f8f8f8"];
}


- (void)bindView {

    self.lbCity1.text = self.stCity;
    self.tfAdPlaceHolder1.placeholder = self.stCity;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

//    self.tfAddress1.hidden = YES;
    self.lbCity1.hidden = YES;
    self.btnSave.enabled = NO;
    self.CityField.delegate  = self;
    self.tfName1.delegate = self;
    self.tfPhone1.delegate = self;
    self.tfPhone1.keyboardType = UIKeyboardTypePhonePad;
    self.title = @"新增地址";
    [self.btnSave setBackgroundColor:APP_COLOR_GRAY2];
    if (self.info) {
//        if (self.info.regionName == nil) {
//            self.info.regionName = @"北京";
//        }
        self.title = @"修改地址信息";
        self.btnSave.enabled = YES;
        self.tfName1.text = self.info.contacts;
        self.tfPhone1.text = self.info.contactsPhone;
        self.tfAddress1.text = self.info.address;
        self.CityField.text = self.info.regionName;
//        self.tfAdPlaceHolder1.text = self.info.address;
        self.cityCode = self.info.regionCode;
        [self.btnSave setBackgroundColor:APP_COLOR_BLUE_BTN];
    }

    self.tvList.hidden = YES;
    self.tfAddress1.delegate = self;
    self.tfName1.delegate = self;
    self.tfPhone1.delegate = self;

    [self.tfAddress1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfName1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfPhone1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

}




- (void) textFieldDidChange:(UITextField *)tf {
    
    self.btnSave.enabled = (self.tfName1.text.length>0 && self.tfPhone1.text.length > 0);
     NSLog(@" =====%@",tf.text );

    AddressSearch *addressInfo = [AddressSearch shareAddressSearch];


    
    WS(ws);
    if (!self.stCity) {
        self.stCity  =@"北京";
    }
    [addressInfo searchKeyword:tf.text withCity:self.CityField.text withCallback:^(NSArray<NSString *> * _Nullable pois, NSString * _Nullable st) {

        if ([st isEqualToString:ws.tfAddress1.text]) {

                    ws.arrPois = pois;
                    [ws.tvList reloadData];

        }

    }];
}

- (IBAction)chooseContactAction1:(id)sender {

    [self addPhoneBookView];

}

- (IBAction)SetAddressAction1:(id)sender {

    self.tfAddress1.hidden = NO;

    self.lbCity1.hidden = NO;

    self.tfAdPlaceHolder1.hidden = YES;

    [self.tfAddress1 becomeFirstResponder];

    self.view.frame = CGRectMake(0, -40, SCREEN_W, SCREEN_H);


}

- (IBAction)addAction:(id)sender {

    //添加手机号码校验
    [self.view endEditing:YES];
    
    if ([YMKJVerificationTools stringContrainsEmoji:self.tfName1.text]) {
        [[Toast shareToast]makeText:@"联系人信息包含非法字符" aDuration:1];
        return;
    }
    
    if (self.tfPhone1.text.length!= 11) {
        [[Toast shareToast]makeText:@"错误的手机格式" aDuration:1];
        return;
    }else if (![YMKJVerificationTools isAvailablePhoneNumber:self.tfPhone1.text]){
        [[Toast shareToast]makeText:@"错误的手机格式" aDuration:1];
        return;
    }
    
    if (self.tfAddress1.text.length>0 && self.CityField.text.length<1) {
        [[Toast shareToast]makeText:@"请完善信息" aDuration:1];
        return;
    }
    if (self.tfAddress1.text.length < 1 && self.CityField.text.length >0) {
        [[Toast shareToast]makeText:@"请完善信息" aDuration:1];
        return;
    }
    
    ContactAddressViewModel *vm = [ContactAddressViewModel new];

    WS(ws);
    if (self.info) {

        if (!self.point) {
            self.point = [AMapPOI new];
            self.point.location = [AMapGeoPoint new];
            self.point.location.latitude = (CGFloat)[self.info.lat floatValue];
            self.point.location.longitude = (CGFloat)[self.info.lng floatValue];
            self.point.name = self.info.address;
        }

        [vm updateAddressWithName:self.tfName1.text WithPhone:self.tfPhone1.text WithAddress:self.point WithCityCode:self.cityCode WithId:self.info.ID callback:^(NSString *status) {

            [[Toast shareToast]makeText:@"保存成功" aDuration:1];
            [ws.navigationController popViewControllerAnimated:YES];


        }];

    }else {

        if (![self.tfName1.text isEqualToString:@""]&&![self.tfPhone1.text isEqualToString:@""]) {

            [vm addAddressWithName:self.tfName1.text WithPhone:self.tfPhone1.text WithAddress:self.point WithCityCode:self.cityCode WithType:self.type callback:^(NSString *status) {

                [[Toast shareToast]makeText:@"保存成功" aDuration:1];
                
                [ws.navigationController popViewControllerAnimated:YES];

            }];
        }
    }
}

- (ContactAddressViewModel *)vm {
    if (!_vm) {
        _vm = [ContactAddressViewModel new];

    }
    return _vm;
}



/**
 *
 *  @param tableView delegate
 *
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{



    return self.arrPois.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }

    AMapPOI *poi =[self.arrPois objectAtIndex:indexPath.row];
    cell.textLabel.text = poi.name;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    [self.tfAddress1 resignFirstResponder];
     AMapPOI *poi =[self.arrPois objectAtIndex:indexPath.row];
    self.point = poi;

   self.tfAddress1.text = poi.name;

}


/**
 *  UITextFiledDelegate
 *
 */

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.CityField) {
        ZCCityListViewController * vc = [[ZCCityListViewController alloc] init];
        //        vc.fromNaviC = YES;
        vc.completeBlock = ^(CityModel *model) {
            
            self.CityField.text = model.name;
            //获取参数
            self.cityCode = model.code;
            
        };
        [self.navigationController pushViewController:vc animated:YES];
        return NO;
    }
    
    
    self.tvList.hidden = NO;

    return YES;

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

     self.view.frame = CGRectMake(0, 64, SCREEN_W, SCREEN_H);

    self.tvList.hidden = YES;

    if (![self.tfName1.text isEqualToString:@""]&&![self.tfPhone1.text isEqualToString:@""]) {

        [self.btnSave setBackgroundColor:APP_COLOR_BLUE_BTN];
    }

    return YES;
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

        self.tfName1.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        self.tfPhone1.text = arrMPhoneNums[0];
        self.btnSave.enabled = YES;
        [self.btnSave setBackgroundColor:APP_COLOR_BLUE_BTN];
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
        self.tfName1.text = fullName;
        NSString *strUrl = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.tfPhone1.text = strUrl;
        self.btnSave.enabled = (self.tfName1.text.length>0 && self.tfPhone1.text.length > 0);

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
    self.tfName1.text = fullName;
    NSString *strUrl = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.tfPhone1.text = strUrl;
    self.btnSave.enabled = YES;

    return YES;
}

@end
