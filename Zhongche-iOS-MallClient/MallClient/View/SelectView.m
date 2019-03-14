//
//  SelectView.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "SelectView.h"
#import "AppDelegate.h"

@interface SelectView()

@property (nonatomic, copy)void(^callback)(NSString *);

@end

@implementation SelectView

+(SelectView *)addSelectViewWithEntrys:(NSArray *)entrys WithSelectEntry:(NSString *)entry WithCallback:(void (^)(NSString *))callback
{
    SelectView* view = [SelectView new];
    view.callback = callback;
    UIButton * button;
    UIView * line;
    for (int i = 0;  i < entrys.count; i ++)
    {
        button = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_H - 57 -(entrys.count - i) * 50, SCREEN_W, 50)];
        [button setTitle:entrys[i] forState:UIControlStateNormal];
        [button setTitle:[NSString stringWithFormat:@"%@  (已选)",entrys[i]] forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        
        [button setTitleColor:APP_COLOR_GRAY_SEARCH_TEXT forState:UIControlStateNormal];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateSelected];
        [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateHighlighted];
        
        [button setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_WHITE andSize:CGSizeMake(SCREEN_W, 50)] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_WHITE_BG andSize:CGSizeMake(SCREEN_W, 50)] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_WHITE_BG andSize:CGSizeMake(SCREEN_W, 50)] forState:UIControlStateHighlighted];
        [button addTarget:view action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if([entrys[i] isEqualToString:entry])
        {
            button.selected = YES;
        }
        [view addSubview:button];
        
        line = [[UIView alloc]initWithFrame:CGRectMake(0, button.height - 1, SCREEN_W, 1)];
        line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        [button addSubview:line];
    }
    [((AppDelegate*)[[UIApplication sharedApplication] delegate]).window addSubview:view];
    
    return view;
}
-(void)buttonClick:(UIButton *)button
{
    button.selected = YES;
    self.callback(button.titleLabel.text);
    [self removeFromSuperview];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
        [self creatView];
    }
    return self;
}

- (void)creatView
{
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self addSubview:effe];
    
    UIView * view = [UIView new];
    view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    view.frame = CGRectMake(0, SCREEN_H - 57, SCREEN_W, 7);
    [self addSubview:view];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_H - 50, SCREEN_W, 50)];
    [button setTitle:@"取消" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    
    [button setTitleColor:APP_COLOR_GRAY_SEARCH_TEXT forState:UIControlStateNormal];
    [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateSelected];
    [button setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateHighlighted];
    
    [button setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_WHITE andSize:CGSizeMake(SCREEN_W, 50)] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_WHITE_BG andSize:CGSizeMake(SCREEN_W, 50)] forState:UIControlStateSelected];
    [button setBackgroundImage:[UIImage getImageWithColor:APP_COLOR_WHITE_BG andSize:CGSizeMake(SCREEN_W, 50)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}
@end
