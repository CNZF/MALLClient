//
//  KNCustomSelectSpecVC.m
//  MallClient
//
//  Created by 沙漠 on 2018/5/2.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNCustomSelectSpecVC.h"
#import "ContainerViewModel.h"
#import "ContainerTypeModel.h"
#import "KNCustomSelectTableViewCell.h"

@interface KNCustomSelectSpecVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *KNTableView;

@end

@implementation KNCustomSelectSpecVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择箱型";
    [self.view addSubview:self.KNTableView];
}

- (void)bindModel{
    
    [[[ContainerViewModel alloc] init] getContainerTypecallback:^(NSArray *arr) {
        [self.dataArray addObjectsFromArray:arr];
        [self.KNTableView reloadData];
    }];
}

- (void)onBackAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KNCustomSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KNCustomSelectTableViewCell" forIndexPath:indexPath];
    ContainerTypeModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ContainerTypeModel *model = self.dataArray[indexPath.row];
    if (self.completeBlock) {
        self.completeBlock(model);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -- Getter
- (UITableView *)KNTableView {
    if (!_KNTableView) {
        _KNTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStylePlain];
        _KNTableView.rowHeight = 50;
        _KNTableView.delegate = self;
        _KNTableView.dataSource = self;
        _KNTableView.backgroundColor = APP_COLOR_GRAY_SEARCH_BG;
        _KNTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_KNTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        [_KNTableView registerNib:[UINib nibWithNibName:@"KNCustomSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"KNCustomSelectTableViewCell"];
    }
    return _KNTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
