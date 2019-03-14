//
//  AnimationMath.h
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/13.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationMath : NSObject

-(void)getCGPointsWithStartPoint:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint AndNeedPointNumber:(int)num AndPowerNum:(int)n withCallBack:(void (^)(CGPoint *points))callback;

-(void)getNextPointWithStartPoint:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint AndNeedPointNumber:(int)num AndPowerNum:(int)n withNowPoint_x:(int)point_x withCallBack:(CGPoint *)point;
@end
