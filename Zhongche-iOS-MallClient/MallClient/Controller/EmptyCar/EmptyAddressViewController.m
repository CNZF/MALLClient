//
//  EmptyAddressViewController.m
//  MallClient
//
//  Created by lxy on 2017/3/30.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EmptyAddressViewController.h"
#import "YMTextView.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressSearch.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface EmptyAddressViewController ()<ABPeoplePickerNavigationControllerDelegate,CNContactPickerDelegate>
@property (weak, nonatomic  ) IBOutlet UIView      *startView;
@property (weak, nonatomic  ) IBOutlet UIView      *endView;

@property (weak, nonatomic  ) IBOutlet UILabel     *lbStart;
@property (weak, nonatomic  ) IBOutlet UILabel     *lbEnd;
@property (weak, nonatomic) IBOutlet UILabel *lbTytle1;
@property (weak, nonatomic) IBOutlet UILabel *lbTytle2;
@property (weak, nonatomic) IBOutlet UIView *viStartProvince;
@property (weak, nonatomic) IBOutlet UIView *viEndProvince;

@property (nonatomic, assign) int isReturn;


@end

@implementation EmptyAddressViewController

- (void)viewWillDisappear:(BOOL)animated {

    if (self.isReturn == 1) {

        if (self.returnInfoBlock != nil) {
            self.returnInfoBlock(self.tfName.text,self.tfPhone.text,self.tvStart.text,self.tvEnd.text);
        }
    }

    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.title = @"填写地址";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)bindView {


    self.tvStart.frame = CGRectMake(95, 0, SCREEN_W - 100, 50);
    self.tvEnd.frame = CGRectMake(95, 0, SCREEN_W - 100, 50);

    [self.startView addSubview:self.tvStart];
    [self.endView addSubview:self.tvEnd];

    if (self.type == 1) {

        self.lbTytle1.hidden = YES;
        self.lbTytle2.hidden = YES;
        self.startView.hidden = YES;
        self.endView.hidden = YES;
        self.viStartProvince.hidden = YES;
        self.viEndProvince.hidden = YES;

    }

    if (self.currentModel) {
        if (!self.currentModel.currentLine.startParentAddress) {
            self.currentModel.currentLine.startParentAddress  =@"";
        }

        if (!self.currentModel.currentLine.endParentAddress) {
            self.currentModel.currentLine.endParentAddress  =@"";
        }

        self.lbStart.text = [NSString stringWithFormat:@"%@%@",self.currentModel.currentLine.startParentAddress,self.currentModel.currentLine.startCity];
        self.lbEnd.text = [NSString stringWithFormat:@"%@%@",self.currentModel.currentLine.endParentAddress,self.currentModel.currentLine.endCity];

    }

    if (self.name) {
        self.tfName.text = self.name;
        self.tfPhone.text = self.phone;
    }

}

- (YMTextView *)tvStart {
    if (!_tvStart) {
        _tvStart = [YMTextView new];
        _tvStart.placeholder = @"输入详细地址";
        _tvStart.font = [UIFont systemFontOfSize:14];

    }
    return _tvStart;
}

- (YMTextView *)tvEnd {
    if (!_tvEnd) {
        _tvEnd = [YMTextView new];
        _tvEnd.placeholder = @"输入详细地址";
        _tvEnd.font = [UIFont systemFontOfSize:14];

    }
    return _tvEnd;
}

- (IBAction)tongxunluAction:(id)sender {

    [self addPhoneBookView];
}

- (IBAction)centainAction:(id)sender {

    if (self.type == 1) {

        if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]) {
            [[Toast shareToast]makeText:@"信息不完善" aDuration:1];

        }else {
            self.isReturn = 1;

            [self onBackAction];
            
        }



    }else {
        if ([self.tfName.text isEqualToString:@""]||[self.tfPhone.text isEqualToString:@""]||[self.tvStart.text isEqualToString:@""]||[self.tvEnd.text isEqualToString:@""]) {
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

    self.tfPhone.text = [arrMPhoneNums[0] stringByReplacingOccurrencesOfString:@"-" withString:@""];

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

- (void)returnInfo:(ReturnBlock)block{
    self.returnInfoBlock = block;
}


@end
