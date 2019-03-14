//
//  ZCCityListViewController.m
//  Zhongche
//
//  Created by 刘磊 on 16/7/14.
//  Copyright © 2016年 lxy. All rights reserved.
//

#import "ZCCityListViewController.h"
#import "ZCCityListViewModel.h"
#import "OftenUseCityCell.h"
#import "NSString+InOrderSubstring.h"
#import "MLNavigationController.h"

@interface ZCCityListViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,OftenUseCityCellDelegate>
#pragma mark - 属性声明部分
@property (nonatomic, strong) UITableView    * cityList;
@property (nonatomic, strong) NSMutableArray * cityArray;//城市列表
@property (nonatomic, strong) NSMutableArray * allCitys;
@property (nonatomic, strong) UISearchBar    * searchBar;//搜索栏

@property (nonatomic, assign) BOOL OftenUseCity;//是否有常用地址
@end

@implementation ZCCityListViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fromNaviC = YES;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if([self.navigationController isKindOfClass:[MLNavigationController class]]) {
        ((MLNavigationController *)self.navigationController).canDragBack = NO;
    }

}

- (void)viewWillDisappear:(BOOL)animated {
    
    if([self.navigationController isKindOfClass:[MLNavigationController class]]) {
        ((MLNavigationController *)self.navigationController).canDragBack = YES;
    }
    
    [super viewWillDisappear:animated];
}
#pragma mark -初始化部分
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.btnRight.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.btnLeft setImage:[UIImage imageNamed:[@"Cancle" adS]] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWasShown:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)bindView
{
    self.searchBar.frame = CGRectMake(0, kNavBarHeaderHeight * (self.fromNaviC?0:1), SCREEN_W, 44);
    [self.view addSubview:self.searchBar];
    
//    self.cityList.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_W, SCREEN_H -  CGRectGetMaxY(self.searchBar.frame) - kNavBarHeaderHeight * (self.fromNaviC?1:0)- kiPhoneFooterHeight);
    [self.view addSubview:self.cityList];
}

-(void)bindModel
{
    self.searchBar.placeholder = @"请输入城市名称";
    WS(ws);
    [[[ZCCityListViewModel alloc]init] getCityListWithType:self.type WithCallback:^(NSArray *cityArray) {

        [ws.allCitys removeAllObjects];
        for (CityModel * city in cityArray) {
            [ws.allCitys addObject:city];
        }
        self.cityList.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_W, SCREEN_H -  CGRectGetMaxY(self.searchBar.frame) - kNavBarHeaderHeight * (self.fromNaviC?1:0)- kiPhoneFooterHeight);
        [self.view addSubview:self.cityList];
        [self loadCitysWithString:@""];
    }];
}

-(void)loadCitysWithString:(NSString *)cityName
{
    [self.cityArray removeAllObjects];
    
    NSMutableArray * citys;
    if ([cityName isEqualToString:@""]) {
        self.OftenUseCity = YES;
        citys = [NSMutableArray new];
        for (NSString * str in [[NSUserDefaults standardUserDefaults] objectForKey:@"cityHistory"]) {
            for (CityModel * city in self.allCitys) {
                if ([city.name isEqualToString:str]) {
                    [citys addObject:city];
                }
            }
        }
        
        [self.cityArray addObject:citys];
    }else{
        self.OftenUseCity = NO;
    }
    for (int i = 'A'; i <= 'Z';  i ++)
    {
        citys = [[NSMutableArray alloc]init];
        [self.cityArray addObject:citys];
    }
    for(CityModel * city in self.allCitys)
    {
        if ([cityName isEqualToString:@""]) {
            [(NSMutableArray *)(self.cityArray[[city.startPinyin characterAtIndex:0] - 'A' + 1]) addObject:city];
        }
        else if ([cityName isInOrderSubstringForSting:city.name])
        {
            [(NSMutableArray *)(self.cityArray[[city.startPinyin characterAtIndex:0] - 'A']) addObject:city];
        }
    }
    
    //如果有常用城市,城市不参加排序
    for (NSInteger i = self.cityArray.count - 1;i >= 0 + self.OftenUseCity;i--)
    {
        citys = self.cityArray[i];
        if (citys.count == 0)
        {
            [self.cityArray removeObjectAtIndex:i];
        }
        else
        {
            [citys sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
                NSString * str1 = [NSString stringWithString:((CityModel *)obj1).name];
                NSString * str2 = [NSString stringWithString:((CityModel *)obj2).name];
                return [str1 compare:str2];
            }];
        }
    }
    [self.cityList reloadData];
}
- (NSString *)type
{
    if (!_type) {
//        _type = @"getCityList";
        _type = @"user";
        
    }
    return _type;
}
-(void)onBackAction
{
    if (!self.fromNaviC) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        });;
    }
    else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}
#pragma mark - 属性懒加载部分
- (UITableView *)cityList
{
    if (!_cityList) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cityTableviewCell"];
        [tableView registerClass:[OftenUseCityCell class] forCellReuseIdentifier:@"OftenUseCityCell"];
        _cityList = tableView;
    }
    return _cityList;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [UISearchBar new];
        _searchBar.delegate = self;
        
        [_searchBar setSearchFieldBackgroundImage:[[UIImage getImageWithColor:APP_COLOR_GRAY_SEARCH_BG andSize:CGSizeMake(SCREEN_W - 70, 28)] createRadius:14] forState:UIControlStateNormal];
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.backgroundImage = [UIImage getImageWithColor:[UIColor clearColor] andSize:CGSizeMake(1, 1)];
    }
    return _searchBar;
}
- (NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSMutableArray new];
    }
    return _cityArray;
}
- (NSMutableArray *)allCitys
{
    if (!_allCitys) {
        _allCitys = [NSMutableArray new];
    }
    return _allCitys;
}
#pragma mark - tabview代理
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.OftenUseCity && indexPath.section == 0) {
        OftenUseCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OftenUseCityCell" forIndexPath:indexPath];
        [cell loadUIWithmodel:self.cityArray[0]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.cellDelegate = self;
        return cell;
    }
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cityTableviewCell" forIndexPath:indexPath];
    cell.textLabel.text = ((CityModel *)(self.cityArray[indexPath.section][indexPath.row])).name;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cityArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.OftenUseCity && section == 0) {
        return 1;
    }
    return ((NSArray *)(self.cityArray[section])).count;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.OftenUseCity && section == 0) {
        return @"常用城市";
    }
    CityModel * model = self.cityArray[section][0];
    return model.startPinyin;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = APP_COLOR_GRAY2;
    header.textLabel.font = [UIFont systemFontOfSize:14.f];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *indexs=[[NSMutableArray alloc]init];
    CityModel * model = [[CityModel alloc] init];;
    NSArray * citys;
    for(int i = 0;i< self.cityArray.count;i ++){
        citys = self.cityArray[i];
        model = citys[0];
        if (self.OftenUseCity && i == 0) {
            [indexs addObject:@"常用"];
            continue;
        }
        [indexs addObject:model.startPinyin];
    }
    return indexs;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.OftenUseCity && indexPath.section == 0) {
        return 70 + ([self.cityArray[0] count] - 1) / 3 * 50;
    }
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityModel *model  = self.cityArray[indexPath.section][indexPath.row];
    //model.type = self.cityType;
    NSMutableArray * arr = [NSMutableArray new];
    NSUserDefaults * appdict = [NSUserDefaults standardUserDefaults];
    for (id obj in [appdict objectForKey:@"cityHistory"]) {
        [arr addObject:obj];
    }
    if ([arr indexOfObject:model.name] == NSNotFound) {
        [arr insertObject:model.name atIndex:0];
    }
    if (arr.count > 9) {
        [arr removeObjectAtIndex:9];
    }
    [appdict setObject:arr forKey:@"cityHistory"];
    [self.getCityDelagate getCityModel:model];
    if (self.completeBlock) {
        self.completeBlock(model);
    }
    [self onBackAction];
}
-(void)getClickBtnNum:(NSInteger)num
{
    CityModel *model  = self.cityArray[0][num];
    NSMutableArray * arr = [NSMutableArray new];
    NSUserDefaults * appdict = [NSUserDefaults standardUserDefaults];
    for (id obj in [appdict objectForKey:@"cityHistory"]) {
        [arr addObject:obj];
    }
    [arr removeObject:model.name];
    [arr insertObject:model.name atIndex:0];
    [appdict setObject:arr forKey:@"cityHistory"];
    //model.type = self.cityType;
    [self.getCityDelagate getCityModel:model];
    if (self.completeBlock) {
        self.completeBlock(model);
    }
    [self onBackAction];
}

#pragma mark - UISearchBarDelegate
//输入文本实时更新时调用
- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self loadCitysWithString:searchText];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self loadCitysWithString:@""];
    [searchBar resignFirstResponder];
}
#pragma mark - 键盘
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.cityList.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_W, SCREEN_H -  CGRectGetMaxY(self.searchBar.frame)  - keyBoardFrame.size.height);
}
-(void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    self.cityList.frame = CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), SCREEN_W, SCREEN_H -  CGRectGetMaxY(self.searchBar.frame));
}
@end
