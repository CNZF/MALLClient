//
//  KNOrderCompletePopDetailView.m
//  MallClient
//
//  Created by dushenke on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNOrderCompletePopDetailView.h"
#import "KNOrderCompletePopDetailCell.h"

@interface KNOrderCompletePopDetailView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UITableView *KNTableView;

@property (nonatomic, strong) NSArray *titleArray;

@end


@implementation KNOrderCompletePopDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-50)];
    if (self) {
        [self addSubview:self.coverView];
        [self addSubview:self.KNTableView];
        
    }
    return self;
}

#pragma mark -- Action
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.coverView.alpha = 1.0;
        self.KNTableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)close{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.coverView.alpha = 0;
        self.KNTableView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KNOrderCompletePopDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNOrderCompletePopDetailCell"];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    cell.numLabel.text = [NSString stringWithFormat:@"x%@",self.boxNum];
    NSString * priceStr = self.priceArray[indexPath.row];
    if (self.priceArray) {
        cell.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[priceStr floatValue]];
    }
    return cell;
}

#pragma mark -- getter
- (void)setBoxNum:(NSString *)boxNum{
    _boxNum = boxNum;
    [self.KNTableView reloadData];
}
- (void)setPriceArray:(NSArray *)priceArray{
    _priceArray = priceArray;
    [self.KNTableView reloadData];
}

- (UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:self.bounds];
        _coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _coverView.alpha = 0;
        _coverView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [_coverView addGestureRecognizer:tap];
    }
    return _coverView;
}
-(UITableView *)KNTableView {
    if (!_KNTableView) {
        _KNTableView = [[UITableView alloc]init];
        _KNTableView.frame = CGRectMake(0, SCREEN_H-kiPhoneFooterHeight-self.titleArray.count * 45, SCREEN_W, self.titleArray.count * 45);
        _KNTableView.rowHeight = 45;
        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        _KNTableView.scrollEnabled = NO;
        _KNTableView.bounces = NO;
        _KNTableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        _KNTableView.backgroundColor = [UIColor whiteColor];
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNOrderCompletePopDetailCell" bundle:nil] forCellReuseIdentifier:@"KNOrderCompletePopDetailCell"];
    }
    return _KNTableView;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"运费",@"上门取货费",@"送货上门费"];
    }
    return _titleArray;
}

@end
