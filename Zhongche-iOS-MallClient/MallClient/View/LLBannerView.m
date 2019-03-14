//
//  LLBannerView.m
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/1/19.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "LLBannerView.h"
#import "UIImageView+WebCache.h"

@interface ImageCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)UIImageView * imgVi;

@end
@implementation ImageCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.imgVi.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.imgVi];
        
    }
    return self;
}

-(UIImageView *)imgVi
{
    if (!_imgVi) {
        _imgVi = [UIImageView new];
    }
    return _imgVi;
}
@end


@interface LLBannerView()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong)UICollectionView * collectionVi;

@property (nonatomic, strong)NSMutableArray * imageArr;

@property (nonatomic, strong)NSTimer * timer;

@end

@implementation LLBannerView

-(void)dealloc
{
    [_timer invalidate];
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionVi];
        [self addSubview:self.pageControl];
        _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(updateCollectionViewContentOffset) userInfo:nil repeats:YES];

//        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.collectionVi.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    self.pageControl.frame = CGRectMake(20, frame.size.height - 20, frame.size.width - 40, 20);
    [self.collectionVi reloadData];
}

-(void)setImages:(NSArray *)images
{
    _images = images;
    if (_images.count > 0) {
        [self.imageArr removeAllObjects];
        [self.imageArr addObject:_images[_images.count - 1]];
        [self.imageArr addObjectsFromArray:_images];
        [self.imageArr addObject:_images[0]];
        self.collectionVi.contentOffset = CGPointMake(self.frame.size.width, self.collectionVi.contentOffset.y);
        self.pageControl.numberOfPages = _images.count;
        self.pageControl.currentPage = 0;
        [self.collectionVi reloadData];
    }
}

-(UICollectionView *)collectionVi
{
    if (!_collectionVi) {
        
        UICollectionViewFlowLayout *  layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        UICollectionView * collectionVi = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionVi.delegate = self;
        collectionVi.dataSource = self;
        [collectionVi registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"ImageCollectionViewCell"];
        
        collectionVi.bounces = NO;
        collectionVi.showsHorizontalScrollIndicator = NO;
        collectionVi.showsVerticalScrollIndicator = NO;
        collectionVi.pagingEnabled = YES;

        _collectionVi = collectionVi;
    }
    return _collectionVi;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl * pageControl = [UIPageControl new];
        pageControl.userInteractionEnabled = NO;
        _pageControl = pageControl;
    }
    return _pageControl;
}
-(NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray new];
    }
    return _imageArr;
}
#pragma mark - UICollectionViewDelegate UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
    id obj = self.imageArr[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        [cell.imgVi sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"1111"]];

    }
    else if ([obj isKindOfClass:[UIImage class]]) {
        [cell.imgVi setImage:obj];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageArr.count - 1) {
        NSLog(@"%ld",0L);
    }
    else if (indexPath.row == 0) {
        NSLog(@"%ld",self.imageArr.count - 2);
    }
    else
    {
        NSLog(@"%ld",indexPath.row - 1);

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= self.frame.size.width *(self.imageArr.count - 1)) {
        scrollView.contentOffset = CGPointMake(self.frame.size.width, scrollView.contentOffset.y);
    }
    else if (scrollView.contentOffset.x <= 0) {
        scrollView.contentOffset = CGPointMake(self.frame.size.width *(self.imageArr.count - 2), scrollView.contentOffset.y);
    }
    self.pageControl.currentPage = scrollView.contentOffset.x / self.frame.size.width - 1;
    
}

-(void)updateCollectionViewContentOffset
{
    if (self.collectionVi.contentOffset.x >= self.frame.size.width *(self.imageArr.count - 1)) {
        self.collectionVi.contentOffset = CGPointMake(self.frame.size.width, self.collectionVi.contentOffset.y);
    }
    else if (self.collectionVi.contentOffset.x <= 0) {
        self.collectionVi.contentOffset = CGPointMake(self.frame.size.width *(self.imageArr.count - 2), self.collectionVi.contentOffset.y);
    }

    CGPoint point = CGPointMake((int)(self.collectionVi.contentOffset.x / self.frame.size.width) * self.frame.size.width + self.frame.size.width, self.collectionVi.contentOffset.y);

    [self.collectionVi setContentOffset:point animated:YES];
    self.pageControl.currentPage = point.x / self.frame.size.width - 1;
    if (point.x / self.frame.size.width - 1 >= self.pageControl.numberOfPages) {
        self.pageControl.currentPage = 0;
    }
    
    [self.bannerViewDelegate bannerViewCurrentPageIs:self.pageControl.currentPage + 1];
}
@end
