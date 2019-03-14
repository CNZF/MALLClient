//
//  KNTransportSelectDateVC.m
//  MallClient
//
//  Created by dushenke on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTransportSelectDateVC.h"
#import "FSCalendar.h"
#import "CapacityViewModel.h"
#import "CapacityEntryModel.h"

@interface KNTransportSelectDateVC ()<FSCalendarDelegate,FSCalendarDataSource>

@property (nonatomic, strong) FSCalendar *calendar;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) NSArray *paramArray;
//日期数组
@property (nonatomic, strong) NSMutableArray *dateArray;
//价格数组
@property (nonatomic, strong) NSMutableArray *priceArray;

@end

@implementation KNTransportSelectDateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择日期";
    [self.view addSubview:self.calendar];
    [self.view addSubview:self.bottomLabel];
    
}

- (void)onBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bindModel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *currentYearMonth = [formatter stringFromDate:self.calendar.currentPage];
    self.paramArray = [self getMonthBeginAndEndWith:currentYearMonth];
    self.requestModel.startDate = self.paramArray[0];
    self.requestModel.endDate = self.paramArray[1];
    [[[CapacityViewModel alloc] init] requestPriceCalendaWithInfo:self.requestModel callback:^(NSArray *arr) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CapacityEntryModel *model = obj;
            NSString * str = [self ConvertStrToTime:model.departureTime];
            [self.dateArray addObject:str];
            [self.priceArray addObject:model.price];
        }];
        [self.calendar reloadData];
        NSLog(@"dataArray %@",self.dataArray);
    }];
}

#pragma mark-- FSCalendarDataSource,FSCalendarDelegate
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition{
    if (self.selectDateBlock) {
        self.selectDateBlock(date);
        [self onBackAction];
    }
}

- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar{
    [self bindModel];
}

- (NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
    NSString *timinterval = [NSString stringWithFormat:@"%ld000", (long)[date timeIntervalSince1970]];
    NSString * now = [self ConvertStrToTime:timinterval];
    if ([self.dateArray containsObject:now]) {
        NSInteger index = [self.dateArray indexOfObject:now];
        NSString * price = self.priceArray[index];
        if ([price intValue] > 0) {
            return [NSString stringWithFormat:@"￥%@",self.priceArray[index]];
        }else{
            return [NSString stringWithFormat:@"￥%@",@"-"];
        }
        
    }
    return @"";
}
- (NSString *)ConvertStrToTime:(NSString *)timeStr

{
    
    long long time=[timeStr longLongValue];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString*timeString=[formatter stringFromDate:d];
    
    return timeString;
    
}
#pragma mark -- PrivateMethod
- (NSArray *)getMonthBeginAndEndWith:(NSString *)dateStr{
    
    NSMutableArray *mutArray = [NSMutableArray array];
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }
    [mutArray addObject:beginDate];
    [mutArray addObject:endDate];
    return mutArray;
}

#pragma mark -- Getter
- (FSCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, kNavBarHeaderHeight, SCREEN_W, SCREEN_W)];
        _calendar.dataSource = self;
        _calendar.delegate = self;
        _calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _calendar.backgroundColor = [UIColor whiteColor];
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase | FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        _calendar.appearance.selectionColor = [HelperUtil colorWithHexString:@"ED933D"];
        _calendar.appearance.titleTodayColor = [HelperUtil colorWithHexString:@"ED933D"];
        _calendar.appearance.subtitleTodayColor = [HelperUtil colorWithHexString:@"ED933D"];
        _calendar.appearance.titleSelectionColor = [UIColor whiteColor];
        _calendar.appearance.subtitleSelectionColor = [UIColor whiteColor];
        _calendar.appearance.headerTitleColor = APP_COLOR_GRAY666;
        _calendar.appearance.weekdayTextColor = APP_COLOR_GRAY666;
        _calendar.appearance.headerDateFormat = @"yyyy年M月";
        _calendar.appearance.todayColor = [UIColor whiteColor];
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.appearance.subtitleFont = [UIFont systemFontOfSize:9];
    }
    return _calendar;
}

- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREEN_H-kiPhoneFooterHeight-34, SCREEN_W, 34)];
        _bottomLabel.backgroundColor = [HelperUtil colorWithHexString:@"FFFBCF"];
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.textColor = APP_COLOR_GRAY666;
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.text = @"运力票价格会因实际情况变动频繁，请以实际咨询价格为准";
    }
    return _bottomLabel;
}

- (NSMutableArray *)dateArray{
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)priceArray{
    if (!_priceArray) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
