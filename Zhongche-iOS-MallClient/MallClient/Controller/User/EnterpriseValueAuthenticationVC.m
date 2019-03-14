//
//  EnterpriseValueAuthenticationVC.m
//  MallClient
//
//  Created by lxy on 2017/2/6.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EnterpriseValueAuthenticationVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UserViewModel.h"

@interface EnterpriseValueAuthenticationVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UIImageView *ivCurrent;
@property (nonatomic, strong) UIButton    *btnSubmit;
@property (nonatomic, strong) UILabel     *lb1;
@property (nonatomic, strong) UILabel     *lb2;
@property (nonatomic, strong) UIView      *vi1;
@property (nonatomic, strong) UIImageView *iv1;
@property (nonatomic, strong) UIButton    *btn1;
@property (nonatomic, strong) UIImage     *im1;//请上传道路运输经营许可证图片

@end

@implementation EnterpriseValueAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
}

- (void)bindView {

    self.title = @"企业资质认证";

    self.view.backgroundColor  =[UIColor groupTableViewBackgroundColor];

    self.lb1.frame = CGRectMake(20, 0, SCREEN_W, 40);
    [self.view addSubview:self.lb1];

    self.btnSubmit.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.btnSubmit];

    self.lb1.frame = CGRectMake(20, 0, SCREEN_W, 40);
    [self.view addSubview:self.lb1];

    self.vi1.frame = CGRectMake(0, self.lb1.bottom, SCREEN_W, 150);
    [self.view addSubview:self.vi1];

    self.iv1.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi1 addSubview:self.iv1];

    self.btn1.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi1 addSubview:self.btn1];

    self.lb2.frame = CGRectMake(20, self.vi1.bottom, SCREEN_W, 40);
    [self.view addSubview:self.lb2];
}

- (void)onBackAction {

    if (self.status == 1) {

        [self.navigationController popViewControllerAnimated:YES];

    }else {
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

//设置图片按钮点击事件
- (void)chooseImage:(UIButton *)btn {

    [self.view endEditing:YES];

    if (btn.tag == 11) {
        self.ivCurrent = self.iv1;
    }

    self.ivCurrent.tag = btn.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];

}

//图片设置
- (void)imgSet{

    if (self.ivCurrent.tag ==11) {
        self.im1 = self.ivCurrent.image;
    }

    if (self.im1) {
        [self.btnSubmit setBackgroundColor:APP_COLOR_BLUE_BTN];
    }
}

//上传图片
- (void)submitAction {


    if (self.im1) {

        UserViewModel *vm = [UserViewModel new];
        WS(ws);


        
        
        [vm submitPhotoForEnterpriseValueAuthenticationWithPhoto:self.im1 callback:^(NSString *st) {

            [ws.navigationController popToRootViewControllerAnimated:YES];


        }];


    }else {

        [[Toast shareToast]makeText:@"图片信息不完整" aDuration:1];
    }

}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera {
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;


    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    _imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum {
    //NSLog(@"相册");
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //按照按钮的顺序0-N；
    switch (buttonIndex) {
        case 0:
            [self selectImageFromCamera];
            break;

        case 1:
            [self selectImageFromAlbum];
            break;


        default:
            break;
    }

}



#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    self.ivCurrent.image = image;
    [self imgSet];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        self.ivCurrent.image = info[UIImagePickerControllerOriginalImage];
        [self imgSet];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  get(懒加载)
 */
- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"请上传道路运输经营许可证";

        _lb1 = label;
    }
    return _lb1;
}

- (UIButton *)btnSubmit {
    if (!_btnSubmit) {
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:APP_COLOR_GRAY_BTN_1];
        [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];

        _btnSubmit = button;
    }
    return _btnSubmit;
}

- (UIView *)vi1 {
    if (!_vi1) {
        _vi1 = [UIView new];
        _vi1.backgroundColor = [UIColor whiteColor];
    }
    return _vi1;
}

- (UIImageView *)iv1 {
    if (!_iv1) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"submit1"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv1 = imageView;
    }
    return _iv1;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 11;


        _btn1 = button;
    }
    return _btn1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"提示：通过个人和企业实名认证，可以购买运力";

        _lb2 = label;
    }
    return _lb2;
}


@end
