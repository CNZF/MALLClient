//
//  MessageViewController.m
//  MallClient
//
//  Created by lxy on 2018/6/22.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "MessageViewController.h"
#import "SelectNormalMenuView.h"
#import "AllDataSource.h"
#import "NoReadDataSource.h"
#import "ReadDataSource.h"
#import <UIScrollView+MJRefresh.h>
#import "NoDataView.h"
#import "SendNoDataView.h"
#import "MessageModel.h"
#import "HasOrderCell.h"
#import "MLNavigationController.h"
#import "MessageBottomView.h"
#import "MessageViewModel.h"

#define PageMax 20
#define deleMax 100
#define RGBA(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/255.0    \
green:((c>>8)&0xFF)/255.0    \
blue:(c&0xFF)/255.0         \
alpha:a]

@interface MessageViewController ()<UITableViewDelegate>
//视图
@property (nonatomic, strong) SelectNormalMenuView * menuView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) SendNoDataView * noDataView;
@property (nonatomic, strong) MessageBottomView * selectBottomView;
//数据
@property (nonatomic, strong) AllDataSource * allDataSource;
@property (nonatomic, strong) NoReadDataSource * noReadDataSource;
@property (nonatomic, strong) ReadDataSource * readDataSource;
@property (nonatomic, strong) NSMutableArray * delectArray;
//变量
@property (nonatomic, assign) NSInteger index;
@property (strong, nonatomic) NSIndexPath* editingIndexPath;  //当前左滑cell的index，在代理方法中设置
@property (nonatomic, assign) int curPage;
@property (nonatomic, assign) BOOL isAllSelect;

//刷新
@property (nonatomic, strong) MJRefreshNormalHeader * mj_header;
@property (nonatomic, strong) MJRefreshBackNormalFooter * mj_footer;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.index = 0;
    self.curPage = 0;
    self.editing = NO;
    self.btnRight.hidden = NO;
    [self.btnRight setTitle:@"选择" forState:UIControlStateNormal];
    [self configureMenuView];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource  = self.allDataSource;
    [self setTableViewRefreash];
}


#warning 非常坑的一点，导航栏的左滑手势拦截了tableViewCell的滑动删除手势
- (void)viewWillAppear:(BOOL)animated
{
    MLNavigationController * navi = (MLNavigationController *)self.navigationController;
    [navi removePanGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    MLNavigationController * navi = (MLNavigationController *)self.navigationController;
    [navi addPanGestureRecognizer];
}


#pragma mark  -- Cell删除

#pragma mark - viewDidLayoutSubviews
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if (self.editingIndexPath){
       [self configSwipeButtons];
    }
}
#pragma mark - configSwipeButtons
- (void)configSwipeButtons{
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *)){
        
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews)
        {
            NSLog(@"%@-----%zd",subview,subview.subviews.count);
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 1)
            {
                // 和iOS 10的按钮顺序相反
                UIButton *deleteButton = subview.subviews[0];
                [self configDeleteButton:deleteButton];
            }
        }
    }
    else{
        // iOS 8-10层级 (Xcode 8编译): UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        HasOrderCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews){
            NSLog(@"subview%@-----%zd",subview,subview.subviews.count);
            
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 1)
            {
                UIButton *deleteButton = subview.subviews[0];
                [self configDeleteButton:deleteButton];
            }
        }
    }
}
- (void)configDeleteButton:(UIButton*)deleteButton{
    if (deleteButton) {
        [deleteButton setImage:[UIImage imageNamed:@"delegateBtn"] forState:UIControlStateNormal];
        
        double systemVersion = [UIDevice currentDevice].systemVersion.floatValue;

        if (systemVersion >= 10.0) {

        } else {
           deleteButton.imageView.center = deleteButton.center;
        }
        [deleteButton setBackgroundColor:APP_COLOR_DeleteBtnBack];
    }
}

- (void)onRightAction
{
    if ([self.btnRight.titleLabel.text isEqualToString:@"选择"]) {
    
        [self.btnRight setTitle:@"取消" forState:UIControlStateNormal];
         self.tableView.frame = CGRectMake(0, 44, SCREEN_W, SCREEN_H-kNavBarHeaderHeight-kiPhoneFooterHeight -44- 55);
        if (self.delectArray) {
            [self.delectArray removeAllObjects];
        }else
        {
            self.delectArray  = [NSMutableArray arrayWithCapacity:0];
        }
        [self.delectArray removeAllObjects];
        if (self.index == 0) {
            self.allDataSource.isEdite = YES;
             self.selectBottomView.readBtn.hidden  = YES;
            self.allDataSource.deleteArray  = self.delectArray;
            for (MessageModel * model in _allDataSource.dataArray) {
                model.isEdite = YES;
                model.isSelect = NO;
                
            }
        }else if (self.index == 1){
            self.selectBottomView.readBtn.hidden  = NO;
            self.noReadDataSource.isEdite = YES;
            for (MessageModel * model in _noReadDataSource.dataArray) {
                model.isEdite = YES;
                model.isSelect = NO;
                
            }
        }else{
            self.readDataSource.isEdite = YES;
            self.selectBottomView.readBtn.hidden  = YES;
            for (MessageModel * model in _readDataSource.dataArray) {
                model.isEdite = YES;
                model.isSelect = NO;
                
            }
        }
        
        [self.view addSubview:self.selectBottomView];
    }else{

        [self.btnRight setTitle:@"选择" forState:UIControlStateNormal];
         self.tableView.frame = CGRectMake(0, 44, SCREEN_W, SCREEN_H-kNavBarHeaderHeight-kiPhoneFooterHeight -44);
        
        if (self.index == 0) {
            self.allDataSource.isEdite = NO;
            for (MessageModel * model in _allDataSource.dataArray) {
                model.isEdite = NO;
               
            }
        }else if (self.index == 1){
            self.noReadDataSource.isEdite = NO;
            for (MessageModel * model in _noReadDataSource.dataArray) {
                model.isEdite = NO;
              
            }
        }else{
            self.readDataSource.isEdite = NO;
            for (MessageModel * model in _readDataSource.dataArray) {
                model.isEdite = NO;
                
            }
        }
        
        [self.selectBottomView removeFromSuperview];
        self.selectBottomView = nil;
    }
    
    [self.tableView reloadData];
}

- (void)verbBtnTitleAndBottomViewStatus{
    [self.btnRight setTitle:@"选择" forState:UIControlStateNormal];
    [self.selectBottomView removeFromSuperview];
    if (self.index == 0) {
        for (MessageModel * model in self.allDataSource.dataArray) {
            model.isEdite = NO;
        }
    }else if (self.index == 1){
        for (MessageModel * model in self.noReadDataSource.dataArray) {
            model.isEdite = NO;
        }
    }else{
        for (MessageModel * model in self.readDataSource.dataArray) {
            model.isEdite = NO;
        }
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 点击CEll及多选删除
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WS(weakSelf);
    MessageModel * model;
    if (self.index == 0) {
        model = self.allDataSource.dataArray[indexPath.section];
        //            [self.allDataSource.dataArray removeObjectAtIndex:indexPath.section];
    }else if(self.index == 1){
        model = self.noReadDataSource.dataArray[indexPath.section];
        //            [self.noReadDataSource.dataArray removeObjectAtIndex:indexPath.section];
    }else{
        model = self.readDataSource.dataArray[indexPath.section];
        //            [self.readDataSource.dataArray removeObjectAtIndex:indexPath.section];
    }
    
    
    
    if (_allDataSource.isEdite || _noReadDataSource.isEdite ||_readDataSource.isEdite) {
        
        if (!model.isSelect) {
            if (self.delectArray.count>=deleMax) {
                [[Toast shareToast] makeText:@"单次删除上限100条" aDuration:1];
                return;
            }
            [self.delectArray addObject:model];
        }else{
            [self.delectArray removeObject:model];
        }
        model.isSelect = !model.isSelect;
        [self.tableView reloadData];
    }else{
        if (self.index == 1) {
            [[MessageViewModel new] detailWithMessageStatus:1 MessageArray:@[model.ID] callback:^(BOOL result) {
                if (result) {
                    [weakSelf.noReadDataSource.dataArray removeObjectAtIndex:indexPath.section];
                    if (weakSelf.noReadDataSource.dataArray.count == 0) {
                        [weakSelf.menuView refreshRedStaus:SHowClear];
                    }
                    [weakSelf.tableView reloadData];
                }
            }];
        }
    }
   
}

#pragma mark --TableViewDelegate

//多选状态下无法左滑删除
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.btnRight.titleLabel.text isEqualToString:@"选择"])
        return UITableViewCellEditingStyleDelete;
    else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];   // 触发-(void)viewDidLayoutSubviews
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.editingIndexPath = nil;
}

#pragma mark -- 左滑删除
- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    //title不设为nil 而是空字符串 理由为啥 ？   自己实践 跑到ios11以下的机器上就知道为啥了
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"        " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        [tableView setEditing:NO animated:YES];  // 这句很重要，退出编辑模式，隐藏左滑菜单
        MessageModel * model;
        if (self.index == 0) {
            model = self.allDataSource.dataArray[indexPath.section];
//            [self.allDataSource.dataArray removeObjectAtIndex:indexPath.section];
        }else if(self.index == 1){
            model = self.noReadDataSource.dataArray[indexPath.section];
//            [self.noReadDataSource.dataArray removeObjectAtIndex:indexPath.section];
        }else{
            model = self.readDataSource.dataArray[indexPath.section];
//            [self.readDataSource.dataArray removeObjectAtIndex:indexPath.section];
        }
        
        [[MessageViewModel new] detailWithMessageStatus:-1 MessageArray:@[model.ID] callback:^(BOOL result) {
            
            if (result) {
                if ([self.delectArray containsObject:model]) {
                    [self.delectArray removeObject:model];
                }
                if (self.index == 0) {
                    
                    [self.allDataSource.dataArray removeObjectAtIndex:indexPath.section];
                }else if(self.index == 1){
                  
                    [self.noReadDataSource.dataArray removeObjectAtIndex:indexPath.section];
                }else{
                    [self.readDataSource.dataArray removeObjectAtIndex:indexPath.section];
                }
            }
            [[Toast shareToast] makeText:@"删除成功" aDuration:1];
            [self.tableView reloadData];
        }];
        
    }];
    return @[deleteAction];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 15)];
    headView.backgroundColor = RGBA(0xF5F5F5, 1);
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((self.index == 0 && _allDataSource.dataArray.count == 0 ) || (self.index == 1 && _noReadDataSource.dataArray.count == 0)|| (self.index == 2 && _readDataSource.dataArray.count == 0)) {
        return CGFLOAT_MIN;
    }else{
        return 15;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ((self.index == 0 && _allDataSource.dataArray.count == 0 ) || (self.index == 1 && _noReadDataSource.dataArray.count == 0)|| (self.index == 2 && _readDataSource.dataArray.count == 0)) {
        return self.noDataView;
    }else{
        return  [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((self.index == 0 && _allDataSource.dataArray.count == 0) || (self.index == 1 && _noReadDataSource.dataArray.count == 0)|| (self.index == 2 && _readDataSource.dataArray.count == 0)) {
        return SCREEN_H-kNavBarHeaderHeight - kiPhoneFooterHeight-44;
    }else{
        return CGFLOAT_MIN;
    }
}

#pragma mark - Public
//刷新组件
- (void)setTableViewRefreash
{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.curPage = 0;
        [self.delectArray removeAllObjects];
        [self.selectBottomView setSelectBtnState];
        if (self.index == 0) {
            _allDataSource.curPage = 1;
            _allDataSource.isAllSelect = NO;
            [_allDataSource asyncWithMessageAllstatus:-1 curPage:_allDataSource.curPage pageSize:PageMax];
        }else if (self.index == 1){
            _noReadDataSource.curPage = 1;
            _noReadDataSource.isAllSelect = NO;
            [_noReadDataSource asyncWithMessageAllstatus:0 curPage:_noReadDataSource.curPage pageSize:PageMax];;
            if (self.noReadDataSource.dataArray.count>0) {
                [self.menuView refreshRedStaus:ShowRed];
            }
        }else{
            _readDataSource.curPage = 1;
            _readDataSource.isAllSelect = NO;
            [_readDataSource asyncWithMessageAllstatus:1 curPage:_readDataSource.curPage pageSize:PageMax];;
        }
        [self.tableView.mj_header endRefreshing];
        
    }];
    
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if (self.index == 0) {
            _allDataSource.curPage ++;
            [_allDataSource asyncWithMessageAllstatus:-1 curPage:_allDataSource.curPage pageSize:PageMax];
        }else if (self.index == 1){
            _noReadDataSource.curPage++;
            [_noReadDataSource asyncWithMessageAllstatus:0 curPage:_noReadDataSource.curPage pageSize:PageMax];;
            if (self.noReadDataSource.dataArray.count>0) {
                [self.menuView refreshRedStaus:ShowRed];
            }
        }else{
             _readDataSource.curPage ++;
            [_readDataSource asyncWithMessageAllstatus:1 curPage:_readDataSource.curPage pageSize:PageMax];;
        }
        [self.tableView.mj_footer endRefreshing];
    }];
    
    self.tableView.mj_header = self.mj_header;
    self.tableView.mj_footer = self.mj_footer;
    
    [self.tableView.mj_header beginRefreshing];
}

//配置菜单
-(void)configureMenuView{
    self.menuView = [[SelectNormalMenuView alloc] initWithFrame:CGRectMake(0,0, SCREEN_W, 44)];
    self.menuView.textColor = RGBA(0x333333, 1);
    self.menuView.selectedTextColor = RGBA(0x329AF0, 1);
    self.menuView.sliderColor = RGBA(0x329AF0, 1);
    WS(weakSelf);
    [self.menuView setTitles:@[@"全部", @"未读消息",@"已读消息"] selectedBlock:^(NSInteger index) {
        weakSelf.index = index;
        weakSelf.tableView.frame = CGRectMake(0, 44, SCREEN_W, SCREEN_H-kNavBarHeaderHeight-kiPhoneFooterHeight -44);
        //清除多选状态
        [weakSelf verbBtnTitleAndBottomViewStatus];
        if (index == 0) {
            weakSelf.tableView.dataSource = weakSelf.allDataSource;
            weakSelf.allDataSource.isAllSelect = NO;
            weakSelf.noReadDataSource.isEdite = NO;
            weakSelf.readDataSource.isEdite = NO;
            if (weakSelf.allDataSource.dataArray.count>0) {
                weakSelf.btnRight.hidden = NO;
            }else{
                weakSelf.btnRight.hidden = YES;
            }
        }else if (index == 1){
            weakSelf.tableView.dataSource = weakSelf.noReadDataSource;
            weakSelf.noReadDataSource.isAllSelect = NO;
            weakSelf.allDataSource.isEdite = NO;
            weakSelf.readDataSource.isEdite = NO;
            if (!weakSelf.noReadDataSource.hasRefresh) {
                weakSelf.noReadDataSource.hasRefresh = YES;
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            if (weakSelf.noReadDataSource.dataArray.count>0) {
                weakSelf.btnRight.hidden = NO;
            }else{
                weakSelf.btnRight.hidden = YES;
            }
        }else{
            weakSelf.tableView.dataSource = weakSelf.readDataSource;
            weakSelf.readDataSource.isAllSelect = NO;
            weakSelf.allDataSource.isEdite = NO;
            weakSelf.noReadDataSource.isEdite = NO;
            if (!weakSelf.readDataSource.hasRefresh) {
                weakSelf.readDataSource.hasRefresh = YES;
                [weakSelf.tableView.mj_header beginRefreshing];
            }
            if (weakSelf.readDataSource.dataArray.count>0) {
                weakSelf.btnRight.hidden = NO;
            }else{
                weakSelf.btnRight.hidden = YES;
            }
        }
        //点击线清楚所有数据之前选中的状态
        if (index!=0) {
            for (MessageModel * model in weakSelf.allDataSource.dataArray) {
                model.isSelect = NO;
            }
        }
        [weakSelf.tableView reloadData];
    }];
    
    [self.view addSubview:self.menuView];
}

- (AllDataSource *)allDataSource
{
    WS(weakSelf);
    if (!_allDataSource) {
        _allDataSource = [[AllDataSource alloc]initWithTarget:self tableView:self.tableView];
        _allDataSource.hasRefresh = YES;
        _allDataSource.isAllSelect = weakSelf.isAllSelect;
        [_allDataSource setAllDataBlcok:^(NSArray *AllDataArray) {
            
            
            //红标判断
            if (AllDataArray.count == 0) {
                [weakSelf.menuView refreshRedStaus:SHowClear];
                 weakSelf.btnRight.hidden = YES;
            }else{
                 weakSelf.btnRight.hidden = NO;
                for (MessageModel * model in AllDataArray) {///红标判断
                    if ([model.readStatus intValue] == 0) {
                        [weakSelf.menuView refreshRedStaus:ShowRed];
                        break;
                    }else{
                        
                    }
                }
            }
            
            //多余100条数据处理
            int seletNum = 0;
            for (int i = 0; i<AllDataArray.count; i++) {
                MessageModel * model = AllDataArray[i];
                if (model.isSelect) {
                    seletNum++;
                    if (seletNum >deleMax) {
                        model.isSelect = NO;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }];
        [_allDataSource setCurttenPageDataBlcok:^(NSArray *curttenArray) {
            if (weakSelf.isAllSelect) {
                [weakSelf.delectArray addObjectsFromArray:curttenArray];
                if (weakSelf.delectArray.count>=deleMax) {
                    
                    [weakSelf.delectArray removeObjectsInRange:NSMakeRange(deleMax, weakSelf.delectArray.count-deleMax)];
                    [[Toast shareToast] makeText:@"单次操作上限100条" aDuration:1];

                }else{
                    
                }
            }
        
        }];
    }
    return _allDataSource;
}

- (NoReadDataSource *)noReadDataSource
{
    WS(weakSelf);
    if (!_noReadDataSource) {
        _noReadDataSource = [[NoReadDataSource alloc]initWithTarget:self tableView:self.tableView];
        _noReadDataSource.isAllSelect = weakSelf.isAllSelect;
        [_noReadDataSource setNoReadDataBlock:^(NSArray *NoReadDataArray) {
            if (NoReadDataArray.count == 0) {
                [weakSelf.menuView refreshRedStaus:SHowClear];
                weakSelf.btnRight.hidden = YES;
            }else{
                [weakSelf.menuView refreshRedStaus:ShowRed];
                weakSelf.btnRight.hidden = NO;
            }
            
            //多余100条数据处理
            int seletNum = 0;
            for (int i = 0; i < NoReadDataArray.count; i++) {
                MessageModel * model = NoReadDataArray[i];
                if (model.isSelect) {
                    seletNum++;
                    if (seletNum >deleMax) {
                        model.isSelect = NO;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }];
        [_noReadDataSource setCurttenPageDataBlcok:^(NSArray *curttenArray) {
            if (weakSelf.isAllSelect) {
                [weakSelf.delectArray addObjectsFromArray:curttenArray];
                if (weakSelf.delectArray.count>=deleMax) {
                    
                    [weakSelf.delectArray removeObjectsInRange:NSMakeRange(deleMax, weakSelf.delectArray.count-deleMax)];
                    [[Toast shareToast] makeText:@"单次操作上限100条" aDuration:1];
                    
                }else{
                    
                }
            }
            
        }];
    }
    return _noReadDataSource;
}

- (ReadDataSource *)readDataSource
{
    WS(weakSelf);
    if (!_readDataSource) {
        _readDataSource = [[ReadDataSource alloc]initWithTarget:self tableView:self.tableView];
        _readDataSource.isAllSelect = weakSelf.isAllSelect;
        [_readDataSource setReadDataBlock:^(NSArray *ReadDataArray) {
            if (ReadDataArray.count == 0) {
                weakSelf.btnRight.hidden = YES;
            }else{
                weakSelf.btnRight.hidden = NO;
            }
            
            //多余100条数据处理
            int seletNum = 0;
            for (int i = 0; i<ReadDataArray.count; i++) {
                MessageModel * model = ReadDataArray[i];
                if (model.isSelect) {
                    seletNum++;
                    if (seletNum >deleMax) {
                        model.isSelect = NO;
                    }
                }
            }
            [weakSelf.tableView reloadData];
            
        }];
        [_readDataSource setCurttenPageDataBlcok:^(NSArray *curttenArray) {
            if (weakSelf.isAllSelect) {
                [weakSelf.delectArray addObjectsFromArray:curttenArray];
                if (weakSelf.delectArray.count>=deleMax) {
                    
                    [weakSelf.delectArray removeObjectsInRange:NSMakeRange(deleMax, weakSelf.delectArray.count-deleMax)];
                    [[Toast shareToast] makeText:@"单次操作上限100条" aDuration:1];
                    
                }else{
                    
                }
            }
            
        }];
    }
    return _readDataSource;
}

- (SendNoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SendNoDataView class]) owner:self options:nil] firstObject];
        _noDataView.frame = CGRectMake(0, 44, SCREEN_W, SCREEN_H-kNavBarHeaderHeight - kiPhoneFooterHeight-44);
        _noDataView.noLabel.text = @"暂无消息";
    }
    return _noDataView;
}

- (MessageBottomView *)selectBottomView
{
    WS(weakSelf);
    if (!_selectBottomView) {
        _selectBottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MessageBottomView class]) owner:self options:nil] firstObject];
        _selectBottomView.frame = CGRectMake(0, SCREEN_H-kiPhoneFooterHeight- kNavBarHeaderHeight- 55, SCREEN_W, 55);
        //全选事件
        [_selectBottomView setBlock:^(BOOL ret) {
            weakSelf.isAllSelect = ret;
            if (!ret) {
                [weakSelf.delectArray removeAllObjects];
            }
            
            if (weakSelf.index == 0) {
                weakSelf.allDataSource.isAllSelect = ret;
                for (MessageModel * model in weakSelf.allDataSource.dataArray) {
                    model.isSelect = ret;
                    if (ret) {
                        [weakSelf.delectArray addObject:model];
                    }else{
                        [weakSelf.delectArray removeAllObjects];
                    }
                }
               
            }else if (weakSelf.index ==1){
                weakSelf.noReadDataSource.isAllSelect = ret;
                for (MessageModel * model in weakSelf.noReadDataSource.dataArray) {
                    model.isSelect = ret;
                    if (ret) {
                        [weakSelf.delectArray addObject:model];
                    }else{
                        [weakSelf.delectArray removeAllObjects];
                    }
                }
               
            }else{
                weakSelf.readDataSource.isAllSelect = ret;
                for (MessageModel * model in weakSelf.readDataSource.dataArray) {
                    model.isSelect = ret;
                    if (ret) {
                        [weakSelf.delectArray addObject:model];
                    }else{
                        [weakSelf.delectArray removeAllObjects];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }];
        //全选删除事件
//        [_selectBottomView setDeleteBlock:^{
//            if (weakSelf.delectArray.count == 0) {
//                [[Toast shareToast] makeText:@"请选择要删除的信息" aDuration:1];
//            }else{
//                NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
//                for (MessageModel * model in weakSelf.delectArray) {
//                    [tempArray addObject:model.ID];
//                }
//                
//                [[MessageViewModel new] detailWithMessageStatus:-1 MessageArray:tempArray callback:^(BOOL result) {
//                    if (result) {
//
//                        if (weakSelf.index == 0) {
//
//                            [weakSelf.allDataSource.dataArray removeObjectsInArray:weakSelf.delectArray];
//                        }else if(weakSelf.index == 1){
//                            [weakSelf.noReadDataSource.dataArray removeObjectsInArray:weakSelf.delectArray];
//
//                        }else{
//                           [weakSelf.readDataSource.dataArray removeObjectsInArray:weakSelf.delectArray];
//                        }
//
//                        [[Toast shareToast] makeText:@"删除成功" aDuration:1];
//                        [weakSelf.tableView reloadData];
//                    }
//                }];
//            }
//
//        }];
        
        [_selectBottomView setDeleteBlock:^(NSString *state) {
            if (weakSelf.delectArray.count == 0) {
                [[Toast shareToast] makeText:@"请选择消息" aDuration:1];
            }else{
                NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
                for (MessageModel * model in weakSelf.delectArray) {
                    [tempArray addObject:model.ID];
                }
                int status;
                if ([state isEqualToString:@"delete"]) {
                    status = -1;
                }else{
                    status = 1;
                }
                [[MessageViewModel new] detailWithMessageStatus:status MessageArray:tempArray callback:^(BOOL result) {
                    if (result) {
                        
                        if (weakSelf.index == 0) {
                            
                            [weakSelf.allDataSource.dataArray removeObjectsInArray:weakSelf.delectArray];
                        }else if(weakSelf.index == 1){
                            [weakSelf.noReadDataSource.dataArray removeObjectsInArray:weakSelf.delectArray];
                            
                        }else{
                            [weakSelf.readDataSource.dataArray removeObjectsInArray:weakSelf.delectArray];
                        }
                        if (status == 1) {
                             [[Toast shareToast] makeText:@"已标记为已读" aDuration:1];
                        }else{
                             [[Toast shareToast] makeText:@"删除成功" aDuration:1];
                        }
                        [weakSelf.tableView reloadData];
                        
                        [weakSelf.btnRight setTitle:@"选择" forState:UIControlStateNormal];
                        weakSelf.isAllSelect = NO;
                        weakSelf.tableView.frame = CGRectMake(0, 44, SCREEN_W, SCREEN_H-kNavBarHeaderHeight-kiPhoneFooterHeight -44);
                        
                        if (weakSelf.index == 0) {
                            weakSelf.allDataSource.isEdite = NO;
                            weakSelf.allDataSource.isAllSelect = NO;
                           
                            for (MessageModel * model in weakSelf.allDataSource.dataArray) {
                                model.isEdite = NO;
                                
                            }
                        }else if (weakSelf.index == 1){
                            weakSelf.noReadDataSource.isEdite = NO;
                            weakSelf.noReadDataSource.isAllSelect = NO;
                          
                            for (MessageModel * model in weakSelf.noReadDataSource.dataArray) {
                                model.isEdite = NO;
                                
                            }
                        }else{
                            weakSelf.readDataSource.isEdite = NO;
                            weakSelf.readDataSource.isAllSelect = NO;
                            for (MessageModel * model in weakSelf.readDataSource.dataArray) {
                                model.isEdite = NO;
                                
                            }
                        }
                        
                        [weakSelf.selectBottomView removeFromSuperview];
                        weakSelf.selectBottomView = nil;
                        if (weakSelf.index == 0) {
                            weakSelf.allDataSource.curPage = 1;
                            weakSelf.allDataSource.isAllSelect = NO;
                            [weakSelf.allDataSource asyncWithMessageAllstatus:-1 curPage:weakSelf.allDataSource.curPage pageSize:PageMax];
                        }else if (weakSelf.index == 1){
                            weakSelf.noReadDataSource.curPage = 1;
                            weakSelf.noReadDataSource.isAllSelect = NO;
                            [weakSelf.noReadDataSource asyncWithMessageAllstatus:0 curPage:weakSelf.noReadDataSource.curPage pageSize:PageMax];;
                            if (weakSelf.noReadDataSource.dataArray.count>0) {
                                [weakSelf.menuView refreshRedStaus:ShowRed];
                            }
                        }else{
                            weakSelf.readDataSource.curPage = 1;
                            weakSelf.readDataSource.isAllSelect = NO;
                            [weakSelf.readDataSource asyncWithMessageAllstatus:1 curPage:weakSelf.readDataSource.curPage pageSize:PageMax];;
                        }
                        
                    }
                }];
                
            }
            
        }];
    }
    return _selectBottomView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_W, SCREEN_H-kNavBarHeaderHeight-kiPhoneFooterHeight -44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100.0f;
    }
    return _tableView;
}

@end

