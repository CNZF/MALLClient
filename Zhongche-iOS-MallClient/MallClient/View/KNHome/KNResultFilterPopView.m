//
//  KNResultFilterPopView.m
//  MallClient
//
//  Created by 沙漠 on 2018/4/26.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "KNResultFilterPopView.h"
#import "KNResultFilterPopCell.h"
#import "CapacityViewModel.h"
#import "ContainerTypeModel.h"

@interface KNResultFilterPopView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, strong) UIView *contentBGView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *cuttingLine;

@property (nonatomic, strong) UIButton *makeSureButton;

@property (nonatomic, strong) UICollectionView *KNCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *menuDataArray;

@property (nonatomic, strong) ContainerTypeModel *selectModel;


@end

@implementation KNResultFilterPopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        [self addSubview:self.coverView];
        [self addSubview:self.contentBGView];
        [self.contentBGView addSubview:self.titleLabel];
        [self.contentBGView addSubview:self.cuttingLine];
        [self.contentBGView addSubview:self.KNCollectionView];
        [self.contentBGView addSubview:self.makeSureButton];
        [self requestData];
        [[self.makeSureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.selectModel) {
                if (self.selectBlock) {
                    self.selectBlock(self.selectModel);
                }
            }
            [self close];
            
        }];
        
    }
    return self;
}

- (void)requestData{
    [[[CapacityViewModel alloc] init] requestcontainerListCallback:^(NSArray *arr) {
        self.menuDataArray = arr;
        [self.KNCollectionView reloadData];
    }];
}

#pragma mark -- Action
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.coverView.alpha = 1.0;
        self.contentBGView.transform = CGAffineTransformMakeTranslation(0, -self.contentBGView.bounds.size.height);
    } completion:^(BOOL finished) {
        
    }];
}
- (void)close{
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.coverView.alpha = 0;
        self.contentBGView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -- UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.menuDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KNResultFilterPopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KNResultFilterPopCell" forIndexPath:indexPath];
    ContainerTypeModel *model = self.menuDataArray[indexPath.row];
    cell.mainLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    KNResultFilterPopCell *cell = (KNResultFilterPopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.itemSelected = YES;
    ContainerTypeModel *model = self.menuDataArray[indexPath.row];
    self.selectModel = model;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    KNResultFilterPopCell *cell = (KNResultFilterPopCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.itemSelected = NO;
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

- (UIView *)contentBGView{
    if (!_contentBGView) {
        _contentBGView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 200)];
        _contentBGView.backgroundColor = [UIColor whiteColor];
    }
    return _contentBGView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_W-15, 33)];
        _titleLabel.textColor = APP_COLOR_GRAY999;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"集装箱种类";
    }
    return _titleLabel;
}

- (UIView *)cuttingLine{
    if (!_cuttingLine) {
        _cuttingLine = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom, SCREEN_W, 0.5)];
        _cuttingLine.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _cuttingLine;
}

- (UICollectionView *)KNCollectionView{
    if (!_KNCollectionView) {
        _KNCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, _cuttingLine.bottom+15, SCREEN_W-30, 80) collectionViewLayout:self.layout];
        _KNCollectionView.backgroundColor = [UIColor whiteColor];
        _KNCollectionView.delegate = self;
        _KNCollectionView.dataSource = self;
        [_KNCollectionView registerClass:[KNResultFilterPopCell class] forCellWithReuseIdentifier:@"KNResultFilterPopCell"];
    }
    return _KNCollectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 8;
        _layout.minimumInteritemSpacing = 15;
        _layout.itemSize = CGSizeMake(SCREEN_W/3-20, 28);
        _layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
//        _layout.sectionInset = UIEdgeInsetsMake(10,10,10,10);
    }
    return _layout;
}

- (UIButton *)makeSureButton{
    if (!_makeSureButton) {
        _makeSureButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 120, SCREEN_W-30, 44)];
        [_makeSureButton setTitle:@"完成" forState:UIControlStateNormal];
        _makeSureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _makeSureButton.layer.cornerRadius = 4.0;
        _makeSureButton.layer.masksToBounds = YES;
        [_makeSureButton setBackgroundColor:[HelperUtil colorWithHexString:@"3BA0F3"]];
    }
    return _makeSureButton;
}

- (NSArray *)menuDataArray{
    if (!_menuDataArray) {
        _menuDataArray = [NSArray array];
    }
    return _menuDataArray;
}

@end
