//
//  OrderDetailHeadView.m
//  MallClient
//
//  Created by lxy on 2018/6/6.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "OrderDetailHeadView.h"


@interface OrderDetailHeadView()
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *newcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image_width;

@property (nonatomic, strong) UIImage * codeImage;

@end

@implementation OrderDetailHeadView

//orderDetailTime

//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
//        [tap addTarget:self action:@selector(onTap)];
//        [self.newcodeImageView addGestureRecognizer:tap];
//    }
//    return self;
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(onTap)];
    [self.newcodeImageView addGestureRecognizer:tap];
}



- (void)onTap
{
    if ([self.model.ordetType isEqualToString:@"待发货"] || [self.model.ordetType isEqualToString:@"待收货"]) {
        if (self.ClickBlcok) {
            self.ClickBlcok(self.codeImage);
        }
    }
}

- (void)setModel:(OrderModelForCapacity *)model
{
    _model = model;
    self.stateLabel.text = model.ordetType;
    if ([model.ordetType isEqualToString:@"待发货"] || [model.ordetType isEqualToString:@"待收货"]) {
        [self setMessage:model.orderID];
    }
    long long curtten;
    if ([model.ordetType isEqualToString:@"已完成"] || [model.ordetType isEqualToString:@"已取消"]) {
        OrderProgressModel * ordeModel = model.orderProgress.firstObject;
        curtten = [ordeModel.time longLongValue];
    }else{
        curtten = [self getCurrentDate];
    }
    
    long long allhSecond = curtten - [model.submitTime longLongValue];
    long long second  = allhSecond/1000;
    NSString * totle = [self timeFormatted:second];
    self.timeLabel.text = totle;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)setMessage:(NSString *)message {
    
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    NSString *dataString = message;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    CIImage *outputImage = [filter outputImage];
    // 5.将CIImage转换成UIImage，并放大显示
    UIImage * codeI = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:150];
    self.newcodeImageView.image = self.codeImage = codeI;
    
}

- (long long)getCurrentDate
{
    
    return [[NSDate date] timeIntervalSince1970]*1000;
}
- (NSString *)timeFormatted:(long long)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    long hours = totalSeconds / 3600 %24;
    long day = totalSeconds/(24*3600);
    if (day == 0&& hours == 0&& minutes == 0) {
        return [NSString stringWithFormat:@"%02d秒",seconds];
    }else
        if (day == 0&& hours == 0) {
            return [NSString stringWithFormat:@"%02d分%02d秒", minutes, seconds];
        }else
            if (day == 0) {
                return [NSString stringWithFormat:@"%02ld时%02d分%02d秒",hours, minutes, seconds];
            }else{
                return [NSString stringWithFormat:@"%ld天%02ld时%02d分%02d秒",day,hours, minutes, seconds];
            }
    
}
@end
