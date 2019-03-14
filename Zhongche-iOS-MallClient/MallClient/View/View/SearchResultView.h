//
//  SearchResultView.h
//  MallClient
//
//  Created by lxy on 2016/11/30.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"
#import "TransportationModel.h"

@interface SearchResultView : BaseView

@property (nonatomic, strong) UIButton    *btnboom;
@property (nonatomic, strong) UIButton *btnCancle;

@property (nonatomic, strong) UIButton *btnYesOrNo;
@property (nonatomic, strong) UIButton *btnStyleChoose;
@property (nonatomic, strong) UIImageView *ivAddAndReduce;
@property (nonatomic, strong) UITextField *tfNum;

@property (nonatomic, assign) int num;
@property (nonatomic, strong) TransportationModel *info;



@property (nonatomic, strong) UIView      *viBackground;
@property (nonatomic, strong) UIView      *viShow;
@property (nonatomic, strong) UIImageView *ivTransport;

@property (nonatomic, strong) UIButton    *btnYes;
@property (nonatomic, strong) UIButton    *btnNo;
@property (nonatomic, strong) UIButton    *btnMTM;
@property (nonatomic, strong) UIButton    *btnMTD;
@property (nonatomic, strong) UIButton    *btnDTM;
@property (nonatomic, strong) UIButton    *btnDTD;


@property (nonatomic, strong) UIButton    *btnAdd;
@property (nonatomic, strong) UIButton    *btnReduce;
@property (nonatomic, strong) UILabel     *lb1;
@property (nonatomic, strong) UILabel     *lb2;
@property (nonatomic, strong) UILabel     *lb3;
@property (nonatomic, strong) UILabel     *lb5;
@property (nonatomic, strong) UILabel     *lb7;


@property (nonatomic, strong) UIButton    *btnCall;
@property (nonatomic, strong) UITextField *tfWeight;
@property (nonatomic, strong) UITextField *tfBulk;

@property (nonatomic, strong) UITextField *tfLargestWeight;

@property (nonatomic, strong) UITextField *tfLong;
@property (nonatomic, strong) UITextField *tfWeith;
@property (nonatomic, strong) UITextField *tfHeight;

+(SearchResultView *)shareSearchResultView;

@property (nonatomic, assign)float backgroundAlpha;

@end


@interface SearchResultView1 : SearchResultView



@end

@interface SearchResultView2 : SearchResultView



@end

@interface SearchResultView3 : SearchResultView



@end

@interface SearchResultView4 : SearchResultView



@end
