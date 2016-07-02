//
//  AppDelegate.m
//  Horizon
//
//  Created by Hiro on 16/5/26.
//  Copyright © 2016年 Hiro. All rights reserved.
//

#import "AppDelegate.h"
#import "HRBaseClassViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "SecretKey.h"


//
#import "LaunchDemo.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//改
@import AVFoundation;
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // 初始化及注册社会化分享
    [self registerShare];
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor =[UIColor whiteColor];
    [self.window makeKeyAndVisible];
    HRBaseClassViewController *HRBVC=[[HRBaseClassViewController alloc]init] ;
    HRBVC.flag=1;
    self.window.rootViewController =HRBVC;
    //启动图
    
//    
    LaunchDemo *demo = [LaunchDemo new];
    demo.iconFrame = CGRectMake((SCREEN_WIDTH - 213) * 0.5, 80, 213, 54);
    demo.desLabelFreme = CGRectMake(0, SCREEN_HEIGHT - 34, SCREEN_WIDTH, 25);
    [demo loadLaunchImage:@"launchBg.png"
                 iconName:@"Horizon"
              appearStyle:JRApperaStyleOne
                  bgImage:@"launchBg.png"
                disappear:JRDisApperaStyleLeft
           descriptionStr:@"© Horizon 2016"];
    demo.desLabel.font = [UIFont systemFontOfSize:12];
    demo.desLabel.textColor = [UIColor whiteColor];
    //本地通知
    [self registerNotiTypes];
//    // 设置应用程序的图标右上角的数字
    [application setApplicationIconBadgeNumber:0];
    //改
    [[DataManager shareManager] getSIDArrayWithURLString:@"http://c.m.163.com/nc/video/home/0-10.html"
                                                 success:^(NSArray *sidArray, NSArray *videoArray) {
                                                     self.sidArray =[NSArray arrayWithArray:sidArray];
                                                     self.videoArray = [NSArray arrayWithArray:videoArray];
//                                                     NSLog(@"sidArray = %@",sidArray);
                                                 }
                                                  failed:^(NSError *error) {
                                                      
                                                  }];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance]
     setCategory: AVAudioSessionCategoryPlayback
     error: &setCategoryErr];
    [[AVAudioSession sharedInstance]
     setActive: YES
     error: &activationErr];
    

        return YES;
}
// 注册消息类型
- (void)registerNotiTypes {
    //    [UIApplication sharedApplication] registerUserNotificationSettings:<#(nonnull UIUserNotificationSettings *)#>
    // 判断系统版本
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        // 系统版本>=8.0
        
        UIUserNotificationType notiTypes = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notiTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        
        
    }
   
    

    
}
//
// 接收本地消息
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    NSLog(@"local:%@",notification);
    
    // 取消该消息的发送
    [self cancelNoti];
    
}

// 取消全部消息
- (void)cancelNoti {
    
    // 先获取本app中所有已安排的消息
    NSArray *arrNoti = [[UIApplication sharedApplication] scheduledLocalNotifications];
    
    for (UILocalNotification *localNoti in arrNoti) {
        

        [[UIApplication sharedApplication]cancelLocalNotification:localNoti];
        
    }
    
    
}

- (void)registerShare {
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:ShareAppKey
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
//                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:WeChatAppKey
                                       appSecret:WeChatSecret];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
    
}
//-(void)initSDK {
//     /**
//      *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
//      *  在将生成的AppKey传入到此方法中。
//      *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
//      *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
//      *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
//      */
//     [ShareSDK registerApp:@"1354f4bd6a049"
//      
//           activePlatforms:@[
//                             @(SSDKPlatformTypeSinaWeibo),
//                             @(SSDKPlatformTypeMail),
//                             @(SSDKPlatformTypeSMS),
//                             @(SSDKPlatformTypeCopy),
//                             @(SSDKPlatformTypeWechat),
//                             @(SSDKPlatformTypeQQ)]
//                  onImport:^(SSDKPlatformType platformType)
//      {
//          switch (platformType)
//          {
//              case SSDKPlatformTypeWechat:
//                  [ShareSDKConnector connectWeChat:[WXApi class]];
//                  break;
//              case SSDKPlatformTypeQQ:
//                  [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//                  break;
//              case SSDKPlatformTypeSinaWeibo:
//                  [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//                  break;
//                  
//              default:
//                  break;
//          }
//      }
//           onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
//      {
//          
//          switch (platformType)
//          {
//              case SSDKPlatformTypeSinaWeibo:
//                  //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                  [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
//                                            appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                                          redirectUri:@"http://www.sharesdk.cn"
//                                             authType:SSDKAuthTypeBoth];
//                  break;
//              case SSDKPlatformTypeWechat:
//                  [appInfo SSDKSetupWeChatByAppId:@"wx53227da9b0cd65be"
//                                        appSecret:@"acf5fc7b2e29928e4a56a9a26095d8ad"];
//                  break;
//              case SSDKPlatformTypeQQ:
//                  [appInfo SSDKSetupQQByAppId:@"100371282"
//                                       appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                     authType:SSDKAuthTypeBoth];
//                  break;
//                  
//              default:
//                  break;
//          }
//      }];
//}
+(AppDelegate *)shareAppDelegate{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
