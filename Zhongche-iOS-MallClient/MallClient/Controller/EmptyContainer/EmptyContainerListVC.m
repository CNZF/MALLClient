//
//  EmptyContainerListVC.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2016/12/29.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "EmptyContainerListVC.h"
#import "EmptyContainerListCell.h"
#import "ConditionsForRetrievalVC.h"
#import "FilterModel.h"
#import "EmptyContainerViewModel.h"
#import "GoodsDetailVC.h"

typedef enum
{
    disorderly = 16,//无序
    ascending,//升序
    descending,//降序
}availableNumBtnTagForType;

@interface EmptyContainerListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,ConditionsForRetrievalVCDelegate>

@property (nonatomic, strong) UIButton         * availableNumBtn;
@property (nonatomic, strong) UIButton         * certificationBtn;
@property (nonatomic, strong) UIButton         * screeningBtn;
@property (nonatomic, strong) UICollectionView * collectionVi;
@property (nonatomic, strong) NSMutableArray   * dataArr;
@property (nonatomic, strong) UIView           * line_01;
@property (nonatomic, strong) UIView           * line_02;


@property (nonatomic, strong)FilterModel * filterModel;//筛选条件 + 排序
@property (nonatomic, strong)ConditionsForRetrievalVC * conditionsForRetrievalVC;

@property (nonatomic, strong) MJRefreshNormalHeader     * refreshHeader;//MJ刷新

@property (nonatomic, strong) UIImageView *ivNoTransport;//200 108
@property (nonatomic, strong) UILabel *lb1;

@end

@implementation EmptyContainerListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bindView {
    self.availableNumBtn.frame = CGRectMake(20, 1, (SCREEN_W - 80) / 3, 38);
    [self makeButton:self.availableNumBtn];
    [self.view addSubview:self.availableNumBtn];
    
    self.certificationBtn.frame = CGRectMake(self.availableNumBtn.right + 20, 1, (SCREEN_W - 80) / 3, 38);
    [self.view addSubview:self.certificationBtn];

    self.screeningBtn.frame = CGRectMake(self.certificationBtn.right + 20, 1, (SCREEN_W - 80) / 3, 38);
    [self makeButton:self.screeningBtn];
    [self.view addSubview:self.screeningBtn];

    self.line_01.frame = CGRectMake(0, 0, SCREEN_W, 0.5);
    [self.view addSubview:self.line_01];
    
    self.line_02.frame = CGRectMake(0, 39, SCREEN_W, 0.5);
    [self.view addSubview:self.line_02];
    
    self.collectionVi.frame = CGRectMake(0, 40, SCREEN_W, SCREEN_H - 40 - 55 - 64);
    [self.view addSubview:self.collectionVi];

    self.ivNoTransport.frame = CGRectMake(SCREEN_W/2 - 100, 120, 200, 108);
    self.ivNoTransport.hidden = YES;
    [self.collectionVi addSubview:self.ivNoTransport];
    
    self.lb1.frame = CGRectMake(0, self.ivNoTransport.bottom + 60 , SCREEN_W, 20);
    self.lb1.hidden = YES;
    [self.collectionVi addSubview:self.lb1];
}

- (void)bindAction {
    WS(ws);
    [[self.availableNumBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        //去掉认证的选中效果
        ws.certificationBtn.selected = NO;
        ws.filterModel.isAuthenticated = 0;
        switch (ws.availableNumBtn.tag) {
            case disorderly:
                ws.availableNumBtn.tag = descending;
                [ws.availableNumBtn setImage:[UIImage imageNamed:[@"_Group 17" adS]] forState:UIControlStateNormal];
                ws.availableNumBtn.selected = YES;
                ws.filterModel.useNumberSort = -1;
                break;
            case ascending:
//                ws.availableNumBtn.tag = disorderly;
//                [ws.availableNumBtn setImage:[UIImage imageNamed:[@"Group 16" adS]] forState:UIControlStateNormal];
//                ws.availableNumBtn.selected = NO;
//                ws.filterModel.useNumberSort = 0;
                ws.availableNumBtn.tag = descending;
                [ws.availableNumBtn setImage:[UIImage imageNamed:[@"_Group 17" adS]] forState:UIControlStateNormal];
                ws.availableNumBtn.selected = YES;
                ws.filterModel.useNumberSort = -1;
                break;
            case descending:
                ws.availableNumBtn.tag = ascending;
                [ws.availableNumBtn setImage:[UIImage imageNamed:[@"_Group 18" adS]] forState:UIControlStateNormal];
                ws.availableNumBtn.selected = YES;
                ws.filterModel.useNumberSort = 1;

                break;
                
            default:
                break;
        }
        
        [ws loadingData];
        
    }];
    
    [[self.certificationBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        ws.certificationBtn.selected = !ws.certificationBtn.selected;
        if (ws.certificationBtn.selected) {
            ws.filterModel.isAuthenticated = -1;

        } else {
            ws.filterModel.isAuthenticated = 1;

        }

        //数量选中去掉
        ws.availableNumBtn.tag = disorderly;
        ws.filterModel.useNumberSort = 0;
        [ws.availableNumBtn setImage:[UIImage imageNamed:[@"Group 16" adS]] forState:UIControlStateNormal];
        ws.availableNumBtn.selected = NO;
        [ws loadingData];
        
    }];
    
    [[self.screeningBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x){
        
        NSArray * arr = [NSStringFromClass([ws class]) componentsSeparatedByString:@"_"];
        ConditionsForRetrievalVC * vc;
        if (arr.count > 1) {
            vc = [NSClassFromString([NSString stringWithFormat:@"ConditionsForRetrievalVC_%@",arr[1]]) new];
        }
        else {
            vc = [ConditionsForRetrievalVC new];
        }
        vc.filterModel = ws.filterModel;
        vc.conditionsForRetrievalVCDelegate = ws;
        [ws.navigationController pushViewController:vc animated:NO];
    }];
    
    ws.collectionVi.mj_header = self.refreshHeader;

}

- (void)bindModel {
    [self loadingData];
}

-(void)loadingData{
    WS(ws);
    [[EmptyContainerViewModel new]getEmptyContainerArrWith:self.filterModel callback:^(NSArray *arr, BOOL isLastPage) {
        [ws.dataArr removeAllObjects];
        [ws.dataArr addObjectsFromArray:arr];
        [ws.collectionVi reloadData];
        ws.collectionVi.contentOffset = CGPointZero;
    }];
}

- (void)makeButton:(UIButton *)btn {

    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0,-btn.imageView.frame.size.width * 2, 0.0,0.0)];//文字距离
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel.bounds.size.width * 2 - btn.imageView.frame.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
}

/**
 *  getter
 *
 */
- (UIButton *)availableNumBtn {
    if (!_availableNumBtn) {
        UIButton * btn = [UIButton new];
        
        [btn setTitle:@"可用数量" forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:[@"Group 16" adS]] forState:UIControlStateNormal];
        btn.tag = disorderly;
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [btn setAdjustsImageWhenHighlighted:NO];
        _availableNumBtn = btn;
    }
    return _availableNumBtn;
}

- (UIButton *)certificationBtn {
    if (!_certificationBtn) {
        UIButton * btn = [UIButton new];
        
        [btn setTitle:@"认证情况" forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLUE_BTN forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        _certificationBtn = btn;
    }
    return _certificationBtn;
}

- (UIButton *)screeningBtn {
    if (!_screeningBtn) {
        UIButton * btn = [UIButton new];
        
        [btn setTitle:@"筛选" forState:UIControlStateNormal];
        [btn setTitleColor:APP_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[@"筛选 copy" adS]] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        
        _screeningBtn = btn;
    }
    return _screeningBtn;
}

- (UICollectionView *)collectionVi {
    if (!_collectionVi) {
        UICollectionView * vi = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        vi.delegate = self;
        vi.dataSource = self;
        vi.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        [vi registerClass:[EmptyContainerListCell class] forCellWithReuseIdentifier:@"EmptyContainerListCell"];
        _collectionVi = vi;
    }
    return _collectionVi;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray new];
    }
    return  _dataArr;
}

- (UIView *)line_01 {
    if (!_line_01) {
        
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        _line_01 = view;
    }
    return _line_01;
}

- (UIView *)line_02 {
    if (!_line_02) {
        
        UIView * view = [UIView new];
        view.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
        _line_02 = view;

    }
    return _line_02;
}


- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"抱歉，没有找到符合您需求的结果";
        
        _lb1 = label;
    }
    return _lb1;
}


- (UIImageView *)ivNoTransport {
    if (!_ivNoTransport) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"NoTransport"];
        
        _ivNoTransport = imageView;
    }
    return _ivNoTransport;
}

-(FilterModel *)filterModel {
    if (!_filterModel) {
        
        FilterModel * model = [FilterModel new];
        model.containerCondition = new0;
        model.currentPage = 0;
        model.pageSize = 40;
        model.isAuthenticated = 0;
        _filterModel = model;
        
    }
    return _filterModel;
}

-(MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        WS(ws);
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            ws.filterModel.city = nil;
            ws.filterModel.startTime = nil;
            ws.filterModel.endTime = nil;
            ws.filterModel.container = nil;
            ws.filterModel.containerCondition = new0;
            [ws loadingData];
        }];
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    }
    return _refreshHeader;
}
#pragma mark - UICollectionViewDelegate UICollectionViewDataSource

//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmptyContainerListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyContainerListCell" forIndexPath:indexPath];
    [cell loadUIWithmodel:self.dataArr[indexPath.row]];
    return cell;
}

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_W / 2, 211);
}

//设置每组的cell的边界,
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//cell被选择时被调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)chooseCompleteNeedLoadingData {
    
    [self loadingData];

}

@end


@implementation EmptyContainerListVC_Rent

-(void)loadingData{
    self.filterModel.saleType = @"租";
    WS(ws);
    [[EmptyContainerViewModel new]getEmptyContainerArrWith:self.filterModel callback:^(NSArray *arr, BOOL isLastPage) {
        
        [ws.dataArr removeAllObjects];
        for (ContainerModel * model in arr) {
            model.unit = @"天/个";
            [ws.dataArr addObject:model];
        }
        [ws.collectionVi reloadData];
        ws.collectionVi.contentOffset = CGPointZero;
        
        if (ws.dataArr.count >0) {
            ws.ivNoTransport.hidden = YES;
            ws.lb1.hidden = YES;
        }else{
            ws.ivNoTransport.hidden = NO;
            ws.lb1.hidden = NO;
        }
        [ws.collectionVi.mj_header endRefreshing];
    }];
}

//租箱
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ContainerModel * model = self.dataArr[indexPath.row];

    GoodsDetailVC *vc= [GoodsDetailVC new];
    vc.style = 0;
    vc.ID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}
@end

@implementation EmptyContainerListVC_Buy
-(void)loadingData{
    self.filterModel.saleType = @"售";
    WS(ws);
    [[EmptyContainerViewModel new]getEmptyContainerArrWith:self.filterModel callback:^(NSArray *arr, BOOL isLastPage) {
        [ws.dataArr removeAllObjects];
        for (ContainerModel * model in arr) {
            model.unit = @"个";
            [ws.dataArr addObject:model];
        }
        [ws.collectionVi reloadData];
        ws.collectionVi.contentOffset = CGPointZero;
        if (ws.dataArr.count >0) {
            ws.ivNoTransport.hidden = YES;
            ws.lb1.hidden = YES;
        }else{
            ws.ivNoTransport.hidden = NO;
            ws.lb1.hidden = NO;
        }
        [ws.collectionVi.mj_header endRefreshing];

    }];
}


//购箱
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ContainerModel * model = self.dataArr[indexPath.row];

    GoodsDetailVC *vc= [GoodsDetailVC new];
    vc.style = 1;
    vc.ID = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
