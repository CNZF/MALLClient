//
//  ProView.m
//  MallClient
//
//  Created by lxy on 2018/9/13.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "ProView.h"

@interface ProView()
@property (nonatomic, assign) float start;
@property (nonatomic, assign) float end;
@end

@implementation ProView



- (void)drawRect:(CGRect)rect {
    
//    if ([self.model.ordetType isEqualToString:@"已取消"]) {
//        return;
//    }
//    if (self.model.estimateFinishTime ) {
    UIColor *color = [HelperUtil colorWithHexString:@"f8f8f8"];
    [color set];

    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:0*M_PI endAngle:M_PI*2 clockwise:YES];
//
    path.lineWidth = 3.0;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
    
    UIColor *color1;
    __block UIBezierPath *path1;
    if ([self.model.ordetType isEqualToString:@"待确认"]) {
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
        path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:M_PI*2*0.2 clockwise:YES];
    }else if ([self.model.ordetType isEqualToString:@"待付款"]) {
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
        path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:M_PI*2*0.4 clockwise:YES];
    }else if ([self.model.ordetType isEqualToString:@"待发货"]) {
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
        path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:M_PI*2*0.6 clockwise:YES];
    }else if ([self.model.ordetType isEqualToString:@"待结算"]) {
        color1 = [HelperUtil colorWithHexString:@"00A3FF"];
        path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:M_PI*2*0.8 clockwise:YES];
    }else if ([self.model.ordetType isEqualToString:@"已完成"]) {
        color1 = [HelperUtil colorWithHexString:@"9CCC4E"];
        path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:M_PI*2*1 clockwise:YES];
    }else{
        color1 = [HelperUtil colorWithHexString:@"F03E3E"];
        path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:M_PI*2*1 clockwise:YES];
    }
//
//        UIColor *color1 = [HelperUtil colorWithHexString:@"00A3FF"];
        [color1 set];
//
//        float qqq = self.start/self.end;
//
//       __block UIBezierPath *path1;
//
//
//        if ([self.model.ordetType isEqualToString:@"已完成"]) {
//            path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:M_PI*2 clockwise:YES];
//        }else{
//            if (qqq>=0 && qqq<1) {
//                 path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:qqq*M_PI*2 clockwise:YES];
//            }else{
//                path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(25, 25) radius:22 startAngle:M_PI*0 endAngle:2*M_PI- 0.03*2*M_PI clockwise:YES];
//            }
//        }
//
//
        path1.lineWidth = 3.0;
        path1.lineCapStyle = kCGLineCapRound;
        path1.lineJoinStyle = kCGLineJoinRound;
        [path1 stroke];
//
//
//    }
    
    
}

- (void)drawProRectModel:(OrderModelForCapacity *)model
{
    _model = model;
    [self setNeedsDisplay];
}

- (void)drawProRect:(long)curttenTime all:(long)allTime Model:(OrderModelForCapacity *)model
{
    self.model = model;
    self.start = (float)curttenTime;
    self.end = (float)allTime;
    [self setNeedsDisplay];
}

@end
