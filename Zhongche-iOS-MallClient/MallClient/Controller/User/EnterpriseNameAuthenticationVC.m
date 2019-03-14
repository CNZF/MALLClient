//
//  EnterpriseNameAuthenticationVC.m
//  MallClient
//
//  Created by lxy on 2017/2/6.
//  Copyright © 2017年 com.zhongche.cn. All rights reserved.
//

#import "EnterpriseNameAuthenticationVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UserViewModel.h"
#import "PhotoInfo.h"
#import "EnterpriseValueAuthenticationVC.h"
#import "ViImg.h"
#import "UserInfoVC.h"

@interface EnterpriseNameAuthenticationVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UIScrollView *scroView;
@property (nonatomic, strong) UIImageView  *ivCurrent;
@property (nonatomic, strong) UIButton     *btnSubmit;
/**
 *  命名原则 1、申请公函  2、营业执照  3、组织机构代码证/最新营业执照（适用三证合一）4、税务登记证
 */
@property (nonatomic, strong) UILabel *lb1;
@property (nonatomic, strong) UILabel *lb2;
@property (nonatomic, strong) UILabel *lb3;
@property (nonatomic, strong) UILabel *lb4;
@property (nonatomic, strong) UILabel *lb5;

@property (nonatomic, strong) UIView  *vi1;
@property (nonatomic, strong) UIView  *vi2;
@property (nonatomic, strong) UIView  *vi3;
@property (nonatomic, strong) UIView  *vi4;

@property (nonatomic, strong) UIImageView *iv1;
@property (nonatomic, strong) UIImageView *iv2;
@property (nonatomic, strong) UIImageView *iv3;
@property (nonatomic, strong) UIImageView *iv4;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;

@property (nonatomic, strong) UIImage *im1;
@property (nonatomic, strong) UIImage *im2;
@property (nonatomic, strong) UIImage *im3;
@property (nonatomic, strong) UIImage *im4;

@property (nonatomic, strong) UIButton *btnAdvance;

@end

@implementation EnterpriseNameAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = NO;
}

- (void)bindView {

   

//    self.title = @"企业实名认证";

    self.scroView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H - 64 - 50);
    [self.view addSubview:self.scroView];

    self.btnSubmit.frame = CGRectMake(0, SCREEN_H - 64 - 50, SCREEN_W, 50);
    [self.view addSubview:self.btnSubmit];

    self.lb1.frame = CGRectMake(20, 0, SCREEN_W, 40);
    [self.scroView addSubview:self.lb1];
    
    self.btnAdvance.frame = CGRectMake(SCREEN_W - 120, 0, 100, 40);
    [self.scroView addSubview:self.btnAdvance];

    self.vi1.frame = CGRectMake(0, self.lb1.bottom, SCREEN_W, 150);
    [self.scroView addSubview:self.vi1];

    self.lb2.frame = CGRectMake(20, self.vi1.bottom +10, SCREEN_W, 40);
    [self.scroView addSubview:self.lb2];

    self.vi2.frame = CGRectMake(0, self.lb2.bottom, SCREEN_W, 150);
    [self.scroView addSubview:self.vi2];

    self.lb3.frame = CGRectMake(20, self.vi2.bottom +10, SCREEN_W, 40);
    [self.scroView addSubview:self.lb3];

    self.vi3.frame = CGRectMake(0, self.lb3.bottom, SCREEN_W, 150);
    [self.scroView addSubview:self.vi3];

    self.lb4.frame = CGRectMake(20, self.vi3.bottom +10, SCREEN_W, 40);
    [self.scroView addSubview:self.lb4];

    self.vi4.frame = CGRectMake(0, self.lb4.bottom, SCREEN_W, 150);
    [self.scroView addSubview:self.vi4];

    self.lb5.frame = CGRectMake(20, self.vi4.bottom + 10, SCREEN_W, 40);
    [self.scroView addSubview:self.lb5];

    self.scroView.contentSize = CGSizeMake(SCREEN_W, self.vi4.bottom + 80);

    self.iv1.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi1 addSubview:self.iv1];

    self.iv2.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi2 addSubview:self.iv2];

    self.iv3.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi3 addSubview:self.iv3];

    self.iv4.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi4 addSubview:self.iv4];

    self.btn1.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi1 addSubview:self.btn1];

    self.btn2.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi2 addSubview:self.btn2];

    self.btn3.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi3 addSubview:self.btn3];

    self.btn4.frame = CGRectMake(SCREEN_W/2 - 100, 15, 200, 120);
    [self.vi4 addSubview:self.btn4];

    if(self.type == 1) {

        self.lb3.hidden  = YES;
        self.lb4.hidden  = YES;
        self.iv3.hidden  = YES;
        self.iv4.hidden  = YES;
        self.btn3.hidden = YES;
        self.btn4.hidden = YES;
        self.vi3.hidden  = YES;
        self.vi4.hidden  = YES;

        self.lb5.frame = CGRectMake(20, self.vi2.bottom + 10, SCREEN_W, 40);
        [self.scroView addSubview:self.lb5];
        self.scroView.contentSize = CGSizeMake(SCREEN_W, self.lb5.bottom);

        self.lb2.text = @"含统一信用代码的营业执照";


    }




}

//设置图片按钮点击事件
- (void)chooseImage:(UIButton *)btn {

    [self.view endEditing:YES];

    if (btn.tag == 11) {
        self.ivCurrent = self.iv1;
    }
    if (btn.tag == 12) {
        self.ivCurrent = self.iv2;
    }
    if (btn.tag == 13) {
        self.ivCurrent = self.iv3;
    }
    if (btn.tag == 14) {
        self.ivCurrent = self.iv4;
    }
    self.ivCurrent.tag = btn.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];

}

//图片设置
- (void)imgSet {

    if (self.ivCurrent.tag ==11) {
        self.im1 = self.ivCurrent.image;
    }
    if (self.ivCurrent.tag ==12) {
        self.im2 = self.ivCurrent.image;
    }
    if (self.ivCurrent.tag ==13) {
        self.im3 = self.ivCurrent.image;
    }
    if (self.ivCurrent.tag ==14) {
        self.im4 = self.ivCurrent.image;
    }

   if ((self.im1 &&self.im2 &&self.im3 &&self.im4)||(self.im1 &&self.im2 &&self.type == 1)) {
       
        [self.btnSubmit setBackgroundColor:APP_COLOR_BLUE_BTN];

   }
}

//引导加载
- (void)advanceAction {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    ViImg *vi = [ViImg new];
    vi.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);

    [window addSubview: vi];

}

//上传图片
- (void)submitAction {


    if ((self.im1 &&self.im2 &&self.im3 &&self.im4)||(self.im1 &&self.im2 &&self.type == 1)) {

        PhotoInfo *pInfo = [PhotoInfo new];
        pInfo.img1 = self.im1;
        pInfo.img2 = self.im2;
        pInfo.img3 = self.im3;
        pInfo.img4 = self.im4;

        UserViewModel *vm = [UserViewModel new];
        WS(ws);
        [vm submitPhotoForEnterpriseNameAuthenticationWithPhoto:pInfo callback:^(NSString *st) {


            if (ws.status == 1) {

                [ws.navigationController pushViewController:[UserInfoVC new] animated:YES];
                
            }else {

                 [ws.navigationController pushViewController:[EnterpriseValueAuthenticationVC new] animated:YES];

            }



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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        self.ivCurrent.image = info[UIImagePickerControllerOriginalImage];
        [self imgSet];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

/**
 *  get(懒加载)
 */

- (UIScrollView *)scroView {
    if (!_scroView) {
        _scroView = [UIScrollView new];
        _scroView.delegate = self;
        _scroView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    }
    return _scroView;
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

- (UILabel *)lb1 {
    if (!_lb1) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"申请公函";

        _lb1 = label;
    }
    return _lb1;
}

- (UILabel *)lb2 {
    if (!_lb2) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"营业执照";

        _lb2 = label;
    }
    return _lb2;
}

- (UILabel *)lb3 {
    if (!_lb3) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"组织机构代码证";
        _lb3 = label;
    }
    return _lb3;
}

- (UILabel *)lb4 {
    if (!_lb4) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"税务登记证";

        _lb4 = label;
    }
    return _lb4;
}

- (UILabel *)lb5 {
    if (!_lb5) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = APP_COLOR_GRAY_TEXT_1;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.text = @"提示：通过个人和企业实名认证，可以购买运力";

        _lb5 = label;
    }
    return _lb5;
}

- (UIView *)vi1 {
    if (!_vi1) {
        _vi1 = [UIView new];
        _vi1.backgroundColor = [UIColor whiteColor];
    }
    return _vi1;
}

- (UIView *)vi2 {
    if (!_vi2) {
        _vi2 = [UIView new];
        _vi2.backgroundColor = [UIColor whiteColor];

    }
    return _vi2;
}

- (UIView *)vi3 {
    if (!_vi3) {
        _vi3 = [UIView new];
        _vi3.backgroundColor = [UIColor whiteColor];
    }
    return _vi3;
}

- (UIView *)vi4 {
    if (!_vi4) {
        _vi4 = [UIView new];
        _vi4.backgroundColor = [UIColor whiteColor];
    }
    return _vi4;
}

- (UIImageView *)iv1 {
    if (!_iv1) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"submit3"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv1 = imageView;
    }
    return _iv1;
}

- (UIImageView *)iv2 {
    if (!_iv2) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"submit2"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv2 = imageView;
    }
    return _iv2;
}

- (UIImageView *)iv3 {
    if (!_iv3) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"submit4"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;


        _iv3 = imageView;
    }
    return _iv3;
}

- (UIImageView *)iv4 {
    if (!_iv4) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"submit5"];
        imageView.contentMode = UIViewContentModeScaleAspectFit;

        _iv4 = imageView;
    }
    return _iv4;
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

- (UIButton *)btn2 {
    if (!_btn2) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 12;


        _btn2 = button;
    }
    return _btn2;
}

- (UIButton *)btn3 {
    if (!_btn3) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 13;


        _btn3 = button;
    }
    return _btn3;
}

- (UIButton *)btn4 {
    if (!_btn4) {
        UIButton *button = [[UIButton alloc]init];
        [button addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 14;
        
        _btn4 = button;
    }
    return _btn4;
}

- (UIButton *)btnAdvance {
    if (!_btnAdvance) {
        UIButton *button = [[UIButton alloc]init];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button setTitle:@"格式预览" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(advanceAction) forControlEvents:UIControlEventTouchUpInside];


        _btnAdvance = button;
    }
    return _btnAdvance;
}


@end


