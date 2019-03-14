//
//  SelectNormalMenuView.m
//  Paggy-Sloth
//
//  Created by 张熔冰 on 2017/12/6.
//  Copyright © 2017年 Lovcreate. All rights reserved.
//

#import "SelectNormalMenuView.h"
#import "UIView+Addition.h"
#import "UIColor+Addition.h"

@interface SelectNormalMenuView()

@property(nonatomic, strong) NSArray* titles;
@property(nonatomic, assign) NSInteger curIndex;//当前选择的按钮索引
@property(nonatomic, strong) UIButton* curButton;
@property(nonatomic, strong) UIView* silderView;
@property(nonatomic, strong) UILabel * label;

@end

@implementation SelectNormalMenuView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 44.f);
    }
    return self;
}

+(instancetype)viewForFrame:(CGRect)frame titles:(NSArray*)titles index:(NSInteger)index{
    SelectNormalMenuView* view = [[SelectNormalMenuView alloc] initWithFrame:frame];
    view.curIndex = index;
    view.titles = titles;
    return view;
}

-(void)setTitles:(NSArray *)titles selectedBlock:(void (^)(NSInteger))selectedBlock{
    [self setTitles:titles];
    self.selectBlock = selectedBlock;
    self.curIndex = 0;
}

-(void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    NSInteger count = titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(i*self.lc_w/count, 0, self.lc_w/count, self.lc_h)];
        
        if (i == 1) {
           self.label = [[UILabel alloc]initWithFrame:CGRectMake(button.lc_r-35, 5,8,8)];
            [self.label lc_setCornerRadius:4];
            self.label.backgroundColor = [UIColor clearColor];
            [self addSubview:self.label];
        }
        
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        if (self.textColor) {
            [button setTitleColor:self.textColor forState:UIControlStateNormal];
        }
        if (self.selectedTextColor) {
            [button setTitleColor:self.selectedTextColor forState:UIControlStateSelected];
        }
        [button addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i == self.curIndex) {
            [button setSelected:YES];
            self.curButton = button;
            self.silderView.lc_center = CGPointMake(self.curButton.lc_center.x, self.lc_h - 3);
            [self addSubview:self.silderView];
        }
    }
}

-(void)moveToIndex:(NSInteger)curIndex{
    self.userInteractionEnabled = NO;
    //控制滑块
    [UIView animateWithDuration:.3 animations:^{
        self.silderView.lc_center = CGPointMake(self.curButton.lc_center.x, self.lc_h - 3);
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}

-(UIView*)silderView{
    if (!_silderView) {
        _silderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 2)];
        _silderView.backgroundColor = self.sliderColor?self.sliderColor:RGBA(0x0D70D8, 1);
    }
    return _silderView;
}


-(void)refreshRedStaus:(ShowType)showType
{
    if (showType == ShowRed) {
        self.label.backgroundColor = [UIColor redColor];
    }else{
        self.label.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark - Action
//点击按钮
-(void)pressButton:(UIButton*)button{
    if (self.curButton == button) {
        return;
    }
    [button setSelected:YES];
    [self.curButton setSelected:NO];
    
    self.curButton = button;
    self.curIndex = button.tag;
    [self moveToIndex:self.curIndex];
    if (self.selectBlock) {
        self.selectBlock(self.curIndex);
    }
}
@end
