//
//  CustomCapacityController.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CustomCapacityController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SelectView.h"
#import "CapacityEntryCell.h"
#import "CapacityViewModel.h"
#import "OrderTransportSuccessViewController.h"

typedef enum
{
    boxNumTag = 1,
    pNameTag,
    pPhoneTag,
    totalWeightTfdTag,
    numberTfdTag,
    goodsNumTfdTag,
    volumeTfdTag,
    carNumTfdTag,
    longTag,
    hightTag,
    wideTag,
    maxWeightTag,

}TextFiledTag;

@interface CustomCapacityController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, strong) UITableView    *tbv;
@property (nonatomic, strong) NSMutableArray *dataSubArray;
@property (nonatomic, strong) UIView         *headView;//头
@property (nonatomic, strong) UIButton       *packaging;
@property (nonatomic, strong) UIButton       *servicemMode;
@property (nonatomic, strong) UIButton       *bringYourOwnCase;
@property (nonatomic, strong) UITextField    *boxNum;
@property (nonatomic, strong) UITextField    *totalWeightTfd;//总重量
@property (nonatomic, strong) UITextField    *numberTfd;//件数
@property (nonatomic, strong) UITextField    *goodsNumTfd;//货品数量
@property (nonatomic, strong) UITextField    *volumeTfd;//体积
@property (nonatomic, strong) UITextField    *carNumTfd;//车辆数
@property (nonatomic, strong) UITextField    *maxWeightTfd;//最大单件重量
@property (nonatomic, strong) UITextField    *hightTfd;//高
@property (nonatomic, strong) UITextField    *longTfd;//长
@property (nonatomic, strong) UITextField    *wideTfd;//宽
@property (nonatomic, strong) UIView         *personView;//联系人信息
@property (nonatomic, strong) UITextField    *pName;
@property (nonatomic, strong) UITextField    *pPhone;
@property (nonatomic, strong) UIButton       *phoneBook;
@property (nonatomic, strong) UIView         *btnView;//按钮
@property (nonatomic, strong) UIButton       *completeBtn;
@property (nonatomic, strong) UIView         *lastView;

@end

@implementation CustomCapacityController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"定制运力";
}

-(void)bindView {
    self.pName.frame = CGRectMake(20, 45, SCREEN_W - 60, 20);
    [self.personView addSubview:self.pName];
    
    self.pPhone.frame = CGRectMake(20, 120, SCREEN_W - 40, 20);
    [self.personView addSubview:self.pPhone];
    
    self.phoneBook.frame = CGRectMake(SCREEN_W - 44, 33, 40, 44);
    [self.personView addSubview:self.phoneBook];
    
    self.completeBtn.frame = CGRectMake(20, 50, SCREEN_W - 40, 44);
    [self.btnView addSubview:self.completeBtn];
    
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.tbv];
}

-(void)bindModel {
    [self.packaging setTitle:@"是" forState:UIControlStateNormal];
    [self.servicemMode setTitle:@"无" forState:UIControlStateNormal];
    
    self.capacityEntry.isPackaging = self.packaging.titleLabel.text;
    self.capacityEntry.serviceWay = self.servicemMode.titleLabel.text;
    
    [self.dataSubArray addObject:@[self.capacityEntry]];
    [self.tbv reloadData];
    [self refreshCompleteBtn];
}

-(void)bindAction {
    WS(ws);
    [[self.packaging rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
        [SelectView addSelectViewWithEntrys:@[@"是",@"否"] WithSelectEntry:ws.packaging.titleLabel.text WithCallback:^(NSString * str) {
            [ws.packaging setTitle:str forState:UIControlStateNormal];
            ws.capacityEntry.isPackaging = str;
            [self refreshCompleteBtn];
        }];
     }];
    
    [[self.servicemMode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [SelectView addSelectViewWithEntrys:@[@"无",@"上门取货",@"送货上门",@"上门取货+送货上门"] WithSelectEntry:ws.servicemMode.titleLabel.text WithCallback:^(NSString * str) {
             [ws.servicemMode setTitle:str forState:UIControlStateNormal];
             [self makeButton:ws.servicemMode];
             ws.capacityEntry.serviceWay = str;
             [self refreshCompleteBtn];

         }];
     }];
    
    [[self.completeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [[CapacityViewModel new]makeCapacityWthCapacityInfo:ws.capacityEntry callback:^(BOOL success) {
             if(success)
             {

                 if(ws.vcDelgate){

                     [ws.vcDelgate needPushNextView];

                 }else{

                     [ws.navigationController pushViewController:[OrderTransportSuccessViewController new] animated:YES];
                 }
             }
         }];
     }];
    
    [[self.phoneBook rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [self addPhoneBookView];
     }];
    MJRefreshNormalHeader * header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws.vcDelgate needGoBackLastView];
        [ws.tbv.mj_header endRefreshing];

    }];

    //设置开关
    if (self.isRefush != 1) {

        self.tbv.mj_header = header;
        [header setTitle:@"下拉返回集装箱" forState:MJRefreshStateIdle];
        [header setTitle:@"松手返回集装箱" forState:MJRefreshStatePulling];
        [header setTitle:@"返回集装箱" forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.arrowView.hidden = YES;

    }
}

-(void)refreshCompleteBtn {
    
}

- (void)makeButton:(UIButton *)btn {
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,
                                             -(btn.width -  [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width), 0.0,0.0)];
}

#pragma mark - Getter

-(UIView *)headView {
    if (!_headView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        _headView = view;
    }
    return _headView;
}

-(UIButton *)packaging {
    if (!_packaging) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _packaging = btn;
    }
    return _packaging;
}

-(UIButton *)servicemMode {
    if (!_servicemMode) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _servicemMode = btn;
    }
    return _servicemMode;
}

-(UIButton *)bringYourOwnCase {
    if (!_bringYourOwnCase) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _bringYourOwnCase = btn;
    }
    return _bringYourOwnCase;
}

-(UITextField *)boxNum {
    if (!_boxNum) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = boxNumTag;
        _boxNum = tfd;
    }
    return _boxNum;
}

-(UITextField *)totalWeightTfd {
    if (!_totalWeightTfd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = totalWeightTfdTag;
        _totalWeightTfd = tfd;
    }
    return _totalWeightTfd;
}

-(UITextField *)numberTfd {
    if (!_numberTfd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = numberTfdTag;
        tfd.text = @"0";
        _numberTfd = tfd;
    }
    return _numberTfd;
}

-(UITextField *)goodsNumTfd {
    if (!_goodsNumTfd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = goodsNumTfdTag;
        _goodsNumTfd = tfd;
    }
    return _goodsNumTfd;
}

-(UITextField *)volumeTfd {
    if (!_volumeTfd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = volumeTfdTag;
        _volumeTfd = tfd;
    }
    return _volumeTfd;
}

-(UITextField *)carNumTfd {
    if (!_carNumTfd) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = carNumTfdTag;
        _carNumTfd = tfd;
    }
    return _carNumTfd;
}

- (UITextField *)maxWeightTfd {
    if (!_maxWeightTfd) {
        _maxWeightTfd = [UITextField new];
        _maxWeightTfd.keyboardType = UIKeyboardTypeNumberPad;
        _maxWeightTfd.tag = maxWeightTag;
        _maxWeightTfd.delegate = self;
        //_maxWeightTfd.placeholder = @"====";


    }
    return _maxWeightTfd;
}

- (UITextField *)wideTfd {
    if (!_wideTfd) {
        _wideTfd = [UITextField new];
        _wideTfd.keyboardType = UIKeyboardTypeNumberPad;
        _wideTfd.tag  = wideTag;
        _wideTfd.delegate = self;

    }
    return _wideTfd;
}

- (UITextField *)longTfd {
    if (!_longTfd) {
        _longTfd = [UITextField new];
        _longTfd.keyboardType = UIKeyboardTypeNumberPad;
        _longTfd.tag = longTag;
        _longTfd.delegate = self;
        //_longTfd.placeholder = @"=======";

    }
    return _longTfd;
}

- (UITextField *)hightTfd {
    if (!_hightTfd) {
        _hightTfd = [UITextField new];
        _hightTfd.keyboardType = UIKeyboardTypeNumberPad;
        _hightTfd.tag = hightTag;
        _hightTfd.delegate = self;

    }
    return _hightTfd;
}

-(UIView *)personView{
    if (!_personView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;

        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20,20, SCREEN_W - 40, 17)];
        lab1.text = @"联系人姓名";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, lab1.bottom + 37, SCREEN_W - 40, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];

        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, SCREEN_W - 40, 17)];
        lab2.text = @"联系人电话";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(20, lab2.bottom + 37, SCREEN_W - 40, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        _personView = view;
    }
    return _personView;
}

-(UITextField *)pName {
    if (!_pName) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.delegate = self;
        tfd.tag = pNameTag;
        tfd.placeholder = @"输入联系人姓名";
        _pName = tfd;
    }
    return _pName;
}

-(UITextField *)pPhone {
    if (!_pPhone) {
        UITextField * tfd = [UITextField new];
        tfd.textColor = APP_COLOR_BLACK_TEXT;
        tfd.font = [UIFont systemFontOfSize:18];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.delegate = self;
        tfd.tag = pPhoneTag;
        tfd.placeholder = @"输入联系人电话";
        _pPhone = tfd;
    }
    return _pPhone;
}

-(UIButton *)phoneBook {
    if (!_phoneBook) {
        UIButton * btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:[@"iconfont-tongxunlu" adS]] forState:UIControlStateNormal];
        _phoneBook = btn;
    }
    return _phoneBook;
}

-(UIView *)btnView {
    if (!_btnView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 109, SCREEN_W, 17)];
        lab.text = @"请您补充相关信息，我们将在24小时内安排专人与您探讨方案";
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab];
        
        _btnView = view;
    }
    return _btnView;
}

-(UIButton *)completeBtn {
    if (!_completeBtn) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交定制方案" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_GRAY_BTN_1 andSize:CGSizeMake(SCREEN_W - 40, 44)] createRadius:5] forState:UIControlStateDisabled];
        [button setBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_BLUE_BTN andSize:CGSizeMake(SCREEN_W - 40, 44)] createRadius:5] forState:UIControlStateNormal];
        [button.layer setMasksToBounds:YES];
        [button.layer setCornerRadius:5.0];//设置矩形四个圆角半径
        _completeBtn = button;
    }
    return _completeBtn;
}

-(UIView *)lastView {
    if (!_lastView) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, SCREEN_W - 40, 17)];
        lab.text = @"已填信息";
        lab.font = [UIFont systemFontOfSize:12.0f];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab];
        
        _lastView = view;
    }
    return _lastView;
}

-(NSMutableArray *)dataSubArray {
    if (!_dataSubArray) {
        _dataSubArray = [NSMutableArray array];
        [_dataSubArray addObject:[NSArray new]];
        [_dataSubArray addObject:[NSArray new]];
        [_dataSubArray addObject:[NSArray new]];
    }
    return _dataSubArray;
}

- (UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;

        tableView.backgroundColor = APP_COLOR_WHITEBG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSString * type = [NSStringFromClass([self class]) componentsSeparatedByString:@"_"][1];
        [tableView registerClass:NSClassFromString([NSString stringWithFormat:@"CapacityEntryCell_%@",type]) forCellReuseIdentifier:[NSString stringWithFormat:@"CapacityEntryCell_%@",type]];
        
        _tbv = tableView;
    }
    return _tbv;
}

#pragma mark - Tabview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * type = [NSStringFromClass([self class]) componentsSeparatedByString:@"_"][1];
    CapacityEntryCell * cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"CapacityEntryCell_%@",type] forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell loadUIWithmodel:self.dataSubArray[indexPath.section][0]];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view;
    switch (section) {
        case 0:
            view = self.headView;
            break;
        case 1:
            view = self.personView;
            break;
        case 2:
            view = self.btnView;
            break;
        case 3:
            view = self.lastView;
            break;
        default:
            break;
    }
    return view;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSubArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSubArray[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    switch (section) {
        case 0:
            height = 155;
            break;
        case 1:
            height = 150;
            break;
        case 2:
            height = 155;
            break;
        case 3:
            height = 50;
            break;
        default:
            break;
    }
    return height;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case boxNumTag:
            self.capacityEntry.boxNum = textField.text;
            break;
        case pPhoneTag:
            self.capacityEntry.pPhone = textField.text;
            break;
        case pNameTag:
            self.capacityEntry.pName = textField.text;
            break;
        case totalWeightTfdTag:
            self.capacityEntry.totalWeight = textField.text;
            break;
        case numberTfdTag:
            self.capacityEntry.number = textField.text;
            break;
        case goodsNumTfdTag:
            self.capacityEntry.goodsNum = textField.text;
            break;
        case volumeTfdTag:
            self.capacityEntry.volume = textField.text;
            break;
        case carNumTfdTag:
            self.capacityEntry.carNum = textField.text;
            break;
        case longTag:
            self.capacityEntry.longCm = textField.text;
            break;
        case wideTag:
            self.capacityEntry.wideCm = textField.text;
            break;
        case hightTag:
            self.capacityEntry.highCm = textField.text;
            break;
        case maxWeightTag:
            self.capacityEntry.biggestWeight = textField.text;
            break;
        default:
            break;
    }
    [self refreshCompleteBtn];
}


#pragma mark - 通讯录

-(void)addPhoneBookView {
    float version = EQUIPMENTVERSION;
    if (version >= 9.0) {
        CNContactPickerViewController * contactVc = [CNContactPickerViewController new];
        contactVc.delegate = self;
        if (self.vcDelgate) {
            [self.vcDelgate presentViewController:contactVc animated:YES completion:^{
                
            }];
        }
        else
        {
            [self presentViewController:contactVc animated:YES completion:^{
                
            }];
        }
    }
    else
    {
        ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
        picker.peoplePickerDelegate = self;
        if (self.vcDelgate) {
            [self.vcDelgate presentViewController:picker animated:YES completion:nil];

        }
        else
        {
            [self presentViewController:picker animated:YES completion:nil];
        }
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
    self.pPhone.text = arrMPhoneNums[0];
    self.pName.text = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
    self.capacityEntry.pName = self.pName.text;
    self.capacityEntry.pPhone = self.pPhone.text;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self refreshCompleteBtn];
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
    self.pName.text = fullName;
    self.pPhone.text = value;
    self.capacityEntry.pName = self.pName.text;
    self.capacityEntry.pPhone = self.pPhone.text;
    [self refreshCompleteBtn];
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
    self.pName.text = fullName;
    self.pPhone.text = value;
    self.capacityEntry.pName = self.pName.text;
    self.capacityEntry.pPhone = self.pPhone.text;
    [self refreshCompleteBtn];
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];

    return YES;
}

@end
#pragma mark - 集装箱运力
@implementation CustomCapacityController_Container : CustomCapacityController

-(void)bindView {
    self.packaging.frame = CGRectMake(20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.packaging];
    [self.headView addSubview:self.packaging];
    
    self.servicemMode.frame = CGRectMake(self.packaging.right +20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];
    
    self.bringYourOwnCase.frame = CGRectMake(20, 130, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.bringYourOwnCase];
    [self.headView addSubview:self.bringYourOwnCase];
    
    self.boxNum.frame = CGRectMake(self.bringYourOwnCase.right +20, 130, SCREEN_W / 2 - 30, 20);;
    [self.headView addSubview:self.boxNum];
    
    [super bindView];
}

-(void)bindModel {
    [self.bringYourOwnCase setTitle:@"是" forState:UIControlStateNormal];
    self.boxNum.text = @"1";

    self.capacityEntry.isOwnBox = self.bringYourOwnCase.titleLabel.text;
    self.capacityEntry.boxNum = self.boxNum.text;
    [super bindModel];
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.bringYourOwnCase rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [SelectView addSelectViewWithEntrys:@[@"是",@"否"] WithSelectEntry:ws.bringYourOwnCase.titleLabel.text WithCallback:^(NSString * str) {
             [ws.bringYourOwnCase setTitle:str forState:UIControlStateNormal];
             ws.capacityEntry.isOwnBox = str;
             [self refreshCompleteBtn];
             
         }];
     }];
}

#pragma mark - Tabview Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 200;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 155;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab1.text = @"是否包装";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 100) / 2, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 40, 78, (SCREEN_W - 100) / 2, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, (SCREEN_W - 60)/ 2, 17)];
        lab3.text = @"是否自备箱";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];
        
        UILabel * lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.right + 20, lab3.top, (SCREEN_W - 60)/ 2, 17)];
        lab4.text = @"用箱数量";
        lab4.font = [UIFont systemFontOfSize:12.0f];
        lab4.textAlignment = NSTextAlignmentLeft;
        lab4.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab4];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20,lab3.bottom + 36, (SCREEN_W - 100) / 2, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];
        
        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(line3.right + 40, line3.top, (SCREEN_W - 100) / 2, 0.5)];
        line4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line4];
        
        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.isPackaging && self.capacityEntry.serviceWay && self.capacityEntry.isOwnBox && self.capacityEntry.boxNum && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}
@end

#pragma mark - 散堆装运力
@implementation CustomCapacityController_InBulk : CustomCapacityController

-(void)bindView {
//    self.packaging.frame = CGRectMake(20, 55, SCREEN_W / 2 - 30, 20);
//    [self makeButton:self.packaging];
//    [self.headView addSubview:self.packaging];

    self.servicemMode.frame = CGRectMake(20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];
    
    self.totalWeightTfd.frame = CGRectMake(20, 130, SCREEN_W / 2 - 30, 20);
    [self.headView addSubview:self.totalWeightTfd];
    
    self.volumeTfd.frame = CGRectMake(self.totalWeightTfd.right +20, 130, SCREEN_W / 2 - 30, 20);;
    [self.headView addSubview:self.volumeTfd];
    
    [super bindView];
}

-(void)bindModel {
    self.totalWeightTfd.text = @"0";
    self.volumeTfd.text = @"0";
    
    self.capacityEntry.totalWeight = self.totalWeightTfd.text;
    self.capacityEntry.volume_Custom = self.volumeTfd.text;
    [super bindModel];
}

#pragma mark - Tabview Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 170;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 155;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

#pragma mark - Getter

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
//        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 60)/ 2, 17)];
//        lab1.text = @"是否包装";
//        lab1.font = [UIFont systemFontOfSize:12.0f];
//        lab1.textAlignment = NSTextAlignmentLeft;
//        lab1.textColor = APP_COLOR_GRAY2;
//        [view addSubview:lab1];

        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
//        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 100) / 2, 0.5)];
//        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
//        [view addSubview:line1];

        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 100) / 2, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        
        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line2.bottom + 20, (SCREEN_W - 60)/ 2, 17)];
        lab3.text = @"总重量";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];
        
        UILabel * lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.right + 20, lab3.top, (SCREEN_W - 60)/ 2, 17)];
        lab4.text = @"体积";
        lab4.font = [UIFont systemFontOfSize:12.0f];
        lab4.textAlignment = NSTextAlignmentLeft;
        lab4.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab4];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20,lab3.bottom + 36, (SCREEN_W - 100) / 2, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];
        
        UILabel * lab3_1 = [[UILabel alloc]initWithFrame:CGRectMake(line3.right - 14, line3.top - 24, 14, 16)];
        lab3_1.text = @"吨";
        lab3_1.font = [UIFont systemFontOfSize:12.0f];
        lab3_1.textAlignment = NSTextAlignmentRight;
        lab3_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3_1];
        
        
        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(line3.right + 40, line3.top, (SCREEN_W - 100) / 2, 0.5)];
        line4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line4];
        
        UILabel * lab4_1 = [[UILabel alloc]initWithFrame:CGRectMake(line4.right - 20, line4.top - 24, 20, 16)];
        lab4_1.text = @"m³";
        lab4_1.font = [UIFont systemFontOfSize:12.0f];
        lab4_1.textAlignment = NSTextAlignmentRight;
        lab4_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab4_1];
        
        
        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.serviceWay && self.capacityEntry.totalWeight && self.capacityEntry.volume_Custom && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}

@end

#pragma mark - 三农化肥运力
@implementation CustomCapacityController_Fertilizer : CustomCapacityController

-(void)bindView {
    self.packaging.frame = CGRectMake(20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.packaging];
    [self.headView addSubview:self.packaging];
    
    self.servicemMode.frame = CGRectMake(self.packaging.right +20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];
    
    self.totalWeightTfd.frame = CGRectMake(self.servicemMode.right + 20, 55, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.totalWeightTfd];
    
    [super bindView];
}

-(void)bindModel {
    self.totalWeightTfd.text = @"0";
    
    self.capacityEntry.totalWeight = self.totalWeightTfd.text;
    [super bindModel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 170;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab1.text = @"是否包装";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab2.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab3.text = @"总重量";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];
        
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(line2.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];
        
        UILabel * lab3_1 = [[UILabel alloc]initWithFrame:CGRectMake(line3.right - 14, line3.top - 24, 14, 16)];
        lab3_1.text = @"吨";
        lab3_1.font = [UIFont systemFontOfSize:12.0f];
        lab3_1.textAlignment = NSTextAlignmentRight;
        lab3_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3_1];
        
        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.isPackaging && self.capacityEntry.serviceWay  && self.capacityEntry.totalWeight && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}

@end

#pragma mark - 批量成件运力
@implementation CustomCapacityController_Batch : CustomCapacityController

-(void)bindView {
    self.packaging.frame = CGRectMake(20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.packaging];
    [self.headView addSubview:self.packaging];
    
    self.servicemMode.frame = CGRectMake(self.packaging.right +20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];
    
    self.goodsNumTfd.frame = CGRectMake(self.servicemMode.right + 20, 55, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.goodsNumTfd];
    
    [super bindView];
}

-(void)bindModel {
    self.goodsNumTfd.text = @"0";
    
    self.capacityEntry.goodsNum = self.goodsNumTfd.text;
    [super bindModel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 240;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab1.text = @"是否包装";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab2.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab3.text = @"货品数量";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];
        
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(line2.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];
        
        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.isPackaging && self.capacityEntry.serviceWay  && self.capacityEntry.goodsNum && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}

@end

#pragma mark - 冷链运力
@implementation CustomCapacityController_ColdChain : CustomCapacityController

-(void)bindView {
    self.packaging.frame = CGRectMake(20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.packaging];
    [self.headView addSubview:self.packaging];

    self.servicemMode.frame = CGRectMake(self.packaging.right +20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];

    self.bringYourOwnCase.frame = CGRectMake(20, 130, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.bringYourOwnCase];
    [self.headView addSubview:self.bringYourOwnCase];

    self.boxNum.frame = CGRectMake(self.bringYourOwnCase.right +20, 130, SCREEN_W / 2 - 30, 20);;
    [self.headView addSubview:self.boxNum];

    [super bindView];
}

-(void)bindModel {
    [self.bringYourOwnCase setTitle:@"是" forState:UIControlStateNormal];
    self.boxNum.text = @"1";

    self.capacityEntry.isOwnBox = self.bringYourOwnCase.titleLabel.text;
    self.capacityEntry.boxNum = self.boxNum.text;
    [super bindModel];
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.bringYourOwnCase rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [SelectView addSelectViewWithEntrys:@[@"是",@"否"] WithSelectEntry:ws.bringYourOwnCase.titleLabel.text WithCallback:^(NSString * str) {
             [ws.bringYourOwnCase setTitle:str forState:UIControlStateNormal];
             ws.capacityEntry.isOwnBox = str;
             [self refreshCompleteBtn];

         }];
     }];
}

#pragma mark - Tabview Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 200;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 155;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab1.text = @"是否包装";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];

        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];

        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 100) / 2, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];

        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 40, 78, (SCREEN_W - 100) / 2, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];

        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, (SCREEN_W - 60)/ 2, 17)];
        lab3.text = @"是否自备箱";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];

        UILabel * lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.right + 20, lab3.top, (SCREEN_W - 60)/ 2, 17)];
        lab4.text = @"用箱数量";
        lab4.font = [UIFont systemFontOfSize:12.0f];
        lab4.textAlignment = NSTextAlignmentLeft;
        lab4.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab4];

        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20,lab3.bottom + 36, (SCREEN_W - 100) / 2, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];

        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(line3.right + 40, line3.top, (SCREEN_W - 100) / 2, 0.5)];
        line4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line4];

        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.isPackaging && self.capacityEntry.serviceWay && self.capacityEntry.isOwnBox && self.capacityEntry.boxNum && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}

@end

#pragma mark - 大件运力
@implementation CustomCapacityController_Big : CustomCapacityController

-(void)bindView {
    self.numberTfd.frame = CGRectMake(20, 55, (SCREEN_W - 80)/ 3, 20);

    [self.headView addSubview:self.numberTfd];
    
    self.servicemMode.frame = CGRectMake(self.numberTfd.right +20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];
    
    self.totalWeightTfd.frame = CGRectMake(self.servicemMode.right + 20, 55, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.totalWeightTfd];

    self.longTfd.frame = CGRectMake( 20, 144, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.longTfd];

    self.wideTfd.frame = CGRectMake(self.longTfd.right + 20, 144, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.wideTfd];

    self.hightTfd.frame = CGRectMake(self.wideTfd.right + 20, 144, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.hightTfd];

    self.maxWeightTfd.frame = CGRectMake( 20, 210, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.maxWeightTfd];

    
    [super bindView];
}

-(void)bindModel {
    self.totalWeightTfd.text = @"0";
    
    self.capacityEntry.totalWeight = self.totalWeightTfd.text;
    [super bindModel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 230;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 250;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab1.text = @"件数";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab2.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab3.text = @"总重量";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];
        
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];

        UILabel * lab1_1 = [[UILabel alloc]initWithFrame:CGRectMake(line1.right - 14, line1.top - 24, 14, 16)];
        lab1_1.text = @"个";
        lab1_1.font = [UIFont systemFontOfSize:12.0f];
        lab1_1.textAlignment = NSTextAlignmentRight;
        lab1_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1_1];

        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];

        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(line2.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];
        
        UILabel * lab3_1 = [[UILabel alloc]initWithFrame:CGRectMake(line3.right - 14, line3.top - 24, 14, 16)];
        lab3_1.text = @"吨";
        lab3_1.font = [UIFont systemFontOfSize:12.0f];
        lab3_1.textAlignment = NSTextAlignmentRight;
        lab3_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3_1];
        
        UILabel * lab4 = [[UILabel alloc]initWithFrame:CGRectMake(20, line3.bottom + 10, SCREEN_W - 20, 17)];
        lab4.text = @"最大单件尺寸";
        lab4.font = [UIFont systemFontOfSize:12.0f];
        lab4.textAlignment = NSTextAlignmentLeft;
        lab4.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab4];


        UILabel * lab5 = [[UILabel alloc]initWithFrame:CGRectMake(20, lab4.bottom + 10, (SCREEN_W - 80)/ 3, 17)];
        lab5.text = @"长（㎝）";
        lab5.font = [UIFont systemFontOfSize:12.0f];
        lab5.textAlignment = NSTextAlignmentLeft;
        lab5.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab5];


        UILabel * lab6 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, lab4.bottom + 10, (SCREEN_W - 80)/ 3, 17)];
        lab6.text = @"宽（㎝）";
        lab6.font = [UIFont systemFontOfSize:12.0f];
        lab6.textAlignment = NSTextAlignmentLeft;
        lab6.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab6];

        UILabel * lab7 = [[UILabel alloc]initWithFrame:CGRectMake(lab2.right + 20, lab4.bottom + 10, (SCREEN_W - 80)/ 3, 17)];
        lab7.text = @"高（㎝）";
        lab7.font = [UIFont systemFontOfSize:12.0f];
        lab7.textAlignment = NSTextAlignmentLeft;
        lab7.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab7];

        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(20, lab7.bottom + 36, (SCREEN_W - 80) / 3, 0.5)];
        line4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line4];

        UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(line4.right + 20, lab7.bottom + 36, (SCREEN_W - 80) / 3, 0.5)];
        line5.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line5];

        UIView * line6 = [[UIView alloc]initWithFrame:CGRectMake(line5.right + 20, lab7.bottom + 36, (SCREEN_W - 80) / 3, 0.5)];
        line6.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line6];

        UILabel * lab8 = [[UILabel alloc]initWithFrame:CGRectMake(20, line6.bottom + 10, SCREEN_W - 20, 17)];
        lab8.text = @"最大单件重量";
        lab8.font = [UIFont systemFontOfSize:12.0f];
        lab8.textAlignment = NSTextAlignmentLeft;
        lab8.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab8];

        UIView * line7 = [[UIView alloc]initWithFrame:CGRectMake( 20, lab8.bottom + 36, (SCREEN_W - 80) / 3, 0.5)];
        line7.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line7];

        UILabel * lab7_1 = [[UILabel alloc]initWithFrame:CGRectMake(line7.right - 14, line7.top - 24, 14, 16)];
        lab7_1.text = @"吨";
        lab7_1.font = [UIFont systemFontOfSize:12.0f];
        lab7_1.textAlignment = NSTextAlignmentRight;
        lab7_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab7_1];





    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.number && self.capacityEntry.serviceWay  && self.capacityEntry.totalWeight && self.capacityEntry.highCm&& self.capacityEntry.wideCm&& self.capacityEntry.longCm&& self.capacityEntry.biggestWeight) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}

@end

#pragma mark - 商品车运力
@implementation CustomCapacityController_ForCar : CustomCapacityController

-(void)bindView {
//    self.packaging.frame = CGRectMake(20, 55, (SCREEN_W - 80)/ 3, 20);
//    [self makeButton:self.packaging];
//    [self.headView addSubview:self.packaging];

    self.servicemMode.frame = CGRectMake(20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];
    
    self.carNumTfd.frame = CGRectMake(self.servicemMode.right + 20, 55, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.carNumTfd];
    
    [super bindView];
}

-(void)bindModel {
    self.carNumTfd.text = @"0";
    
    self.capacityEntry.carNum = self.carNumTfd.text;
    [super bindModel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 200;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {

    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
//        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 3, 17)];
//        lab1.text = @"是否包装";
//        lab1.font = [UIFont systemFontOfSize:12.0f];
//        lab1.textAlignment = NSTextAlignmentLeft;
//        lab1.textColor = APP_COLOR_GRAY2;
//        [view addSubview:lab1];

        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab2.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab3.text = @"辆数";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];
        
        
//        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 80) / 3, 0.5)];
//        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
//        [view addSubview:line1];

        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake( 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(line2.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];
        
        UILabel * lab3_1 = [[UILabel alloc]initWithFrame:CGRectMake(line3.right - 14, line3.top - 24, 14, 16)];
        lab3_1.text = @"辆";
        lab3_1.font = [UIFont systemFontOfSize:12.0f];
        lab3_1.textAlignment = NSTextAlignmentRight;
        lab3_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3_1];
        
        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if ( self.capacityEntry.serviceWay  && self.capacityEntry.carNum && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}

@end

#pragma mark - 液态运力
@implementation CustomCapacityController_Liquid : CustomCapacityController

-(void)bindView {
    self.packaging.frame = CGRectMake(20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.packaging];
    [self.headView addSubview:self.packaging];
    
    self.servicemMode.frame = CGRectMake(self.packaging.right +20, 55, (SCREEN_W - 80)/ 3, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];
    
    self.totalWeightTfd.frame = CGRectMake(self.servicemMode.right + 20, 55, (SCREEN_W - 80)/ 3, 20);;
    [self.headView addSubview:self.totalWeightTfd];
    
    [super bindView];
}

-(void)bindModel {
    self.totalWeightTfd.text = @"0";
    
    self.capacityEntry.totalWeight = self.totalWeightTfd.text;
    [super bindModel];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 170;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 80;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab1.text = @"是否包装";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];
        
        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];
        
        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab2.right + 20, 25, (SCREEN_W - 80)/ 3, 17)];
        lab3.text = @"总重量";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];
        
        
        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];
        
        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];
        
        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(line2.right + 20, 78, (SCREEN_W - 80) / 3, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];
        
        UILabel * lab3_1 = [[UILabel alloc]initWithFrame:CGRectMake(line3.right - 14, line3.top - 24, 14, 16)];
        lab3_1.text = @"吨";
        lab3_1.font = [UIFont systemFontOfSize:12.0f];
        lab3_1.textAlignment = NSTextAlignmentRight;
        lab3_1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3_1];
        
        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.isPackaging && self.capacityEntry.serviceWay  && self.capacityEntry.totalWeight && self.capacityEntry.pName && self.capacityEntry.pPhone) {
        
        self.completeBtn.enabled = YES;
    }
    else
    {
        
        self.completeBtn.enabled = NO;
    }
}

@end

#pragma mark - 一带一路运力
@implementation CustomCapacityController_OneBeltOneRoad : CustomCapacityController

-(void)bindView {
    self.packaging.frame = CGRectMake(20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.packaging];
    [self.headView addSubview:self.packaging];

    self.servicemMode.frame = CGRectMake(self.packaging.right +20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];

    self.bringYourOwnCase.frame = CGRectMake(20, 130, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.bringYourOwnCase];
    [self.headView addSubview:self.bringYourOwnCase];

    self.boxNum.frame = CGRectMake(self.bringYourOwnCase.right +20, 130, SCREEN_W / 2 - 30, 20);;
    [self.headView addSubview:self.boxNum];

    [super bindView];
}

-(void)bindModel {
    [self.bringYourOwnCase setTitle:@"是" forState:UIControlStateNormal];
    self.boxNum.text = @"1";

    self.capacityEntry.isOwnBox = self.bringYourOwnCase.titleLabel.text;
    self.capacityEntry.boxNum = self.boxNum.text;
    [super bindModel];
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.bringYourOwnCase rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [SelectView addSelectViewWithEntrys:@[@"是",@"否"] WithSelectEntry:ws.bringYourOwnCase.titleLabel.text WithCallback:^(NSString * str) {
             [ws.bringYourOwnCase setTitle:str forState:UIControlStateNormal];
             ws.capacityEntry.isOwnBox = str;
             [self refreshCompleteBtn];

         }];
     }];
}

#pragma mark - Tabview Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 200;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 155;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab1.text = @"是否包装";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];

        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];

        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 100) / 2, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];

        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 40, 78, (SCREEN_W - 100) / 2, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];

        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, (SCREEN_W - 60)/ 2, 17)];
        lab3.text = @"是否自备箱";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];

        UILabel * lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.right + 20, lab3.top, (SCREEN_W - 60)/ 2, 17)];
        lab4.text = @"用箱数量";
        lab4.font = [UIFont systemFontOfSize:12.0f];
        lab4.textAlignment = NSTextAlignmentLeft;
        lab4.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab4];

        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20,lab3.bottom + 36, (SCREEN_W - 100) / 2, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];

        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(line3.right + 40, line3.top, (SCREEN_W - 100) / 2, 0.5)];
        line4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line4];

        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.isPackaging && self.capacityEntry.serviceWay && self.capacityEntry.isOwnBox && self.capacityEntry.boxNum && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}


@end

//CustomCapacityController_QuickGo

#pragma mark - 快速配送运力
@implementation CustomCapacityController_QuickGo : CustomCapacityController

-(void)bindView {
    self.packaging.frame = CGRectMake(20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.packaging];
    [self.headView addSubview:self.packaging];

    self.servicemMode.frame = CGRectMake(self.packaging.right +20, 55, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.servicemMode];
    [self.headView addSubview:self.servicemMode];

    self.bringYourOwnCase.frame = CGRectMake(20, 130, SCREEN_W / 2 - 30, 20);
    [self makeButton:self.bringYourOwnCase];
    [self.headView addSubview:self.bringYourOwnCase];

    self.boxNum.frame = CGRectMake(self.bringYourOwnCase.right +20, 130, SCREEN_W / 2 - 30, 20);;
    [self.headView addSubview:self.boxNum];

    [super bindView];
}

-(void)bindModel {
    [self.bringYourOwnCase setTitle:@"是" forState:UIControlStateNormal];
    self.boxNum.text = @"1";

    self.capacityEntry.isOwnBox = self.bringYourOwnCase.titleLabel.text;
    self.capacityEntry.boxNum = self.boxNum.text;
    [super bindModel];
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.bringYourOwnCase rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [SelectView addSelectViewWithEntrys:@[@"是",@"否"] WithSelectEntry:ws.bringYourOwnCase.titleLabel.text WithCallback:^(NSString * str) {
             [ws.bringYourOwnCase setTitle:str forState:UIControlStateNormal];
             ws.capacityEntry.isOwnBox = str;
             [self refreshCompleteBtn];

         }];
     }];
}

#pragma mark - Tabview Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        return 200;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 155;
    }
    return [super tableView:tableView heightForHeaderInSection:section];
}

-(UIView *)headView {
    UIView * view = [super headView];
    if ([view.subviews indexOfObject:self.packaging] == NSNotFound) {
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab1.text = @"是否包装";
        lab1.font = [UIFont systemFontOfSize:12.0f];
        lab1.textAlignment = NSTextAlignmentLeft;
        lab1.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab1];

        UILabel * lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1.right + 20, 25, (SCREEN_W - 60)/ 2, 17)];
        lab2.text = @"增值服务";
        lab2.font = [UIFont systemFontOfSize:12.0f];
        lab2.textAlignment = NSTextAlignmentLeft;
        lab2.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab2];

        UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(20, 78, (SCREEN_W - 100) / 2, 0.5)];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line1];

        UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(line1.right + 40, 78, (SCREEN_W - 100) / 2, 0.5)];
        line2.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line2];

        UILabel * lab3 = [[UILabel alloc]initWithFrame:CGRectMake(20, line1.bottom + 20, (SCREEN_W - 60)/ 2, 17)];
        lab3.text = @"是否自备箱";
        lab3.font = [UIFont systemFontOfSize:12.0f];
        lab3.textAlignment = NSTextAlignmentLeft;
        lab3.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab3];

        UILabel * lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab3.right + 20, lab3.top, (SCREEN_W - 60)/ 2, 17)];
        lab4.text = @"用箱数量";
        lab4.font = [UIFont systemFontOfSize:12.0f];
        lab4.textAlignment = NSTextAlignmentLeft;
        lab4.textColor = APP_COLOR_GRAY2;
        [view addSubview:lab4];

        UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(20,lab3.bottom + 36, (SCREEN_W - 100) / 2, 0.5)];
        line3.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line3];

        UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(line3.right + 40, line3.top, (SCREEN_W - 100) / 2, 0.5)];
        line4.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [view addSubview:line4];

        [view addSubview:self.packaging];
    }
    return view;
}

-(void)refreshCompleteBtn {
    if (self.capacityEntry.isPackaging && self.capacityEntry.serviceWay && self.capacityEntry.isOwnBox && self.capacityEntry.boxNum && self.capacityEntry.pName&& self.capacityEntry.pPhone) {
        self.completeBtn.enabled = YES;
    }
    else
    {
        self.completeBtn.enabled = NO;
    }
}


@end
