
//
//  EntrySelectCell.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/28.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "EntrySelectCell.h"
#import "UICollectionViewLeftAlignedLayout.h"
#import "EntryCollectionCell.h"

#define  PLUSE_SIGN @"+   "
@interface EntrySelectCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UIButton * arrowBtn;

@property (nonatomic, strong) UICollectionView * entrySelect;

@property (nonatomic, strong)UIView * line;
@end

@implementation EntrySelectCell
-(void)bindModel
{
    [super bindModel];
}
-(void)bindView
{
    self.arrowBtn.frame = CGRectMake(SCREEN_W - 35, 5, 33, 27);
    [self addSubview:self.arrowBtn];
    
    self.entrySelect.frame = CGRectMake(20, 5, SCREEN_W - 65, 35);
    [self addSubview:self.entrySelect];
    
    [self addSubview:self.line];
}
-(void)bindAction
{
    [self.arrowBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)loadUIWithmodel:(EntrySelectCellModel *)model
{
    self.entrySelectData = model;
    
    if (model.plusSignHidden == NO)
    {
        if ([self.entrySelectData.entrys indexOfObject:PLUSE_SIGN] == NSNotFound)
        {
            [self.entrySelectData.entrys addObject:PLUSE_SIGN];
        }
    }
    
    if (model.cellCloseOrOpen) {
        self.entrySelect.frame = CGRectMake(self.entrySelect.left, self.entrySelect.top, self.entrySelect.width, self.entrySelectData.cellHeightOpen - 6);
    }
    else
    {
        self.entrySelect.frame = CGRectMake(self.entrySelect.left, self.entrySelect.top, self.entrySelect.width, self.entrySelectData.cellHeightClose - 6);
    }
    [self.entrySelect reloadData];
    self.arrowBtn.selected = model.cellCloseOrOpen;
    model.cellHeightOpen = self.entrySelect.collectionViewLayout.collectionViewContentSize.height +self.entrySelect.top + 10 + 5;
    if (model.cellHeightOpen <= model.cellHeightClose) {
        model.cellHeightOpen = model.cellHeightClose;
        self.arrowBtn.hidden = YES;
    }
    else
    {
        self.arrowBtn.hidden = NO;
    }
    self.line.frame = CGRectMake(20, self.entrySelect.bottom, SCREEN_W - 40, 1);
}
-(void)buttonClick:(UIButton *)button
{
    self.entrySelectData.cellCloseOrOpen = !self.entrySelectData.cellCloseOrOpen;
    
    if([self.cellDelegate respondsToSelector:@selector(tabviewNeedReloadDataForIndexPath:)]){
        [self.cellDelegate tabviewNeedReloadDataForIndexPath:self.indexPath];
    }
}
-(UIButton *)arrowBtn
{
    if (!_arrowBtn) {
        _arrowBtn = [UIButton new];
        [_arrowBtn setImage:[UIImage imageNamed:[@"Back Chevron Copy 5" adS]] forState:UIControlStateNormal];
        [_arrowBtn setImage:[UIImage imageNamed:[@"Clip 4" adS]] forState:UIControlStateSelected];
    }
    return _arrowBtn;
}
-(UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = APP_COLOR_GRAY_CAPACITY_LINE;
    }
    return _line;
}
- (UICollectionView *)entrySelect
{
    if (!_entrySelect) {
        
        _entrySelect = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewLeftAlignedLayout new]];
        _entrySelect.delegate = self;
        _entrySelect.dataSource = self;
        _entrySelect.scrollEnabled = NO;
        _entrySelect.backgroundColor = [UIColor whiteColor];
        [_entrySelect registerClass:[EntryCollectionCell class] forCellWithReuseIdentifier:@"EntryCollectionCell"];
        [_entrySelect registerClass:[EntryCollectionCellForConditionsForRetrievalVC class] forCellWithReuseIdentifier:@"EntryCollectionCellForConditionsForRetrievalVC"];
    }
    return _entrySelect;
}
-(EntrySelectCellModel *)entrySelectData
{
    if (!_entrySelectData) {
        _entrySelectData = [EntrySelectCellModel new];
    }
    return _entrySelectData;
}
#pragma mark - UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.entrySelectData.entrys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntryCollectionCell" forIndexPath:indexPath];
    cell.textLabel.frame = CGRectMake(0, 0, [_entrySelectData.entrys[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:ENTRY_SELECT_FONT}].width + 15, 25);
    cell.textLabel.text = _entrySelectData.entrys[indexPath.row];
    
    cell.bg.frame  = cell.textLabel.frame;
    if ([cell.textLabel.text isEqualToString:self.entrySelectData.selectStr] || [cell.textLabel.text isEqualToString:PLUSE_SIGN]) {
        cell.bright = YES;
    }
    else
    {
        cell.bright = NO;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([_entrySelectData.entrys[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:ENTRY_SELECT_FONT}].width + 15, 25);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,0,0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //选择后CELL关闭
    if(self.entrySelectData.cellCloseOrOpen && !self.arrowBtn.hidden)
    {
        [self buttonClick:self.arrowBtn];
    }
    if ([self.entrySelectData.entrys[indexPath.row] isEqualToString:PLUSE_SIGN]) {
        [self.cellDelegate plusSignHiddenCellClick];
    }
    else
    {
        self.entrySelectData.selectStr = self.entrySelectData.entrys[indexPath.row];
        [self.cellDelegate getSelectString:self.entrySelectData.selectStr WithStringRow:indexPath.row WithIndexPath:self.indexPath];
        [self.entrySelect reloadData];
    }
}

@end

@implementation EntrySelectView
-(void)bindAction
{
    [super bindAction];
    self.entrySelect.userInteractionEnabled = NO;
}
-(CGFloat )loadViewWithEntrys:(NSArray *)entrys WithWidth:(CGFloat)width
{
    EntrySelectCellModel * model = [EntrySelectCellModel new];
    model.entrys = [NSMutableArray arrayWithArray:entrys];
    model.cellCloseOrOpen = YES;
    model.cellCloseOrOpen = YES;
    self.arrowBtn.hidden = YES;
    self.line.hidden = YES;
    self.entrySelect.frame = CGRectMake(0,0, width,1);
    [self loadUIWithmodel:model];
    self.entrySelect.frame = CGRectMake(self.entrySelect.left, self.entrySelect.top, width, model.cellHeightOpen);
    return model.cellHeightOpen;
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}
//设置每组的cell的边界,
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    return UIEdgeInsetsMake(10,0,0,0);
}
@end

@implementation EntrySelectCellForConditionsForRetrievalVC

-(void)bindView
{
    self.entrySelect.frame = CGRectMake(20, 5, SCREEN_W - 65, 44);
    [self addSubview:self.entrySelect];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EntryCollectionCellForConditionsForRetrievalVC *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EntryCollectionCellForConditionsForRetrievalVC" forIndexPath:indexPath];
    cell.textLabel.frame = CGRectMake(0, 0, [self.entrySelectData.entrys[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:ENTRY_SELECT_FONT}].width + 30, 33);
    cell.textLabel.text = self.entrySelectData.entrys[indexPath.row];
    
    cell.bg.frame  = cell.textLabel.frame;
    if ([cell.textLabel.text isEqualToString:self.entrySelectData.selectStr] || [cell.textLabel.text isEqualToString:PLUSE_SIGN]) {
        cell.bright = YES;
    }
    else
    {
        cell.bright = NO;
    }
    return cell;
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self.entrySelectData.entrys[indexPath.row] sizeWithAttributes:@{NSFontAttributeName:ENTRY_SELECT_FONT}].width + 30, 25);
}
@end
