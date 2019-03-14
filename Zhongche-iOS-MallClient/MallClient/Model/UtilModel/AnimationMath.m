//
//  AnimationMath.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/12/13.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "AnimationMath.h"

@implementation AnimationMath
-(void)getCGPointsWithStartPoint:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint AndNeedPointNumber:(int)num AndPowerNum:(int)n withCallBack:(void (^)(CGPoint *points))callback;
{
    if (n <= 0 || num <= 1) {
        return;
    }
    CGPoint points[num];
    float spacing = (endPoint.x - startPoint.x) / (num - 1);
    points[0].x = startPoint.x;
    points[0].y = startPoint.y;
    
    for (int i = 1; i < num; i ++)
    {
        points[i].x = points[i - 1].x + spacing;
        points[i].y = (startPoint.y - endPoint.y) / pow((startPoint.x - endPoint.x), n) * pow((points[i].x - endPoint.x), n) + endPoint.y;
    }
    callback(points);
}

-(void)getNextPointWithStartPoint:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint AndNeedPointNumber:(int)num AndPowerNum:(int)n withNowPoint_x:(int)point_x withCallBack:(CGPoint *)point
{
    [self getCGPointsWithStartPoint:startPoint AndEndPoint:endPoint AndNeedPointNumber:num AndPowerNum:n withCallBack:^(CGPoint *points) {
        
        (*point).y = points[point_x].y;
    }];
}

-(CGFloat)transform:(CGFloat)f
{
    if ([ZSEquipmentAttribute getRetina] == 2) {
        CGFloat a = f - (int)f;
        if (a < 0.25) {
            f = (int)f;
        }
        else if (a >= 0.25 && a < 0.75) {
            f = (int)f + 0.5;
        }
        else if (a >= 0.75) {
            f = (int)f + 1;
        }
    }
    else if ([ZSEquipmentAttribute getRetina] == 3) {
        CGFloat a = f - (int)f;
        if (a < 1.0 / 6) {
            f = (int)f;
        }
        else if (a >= 1.0 / 6 && a < 0.5) {
            f = (int)f + 1.0 / 3;
        }
        else if (a >= 0.5 && a < 5.0 / 6) {
            f = (int)f + 2.0 / 3;
        }
        else if (a > 5.0 / 6) {
            f = (int)f + 2.0 / 3;
        }
    }
    return f;
}
@end
