//
//  KNTransportResultListTopView.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/25.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNTransportResultListTopView.h"
#import "KNResultListTopViewSubCell.h"
#import "CapacityEntryModel.h"
#import "CapacityViewModel.h"

static CGFloat KNcollectionViewCell_Width = 74;

@interface KNTransportResultListTopView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *topBGView;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) NSArray *dateArray;

@property (nonatomic, strong) NSArray *descDateArray;

@property (nonatomic, strong) NSArray *weekArray;

@property (nonatomic,strong) NSArray *priceArray;

@property (nonatomic, assign) NSInteger selectIndex;

@end

@implementation KNTransportResultListTopView

- (instancetype)initWithRequestModel:(CapacityEntryModel *)model{
    self = [super init];
    if (self) {
        self.requestModel = model;
        [self binView];
        [self requestData];
    }
    return self;
}

- (void)binView{
    //94.5
    self.backgroundColor = APP_COLOR_WHITEBG;
    [self addSubview:self.topBGView];
    [self.topBGView addSubview:self.collectionView];
    [self.topBGView addSubview:self.rightButton];
    [self addSubview:self.distanceLabel];
    
    [self updateSubViewConstraints];
    
}

- (void)updateSubViewConstraints{
    WS(weakSelf)
    [self.topBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf);
        make.top.mas_equalTo(@0.5);
        make.height.mas_equalTo(KNcollectionViewCell_Width);
        make.width.mas_equalTo(SCREEN_W);
    }];
    [self.rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(weakSelf.topBGView);
        make.width.height.mas_equalTo(KNcollectionViewCell_Width);
    }];
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.rightButton.mas_left);
        make.top.bottom.mas_equalTo(weakSelf.topBGView);
        make.width.mas_equalTo(SCREEN_W-KNcollectionViewCell_Width);
    }];
    [self.distanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topBGView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(@15);
    }];
}

- (void)requestData{
    WS(weakSelf);
  
    self.dateArray =  [self getDateArrayWithDate:self.requestModel.shipmentsTime];
    self.descDateArray = [self getDescDateArrayWithDate:self.requestModel.shipmentsTime];
    NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:self.dateArray.count];
    for (NSString *dateStr in self.descDateArray) {
        NSString *weekStr = [self getTheDayOfTheWeekByDateString:dateStr];
        [mutArray addObject:weekStr];
    }
    self.weekArray = mutArray;
    
    NSString *startStr = [self getDescDateArrayWithDate:self.requestModel.shipmentsTime][0];
    NSString *endStr = [self getDescDateArrayWithDate:self.requestModel.shipmentsTime][6];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    self.requestModel.startDate = [dateFormatter dateFromString:startStr];
    self.requestModel.endDate = [dateFormatter dateFromString:endStr];
    [[[CapacityViewModel alloc] init] requestPriceCalendaWithInfo:self.requestModel callback:^(NSArray *arr) {
        weakSelf.priceArray = arr;
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark -- UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dateArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KNResultListTopViewSubCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KNResultListTopViewSubCell" forIndexPath:indexPath];
    cell.dateLabel.text = self.dateArray[indexPath.row];
    cell.weekLabel.text = self.weekArray[indexPath.row];
    //格式化
    if (indexPath.row < self.dateArray.count-1) {
        cell.rightLineLabel.hidden = YES;
    }
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"MM/dd"];
    NSString *the_date_str = [date_formatter stringFromDate:self.requestModel.shipmentsTime];
    if ([the_date_str isEqualToString:self.dateArray[indexPath.row]]) {
        cell.cellSelected = YES;
        self.selectIndex = indexPath.row;
    }else{
        cell.cellSelected = NO;
    }
    if (self.priceArray) {
        CapacityEntryModel *model = self.priceArray[indexPath.row];
        if ([model.price intValue] == 0) {
            cell.priceLabel.text = @"--";
        }else{
            NSString *str = [NSString stringWithFormat:@"￥%.2f",[model.price doubleValue]];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
            NSUInteger loc = str.length;
            [AttributedStr addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:9.0]
                                  range:NSMakeRange(loc - 2, 2)];
            cell.priceLabel.attributedText = AttributedStr;
        }
    }else{
        NSString *str = @"￥----";
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
        NSUInteger loc = str.length;
        [AttributedStr addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:9.0]
                              range:NSMakeRange(loc - 2, 2)];
        cell.priceLabel.attributedText = AttributedStr;
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KNResultListTopViewSubCell *lastCell = (KNResultListTopViewSubCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
    lastCell.cellSelected = NO;
    KNResultListTopViewSubCell *cell = (KNResultListTopViewSubCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.cellSelected = YES;
    [collectionView reloadData];
    NSString *dateString = self.descDateArray[indexPath.row];
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *resDate = [date_formatter dateFromString:dateString];
    if (self.selectModel) {
        self.selectModel(resDate);
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    KNResultListTopViewSubCell *cell = (KNResultListTopViewSubCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.cellSelected = NO;
}

#pragma mark -- Getter
- (UIView *)topBGView{
    if (!_topBGView) {
        _topBGView = [[UIView alloc] init];
        _topBGView.backgroundColor = [UIColor whiteColor];
//        _topBGView.backgroundColor = [UIColor cyanColor];
    }
    return _topBGView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.collectionViewLayout = self.collectionViewFlowLayout;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"KNResultListTopViewSubCell" bundle:nil] forCellWithReuseIdentifier:@"KNResultListTopViewSubCell"];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionViewFlowLayout.itemSize = CGSizeMake(KNcollectionViewCell_Width,KNcollectionViewCell_Width);
        _collectionViewFlowLayout.minimumInteritemSpacing = 0;
        _collectionViewFlowLayout.minimumLineSpacing = 0;
        _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _collectionViewFlowLayout;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"KN_lowprice_icon-1"] forState:UIControlStateNormal];
    }
    return _rightButton;
}

- (UILabel *)distanceLabel{
    if (!_distanceLabel) {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textColor = APP_COLOR_GRAY999;
    }
    return _distanceLabel;
}

- (NSArray *)dateArray{
    if (!_dateArray) {
        _dateArray = [NSArray array];
    }
    return _dateArray;
}

- (NSArray *)descDateArray{
    if (!_descDateArray) {
        _descDateArray = [NSArray array];
    }
    return _descDateArray;
}

- (NSArray *)weekArray{
    if (!_weekArray) {
        _weekArray = [NSArray array];
    }
    return _weekArray;
}

- (NSArray *)getDescDateArrayWithDate:(NSDate *)date{
    NSMutableArray *dateArray = [NSMutableArray array];
    // 1天的长度
    NSTimeInterval oneDay = 24*60*60*1;
    // 参数时间戳
    NSTimeInterval paramTimeInterval = [date timeIntervalSince1970];
    // 当前时间戳
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    //格式化
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd"];
    
    if (paramTimeInterval-currentTimeInterval < oneDay*3) {
        for (int i = 0; i<7; i++) {
            NSDate *theDate = [date initWithTimeInterval:i*oneDay + 4*oneDay sinceDate:date];;
            NSString *the_date_str = [date_formatter stringFromDate:theDate];
            [dateArray addObject:the_date_str];
        }
    }else{
        for (int i = -3; i<4; i++) {
            NSDate *theDate = [date initWithTimeInterval:i*oneDay + 4*oneDay sinceDate:date];
            NSString *the_date_str = [date_formatter stringFromDate:theDate];
            [dateArray addObject:the_date_str];
        }
    }
    return dateArray;
}

- (NSArray *)getDateArrayWithDate:(NSDate *)date{
    NSMutableArray *dateArray = [NSMutableArray array];
    // 1天的长度
    NSTimeInterval oneDay = 24*60*60*1;
    // 参数时间戳
    NSTimeInterval paramTimeInterval = [date timeIntervalSince1970];
    // 当前时间戳
    NSTimeInterval currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    //格式化
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"MM/dd"];

    if (paramTimeInterval-currentTimeInterval < oneDay*3) {
        for (int i = 0; i<7; i++) {
            NSDate *theDate = [date initWithTimeInterval:i*oneDay+4*oneDay sinceDate:date];;
            NSString *the_date_str = [date_formatter stringFromDate:theDate];
            [dateArray addObject:the_date_str];
        }
    }else{
        for (int i = -3; i<4; i++) {
            NSDate *theDate = [date initWithTimeInterval:i*oneDay + 4*oneDay sinceDate:date];
            NSString *the_date_str = [date_formatter stringFromDate:theDate];
            [dateArray addObject:the_date_str];
        }
    
    }
    return dateArray;
}

//根据日期获取星期几
-(NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString{
    
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];

    [outputFormatter setDateFormat:@"EEE"];
    NSLocale *zh_Locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    [outputFormatter setLocale:zh_Locale];
    
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
    return [weekArray objectAtIndex:0];
}


@end
