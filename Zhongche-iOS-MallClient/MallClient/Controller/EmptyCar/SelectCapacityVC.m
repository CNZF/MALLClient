//
//  SelectCapacityVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/29.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "SelectCapacityVC.h"
#import "EntrySelectCell.h"
#import "ZCCityListViewController.h"
#import "EmptyCarViewModel.h"
#import "EmptyCarVC.h"

typedef enum {
    startAddress,
    endAddress,
}AddressBtnType;
@interface SelectCapacityVC ()<UITableViewDelegate,UITableViewDataSource,ZCCityListViewControllerDelagate>
@property (weak, nonatomic) IBOutlet UITableView *tbv;
@property (nonatomic, strong) NSMutableArray * showViews;

@property (nonatomic, strong) NSArray        * transportationTypeArray;
@property (nonatomic, strong) NSArray        * carAndShipTypeArray;
@property (nonatomic, strong) NSArray        * carTypeArray;
@property (nonatomic, strong) NSArray        * railwayTypeArray;
@property (nonatomic, strong) NSArray        * shipTypeArray;

@property (nonatomic, strong) UIView         * addressVi;//地址选择
@property (nonatomic, strong) UIButton       * startAddressBtn;
@property (nonatomic, strong) UIButton       * endAddressBtn;
@property (nonatomic, assign) AddressBtnType addressBtnType;

@property (nonatomic, strong) UIView         * transportationTypeVi;//运输类型

@property (nonatomic, strong) UIView         * carAndShipTypeVi;//车船类型

@property (nonatomic, strong) UIView         * timeVi;//发货日期
@property (nonatomic, strong) UIButton       * timeBtn;

@property (nonatomic, strong) UIView         * certificationVi;//认证状态
@property (nonatomic, strong) UISwitch       * certificationSwitch;

@property (nonatomic, strong) UIView         * searchVi;//搜索
@property (nonatomic, strong) UIButton       * searchBtn;

@property (nonatomic, strong) UIView         * datePirckerVi;//时间选择
@property (nonatomic, strong) UIDatePicker   * datePicker;
@property (nonatomic, strong) UIButton       * datePickerCancleBtn;
@property (nonatomic, strong) UIButton       * datePickercompleteBtn;
@end

@implementation SelectCapacityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查找运力";
    self.tbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbv.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    [self.tbv registerClass:[EntrySelectCellForConditionsForRetrievalVC class] forCellReuseIdentifier:NSStringFromClass([EntrySelectCellForConditionsForRetrievalVC class])];
}

-(void)bindView {
    self.addressVi.frame = CGRectMake(0, 0, SCREEN_W, 70);
    self.transportationTypeVi.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.carAndShipTypeVi.frame = CGRectMake(0, 0, SCREEN_W, 30);
    self.timeVi.frame = CGRectMake(0, 0, SCREEN_W, 74);
    self.certificationVi.frame = CGRectMake(0, 0, SCREEN_W, 84);
    self.searchVi.frame = CGRectMake(0, 0, SCREEN_W, 98);
    
    [self.view addSubview:self.datePirckerVi];
    self.datePirckerVi.hidden = YES;
}

-(void)bindModel {
    [self.showViews addObject:self.addressVi];
    [self.showViews addObject:self.transportationTypeVi];
    [self.showViews addObject:self.carAndShipTypeVi];
    [self.showViews addObject:self.timeVi];
    [self.showViews addObject:self.certificationVi];
    [self.showViews addObject:self.searchVi];

    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    
    EntrySelectCellModel * model1 = [EntrySelectCellModel new];
    model1.cellHeightClose = 60;
    model1.cellCloseOrOpen = NO;
    model1.entrys = [NSMutableArray arrayWithArray:self.transportationTypeArray];
    [self.dataArray addObject:model1];
    
    EntrySelectCellModel * model2 = [EntrySelectCellModel new];
    model2.cellHeightClose = 60;
    model2.cellCloseOrOpen = NO;
    model2.entrys = [NSMutableArray new];
    [self.dataArray addObject:model2];
    
    [self.dataArray addObject:[NSObject new]];
    [self.dataArray addObject:[NSObject new]];
    [self.dataArray addObject:[NSObject new]];

    [self getDataWithCarAndShipTypeArray];
    [self updataForThisPage];
    [self.tbv reloadData];
}

-(void)bindAction {

    [super bindAction];

    WS(ws);
    [[self.startAddressBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.addressBtnType = startAddress;
        ZCCityListViewController * city = [ZCCityListViewController new];
        city.getCityDelagate = ws;
        [ws.navigationController pushViewController:city animated:YES];
    }];
    
    [[self.endAddressBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.addressBtnType = endAddress;
        ZCCityListViewController * city = [ZCCityListViewController new];
        city.getCityDelagate = ws;
        [ws.navigationController pushViewController:city animated:YES];
    }];
    
    [[self.timeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.datePirckerVi.hidden = NO;
        NSDateFormatter *outputFormatter = [ NSDateFormatter new];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * dateStr = [outputFormatter stringFromDate:ws.datePicker.date];
        [ws.timeBtn setTitle:dateStr forState:UIControlStateNormal];
        [self makeButton:ws.timeBtn];
    }];
    
    [[self.searchBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        if (!ws.model.startCity || !self.model.endCity) {
            [[Toast shareToast]makeText:@"请选择起运地或抵运地" aDuration:1];
            return ;
        }
        if (!ws.model.startTime) {
            [[Toast shareToast]makeText:@"请选择发货日期" aDuration:1];
            return ;
        }
        //[ws.vcDelegate chooseCompleteNeedLoadingData];
        //[ws.navigationController popViewControllerAnimated:YES];
        EmptyCarVC * vc = [EmptyCarVC new];
        vc.filterModel = ws.model;
        [ws.navigationController pushViewController:vc animated:YES];
    }];
    
    [[self.datePickerCancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.datePirckerVi.hidden = YES;
    }];
    
    [[self.datePickercompleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.datePirckerVi.hidden = YES;
        ws.model.startTime = ws.datePicker.date;
        [self updataForThisPage];
    }];
    
    [[self.certificationSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x){
        ws.model.isCertification = ws.certificationSwitch.on;
    }];

}

//加载车辆类型数据
-(void)loadCarTypeData {
    
    WS(ws);
    [[EmptyCarViewModel new] getEmptyCarListMethod:@"getVehicleTypeList" callBack:^(NSArray *arr) {
        ws.carTypeArray = arr;
        if (ws.model.transportType == landTransportation) {
            ws.carAndShipTypeArray = ws.carTypeArray;
            if (ws.carAndShipTypeArray.count >= 1) {
                ws.model.carOrShipType = ws.carAndShipTypeArray[0];
            }
            EntrySelectCellModel * model = ws.dataArray[2];
            [model.entrys removeAllObjects];
            for (CarOrShipTypeModel * mod in arr)
            {
                if(mod.name){
                    
                    [model.entrys addObject:mod.name];
                    
                }
            }
            model.selectStr = ws.model.carOrShipType.name;
            //更新model的高度值,
            [[EntrySelectCellForConditionsForRetrievalVC new] loadUIWithmodel:model];
            model.cellCloseOrOpen = YES;
            [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }

    }];

}

//加载火车类型数据
-(void)loadTrainTypeData {
    
    WS(ws);
    [[EmptyCarViewModel new] getEmptyCarListMethod:@"getTrainTypeList" callBack:^(NSArray *arr) {
        ws.railwayTypeArray = arr;
        if (ws.model.transportType == trainsTransportation) {
            ws.carAndShipTypeArray = ws.railwayTypeArray;
            if (ws.carAndShipTypeArray.count >= 1) {
                ws.model.carOrShipType = ws.carAndShipTypeArray[0];
            }
            EntrySelectCellModel * model = ws.dataArray[2];
            [model.entrys removeAllObjects];
            for (CarOrShipTypeModel * mod in arr)
            {
                if(mod.name){
                    [model.entrys addObject:mod.name];
                }
            }
            model.selectStr = ws.model.carOrShipType.name;
            //更新model的高度值,
            [[EntrySelectCellForConditionsForRetrievalVC new] loadUIWithmodel:model];
            model.cellCloseOrOpen = YES;
            [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }];
    
    
}

/**
 *  懒加载
 *
 */

-(UIView *)addressVi {
    if (!_addressVi) {
        UIView * vi = [UIView new];
        
        UILabel * labStart = [UILabel new];
        labStart.frame = CGRectMake(20, 17, SCREEN_W / 2 - 40, 16);
        labStart.font = [UIFont systemFontOfSize:12.f];
        labStart.textColor = APP_COLOR_GRAY2;
        labStart.text = @"起运地";
        [vi addSubview:labStart];
        
        UILabel * labEnd = [UILabel new];
        labEnd.frame = CGRectMake(SCREEN_W / 2 + 20, 17, SCREEN_W / 2 - 40, 16);
        labEnd.font = [UIFont systemFontOfSize:12.f];
        labEnd.textColor = APP_COLOR_GRAY2;
        labEnd.text = @"抵运地";
        [vi addSubview:labEnd];
        
        self.startAddressBtn.frame = CGRectMake(labStart.left, labStart.bottom, labStart.width, 36);
        [vi addSubview:self.startAddressBtn];
        
        self.endAddressBtn.frame = CGRectMake(labEnd.left, labEnd.bottom, labEnd.width, 36);
        [vi addSubview:self.endAddressBtn];
        
        
        UIView * lineStart = [UIView new];
        lineStart.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        lineStart.frame = CGRectMake(labStart.left, self.startAddressBtn.bottom, labStart.width, 0.5);
        [vi addSubview:lineStart];
        
        UIView * lineEnd = [UIView new];
        lineEnd.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        lineEnd.frame = CGRectMake(labEnd.left, self.endAddressBtn.bottom, labEnd.width, 0.5);
        [vi addSubview:lineEnd];
        
        UIImageView * igv = [UIImageView new];
        igv.image = [UIImage imageNamed:[@"The arrow" adS]];
        igv.frame = CGRectMake(SCREEN_W / 2 - 12.5, 39, 25, 25);
        [vi addSubview:igv];
        
        vi.backgroundColor = APP_COLOR_WHITE;
        _addressVi = vi;
    }
    return _addressVi;
}

-(UIButton *)startAddressBtn {
    if (!_startAddressBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        _startAddressBtn = btn;
    }
    return _startAddressBtn;
}

-(UIButton *)endAddressBtn {
    if (!_endAddressBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        _endAddressBtn = btn;
    }
    return _endAddressBtn;
}

-(UIView *)transportationTypeVi {
    if (!_transportationTypeVi) {
        UIView * vi = [UIView new];
        
        UILabel * lab = [UILabel new];
        lab.frame = CGRectMake(20, 17, SCREEN_W - 40, 16);
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        lab.text = @"运输类型";
        [vi addSubview:lab];
        
        vi.backgroundColor = APP_COLOR_WHITE;
        _transportationTypeVi = vi;
    }
    return _transportationTypeVi;
}

-(UIView *)carAndShipTypeVi {
    if (!_carAndShipTypeVi) {
        UIView * vi = [UIView new];
        
        UIView * line =[UIView new];
        line.frame = CGRectMake(20, 0, SCREEN_W - 40, 0.5);
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [vi addSubview:line];
        
        
        UILabel * lab = [UILabel new];
        lab.frame = CGRectMake(20, 17, SCREEN_W - 40, 16);
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        lab.text = @"车船类型";
        [vi addSubview:lab];
        
        vi.backgroundColor = APP_COLOR_WHITE;
        _carAndShipTypeVi = vi;
    }
    return _carAndShipTypeVi;
}

-(UIView *)timeVi {
    if (!_timeVi) {
        UIView * vi = [UIView new];
        
        UIView * line =[UIView new];
        line.frame = CGRectMake(20, 0, SCREEN_W - 40, 0.5);
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [vi addSubview:line];
        
        
        UILabel * lab = [UILabel new];
        lab.frame = CGRectMake(20, 17, SCREEN_W - 40, 16);
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        lab.text = @"发货日期";
        [vi addSubview:lab];
        
        self.timeBtn.frame = CGRectMake(20, lab.bottom, SCREEN_W - 50, 38);
        [vi addSubview:self.timeBtn];
        
        UIImageView * arrowIgv = [UIImageView new];
        arrowIgv.frame = CGRectMake(SCREEN_W - 33, 50, 7, 13);
        arrowIgv.image = [UIImage imageNamed:[@"Back Chevron Copy 2" adS]];
        [vi addSubview:arrowIgv];
        
        vi.backgroundColor = APP_COLOR_WHITE;
        _timeVi = vi;
    }
    return _timeVi;
}

-(UIButton *)timeBtn {
    if (!_timeBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        _timeBtn = btn;
    }
    return _timeBtn;
}

-(UIView *)certificationVi {
    if (!_certificationVi) {
        UIView * vi = [UIView new];
        
        UIView * line =[UIView new];
        line.frame = CGRectMake(20, 0, SCREEN_W - 40, 0.5);
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [vi addSubview:line];
        
        
        UILabel * lab = [UILabel new];
        lab.frame = CGRectMake(20, 17, SCREEN_W - 40, 16);
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textColor = APP_COLOR_GRAY2;
        lab.text = @"是否认证";
        [vi addSubview:lab];
        
        [vi addSubview:self.certificationSwitch];
        
        vi.backgroundColor = APP_COLOR_WHITE;
        _certificationVi = vi;
    }
    return _certificationVi;
}

-(UISwitch *)certificationSwitch {
    if (!_certificationVi) {
        UISwitch * s = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_W - 70, 10, 50, 30)];
        s.onTintColor = APP_COLOR_BLUE_BTN;
        
        _certificationSwitch = s;
    }
    return _certificationSwitch;
}

-(UIView *)searchVi {
    if (!_searchVi) {
        UIView * vi = [UIView new];

        self.searchBtn.frame = CGRectMake(20, 27, SCREEN_W - 40, 44);
        [vi addSubview:self.searchBtn];
        
        vi.backgroundColor = APP_COLOR_WHITE;
        _searchVi = vi;

    }
    return _searchVi;
}

-(UIButton *)searchBtn {
    if (!_searchBtn) {
        UIButton * btn = [UIButton new];
        [btn setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_BLUE_BTN andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_GRAY_BTN_1 andSize:CGSizeMake(1, 1)] forState:UIControlStateDisabled];
        [btn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        [btn setTitle:@"搜索" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 5.f;
        _searchBtn = btn;
    }
    return _searchBtn;
}

-(UIView *)datePirckerVi {
    if (!_datePirckerVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_WHITE;
        vi.frame = CGRectMake(0, SCREEN_H - 300, SCREEN_W, 300);
        
        UIView * vi1 = [UIView new];
        vi1.backgroundColor = APP_COLOR_BLUE_BTN;
        vi1.frame = CGRectMake(0, 0, SCREEN_W, 40);
        [vi addSubview:vi1];
        
        self.datePickerCancleBtn.frame = CGRectMake(0, 0, 50, 40);
        [vi addSubview:self.datePickerCancleBtn];
        
        self.datePickercompleteBtn.frame = CGRectMake(SCREEN_W - 50, 0, 50, 40);
        [vi addSubview:self.datePickercompleteBtn];
        
        self.datePicker.frame = CGRectMake(0, 40, SCREEN_W, 260);
        [vi addSubview:self.datePicker];
        
        _datePirckerVi = vi;
    }
    return _datePirckerVi;
}

-(UIButton *)datePickerCancleBtn {
    if (!_datePickerCancleBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        _datePickerCancleBtn = btn;
    }
    return _datePickerCancleBtn;
}

-(UIButton *)datePickercompleteBtn {
    if (!_datePickercompleteBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [btn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        _datePickercompleteBtn = btn;
    }
    return _datePickercompleteBtn;
}

-(UIDatePicker *)datePicker {
    if (!_datePicker) {
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSDate* minDate = [NSDate date];
        NSDate* maxDate = [NSDate dateWithTimeIntervalSinceNow:315576000L];//10年
        datePicker.minimumDate = minDate;
        datePicker.maximumDate = maxDate;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
        _datePicker = datePicker;
    }
    return  _datePicker;
}

-(NSMutableArray *)showViews {
    if (!_showViews) {
        _showViews = [NSMutableArray array];
    }
    return _showViews;
}

-(NSArray *)transportationTypeArray {
    if (!_transportationTypeArray) {
        _transportationTypeArray = @[@"公路",
                                     @"铁路",
                                     @"海运"];
    }
    return _transportationTypeArray;
}

-(NSArray *)carAndShipTypeArray {

    if (!_carAndShipTypeArray) {
        _carAndShipTypeArray = [NSArray new];
    }
    return _carAndShipTypeArray;
}

-(NSArray *)carTypeArray {
    if (!_carTypeArray) {
        _carTypeArray = [NSMutableArray new];
    }
    return _carTypeArray;
}

-(NSArray *)railwayTypeArray {
    if (!_railwayTypeArray) {
        _railwayTypeArray = [NSMutableArray new];
    }
    return _railwayTypeArray;
}

-(NSArray *)shipTypeArray {
    if (!_shipTypeArray) {
        
        CarOrShipTypeModel * model0;
        
        model0 = [CarOrShipTypeModel new];
        model0.name = @"班轮";

        _shipTypeArray =  [NSArray arrayWithObjects:model0, nil];
        
    }
    return _shipTypeArray;
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntrySelectCellForConditionsForRetrievalVC * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EntrySelectCellForConditionsForRetrievalVC class]) forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell loadUIWithmodel:self.dataArray[indexPath.section]];
    cell.cellDelegate = self;
    cell.indexPath = indexPath;
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.showViews[section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataArray[section] isKindOfClass:[EntrySelectCellModel class]]) {
        return 1;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    double height = 0;
    if ([self.dataArray[indexPath.section] isKindOfClass:[EntrySelectCellModel class]]) {
        if (((EntrySelectCellModel *)(self.dataArray[indexPath.section])).cellCloseOrOpen) {
            height = ((EntrySelectCellModel *)(self.dataArray[indexPath.section])).cellHeightOpen;
        }
        else
        {
            height = ((EntrySelectCellModel *)(self.dataArray[indexPath.section])).cellHeightClose;
        }
    }
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    UIView * view = self.showViews[section];
    return view.height;
}

//加载车辆、船数组
-(void)getDataWithCarAndShipTypeArray {
    
    switch (self.model.transportType) {
        case landTransportation:
            if (self.carTypeArray.count != 0) {
                self.carAndShipTypeArray = self.carTypeArray;
            }else {
                [self loadCarTypeData];
                return ;
            }
            break;
        case trainsTransportation:
            if (self.railwayTypeArray.count != 0) {
                self.carAndShipTypeArray = self.railwayTypeArray;
            }else {
                [self loadTrainTypeData];
                return ;
            }
            break;
        case shipTransportation:
            self.carAndShipTypeArray = self.shipTypeArray;
            break;
        default:
            break;
    }
    
    if (self.carAndShipTypeArray.count >= 1) {
        self.model.carOrShipType = self.carAndShipTypeArray[0];
    }
    EntrySelectCellModel * model = self.dataArray[2];
    [model.entrys removeAllObjects];
    model.selectStr = self.model.carOrShipType.name;
    for (ContainerTypeModel * mod in self.carAndShipTypeArray)
    {
        [model.entrys addObject:mod.name];
    }
    //更新model的高度值,
    [[EntrySelectCellForConditionsForRetrievalVC new] loadUIWithmodel:model];
    model.cellCloseOrOpen = YES;
    [self.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}

//获取时间选择器时间
-(void)dateChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [outputFormatter stringFromDate:datePicker.date];
    [self.timeBtn setTitle:dateStr forState:UIControlStateNormal];
    [self makeButton:self.timeBtn];
}

//城市列表选择回调
-(void)getCityModel:(CityModel *)cityModel {
    switch (self.addressBtnType) {
        case startAddress:
            self.model.startCity = cityModel;
            break;
        case endAddress:
            self.model.endCity = cityModel;
            break;
    }
    [self updataForThisPage];
}

//更新页面
-(void)updataForThisPage {
    
    if (self.model.startCity) {
        [self.startAddressBtn setTitle:self.model.startCity.name forState:UIControlStateNormal];
        [self.startAddressBtn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
    } else {
        [self.startAddressBtn setTitle:@"选择城市" forState:UIControlStateNormal];
        [self.startAddressBtn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        
    }
    
    if (self.model.endCity) {
        [self.endAddressBtn setTitle:self.model.endCity.name forState:UIControlStateNormal];
        [self.endAddressBtn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
    } else {
        [self.endAddressBtn setTitle:@"选择城市" forState:UIControlStateNormal];
        [self.endAddressBtn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    }
    
    [self makeButton:self.startAddressBtn];
    [self makeButton:self.endAddressBtn];
    
    EntrySelectCellModel * model = self.dataArray[1];
    model.selectStr = self.transportationTypeArray[self.model.transportType];
    
    if (self.model.startTime) {
        NSDateFormatter *outputFormatter = [ NSDateFormatter new];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * dateStr = [outputFormatter stringFromDate:self.model.startTime];
        [self.timeBtn setTitle:dateStr forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
    } else {
        [self.timeBtn setTitle:@"请设置时间" forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    }
    [self makeButton:self.timeBtn];
    self.certificationSwitch.on = self.model.isCertification;
    
    //起运地 抵运地 时间 已填
    if (self.model.startCity && self.model.endCity && self.model.startTime) {
        [self.searchBtn setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_BLUE_BTN andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    } else {
        [self.searchBtn setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_GRAY_BTN_1 andSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    }
}

//按钮点击事件
- (void)makeButton:(UIButton *)btn {
    if ([btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width > btn.width) {
        return ;
    }
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0,-(btn.width -  [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width), 0.0,0.0)];
}

//设置视图文字
-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.model.transportType != row) {
            self.model.transportType = (TransportTypeEnum)row;
            self.model.carOrShipType = nil;
            [self getDataWithCarAndShipTypeArray];
        }
    }else if(indexPath.section == 2) {
        if ([self.carAndShipTypeArray indexOfObject:self.model.carOrShipType] != row)
        {
            self.model.carOrShipType = self.carAndShipTypeArray[row];
        }
    }
}

@end
