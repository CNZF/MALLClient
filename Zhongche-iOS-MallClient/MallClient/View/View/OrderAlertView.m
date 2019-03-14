//
//  OrderAlertView.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/4/10.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "OrderAlertView.h"
#import "OrderAlertViCell.h"
#import "AppDelegate.h"

@interface OrderAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign)NSInteger entryNum;

@property (nonatomic, strong)UIView * bgVi;
@property (nonatomic, strong)UILabel * titleLab;
@property (nonatomic, strong)UIButton * titlebtn;
@property (nonatomic, strong)UIView * lineVi;
@property (nonatomic, strong)UILabel * lastLab;

@property (nonatomic, strong)UITableView * tbv;
@property (nonatomic, strong)NSMutableArray * dataArray;
@end

@implementation OrderAlertView

-(void)show {
    AppDelegate * app = (AppDelegate *)([UIApplication sharedApplication].delegate);
    [app.window addSubview:self];
}

-(void)dismiss {
    [self removeFromSuperview];
}
-(instancetype)initWithTitle:(NSString *)title entryArray:(NSArray<NSString *>*)entry annotation:(id)annotation
           cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)buttonTitle{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        
        NSInteger entryNum;
        entryNum = entry.count;
        if (entryNum > 5) {
            entryNum = 5;
        }
        
        self.bgVi.frame = CGRectMake(0, 0, SCREEN_W - 60, 126 + entryNum * 44);
        self.bgVi.center = CGPointMake(SCREEN_W / 2, SCREEN_H / 2);
        [self addSubview:self.bgVi];
        
        self.titleLab.frame = CGRectMake(0, 0, self.bgVi.width, 44);
        self.titleLab.text = title;
        [self.bgVi addSubview:self.titleLab];
        
        self.lineVi.frame = CGRectMake(0, 44, self.bgVi.width, 8);
        [self.bgVi addSubview:self.lineVi];
        
        self.tbv.frame = CGRectMake(0, self.lineVi.bottom, self.bgVi.width, 44 * entryNum);
        [self.bgVi addSubview:self.tbv];
        
        self.lastLab.frame = CGRectMake(0, self.tbv.bottom, self.bgVi.width + 3, 33);
        self.lastLab.text = [NSString stringWithFormat:@"%@     .",annotation];
        [self.bgVi addSubview:self.lastLab];
        
        self.titlebtn.frame = CGRectMake(0, self.lastLab.bottom, self.bgVi.width, 44);
        [self.titlebtn setTitle:buttonTitle forState:UIControlStateNormal];
        [self.titlebtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self.bgVi addSubview:self.titlebtn];
        [self.dataArray addObjectsFromArray:entry];
        [self.tbv reloadData];
    }
    return self;
}

-(UIView *)bgVi {
    if (!_bgVi) {
        UIView * vi= [UIView new];
        vi.backgroundColor = APP_COLOR_WHITE;
        [vi.layer setMasksToBounds:YES];
        vi.layer.cornerRadius = 8.0;
        _bgVi = vi;
    }
    return _bgVi;
}

-(UILabel *)titleLab {
    if (!_titleLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.textAlignment = NSTextAlignmentCenter;
        _titleLab = lab;
    }
    return _titleLab;
}

-(UIButton *)titlebtn {
    if (!_titlebtn) {
        UIButton * btn = [UIButton new];
        [btn setTitle:@"确 认" forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateNormal];
        _titlebtn = btn;
    }
    return _titlebtn;
}


-(UIView *)lineVi {
    if (!_lineVi) {
        UIView * vi= [UIView new];
        vi.backgroundColor = APP_COLOR_WHITEBG;
        _lineVi = vi;
    }
    return _lineVi;
}
-(UILabel *)lastLab {
    if (!_lastLab) {
        UILabel * lab = [UILabel new];
        lab.font = [UIFont systemFontOfSize:10.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.textAlignment = NSTextAlignmentRight;
        lab.backgroundColor = APP_COLOR_WHITEBG;
        _lastLab = lab;
    }
    return _lastLab;
}

- (UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[OrderAlertViCell class] forCellReuseIdentifier:NSStringFromClass([OrderAlertViCell class])];
        _tbv = tableView;
    }
    return _tbv;
}
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderAlertViCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderAlertViCell class]) forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.textColor = APP_COLOR_GRAY666;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

@end
