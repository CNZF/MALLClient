//
//  RentBoxVi.h
//  MallClient
//
//  Created by lxy on 2017/3/20.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseView.h"

@interface RentBoxVi : BaseView

@property (nonatomic, strong) UIButton    *btnboom;
@property (nonatomic, strong) UIButton    *btnYesOrNo;
@property (nonatomic, strong) UIImageView *ivAddAndReduce;
@property (nonatomic, strong) UITextField *tfNum;
@property (nonatomic, strong) UIView      *viBackground;
@property (nonatomic, strong) UIView      *viShow;
@property (nonatomic, strong) UIImageView *ivTransport;
@property (nonatomic, strong) UIButton    *btnCancle;
@property (nonatomic, strong) UIButton    *btnAdd;
@property (nonatomic, strong) UIButton    *btnReduce;
@property (nonatomic, strong) UILabel     *lbGoodsStatuse;
@property (nonatomic, strong) UILabel     *lbGoodsName;
@property (nonatomic, strong) UILabel     *lbPrice;
@property (nonatomic, strong) UILabel     *lbDeposit;//押金
@property (nonatomic, strong) UILabel     *lbNum;
@property (nonatomic, strong) UIButton    *btnSelfCarry;//自取
@property (nonatomic, strong) UIButton    *btnSentToHome;//送货上门

@property (nonatomic, strong) UIButton *btnStyleChoose;

@property (nonatomic, assign) int num;

@end
