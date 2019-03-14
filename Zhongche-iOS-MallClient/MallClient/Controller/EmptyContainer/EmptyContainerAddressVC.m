//
//  EmptyContainerAddressVC.m
//  MallClient
//
//  Created by lxy on 2017/1/3.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyContainerAddressVC.h"
#import "CitySql.h"
#import "ZCCityListViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressSearch.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "StationVC.h"

@interface EmptyContainerAddressVC ()<UIPickerViewDelegate,UIPickerViewDataSource,ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate,ZCCityListViewControllerDelagate,ZCStationListViewControllerDelagate>

@property (weak, nonatomic) IBOutlet UIView *viAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnCentain;
@property (nonatomic, strong) NSArray *arrPrivience;
@property (nonatomic, strong) NSArray *arrCity;
@property (nonatomic, strong) NSArray *arrEstate;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UITextField *tfStart;
@property (weak, nonatomic) IBOutlet UITextField *tfStartStation;
@property (weak, nonatomic) IBOutlet UITextField *tfEnd;
@property (weak, nonatomic) IBOutlet UITextField *tfEndStation;

@property (nonatomic, strong) CitySqlModel *currectModel;

@property (nonatomic, strong) CityModel *startCity;

@property (nonatomic, strong) StationModel *startStation;
@property (nonatomic, strong) StationModel *endStation;

@property (nonatomic, assign) int isReturn;

@property (weak, nonatomic) IBOutlet UILabel *lbGiveBackTitle;

@property (weak, nonatomic) IBOutlet UIView *viGiveBack;
@property (nonatomic, assign) int type; //0、起始   1、结束

@end

@implementation EmptyContainerAddressVC


- (void)viewWillDisappear:(BOOL)animated {

    if (self.isReturn == 1) {

        if (self.returnInfoBlock != nil) {
            self.returnInfoBlock(self.tfName.text,self.tfPhone.text,self.startStation,self.endStation,self.startCity.fullName,self.endCity.fullName,self.endCity);
        }
    }

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/**
 *  加载视图
 */
- (void)bindView {

    self.title = @"添加地址";

    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    self.btnCentain.layer.masksToBounds = YES;
    self.btnCentain.layer.cornerRadius = 3;

    self.tfStart.text = self.containerOrderInfo.containerModel.cityName;

    self.tfStartStation.text = self.containerOrderInfo.containerModel.address;

    self.startStation = [StationModel new];
    self.startStation.name = self.containerOrderInfo.containerModel.address;
    self.startCity = [CityModel new];
    self.startCity.fullName = self.containerOrderInfo.containerModel.cityName;

    if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

        self.lbGiveBackTitle.hidden = YES;
        self.viGiveBack.hidden = YES;
    }


    if (self.containerOrderInfo.phone) {

        self.tfName.text = self.containerOrderInfo.name;
        self.tfPhone.text = self.containerOrderInfo.phone;
        self.tfEnd.text = self.containerOrderInfo.endFullName;
        self.tfEndStation.text = self.containerOrderInfo.endStation.name;

        self.endStation = self.containerOrderInfo.endStation;

    }

}

/**
 *  加载模型
 */
- (void)bindModel {

    CitySql *citys = [CitySql shareCitySql];
    self.arrPrivience = [citys selectAllProvincesData];

    CitySqlModel *city1 = [self.arrPrivience firstObject];
    self.arrCity = [citys selectTheNextCityDataWithCity:city1];

    CitySqlModel *city2 = [self.arrCity firstObject];
    self.currectModel = city2;

}

/**
 *  加载方法
 */
- (void)bindAction {
}

- (void)returnInfo:(ReturnInfoBlock)block{
    self.returnInfoBlock = block;
}


- (IBAction)startCityAction:(id)sender {

//    self.viAddress.hidden = NO;

//    ZCCityListViewController * vc = [ZCCityListViewController new];
//    vc.getCityDelagate = self;
//    vc.fromNaviC = YES;
//    [self.navigationController pushViewController:vc animated:YES];
//    self.type = 0;

}

- (IBAction)startStationAction:(id)sender {

//    if (self.startCity) {
//        StationVC *vc= [StationVC new];
//        vc.code = self.startCity.code;
//        vc.stationDelegate = self;
//        self.type = 0;
//        [self.navigationController pushViewController:vc animated:YES];
//
//    }else {
//        [[Toast shareToast]makeText:@"请先选择城市" aDuration:1];
//    }
}

- (IBAction)endCityAction:(id)sender {

//    self.viAddress.hidden = NO;

    ZCCityListViewController * vc = [ZCCityListViewController new];
    vc.getCityDelagate = self;
    vc.fromNaviC = YES;
    [self.navigationController pushViewController:vc animated:YES];
    self.type = 1;



}

- (IBAction)centainAction:(id)sender {

    // @"CONTAINER_RENTSALE_TYPE_SALE";
    if ([self.containerOrderInfo.type isEqualToString:@"CONTAINER_RENTSALE_TYPE_SALE"]) {

        if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]) {
            [[Toast shareToast]makeText:@"信息不完善" aDuration:1];

        }else {
            self.isReturn = 1;

            [self onBackAction];
            
        }

    }else {

        if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]||!self.startStation||!self.endStation) {
            [[Toast shareToast]makeText:@"信息不完善" aDuration:1];

        }else {

            NSString *searchText = self.tfPhone.text;
            NSError *error = NULL;

            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"1\\d{10}$" options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult *result = [regex firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
            if (!result) {

                [[Toast shareToast]makeText:@"手机号码错误" aDuration:1];
                
            }else{

                self.isReturn = 1;

               [self onBackAction];
            }

            
        }
    }




}

- (IBAction)endStationAction:(id)sender {

    if (self.endCity) {
        StationVC *vc= [StationVC new];
        vc.code = self.endCity.code;
        vc.stationDelegate = self;
        self.type = 1;
        [self.navigationController pushViewController:vc animated:YES];

    }else {
        [[Toast shareToast]makeText:@"请先选择城市" aDuration:1];
    }

}

- (IBAction)tongxunAction:(id)sender {

    [self addPhoneBookView];

}

- (IBAction)AddressChoose:(id)sender {

    if (self.type == 0) {

        self.tfStart.text = self.currectModel.full_name;

    }else {

         self.tfEnd.text = self.currectModel.full_name;
        
    }

    self.viAddress.hidden = YES;
}

/**
 *  pickdelegate
 *
 */

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

    return 2;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {

    if (component == 0) {

        return self.arrPrivience.count;

    }else if (component == 1) {

        return self.arrCity.count;
    }

    return self.arrEstate.count;
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {


    if (component == 0) {
        CitySqlModel *city = [self.arrPrivience objectAtIndex:row];
        return city.name;
    }

    if (component == 1) {
        CitySqlModel *city = [self.arrCity objectAtIndex:row];
        return city.name;
    }

    if (component == 2) {
        CitySqlModel *city = [self.arrEstate objectAtIndex:row];
        return city.name;
    }


     return @" ";
}

// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //self.transpoetation.carInfo = [self.arrCar objectAtIndex:row];

    CitySql *citys = [CitySql shareCitySql];
    self.arrPrivience = [citys selectAllProvincesData];

    if (component == 0) {

        CitySqlModel *city1 = [self.arrPrivience objectAtIndex:row];

        self.arrCity = [citys selectTheNextCityDataWithCity:city1];
        CitySqlModel *city2 = [self.arrCity objectAtIndex:0];

        self.currectModel = city2;

    }

    if (component == 1) {

        CitySqlModel *city2 = [self.arrCity objectAtIndex:row];
        self.currectModel = city2;
        
    }



    [pickerView reloadAllComponents];


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

    self.tfName.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];

    NSString *stPhone = arrMPhoneNums[0];
    self.tfPhone.text = [stPhone stringByReplacingOccurrencesOfString:@"-" withString:@""];

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
    self.tfName.text = fullName;
    self.tfPhone.text = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];

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
    self.tfName.text = fullName;
    self.tfPhone.text = [value stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];

    return YES;
}

- (void)getStationModel:(StationModel *)stationModel {

    if (self.type == 0) {

        self.tfStartStation.text = stationModel.name;
        self.startStation = stationModel;

    }else {

        self.tfEndStation.text = stationModel.name;
        self.endStation = stationModel;

    }

}

/**
 *  ZCCityListViewControllerDelagate
 *  选取城市回调
 */

- (void)getCityModel:(CityModel *)cityModel{

    if (self.type == 0) {

        self.tfStart.text = cityModel.fullName;
        self.startCity = cityModel;

    }else {

        self.tfEnd.text = cityModel.fullName;
        self.endCity = cityModel;

        self.endStation = nil;
        self.tfEndStation.text = @"";
    }

}

@end
