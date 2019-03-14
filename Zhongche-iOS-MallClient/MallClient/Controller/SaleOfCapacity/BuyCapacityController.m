//
//  BuyCapacityController.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/24.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BuyCapacityController.h"
#import "ContainerCapacityController.h"
#import "LoginViewController.h"
#import "MLNavigationController.h"
#import "ConstructionVC.h"
#import "HotCapacityCell.h"
#import "CapacityViewModel.h"

@interface BuyCapacityController ()<UITableViewDelegate,UITableViewDataSource>
 
@property (nonatomic, strong) UIView          *viUserButton;//按钮界面
//标题2
@property (nonatomic, strong) UITableViewCell *hotContainerVi;
@property (nonatomic, strong) UIButton        *moreHotBtn;
@property (nonatomic, strong) UITableView     *tbv;
@property (nonatomic, strong) NSMutableArray  *dataArray;

@end

@implementation BuyCapacityController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [super navigationSet];
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]};

    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我要运力";
}

-(void)bindView{
    
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.tbv];

    self.moreHotBtn.hidden = YES;
}

-(void)bindModel {
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObject:[NSNull new]];
    WS(ws);
    [[CapacityViewModel new]getRecommendTicketsCallback:^(NSArray *arr) {
        [ws.dataArray removeAllObjects];
        [ws.dataArray addObject:[NSNull new]];
        [ws.dataArray addObjectsFromArray:arr];
        [ws.tbv reloadData];
    }];
}

-(void)bindAction {
    WS(ws);
    UIButton * button;
    for(UIView * view in self.viUserButton.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            button = (UIButton *)view;
            
            [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                
                if ([button.titleLabel.text isEqualToString:@"集装箱"]) {
                    
                    [ws.navigationController pushViewController:[ContainerCapacityController_Container new] animated:YES];
                } else if ([button.titleLabel.text isEqualToString:@"散堆装"]) {

                    [ws.navigationController pushViewController:[ContainerCapacityController_InBulk new] animated:YES];


                } else if ([button.titleLabel.text isEqualToString:@"三农化肥"]) {

                    [ws.navigationController pushViewController:[ContainerCapacityController_Fertilizer new] animated:YES];

                    
                }       else if ([button.titleLabel.text isEqualToString:@"批量成件"]) {

                    [ws.navigationController pushViewController:[ContainerCapacityController_Batch new] animated:YES];

                }else if ([button.titleLabel.text isEqualToString:@"冷链"]) {

                    [ws.navigationController pushViewController:[ContainerCapacityController_ColdChain new] animated:YES];


                } else if ([button.titleLabel.text isEqualToString:@"大件"]) {

                    [ws.navigationController pushViewController:[ContainerCapacityController_Big new] animated:YES];


                }else if ([button.titleLabel.text isEqualToString:@"商品车"]) {

                    [ws.navigationController pushViewController:[ContainerCapacityController_ForCar new] animated:YES];

                }
                else if ([button.titleLabel.text isEqualToString:@"液态"]) {
                    [ws.navigationController pushViewController:[ContainerCapacityController_Liquid new] animated:YES];
                }
                else if ([button.titleLabel.text isEqualToString:@"一带一路"]) {
                    
                    [ws.navigationController pushViewController:[ContainerCapacityController_OneBeltOneRoad new] animated:YES];
                }
            }];
        }
    }
    [[self.moreHotBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        [ws.navigationController pushViewController:[ContainerCapacityController_Container new] animated:YES];
    }];
}

/**
 *  懒加载
 *
 */
- (UIView *)viUserButton {
    if (!_viUserButton) {
        _viUserButton = [UIView new];
        _viUserButton.backgroundColor = [UIColor clearColor];
        NSArray * buttonTitles = @[@"集装箱",@"一带一路",@"散堆装",@"液态",@"三农化肥",@"大件",@"商品车",@"冷链",@""];
        NSArray * buttonImages = @[@"jizhuangxiang",@"yidaiyilu",@"sanduizhuang",@"yetai",@"Group 41",@"dajian",@"che",@"lenglian",@""];
//        NSArray * off_button_titles = @[@"批量成件",@"冷链",@"大件",@"商品车",@"液态",@"一带一路"];
        UIButton * button;
        UIView * line1;
        UIView * line2;
        for (int i = 0; i < buttonTitles.count; i ++)
        {
            
            button = [[UIButton alloc]init];
            button.backgroundColor = APP_COLOR_WHITE;
            [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
            [button setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            [button setTitleColor:APP_COLOR_GRAY3 forState:UIControlStateDisabled];
            [button setImage:[[UIImage imageNamed:[buttonImages[i] adS]] modifyTheImg] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.frame = CGRectMake(i * SCREEN_W / 3 - i / 3 * SCREEN_W, i / 3 * SCREEN_W / 3, SCREEN_W / 3, SCREEN_W / 3);
            [self makeButton:button];
            [_viUserButton addSubview:button];
            
            line1 = [UIView new];
            line1.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
            line1.frame = CGRectMake(SCREEN_W / 3 - 1, 0, 1, SCREEN_W / 3);
            [button addSubview:line1];
            
            line2 = [UIView new];
            line2.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
            line2.frame = CGRectMake(0,0,SCREEN_W / 3,1);
            [button addSubview:line2];
//            if([off_button_titles indexOfObject:buttonTitles[i]] != NSNotFound)
//            {
//                button.enabled = NO;
//            }
        }
    }
    return _viUserButton;
}

-(UITableViewCell *)hotContainerVi {
    if (!_hotContainerVi) {
        UITableViewCell * cell = [UITableViewCell new];
        cell.backgroundColor = APP_COLOR_WHITE;
        
        UIView * line = [UIView new];
        line.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        line.frame = CGRectMake(0, 0, SCREEN_W , 15);
        [cell addSubview:line];
        
        UIImageView * img = [UIImageView new];
        img.frame = CGRectMake(14, 31, 13, 16);
        img.image = [UIImage imageNamed:[@"iconfont-hot copy" adS]];
        [cell addSubview:img];
        
        UILabel * lab = [UILabel new];
        lab.text = @"热门集装箱运力";
        lab.font = [UIFont systemFontOfSize:16.f];
        lab.textColor = APP_COLOR_BLACK_TEXT;
        lab.frame = CGRectMake(34, 33, SCREEN_W - 120, 12);
        [cell addSubview:lab];
        
        self.moreHotBtn.frame = CGRectMake(SCREEN_W - 15 - 40, 34, 40, 12);
        [self makeButton_:self.moreHotBtn];
        [cell addSubview:self.moreHotBtn];
        
        UIView * line1 = [UIView new];
        line1.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        line1.frame = CGRectMake(0, 59,SCREEN_W, 0.5);
        [cell addSubview:line1];
        
        _hotContainerVi = cell;
    }
    return _hotContainerVi;
}

-(UIButton *)moreHotBtn {
    if(!_moreHotBtn)
    {
        UIButton * btn = [UIButton new];
        [btn setImage:[UIImage imageNamed:[@"Back Chevron Copy 2" adS]] forState:UIControlStateNormal];
        [btn setTitle:@"更多" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [btn setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
        _moreHotBtn = btn;
    }
    return _moreHotBtn;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
        [tableView registerClass:[HotCapacityCell class] forCellReuseIdentifier:NSStringFromClass([HotCapacityCell class])];
        _tbv = tableView;
    }
    return _tbv;
}

#pragma mark - Tabview Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSNull class]]) {
        self.hotContainerVi.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.hotContainerVi;
    }
    HotCapacityCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HotCapacityCell class]) forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell loadUIWithmodel:self.dataArray[indexPath.row]];
    return cell;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        self.viUserButton.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_W);
        return self.viUserButton;
    }
    else if(section == 1)
    {
        self.hotContainerVi.frame = CGRectMake(0, 0, SCREEN_W, 60);
        return self.hotContainerVi;
    }
   
    return nil;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count * section;
}
 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if([self.dataArray[indexPath.row] isKindOfClass:[NSNull class]])
    {
        return 60;
    }
    return 77;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    CGFloat height = 0;
    if (section == 0) {
        height = SCREEN_W;
    }
    else if(section == 1)
    {
        height = 0;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section >= 1) {

        if (indexPath.row == 0) {
            return ;
        }
        ContainerCapacityController * vc = [ContainerCapacityController_Container new];
        vc.isFromHot = YES;
        vc.caModel = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)makeButton:(UIButton *)btn {
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height  + 20,-btn.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(- 10.0, 0.0,0.0, -btn.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
    
}

- (void)makeButton_:(UIButton *)btn {
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-btn.imageView.frame.size.width * 2, 0.0,0.0)];//文字距离
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width * 2 - btn.imageView.frame.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

@end
