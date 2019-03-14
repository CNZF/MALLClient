//
//  LLBannerView.h
//  MallClient
//
//  Created by iOS_Developers_LL on 2017/1/19.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLBannerViewDelegate <NSObject>

-(void)bannerViewCurrentPageIs:(NSInteger) num;

@end

@interface LLBannerView : UIView


@property (nonatomic, strong)NSArray * images;//放入图片或者url字符串

@property (nonatomic, strong)UIPageControl * pageControl;

@property (nonatomic, weak)id<LLBannerViewDelegate> bannerViewDelegate;

@property (nonatomic, strong)NSTimer * timer;

@end
