//
//  PhotoInfo.h
//  MallClient
//
//  Created by lxy on 2017/2/7.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "BaseModel.h"

@interface PhotoInfo : BaseModel

@property (nonatomic, strong) UIImage *img1;//公函照片
@property (nonatomic, strong) UIImage *img2;//营业执照照片
@property (nonatomic, strong) UIImage *img3;//组织机构代码证
@property (nonatomic, strong) UIImage *img4;//税务登记证照片

@end
