//
//  ZSSearchViewController.m
//  LogisticsAssistant
//
//  Created by 中车_LL_iMac on 16/8/28.
//  Copyright © 2016年 com.chongche.cn. All rights reserved.
//

#import "ZSSearchViewController.h"
#import "EntryCollectionCell.h"
#import "SearchGoodsCell.h"
#import "UICollectionViewLeftAlignedLayout.h"

#define SEARCH_HISTORY_FONT [UIFont systemFontOfSize:16.0f]
#define MAX_HISTORY_NUM 10

@interface ZSSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
//搜索栏
@property (nonatomic, strong) UISearchBar      * search;
//搜索历史
@property (nonatomic, strong) UICollectionView * searchHistory;
@property (nonatomic, strong) NSMutableArray   * searchHistoryData;
@property (nonatomic, strong) UITableView * tbv;

@end

@implementation ZSSearchViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.search removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar addSubview:self.search];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
    self.btnLeft.hidden = YES;
    self.btnRight.hidden = NO;
    [self.btnRight setImage:nil forState:UIControlStateNormal];
    [self.btnRight setTitleColor:APP_COLOR_GRAY2 forState:UIControlStateNormal];
    self.btnRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.btnRight setTitle:@"取消" forState:UIControlStateNormal];
    self.btnRight.frame = CGRectMake(10, 0, 33, 22);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)onRightAction {
    [self onBackAction];
}

- (void)bindView {

    self.search.frame = CGRectMake(15, 0,SCREEN_W - 73, 44);
    [self.navigationController.navigationBar addSubview:self.search];
    
    self.searchHistory.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    [self.view addSubview:self.searchHistory];
    
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    self.tbv.hidden = YES;
    [self.view addSubview:self.tbv];
    
}

- (void)bindModel {
    self.searchHistoryData = [NSKeyedUnarchiver unarchiveObjectWithFile:USER_FILE_PATH_HISTORY];
    [self llcollectionViewLoadData];
}

- (void)bindAction {
    [[self.search valueForKey:@"_searchField"] addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 懒加载

- (UISearchBar *)search {
    if (!_search) {
        _search = [UISearchBar new];
        _search.delegate = self;
        //_search背景色[@"Rectangle 23 Copy" adS]
        [_search setSearchFieldBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_GRAY_SEARCH_BG andSize:CGSizeMake(SCREEN_W - 70, 28)] createRadius:5] forState:UIControlStateNormal];
        _search.placeholder = @"请输入关键字";
        //一下代码为修改placeholder字体的颜色和大小
        UITextField * searchField = [_search valueForKey:@"_searchField"];
        [searchField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    }
    return _search;
}

- (UICollectionView *)searchHistory{
    if (!_searchHistory) {
        
        _searchHistory = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLeftAlignedLayout new]];
        _searchHistory.delegate = self;
        _searchHistory.dataSource = self;
        _searchHistory.backgroundColor = APP_COLOR_WHITE;
        [_searchHistory registerClass:[EntryCollectionCell class] forCellWithReuseIdentifier:@"EntryCollectionCell"];
        [_searchHistory registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableView"];
    }
    return _searchHistory;
}

- (NSMutableArray *)searchHistoryData{
    if (!_searchHistoryData) {
        _searchHistoryData = [NSMutableArray new];
    }
    return _searchHistoryData;
}

- (void)llcollectionViewLoadData {
    [self.searchHistory reloadData];
}

#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
//每一组有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchHistoryData.count;
}

//定义并返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EntryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntryCollectionCell" forIndexPath:indexPath];
    cell.textLabel.frame = CGRectMake(0, 0, [_searchHistoryData[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:SEARCH_HISTORY_FONT}].width + 30, 35);
    cell.textLabel.text = _searchHistoryData[indexPath.row];
    
    cell.bg.frame  = cell.textLabel.frame;
    [cell.bg.layer setCornerRadius:16];
    [cell.layer setMasksToBounds:YES];
//    if (indexPath.row == _searchHistoryData.count - 1)
//    {
//        if (CGRectGetMaxY(cell.frame) < SCREEN_H - 64 -20)
//        {
//            self.searchHistory.frame = CGRectMake(0, 0, SCREEN_W, CGRectGetMaxY(cell.frame) + 20);
//        }
//    }
    return cell;
}

//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([_searchHistoryData[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:SEARCH_HISTORY_FONT}].width + 30, 35);
}

//设置每组的cell的边界,
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 10, 20, 10);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

// 和UITableView类似，UICollectionView也可设置段头段尾
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UICollectionReusableView" forIndexPath:indexPath];
        if(headerView == nil)
        {
            headerView = [[UICollectionReusableView alloc] init];
        }
        if (headerView.subviews.count == 0) {
            UILabel * titleLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 151, 44)];
            titleLab.text = @"历史记录";
            titleLab.textColor = APP_COLOR_GRAY_SEARCH_TEXT;
            titleLab.font = [UIFont systemFontOfSize:14.0f];
            [headerView addSubview:titleLab];
            
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_W - 20 -60, 0, 60, 44)];
            [button setTitle:@"清除历史" forState:UIControlStateNormal];
            [button setTitleColor:APP_COLOR_GRAY_TEXT forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [button addTarget:self action:@selector(removeHistory) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
            
            UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(button.frame) - 13, 15, 13, 13)];
            img.image = [UIImage imageNamed:[@"iconfont-shanchu" adS]];
            [headerView addSubview:img];
        }
        headerView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        
        return headerView;
    }
    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return (CGSize){SCREEN_W,44};
}
//cell被选择时被调用

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _search.text = _searchHistoryData[indexPath.row];
    [self textFieldDidChange:[self.search valueForKey:@"_searchField"]];
    [self.tbv reloadData];
    self.tbv.hidden = NO;
    self.searchHistory.hidden = YES;
}

#pragma mark - UISearchBarDeleGate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self hideTheKeyboard];
}

- (void)removeHistory {
    NSString * filePath= USER_FILE_PATH_HISTORY;
    BOOL success = [NSKeyedArchiver archiveRootObject:[NSMutableArray array] toFile:filePath];
    if (success)
    {
        [_searchHistoryData removeAllObjects];
        [self llcollectionViewLoadData];
    }
    else
    {
        
    }
}

//重写父类方法,键盘失去焦点
- (void)hideTheKeyboard {
    [self.navigationController.view endEditing:YES];
}


#pragma mark - Tbv

- (UITableView *)tbv {
    if (!_tbv) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        [tableView registerClass:[SearchGoodsCell class] forCellReuseIdentifier:NSStringFromClass([SearchGoodsCell class])];
        _tbv = tableView;
    }
    return _tbv;
}

#pragma mark - Tabview Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchGoodsCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SearchGoodsCell class]) forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell loadUIWithmodel:self.dataArray[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    int num = (int)text.length;
    
    if ([text isEqualToString:@""]) {
        
        num = -1;
        
    }
    
    if (searchBar.text.length + num > 0) {
        [self.tbv reloadData];
        self.tbv.hidden = NO;
        self.searchHistory.hidden = YES;
    }else {
        self.tbv.hidden = YES;
        self.searchHistory.hidden = NO;
    }

    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsInfo * goods = self.dataArray[indexPath.row];
    [self.vcDelegate getGood:goods];
    
    NSString *filePath = USER_FILE_PATH_HISTORY;
    for (NSInteger i = _searchHistoryData.count -1; i >= 0; i --)
    {
        if ([_searchHistoryData[i] isEqualToString:goods.name])
        {
            [_searchHistoryData removeObjectAtIndex:i];
        }
    }
    [_searchHistoryData insertObject:goods.name atIndex:0];
    if (_searchHistoryData.count > MAX_HISTORY_NUM) {
        [_searchHistoryData removeObjectAtIndex:_searchHistoryData.count - 1];
    }
    BOOL success = [NSKeyedArchiver archiveRootObject:_searchHistoryData toFile:filePath];
    
    if (success)
    {
        [self llcollectionViewLoadData];
        self.search.text = @"";
        [self.search resignFirstResponder];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidChange:(UITextField *)tf {
    WS(ws);
    [[ContainerViewModel new] getGoodsWithKeyWords:tf.text callback:^(NSArray *arr, NSString *keywords) {
        if ([keywords isEqualToString:ws.search.text]) {
            [ws.dataArray removeAllObjects];
            [ws.dataArray addObjectsFromArray:arr];
            [ws.tbv reloadData];
            ws.tbv.contentOffset = CGPointZero;
        }
    }];
}

#pragma mark - 键盘
- (void)keyboardWasShown:(NSNotification*)aNotification {
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - keyBoardFrame.size.height);
    self.searchHistory.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - keyBoardFrame.size.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    self.tbv.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);
    self.searchHistory.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64);

}

@end
