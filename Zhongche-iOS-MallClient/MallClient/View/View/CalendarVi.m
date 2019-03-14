//
//  CalendarVi.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/26.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CalendarVi.h"

typedef enum
{
    circleCell,
    circleCell_start,
    circleCell_end,
    middleCell,
    defaultCell,
}CellType;
@interface CollectionHeaderView : UICollectionReusableView
@property (nonatomic, strong)UILabel * lab;

@end
@implementation CollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lab];
    }
    return self;
}
-(UILabel *)lab
{
    if (!_lab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:14.f];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.textColor = APP_COLOR_BLACK_TEXT;
        _lab = lab;
    }
    return _lab;
    
}
@end


@interface CalendarCell : UICollectionViewCell

@property (nonatomic, strong)UILabel * lab;
@property (nonatomic, assign)CellType type;

@end

@implementation CalendarCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lab.frame = CGRectMake(0, 0, self.width, self.height);
        self.type = defaultCell;
        [self addSubview:self.lab];
    }
    return self;
}
-(UILabel *)lab
{
    if (!_lab) {
        UILabel * lab = [UILabel new];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.layer.masksToBounds = YES;
        lab.numberOfLines = 0;
        _lab = lab;
    }
    return _lab;
    
}
-(void)setType:(CellType)type
{
    _type = type;
    switch (_type) {
        case circleCell:
            self.lab.frame = CGRectMake(0, 0, self.width, self.height);
            self.lab.font = [UIFont systemFontOfSize:16.f];
            self.lab.backgroundColor = APP_COLOR_ORANGE_BTN_TEXT;
            self.lab.textColor = APP_COLOR_WHITE;
            self.lab.layer.cornerRadius = self.lab.height / 2;
            break;
        case circleCell_start:
            self.lab.frame = CGRectMake(-5, - 5, self.width + 10, self.height + 10);
            self.lab.font = [UIFont systemFontOfSize:14.f];
            self.lab.backgroundColor = APP_COLOR_ORANGE_BTN_TEXT;
            self.lab.textColor = APP_COLOR_WHITE;
            self.lab.layer.cornerRadius = self.lab.height / 2;
            self.lab.text = [NSString stringWithFormat:@"%@\n开始",self.lab.text];
            break;
        case circleCell_end:
            self.lab.frame = CGRectMake(-5,  - 5, self.width + 10, self.height + 10);
            self.lab.font = [UIFont systemFontOfSize:14.f];
            self.lab.backgroundColor = APP_COLOR_ORANGE_BTN_TEXT;
            self.lab.textColor = APP_COLOR_WHITE;
            self.lab.layer.cornerRadius = self.lab.height / 2;
            self.lab.text = [NSString stringWithFormat:@"%@\n结束",self.lab.text];
            break;
        case middleCell:
            self.lab.frame = CGRectMake(0, 0, self.width, self.height);
            self.lab.font = [UIFont systemFontOfSize:16.f];
            self.lab.backgroundColor = APP_COLOR_WHITE;
            self.lab.textColor = APP_COLOR_BLACK_TEXT;
            self.lab.layer.cornerRadius = 0;
            break;
        case defaultCell:
            self.lab.frame = CGRectMake(0, 0, self.width, self.height);
            self.lab.font = [UIFont systemFontOfSize:16.f];
            self.lab.backgroundColor = APP_COLOR_WHITE;
            self.lab.textColor = APP_COLOR_GRAY2;
            self.lab.layer.cornerRadius = 0;
            break;
        default:
            break;
    }
}
@end
@interface CalendarVi()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UIView * weeks;
@property (nonatomic, strong)UICollectionView * mainView;
@property (nonatomic, strong)NSMutableArray * monthdays;

@end

@implementation CalendarVi

//定义一个静态变量用于接收实例对象，初始化为nil
static CalendarVi *singleInstance=nil;
+(CalendarVi *)shareCalendarView{
    @synchronized(self){//线程保护，增加同步锁
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = APP_COLOR_WHITEBG;
        self.type =  interval;
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

-(void)binView
{
    [self addSubview:self.weeks];
    
    [self addSubview:self.mainView];
}
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self loadUIWithFrame:frame];
}
-(void)setTitleView:(UIView *)titleView
{
    [_titleView removeFromSuperview];
    _titleView = titleView;
    [self addSubview:_titleView];
    [self loadUIWithFrame:self.frame];
}

-(void)removeFromSuperview
{
    self.monthdays = nil;
    [super removeFromSuperview];
}
-(void)loadUIWithFrame:(CGRect)frame
{
    self.weeks.frame = CGRectMake(0, self.titleView.bottom, frame.size.width, 25);
    
    float f;
    float width;
    width = [self.weeks viewWithTag:100].width;
    f = (frame.size.width - 7 * width) / 7;
    for (int i = 0; i < 7; i ++)
    {
        [self.weeks viewWithTag:100 + i].frame = CGRectMake(f / 2 + i * (f + width), [self.weeks viewWithTag:100].top, width, [self.weeks viewWithTag:100].height);
    }
    
    self.mainView.frame = CGRectMake(0, self.weeks.bottom + 15, frame.size.width, frame.size.height -  self.weeks.bottom - 15);
}

-(UIView *)weeks
{
    if (!_weeks) {
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_WHITE;
        
        UILabel * lab;
        for (int i = 0; i < 7; i ++) {
            lab = [UILabel new];
            lab.frame = CGRectMake(0, 3, 20, 20);
            lab.tag = i + 100;
            lab.text = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"][i];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = APP_COLOR_GRAY2;
            lab.font = [UIFont systemFontOfSize:14.0f];
            
            [view addSubview:lab];
        }
        
        _weeks = view;
    }
    return _weeks;
}
- (UICollectionView *)mainView
{
    if (!_mainView) {
        
        UICollectionView * view = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        view.delegate = self;
        view.dataSource = self;
        view.backgroundColor = [UIColor whiteColor];
        [view registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"CalendarCell"];
        [view registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderView"];
        _mainView = view;
    }
    return _mainView;
}
-(NSMutableArray *)monthdays
{
    if (!_monthdays) {
        NSMutableArray * array = [NSMutableArray new];
        
        NSDate * now = [NSDate new];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];

        [dateformatter setDateFormat:@"dd"];
        NSMutableArray * arr;
        NSDate * date = [NSDate dateWithTimeInterval:(1 - [[dateformatter stringFromDate:now] intValue])* 24l * 3600  sinceDate:now];
        for (int i = 0; i < 36; i ++) {
            arr = [NSMutableArray new];
            
            [dateformatter setDateFormat:@"EEE"];
            NSString *weekString = [dateformatter stringFromDate:date];
            int a = 0;
            if([weekString isEqualToString:@"周日"]||[weekString isEqualToString:@"Sun"]){
                a = 0;
            }
            if([weekString isEqualToString:@"周一"]||[weekString isEqualToString:@"Mon"]){
                a = 1;
                
            }
            if([weekString isEqualToString:@"周二"]||[weekString isEqualToString:@"Tue"]){
                a = 2;
                
            }
            if([weekString isEqualToString:@"周三"]||[weekString isEqualToString:@"Wed"]){
                a = 3;
                
            }
            if([weekString isEqualToString:@"周四"]||[weekString isEqualToString:@"Thu"]){
                a = 4;
                
            }
            if([weekString isEqualToString:@"周五"]||[weekString isEqualToString:@"Fri"]){
                a = 5;
                
            }
            if([weekString isEqualToString:@"周六"]||[weekString isEqualToString:@"Sat"]){
                a = 6;
            }
            for (int j = 0 ; j < a; j ++) {
                [arr addObject:[NSNull null]];
            }
            
            
            [dateformatter setDateFormat:@"dd"];
            while ([[dateformatter stringFromDate:date] intValue] < [[dateformatter stringFromDate:[NSDate dateWithTimeInterval: 24l * 3600  sinceDate:date]] intValue]) {
                [arr addObject:date];

                date = [NSDate dateWithTimeInterval: 24l * 3600  sinceDate:date];
            }
            [arr addObject:date];
            date = [NSDate dateWithTimeInterval: 24l * 3600  sinceDate:date];
            [array addObject:arr];
        }
        _monthdays = array;
        
        [self.mainView reloadData];
    }
    return _monthdays;
}
#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.monthdays[section] count];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.monthdays.count;
}
// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        CollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionHeaderView" forIndexPath:indexPath];
        
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"yyyy年MM月"];
        headerView.lab.text = [dateformatter stringFromDate:self.monthdays[indexPath.section][7]];
        headerView.lab.frame = CGRectMake(0, 15, self.width, 11);
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
    }
    return nil;
}
//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CalendarCell" forIndexPath:indexPath];
    NSDate * date = self.monthdays[indexPath.section][indexPath.row];
    if ([date isKindOfClass:[NSDate class]]) {
    
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        
        [dateformatter setDateFormat:@"dd"];
        cell.lab.text = [NSString stringWithFormat:@"%d",[[dateformatter stringFromDate:date]intValue]];
        if (self.type == radio) {
            if ([self.selectedDate isEqual:date]) {
                cell.type = circleCell;
            }
            else
            {
                cell.type = defaultCell;
            }
        }
        if (self.type == interval)
        {
            if ([[self.startDate earlierDate:date] isEqualToDate:self.startDate] && [[self.endDate earlierDate:date] isEqualToDate:date]) {
                cell.type = middleCell;
            }
            else
            {
                cell.type = defaultCell;
            }
            if ([self.startDate isEqualToDate:date]) {
                cell.type = circleCell_start;
            }
            else if([self.endDate isEqualToDate:date])
            {
                cell.type = circleCell_end;

            }
            
        }
    }
    else
    {
        cell.lab.text = @"";
        cell.type = defaultCell;
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){self.frame.size.width,44};
}
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(30, 30);
}

//设置每组的cell的边界,
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    float f = (self.width - 7 * 30) / 7;
    return UIEdgeInsetsMake(0,f /2,0,f /2);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (self.width - 7 * 30) / 7;
}
//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate * date = self.monthdays[indexPath.section][indexPath.row];
    if ([date isKindOfClass:[NSDate class]]) {
        if (self.type == radio) {
            self.selectedDate = date;
            [self.viDelegate calendarViGetSelectedDate:self.selectedDate];
        }
        if (self.type == interval) {
            //二者都存在
            if (self.startDate && self.endDate) {
                self.startDate = nil;
                self.endDate = nil;
                self.startDate = date;
            }
            //存在一个
            else if(!self.startDate && self.endDate) {
                if([self.endDate isEqualToDate:date])
                {
                    self.startDate = date;
                }
                else
                {
                    if ([[self.endDate earlierDate:date] isEqualToDate:date]) {
                        self.startDate = date;
                    }
                    else
                    {
                        self.startDate = self.endDate;
                        self.endDate = date;
                    }
                }
            }
            else if (self.startDate && !self.endDate)
            {
                if([self.startDate isEqualToDate:date])
                {
                    self.endDate = date;
                }
                else
                {
                    if ([[self.startDate earlierDate:date] isEqualToDate:date]) {
                        self.endDate = self.startDate;
                        self.startDate = date;
                    }
                    else
                    {
                        self.endDate = date;
                    }

                }
            }
            //都存在
            else
            {
                self.startDate = date;
            }
        }
        [self.mainView reloadData];
    }
}
@end
