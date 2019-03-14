//
//  ConditionsForRetrievalVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/3/19.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "ConditionsForRetrievalVC.h"
#import "EntrySelectCellModel.h"
#import "EntrySelectCell.h"
#import "ContainerViewModel.h"
#import "MLNavigationController.h"
#import "ZCCityListViewController.h"


typedef enum {
    startTimeBtnClicked,
    endTimeBtnClicked,
}DateType;

@interface ConditionsForRetrievalVC ()<UITableViewDelegate,UITableViewDataSource,ZCCityListViewControllerDelagate>

@property (nonatomic, strong) UITableView *  tbv;

@property (nonatomic, strong) UIButton       * addressBtn;//箱子位置
@property (nonatomic, strong) UILabel        * cityLab;

@property (nonatomic, strong) UIView         * timeVi;
@property (nonatomic, strong) UIButton       * startTimeBtn;
@property (nonatomic, strong) UIButton       * endTimeBtn;
@property (nonatomic, assign) DateType       datetype;
@property (nonatomic, strong) UIView         *headerBox;//箱型
@property (nonatomic, strong) UILabel        *box;
@property (nonatomic, strong) UIButton       * arrowBtn;
@property (nonatomic, strong) NSArray        *arrContainerType;//集装箱箱型数组

@property (nonatomic, strong) UIView         *boxStatus;//箱子状态
@property (nonatomic, strong) NSArray        *boxStatusArr;

@property (nonatomic, strong) UIButton       * resetBtn;
@property (nonatomic, strong) UIButton       * completeBtn;

@property (nonatomic, strong) NSMutableArray * showViews;

@property (nonatomic, strong) UIView         * datePirckerVi;
@property (nonatomic, strong) UIDatePicker   * datePicker;
@property (nonatomic, strong) UIButton       * datePickerCancleBtn;
@property (nonatomic, strong) UIButton       * datePickercompleteBtn;
@property (nonatomic, strong) UIButton       * backBtn;

@property (nonatomic, strong)FilterModel * filterModelNew;

@end

@implementation ConditionsForRetrievalVC


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    ((MLNavigationController *)self.navigationController).isNeedZoomIn = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    ((MLNavigationController *)self.navigationController).isNeedZoomIn = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)bindView {
    self.tbv.frame = CGRectMake(45, -20, SCREEN_W, SCREEN_H - 30);
    [self.view addSubview:self.tbv];
    
    self.resetBtn.frame = CGRectMake(45, SCREEN_H - 50, (SCREEN_W - 45) * 13/ 33.0, 50);
    [self.view addSubview:self.resetBtn];
    
    self.completeBtn.frame = CGRectMake(self.resetBtn.right, SCREEN_H - 50, (SCREEN_W - 45) * 20 / 33.0, 50);
    [self.view addSubview:self.completeBtn];
    
    [self.view addSubview:self.datePirckerVi];
    self.datePirckerVi.hidden = YES;
    

    self.backBtn.frame = CGRectMake(0, 0, 45, SCREEN_H);
    [self.view addSubview:self.backBtn];
}

-(void)bindAction {
    
    WS(ws);
    [[self.addressBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ZCCityListViewController * city = [ZCCityListViewController new];
        city.getCityDelagate = ws;
        [ws.navigationController pushViewController:city animated:YES];
    }];
    
    [[self.completeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        ws.filterModel.city = ws.filterModelNew.city;
        ws.filterModel.startTime = ws.filterModelNew.startTime;
        ws.filterModel.endTime = ws.filterModelNew.endTime;
        ws.filterModel.container = ws.filterModelNew.container;
        ws.filterModel.containerCondition = ws.filterModelNew.containerCondition;
        ws.filterModel.currentPage = ws.filterModelNew.currentPage;
        ws.filterModel.pageSize = ws.filterModelNew.pageSize;
        ws.filterModel.saleType = ws.filterModelNew.saleType;
        ws.filterModel.useNumberSort = ws.filterModelNew.useNumberSort;
        ws.filterModel.isAuthenticated = ws.filterModelNew.isAuthenticated;
        [ws.conditionsForRetrievalVCDelegate chooseCompleteNeedLoadingData];
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.resetBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
       
        ws.arrowBtn.selected = NO;
        ws.filterModelNew.city = nil;
        ws.filterModelNew.startTime = nil;
        ws.filterModelNew.endTime = nil;
        ws.filterModelNew.container = nil;
        ws.filterModelNew.containerCondition = new0;
        
        if (!ws.filterModelNew.startTime) {
            NSDate * date = [NSDate dateWithTimeIntervalSinceNow:24L * 3600];
            NSDateFormatter * outputFormatter = [NSDateFormatter new];
            [outputFormatter setDateFormat:@"yyyy-MM-dd"];
            ws.filterModelNew.startTime = [outputFormatter dateFromString:[outputFormatter stringFromDate:date]];
        }
        [self updateThisPageView];
    }];

    [[self.startTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.datetype = startTimeBtnClicked;
        ws.datePirckerVi.hidden = NO;
    }];
   
    [[self.endTimeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.datetype = endTimeBtnClicked;
        ws.datePirckerVi.hidden = NO;

    }];
    
    [[self.datePickerCancleBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.datePirckerVi.hidden = YES;
        [self updateThisPageView];
    }];
    
    [[self.datePickercompleteBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        if (ws.datetype == startTimeBtnClicked) {
            if (!ws.filterModelNew.endTime) {
                ws.filterModelNew.startTime = ws.datePicker.date;

            }else if ([ws.filterModelNew.endTime earlierDate:ws.datePicker.date] == ws.datePicker.date) {
                ws.filterModelNew.startTime = ws.datePicker.date;

            }else {
                ws.filterModelNew.startTime = [NSDate dateWithTimeInterval:-24L * 3600 sinceDate:ws.filterModelNew.endTime];

            }
        } else if(ws.datetype == endTimeBtnClicked) {
            if (!ws.filterModelNew.startTime) {
                ws.filterModelNew.endTime = ws.datePicker.date;
                
            }else if ([ws.filterModelNew.startTime earlierDate:ws.datePicker.date] == ws.filterModelNew.startTime) {
                ws.filterModelNew.endTime = ws.datePicker.date;
                
            }else {
                ws.filterModelNew.endTime = [NSDate dateWithTimeInterval:24L * 3600 sinceDate:ws.filterModelNew.startTime];
                
            }
        }
        ws.datePirckerVi.hidden = YES;
        [self updateThisPageView];
    }];
    
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    
}

/**
 *  懒加载
 *
 */

- (UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[EntrySelectCellForConditionsForRetrievalVC class] forCellReuseIdentifier:NSStringFromClass([EntrySelectCellForConditionsForRetrievalVC class])];

        _tbv = tableView;
    }
    return _tbv;
}

-(NSMutableArray *)showViews {
    if (!_showViews) {
        _showViews  = [NSMutableArray new];
        
    }
    return _showViews;
}

-(UIButton *)addressBtn{
    if (!_addressBtn) {
        UIButton * btn = [UIButton new];
        btn.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.text = @"箱子位置";
        lab.frame = CGRectMake(15, 55,200 , 17);
        [btn addSubview:lab];
        
        
        UIImageView * igv = [UIImageView new];
        igv.frame = CGRectMake(SCREEN_W - 45 - 20, 82, 7, 13);
        igv.image = [UIImage imageNamed:[@"Back Chevron Copy 2" adS]];
        [btn addSubview:igv];
        
        self.cityLab.frame = CGRectMake(15, 87, 0, 33);
        [btn addSubview:self.cityLab];
        
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITEBG;
        view.frame = CGRectMake(0, 134, SCREEN_W - 45, 1);
        [btn addSubview:view];
        
        btn.frame = CGRectMake(0, 0, SCREEN_W - 45, 135);
        
        _addressBtn = btn;
    }
    return _addressBtn;
}

-(UILabel *)cityLab {
    if (!_cityLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:12.f];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = @"选择城市";
        [lab.layer setMasksToBounds:YES];
        [lab.layer setCornerRadius:16];//设置矩形四个圆角半径
        lab.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
        lab.layer.borderWidth = 0.5;
        _cityLab = lab;
    }
    return _cityLab;
}

-(UIView *)timeVi{
    if (!_timeVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.0];
        lab.textColor = APP_COLOR_GRAY_TEXT_1;
        lab.text = @"起止日期";
        lab.frame = CGRectMake(15, 15,200 , 17);
        [vi addSubview:lab];
        
        
        UIImageView * igv = [UIImageView new];
        igv.frame = CGRectMake(25, 62, 10, 11);
        igv.image = [UIImage imageNamed:[@"The calendar" adS]];
        [vi addSubview:igv];
        
        self.startTimeBtn.frame = CGRectMake(220 - SCREEN_W, 37, SCREEN_W * 2 - 220, 33);
        [vi addSubview:self.startTimeBtn];
        
        self.endTimeBtn.frame = CGRectMake(self.startTimeBtn.left, self.startTimeBtn.bottom, self.startTimeBtn.width, 33);
        [vi addSubview:self.endTimeBtn];

        
        UIImageView * igv1 = [UIImageView new];
        igv1.frame = CGRectMake(SCREEN_W - 45 - 20, 49, 7, 13);
        igv1.image = [UIImage imageNamed:[@"Back Chevron Copy 2" adS]];
        [vi addSubview:igv1];
        
        UIImageView * igv2 = [UIImageView new];
        igv2.frame = CGRectMake(SCREEN_W - 45 - 20, 82, 7, 13);
        igv2.image = [UIImage imageNamed:[@"Back Chevron Copy 2" adS]];
        [vi addSubview:igv2];
        
        UILabel * startTimeLab = [UILabel new];
        startTimeLab.font = [UIFont systemFontOfSize:12.f];
        startTimeLab.textColor = APP_COLOR_GRAY2;
        startTimeLab.text = @"开始日期";
        startTimeLab.frame = CGRectMake(self.startTimeBtn.right + 10, 46, 60, 14);
        [vi addSubview:startTimeLab];
        
        UILabel * endTimeLab = [UILabel new];
        endTimeLab.font = [UIFont systemFontOfSize:12.f];
        endTimeLab.textColor = APP_COLOR_GRAY2;
        endTimeLab.text = @"终止日期";
        endTimeLab.frame = CGRectMake(self.startTimeBtn.right + 10, 79, 60, 14);
        [vi addSubview:endTimeLab];
        
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_WHITEBG;
        line.frame = CGRectMake(0, 109, SCREEN_W - 45, 1);
        [vi addSubview:line];
        
        
        vi.frame = CGRectMake(0, 0, SCREEN_W - 45, 110);
        _timeVi = vi;
    }
    return _timeVi;
}

-(UIButton *)startTimeBtn {
    if (!_startTimeBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        _startTimeBtn = btn;
    }
    return _startTimeBtn;
}

-(UIButton *)endTimeBtn {
    if (!_endTimeBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18.f];
        _endTimeBtn = btn;
    }
    return _endTimeBtn;
}

-(UIView *)headerBox {
    if (!_headerBox)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15,200 , 17)];
        lab1.text = @"箱型";
        lab1.font = [UIFont systemFontOfSize:14.0f];
        lab1.textColor = APP_COLOR_GRAY_TEXT_1;
        [view addSubview:lab1];
        
        self.box.frame = CGRectMake(SCREEN_W - 140, 20, 120, 16);
        [view addSubview:self.box];
        
        self.arrowBtn.frame = CGRectMake(SCREEN_W - 30 - 45, 14, 30, 21);
        [view addSubview:self.arrowBtn];
        
        view.frame = CGRectMake(0, 0, SCREEN_W - 45, 44);
        _headerBox = view;
    }
    return _headerBox;
}

-(UIView *)boxStatus {
    if (!_boxStatus)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 40)];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_WHITEBG;
        line.frame = CGRectMake(0, 0, SCREEN_W - 45, 1);
        [view addSubview:line];
        
        UILabel * lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15,200 , 17)];
        lab1.text = @"箱况";
        lab1.font = [UIFont systemFontOfSize:14.0f];
        lab1.textColor = APP_COLOR_GRAY_TEXT_1;
        [view addSubview:lab1];
        
        view.frame = CGRectMake(0, 0, SCREEN_W - 45, 44);
        _boxStatus = view;
    }
    return _boxStatus;
}

-(NSArray *)boxStatusArr {
    if (!_boxStatusArr) {
        _boxStatusArr = @[@"新造箱",
                          @"完好在用",
                          @"轻微瑕疵",
                          @"破损在用"];
    }
    return _boxStatusArr;
}

-(UIButton *)arrowBtn {
    if (!_arrowBtn) {
        _arrowBtn = [UIButton new];
        [_arrowBtn setImage:[UIImage imageNamed:[@"Back Chevron Copy 5" adS]] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:[@"Clip 4" adS]] forState:UIControlStateSelected];
    }
    return _arrowBtn;
}

-(UILabel *)box {
    if (!_box)
    {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY2;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textAlignment = NSTextAlignmentRight;
        _box = label;
    }
    return _box;
}

-(UIButton *)resetBtn {
    if (!_resetBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"重 置" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        btn.backgroundColor = APP_COLOR_GRAY_BTN_1;
        [btn setTitleColor:APP_COLOR_GRAY_TEXT_1 forState:UIControlStateNormal];
        _resetBtn = btn;
    }
    return _resetBtn;
}

-(UIButton *)completeBtn {
    if (!_completeBtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"完 成" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        btn.backgroundColor = APP_COLOR_BLUE_BTN;
        [btn setTitleColor:APP_COLOR_WHITE forState:UIControlStateNormal];
        _completeBtn = btn;
    }
    return _completeBtn;
}

-(UIView *)datePirckerVi {
    if (!_datePirckerVi) {
        UIView * vi = [UIView new];
        vi.backgroundColor = APP_COLOR_WHITE;
        vi.frame = CGRectMake(45, SCREEN_H - 240, SCREEN_W - 45, 240);
        
        UIView * vi1 = [UIView new];
        vi1.backgroundColor = APP_COLOR_BLUE_BTN;
        vi1.frame = CGRectMake(0, 0, SCREEN_W - 45, 40);
        [vi addSubview:vi1];
        
        self.datePickerCancleBtn.frame = CGRectMake(0, 0, 50, 40);
        [vi addSubview:self.datePickerCancleBtn];
        
        self.datePickercompleteBtn.frame = CGRectMake(SCREEN_W - 50 - 45, 0, 50, 40);
        [vi addSubview:self.datePickercompleteBtn];
        
        self.datePicker.frame = CGRectMake(0, 40, SCREEN_W - 45, 200);
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

-(UIButton *)backBtn {
    if (!_backBtn) {
        UIButton * btn = [UIButton new];
        _backBtn = btn;
    }
    return _backBtn;
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

-(void)setFilterModel:(FilterModel *)filterModel {
    _filterModel = filterModel;
    self.filterModelNew = [FilterModel new];
    self.filterModelNew.city = filterModel.city;
    self.filterModelNew.startTime = filterModel.startTime;
    self.filterModelNew.endTime = filterModel.endTime;
    self.filterModelNew.container = filterModel.container;
    self.filterModelNew.containerCondition = filterModel.containerCondition;
    self.filterModelNew.currentPage = filterModel.currentPage;
    self.filterModelNew.pageSize = filterModel.pageSize;
    self.filterModelNew.saleType = filterModel.saleType;
    self.filterModelNew.useNumberSort = filterModel.useNumberSort;
    self.filterModelNew.isAuthenticated = filterModel.isAuthenticated;
    
    if (!self.filterModelNew.startTime) {
        NSDate * date = [NSDate dateWithTimeIntervalSinceNow:24L * 3600];
        NSDateFormatter * outputFormatter = [NSDateFormatter new];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        self.filterModelNew.startTime = [outputFormatter dateFromString:[outputFormatter stringFromDate:date]];
    }
}

-(void)getCityModel:(CityModel *)cityModel {

}

-(void)dateChanged:(UIDatePicker *)datePicker {
    NSDateFormatter *outputFormatter = [ NSDateFormatter new];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr = [outputFormatter stringFromDate:datePicker.date];
    if (self.datetype == startTimeBtnClicked) {
        [self.startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
    } else if(self.datetype == endTimeBtnClicked) {
        [self.endTimeBtn setTitle:dateStr forState:UIControlStateNormal];

    }
}

-(void)updateThisPageView{

}

/**
 *  tableView 代理
 *
 */

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


@end


@implementation ConditionsForRetrievalVC_Rent

-(void)bindModel {
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    [self.dataArray addObject:[NSObject new]];

    EntrySelectCellModel * model1 = [EntrySelectCellModel new];
    model1.cellHeightClose = 60;
    model1.cellCloseOrOpen = NO;
    [self.dataArray addObject:model1];
    
    EntrySelectCellModel * model2 = [EntrySelectCellModel new];
    model2.cellHeightClose = 400;//120
    model2.cellCloseOrOpen = NO;
    model2.entrys = [NSMutableArray arrayWithArray:self.boxStatusArr];
    [self.dataArray addObject:model2];
    
    [self.showViews addObject:self.addressBtn];
    [self.showViews addObject:self.timeVi];
    [self.showViews addObject:self.headerBox];
    [self.showViews addObject:self.boxStatus];
    
    self.cityLab.text = @"选择城市";
    self.cityLab.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    self.cityLab.textColor = APP_COLOR_BLACK_TEXT;
    self.cityLab.frame = CGRectMake(self.cityLab.left, self.cityLab.top, [self.cityLab.text sizeWithAttributes:@{NSFontAttributeName:self.cityLab.font}].width + 30, self.cityLab.height);
    [self.startTimeBtn setTitle:@"未选择" forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:@"未选择" forState:UIControlStateNormal];

    
    [self.tbv reloadData];
    [self getData];
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.arrowBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.arrowBtn.selected = !ws.arrowBtn.selected;
        EntrySelectCellModel * model = ws.dataArray[2];
        model.cellCloseOrOpen = ws.arrowBtn.selected;
        [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

-(void)getData {
    ContainerViewModel *vm = [ContainerViewModel new];
    WS(ws);
    [vm getContainerTypecallback:^(NSArray *arr) {
        
        ws.arrContainerType = arr;
        EntrySelectCellModel * model = ws.dataArray[2];
        [model.entrys removeAllObjects];
        for (ContainerTypeModel * mod in arr)
        {
            if(mod.name){
                
                [model.entrys addObject:mod.name];
                
            }
        }
        [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        [self updateThisPageView];
    }];
}

-(void)updateThisPageView{
    if (self.filterModelNew.city) {
        self.cityLab.text = self.filterModelNew.city.name;
        self.cityLab.layer.borderColor = [APP_COLOR_ORANGE_BTN_TEXT CGColor];
        self.cityLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
    }
    else {
        self.cityLab.text = @"选择城市";
        self.cityLab.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
        self.cityLab.textColor = APP_COLOR_BLACK_TEXT;
    }
    self.cityLab.frame = CGRectMake(self.cityLab.left, self.cityLab.top, [self.cityLab.text sizeWithAttributes:@{NSFontAttributeName:self.cityLab.font}].width + 30, self.cityLab.height);
    
    if (!self.filterModelNew.startTime) {
        [self.startTimeBtn setTitle:@"未选择" forState:UIControlStateNormal];
    } else {
        NSDateFormatter *outputFormatter = [ NSDateFormatter new];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * dateStr = [outputFormatter stringFromDate:self.filterModelNew.startTime];
        [self.startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
        
    }
    
    if (!self.filterModelNew.endTime) {
        [self.endTimeBtn setTitle:@"未选择" forState:UIControlStateNormal];
    } else {
        NSDateFormatter *outputFormatter = [ NSDateFormatter new];
        [outputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * dateStr = [outputFormatter stringFromDate:self.filterModelNew.endTime];
        [self.endTimeBtn setTitle:dateStr forState:UIControlStateNormal];
    }
    EntrySelectCellModel * model = self.dataArray[2];
    model.selectStr = self.filterModelNew.container.name;
    [self.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    
    
    EntrySelectCellModel * model1 = self.dataArray[3];
    if (self.filterModelNew.containerCondition < self.boxStatusArr.count) {
        model1.selectStr = self.boxStatusArr[self.filterModelNew.containerCondition];
    } else {
        model1.selectStr = @"未选择";
    }
    [self.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];

}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        self.filterModelNew.container = self.arrContainerType[row];
    }else if (indexPath.section == 3) {
        self.filterModelNew.containerCondition = (boxCondition)(new100 + row);
    }
}

-(void)getCityModel:(CityModel *)cityModel {
    self.filterModelNew.city = cityModel;
    [self updateThisPageView];
}

@end


@implementation ConditionsForRetrievalVC_Buy

-(void)bindModel {
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSObject new]];
    
    EntrySelectCellModel * model1 = [EntrySelectCellModel new];
    model1.cellHeightClose = 60;
    model1.cellCloseOrOpen = NO;
    [self.dataArray addObject:model1];
    
    EntrySelectCellModel * model2 = [EntrySelectCellModel new];
    model2.cellHeightClose = 400;
    model2.cellCloseOrOpen = NO;
    model2.entrys = [NSMutableArray arrayWithArray:self.boxStatusArr];
    [self.dataArray addObject:model2];
    
    [self.showViews addObject:self.addressBtn];
    [self.showViews addObject:self.headerBox];
    [self.showViews addObject:self.boxStatus];
    
    self.cityLab.text = @"选择城市";
    self.cityLab.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
    self.cityLab.textColor = APP_COLOR_BLACK_TEXT;
    self.cityLab.frame = CGRectMake(self.cityLab.left, self.cityLab.top, [self.cityLab.text sizeWithAttributes:@{NSFontAttributeName:self.cityLab.font}].width + 30, self.cityLab.height);
    [self.startTimeBtn setTitle:@"未选择" forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:@"未选择" forState:UIControlStateNormal];
    
    
    [self.tbv reloadData];
    [self getData];
}

-(void)bindAction {
    [super bindAction];
    WS(ws);
    [[self.arrowBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        ws.arrowBtn.selected = !ws.arrowBtn.selected;
        EntrySelectCellModel * model = ws.dataArray[1];
        model.cellCloseOrOpen = ws.arrowBtn.selected;
        [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

-(void)getData {
    ContainerViewModel *vm = [ContainerViewModel new];
    WS(ws);
    [vm getContainerTypecallback:^(NSArray *arr) {
        
        ws.arrContainerType = arr;
        EntrySelectCellModel * model = ws.dataArray[1];
        [model.entrys removeAllObjects];
        for (ContainerTypeModel * mod in arr)
        {
            if(mod.name){
                [model.entrys addObject:mod.name];
            }
        }
        [ws.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        [self updateThisPageView];
    }];
}

-(void)updateThisPageView{
    if (self.filterModelNew.city) {
        self.cityLab.text = self.filterModelNew.city.name;
        self.cityLab.layer.borderColor = [APP_COLOR_ORANGE_BTN_TEXT CGColor];
        self.cityLab.textColor = APP_COLOR_ORANGE_BTN_TEXT;
    }
    else {
        self.cityLab.text = @"选择城市";
        self.cityLab.layer.borderColor = [APP_COLOR_GRAY_CAPACITY_LINE CGColor];
        self.cityLab.textColor = APP_COLOR_BLACK_TEXT;
    }
    self.cityLab.frame = CGRectMake(self.cityLab.left, self.cityLab.top, [self.cityLab.text sizeWithAttributes:@{NSFontAttributeName:self.cityLab.font}].width + 30, self.cityLab.height);
    EntrySelectCellModel * model = self.dataArray[1];
    model.selectStr = self.filterModelNew.container.name;
    [self.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    
    
    EntrySelectCellModel * model1 = self.dataArray[2];
    if (self.filterModelNew.containerCondition < self.boxStatusArr.count) {
        model1.selectStr = self.boxStatusArr[self.filterModelNew.containerCondition];
    } else {
        model1.selectStr = @"未选择";
    }
    [self.tbv reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)getSelectString:(NSString *)str WithStringRow:(NSUInteger)row WithIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        self.filterModelNew.container = self.arrContainerType[row];
    }else if (indexPath.section == 2) {
        self.filterModelNew.containerCondition = (boxCondition)(new100 + row);
    }
}

-(void)getCityModel:(CityModel *)cityModel {
    self.filterModelNew.city = cityModel;
    [self updateThisPageView];
}

@end
