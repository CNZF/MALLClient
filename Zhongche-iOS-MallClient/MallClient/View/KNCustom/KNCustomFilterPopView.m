//
//  KNCustomFilterPopView.m
//  MallClient
//
//  Created by dushenke on 2018/4/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNCustomFilterPopView.h"
#import "KNCustomFilterPopCell.h"

@interface KNCustomFilterPopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UITableView *KNTableView;

@property (nonatomic, strong) NSArray *menuDataArray;

@end


@implementation KNCustomFilterPopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
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
        self.KNTableView.transform = CGAffineTransformMakeTranslation(0, -self.KNTableView.bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)close{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.coverView.alpha = 0;
        self.KNTableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.menuDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KNCustomFilterPopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNCustomFilterPopCell"];
    cell.titleLabel.text = self.menuDataArray[indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(self.menuDataArray[indexPath.row],indexPath.row+1);
        [self close];
    }
    
}

#pragma mark -- getter
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
        _KNTableView.frame = CGRectMake(0, SCREEN_H - kiPhoneFooterHeight, SCREEN_W, self.menuDataArray.count *45);
        _KNTableView.rowHeight = 45;
        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        _KNTableView.scrollEnabled = NO;
        _KNTableView.bounces = NO;
        _KNTableView.backgroundColor = [UIColor whiteColor];
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNCustomFilterPopCell" bundle:nil] forCellReuseIdentifier:@"KNCustomFilterPopCell"];
    }
    return _KNTableView;
}

- (NSArray *)menuDataArray {
    if (!_menuDataArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"KNCustomFilter" ofType:@"plist"];
        _menuDataArray = [[NSArray alloc] initWithContentsOfFile:path];
    }
    return _menuDataArray;
}

@end
