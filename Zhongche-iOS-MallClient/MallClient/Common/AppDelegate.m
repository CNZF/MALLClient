//
//  AppDelegate.m
//  MallClient
//
//  Created by 中车_LL_iMac on 2016/11/8.
//  Copyright © 2016年 com.zhongche.cn. All rights reserved.
//

#import "AppDelegate.h"
#import "MallViewController.h"
#import "GudePageVi.h"
#import "BaiduMobStat.h"
#import "UserViewModel.h"
#import "SDWebImageDownloader.h"
#import "SDWebImageManager.h"
#import "MessageViewController.h"
#import "AdView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:2.0];
    
    //首次打开,配置数据
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpenAPP"]) {
        [self initializeTheAppModel];
    }
    _pinyinDictionary = [NSMutableDictionary dictionary];
    [_pinyinDictionary setObject:@"C" forKey:@"长"];
    [_pinyinDictionary setObject:@"S" forKey:@"沈"];
    [_pinyinDictionary setObject:@"X" forKey:@"厦"];
    [_pinyinDictionary setObject:@"C" forKey:@"重"];
    
    //配置百度统计
    [[BaiduMobStat defaultStat] startWithAppId:@"4536a1da26"];
    
    //初始化图片适配后缀
    _priceSuffix = [ZSEquipmentAttribute getPriceSuffix];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[MallViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    AdView * adView = [[AdView alloc] init];
    adView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    [self.window addSubview:adView];
    
//    self.adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
//    UIImageView * adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
//    adImageView.image = [UIImage imageNamed:@"s1"];
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onadViewSelect)];
//    [adImageView addGestureRecognizer:tap];
//    [self.adView addSubview:adImageView];
//
//    [self.window addSubview:self.adView];
    
    //引导页
//    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstOpenGudePageVi"]) {
//        [Defaults setObject:@YES forKey:@"isFirstOpenGudePageVi"];
//        GudePageVi * vi = [GudePageVi new];
//        [vi setGuideBlock:^{
//
//        }];
//        vi.frame = [UIScreen mainScreen].bounds;
//        [self.window addSubview:vi];
//    }
//
   
//
    
    SDWebImageDownloader *imgDownloader = SDWebImageManager.sharedManager.imageDownloader;
    imgDownloader.headersFilter  = ^NSDictionary *(NSURL *url, NSDictionary *headers) {

        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *imgKey = [SDWebImageManager.sharedManager cacheKeyForURL:url];
        NSString *imgPath = [SDWebImageManager.sharedManager.imageCache defaultCachePathForKey:imgKey];
        NSDictionary *fileAttr = [fm attributesOfItemAtPath:imgPath error:nil];

        NSMutableDictionary *mutableHeaders = [headers mutableCopy];

        NSDate *lastModifiedDate = nil;

        if (fileAttr.count > 0) {
            if (fileAttr.count > 0) {
                lastModifiedDate = (NSDate *)fileAttr[NSFileModificationDate];
            }
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        formatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss z";

        NSString *lastModifiedStr = [formatter stringFromDate:lastModifiedDate];
        lastModifiedStr = lastModifiedStr.length > 0 ? lastModifiedStr : @"";

        if (lastModifiedStr.length > 0) {
            [mutableHeaders setValue:lastModifiedStr forKey:@"If-Modified-Since"];
        }

        
        
        return mutableHeaders;
    };
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(nonnull id)annotation {

    NSString *stUrl = [url absoluteString];
    if([stUrl isEqualToString:@"mallclient://box"] ){

        [[Toast shareToast]makeText:@"加入购物车" aDuration:10];
    }else {
        
        [[Toast shareToast]makeText:@"立即租用" aDuration:10];
    }

    return YES;
}

-(void)initializeTheAppModel {

    NSUserDefaults * appdict = [NSUserDefaults standardUserDefaults];
    [appdict setObject:@YES forKey:@"isFirstOpenAPP"];
    [appdict setObject:@[@"北京",@"上海",@"广州",@"深圳"] forKey:@"cityHistory"];
    [appdict synchronize];
}

@end
