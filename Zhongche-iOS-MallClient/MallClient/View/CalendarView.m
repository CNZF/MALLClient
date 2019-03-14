//
//  CalendarView.m
//  MallClient
//
//  Created by lxy on 2016/11/24.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "CalendarView.h"
#import "DayIndoModel.h"
#import "DateButton.h"


@interface CalendarView()

@property (nonatomic, strong) UIView      *viBackground;
@property (nonatomic, strong) UIView      *viShow;
@property (nonatomic, strong) DateButton   *currentBtn;
@property (nonatomic, strong) UIButton    *btnCancle;
@property (nonatomic, strong) UIImageView *ivCancle;
@property (nonatomic, strong) UIButton    *btnBack;

@end

@implementation CalendarView

//定义一个静态变量用于接收实例对象，初始化为nil
static CalendarView *singleInstance=nil;


+(CalendarView *)shareCalendarView{
    @synchronized(self){//线程保护，增加同步锁
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}

- (void)binView {

    self.viBackground.frame = CGRectMake(0, - SCREEN_H, SCREEN_W,2 * SCREEN_H);
    [self addSubview:self.viBackground];

    self.btnBack.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H/3);
    [self addSubview:self.btnBack];

    self.viShow.frame = CGRectMake(0, SCREEN_H /3, SCREEN_W, SCREEN_H *2/3);
    [self addSubview:self.viShow];

    [self viewMake];
}


- (void) viewMake {

    UILabel *lbTitle = [UILabel new];
    lbTitle.frame = CGRectMake(0, 10, SCREEN_W, 40);
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.text = @"选择发货日期";
    lbTitle.font = [UIFont systemFontOfSize:16];
    [self.viShow addSubview:lbTitle];



    self.ivCancle.frame = CGRectMake(SCREEN_W - 30, 20, 14,14 );
    [self.viShow addSubview:self.ivCancle];

    self.btnCancle.frame = CGRectMake(SCREEN_W - 40, 10, 40,40 );
    [self.viShow addSubview:self.btnCancle];


    UIView *viTitle = [[UIView alloc]initWithFrame:CGRectMake(0, lbTitle.bottom, SCREEN_W, 40)];
    viTitle.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    [self.viShow addSubview:viTitle];

    NSArray *arrWeekDay = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];

    CGFloat right = 0;

    for (int i=0; i<7; i++) {

        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(right, 0, SCREEN_W/7, 40)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.text = [arrWeekDay objectAtIndex:i];
        lb.textColor = [UIColor grayColor];
        lb.font = [UIFont systemFontOfSize:14];
        [viTitle addSubview:lb];
        right = lb.right;


    }


    UIScrollView *sv = [UIScrollView new];
    sv.frame = CGRectMake(0, viTitle.bottom, SCREEN_W, SCREEN_H - viTitle.bottom);


    [self.viShow addSubview:sv];


    // 获取当前时间
    NSDate *senddate=[NSDate date];


    DayIndoModel *currentDayInfo = [DayIndoModel new];
    [currentDayInfo modelWithDate:senddate];


    NSDate *startday1 = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60* (currentDayInfo.day-1))];
    DayIndoModel *startDayInfo1 = [DayIndoModel new];
    [startDayInfo1 modelWithDate:startday1];


    UIView *viMoth1= [self mothViewWith:startday1];
    viMoth1.origin = CGPointMake(0, 0);
    [sv addSubview:viMoth1];

    NSDate *startday2 = [NSDate dateWithTimeInterval:(24*60*60* ([self getDaysInMonth:startDayInfo1.year month:startDayInfo1.month]  )) sinceDate:startday1];
    DayIndoModel *startDayInfo2 = [DayIndoModel new];
    [startDayInfo2 modelWithDate:startday2];

    UIView *viMoth2= [self mothViewWith:startday2];
    viMoth2.origin = CGPointMake(0, viMoth1.bottom);
    [sv addSubview:viMoth2];

    NSDate *startday3 = [NSDate dateWithTimeInterval:(24*60*60* ([self getDaysInMonth:startDayInfo2.year month:startDayInfo2.month]  )) sinceDate:startday2];
    DayIndoModel *startDayInfo3 = [DayIndoModel new];
    [startDayInfo3 modelWithDate:startday3];

    UIView *viMoth3= [self mothViewWith:startday3];
    viMoth3.origin = CGPointMake(0, viMoth2.bottom);
    [sv addSubview:viMoth3];

     sv.contentSize = CGSizeMake( SCREEN_W, viMoth3.bottom +200);




}


- (UIView *)mothViewWith:(NSDate *)startDate {

    UIView *view = [UIView new];

    // 获取当前时间
    NSDate *senddate=[NSDate date];
    DayIndoModel *currentDayInfo = [DayIndoModel new];
    [currentDayInfo modelWithDate:senddate];

    DayIndoModel *startDayInfo = [DayIndoModel new];
    [startDayInfo modelWithDate:startDate];


    NSDate *endday = [NSDate dateWithTimeInterval:(24*60*60* ([self getDaysInMonth:startDayInfo.year month:startDayInfo.month] -1 )) sinceDate:startDate];




    DayIndoModel *endDayInfo = [DayIndoModel new];
    [endDayInfo modelWithDate:endday];




    UILabel *lbTitle1 = [UILabel new];
    lbTitle1.font = [UIFont systemFontOfSize:14];
    lbTitle1.textAlignment = NSTextAlignmentCenter;
    lbTitle1.text = [NSString stringWithFormat:@"%i年%i月",startDayInfo.year,startDayInfo.month];
    lbTitle1.frame = CGRectMake(0, 0, SCREEN_W, 40);
    [view addSubview:lbTitle1];


    NSDate *date = startDate;
    DayIndoModel *dayInfo = [DayIndoModel new];
    CGFloat bottom = lbTitle1.bottom;

    CGFloat w = SCREEN_W/7;
    for (int i = 0; i<endDayInfo.day; i++) {

        DateButton *btn = [DateButton new];

        [dayInfo modelWithDate:date];
        [btn setTitle:[NSString stringWithFormat:@"%i",dayInfo.day] forState:UIControlStateNormal];
        btn.frame = CGRectMake(w * dayInfo.weekday + (w-30)/2, bottom, 30, 30);
        if (dayInfo.weekday == 6) {
            bottom = btn.bottom + 10 ;
        }

        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:15.0];//设置矩形四个圆角半径

        [view addSubview:btn];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        if (dayInfo.day < currentDayInfo.day && dayInfo.month == currentDayInfo.month) {
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }

        if ( dayInfo.day == currentDayInfo.day && dayInfo.month == currentDayInfo.month) {
            [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.date = date;
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        

        date = [NSDate dateWithTimeInterval:24*60*60 sinceDate:date];
        
    }

    if (dayInfo.weekday == 6) {

        // view.frame = CGRectMake(0, 0, SCREEN_W, bottom);

        view.size = CGSizeMake(SCREEN_W, bottom);

    }else {

         //view.frame = CGRectMake(0, 0, SCREEN_W, bottom + 50);

        view.size = CGSizeMake(SCREEN_W, bottom + 50);

    }

    return view;
}


// 获取某年某月总共多少天
- (int)getDaysInMonth:(int)year month:(int)imonth {
    // imonth == 0的情况是应对在CourseViewController里month-1的情况
    if((imonth == 0)||(imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
        return 31;
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
        return 30;
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
        return 29;
    if(year%100 == 0)
        return 28;
    return 29;
}

- (void)clickAction:(DateButton *)btn {

    NSLog(@"%@",btn.date);


    DayIndoModel *chooseDayInfo = [DayIndoModel new];
    [chooseDayInfo modelWithDate:btn.date];


    // 获取当前时间
    NSDate *senddate=[NSDate date];
    DayIndoModel *currentDayInfo = [DayIndoModel new];
    [currentDayInfo modelWithDate:senddate];

    DayIndoModel *dayInfo = [DayIndoModel new];
    [dayInfo modelWithDate:self.currentBtn.date];


    if (btn.titleLabel.textColor != [UIColor grayColor]) {

        [self.chooseDateInfo chooseDateActionWithDate:btn.date];

        [self.currentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.currentBtn setBackgroundColor:[UIColor clearColor]];

        if ( dayInfo.day == currentDayInfo.day && dayInfo.month == currentDayInfo.month) {
            [self.currentBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }


        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor orangeColor]];
        
        self.currentBtn = btn;

    }

    [self closeAction];


}

- (void)closeAction {

    [self removeFromSuperview];
}


/**
 *  getting
 */

- (UIView *)viBackground {
    if (!_viBackground) {
        _viBackground = [UIView new];
        _viBackground.alpha = 0.7;
        _viBackground.backgroundColor = [UIColor blackColor];
    }
    return _viBackground;
}

- (UIView *)viShow {
    if (!_viShow) {
        _viShow = [UIView new];
        _viShow.backgroundColor = [UIColor whiteColor];

    }
    return _viShow;
}

- (UIButton *)btnCancle {
    if (!_btnCancle) {
        UIButton *button = [[UIButton alloc]init];

        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];



        _btnCancle = button;
    }
    return _btnCancle;
}

- (UIImageView *)ivCancle{
    if (!_ivCancle) {
        UIImageView *imageView = [[UIImageView alloc]init];


        imageView.image = [UIImage imageNamed:@"Cancle"];


        _ivCancle = imageView;
    }
    return _ivCancle;
}

- (UIButton *)btnBack {
    if (!_btnBack) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];


        _btnBack = button;
    }
    return _btnBack;
}


@end
