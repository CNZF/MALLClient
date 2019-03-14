//
//  AccontInfoController.m
//  MallClient
//
//  Created by lxy on 2018/6/27.
//  Copyright © 2018年 com.zhongche.cn. All rights reserved.
//

#import "AccontInfoController.h"
#import "AccountHeaderCell.h"
#import "UserViewModel.h"
#import "EnterpriseNameAuthenticationVC.h"
#import "EnterpriseValueAuthenticationVC.h"
#import "ChangePassWordVC.h"

@interface AccontInfoController ()  <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UserInfoModel * info;
@property (nonatomic, strong) UIImagePickerController * imagePickerController;//相机,相册
@property (nonatomic, strong) UIButton * commitBtn;
@end

@implementation AccontInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人资料";
    self.info = USER_INFO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 1?2:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountHeaderCell * cell;
    if (indexPath.section == 0) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AccountHeaderCell class]) owner:self options:nil] firstObject];
    }else if (indexPath.section ==1){
        if (indexPath.row == 0) {
            cell  = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AccountHeaderCell class]) owner:self options:nil][1];
        }else{
            cell  = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AccountHeaderCell class]) owner:self options:nil] [2];
        }
    }else{
        cell  =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AccountHeaderCell class]) owner:self options:nil][1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setsection:indexPath.section row:indexPath.row info:self.info];
    return cell;
}

#pragma mark ---Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [actionSheet showInView:self.view];
    }

    if (indexPath.section == 2) {
        [self.navigationController pushViewController:[ChangePassWordVC new] animated:YES];
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
#pragma mark -- UIActionSheetDelegate
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
#pragma mark -从摄像头获取图片或视频
- (void)selectImageFromCamera {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //相机类型（拍照、录像...）字符串需要做相应的类型转换
    self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    
    self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark -从相册获取图片或视频
- (void)selectImageFromAlbum {
    //NSLog(@"相册");
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}
#pragma mark -UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //        info[UIImagePickerControllerOriginalImage];//获得图片并处理
        
        UIImage *img = info[UIImagePickerControllerOriginalImage];
        
        UserViewModel *vm = [UserViewModel new];
        
        WS(ws);
        [vm submitUserAvatarwithId:[self.info.iden intValue] withAvatar:img callback:^(NSString *st) {
            
            ws.info.icon = st;
            [ws.tableView reloadData];
//            for ( UserInfoCellModel * model in ws.dataArray) {
//                if ([model.titleStr isEqualToString:@"头像"]) {
//                    model.imgStr = [NSString stringWithFormat:@"%@%@",BASEIMGURL,st];
//                    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",BASEIMGURL,st]);
//                    [ws.tbv reloadData];
//                    break;
//                }
//            }
     
        }];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressCommitBtn
{
    UserInfoModel *us = nil;
    [NSKeyedArchiver archiveRootObject:us toFile:[MyFilePlist documentFilePathStr:@"UserInfo.archive"]];
    [[Toast shareToast]makeText:@"退出登录成功" aDuration:1];
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIImagePickerController *)imagePickerController {
    if (!_imagePickerController)
    {
        UIImagePickerController * imgC = [[UIImagePickerController alloc] init];
        imgC.delegate = self;
        imgC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imgC.allowsEditing = NO;
        _imagePickerController = imgC;
    }
    return _imagePickerController;
}

- (UIButton *)commitBtn
{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_H-kNavBarHeaderHeight- kiPhoneFooterHeight-50, SCREEN_W, 50)];
        [_commitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_commitBtn setTitleColor:APP_COLOR_GRAY999 forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(pressCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H - kiPhoneFooterHeight-kNavBarHeaderHeight-50) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1];
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 100.0f;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AccountHeaderCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountHeaderCell class])];
        _tableView = tableView;
    }
    return _tableView;
}

@end
