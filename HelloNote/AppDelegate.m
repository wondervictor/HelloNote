//
//  AppDelegate.m
//  HelloNote
//
//  Created by VicChan on 3/31/16.
//  Copyright © 2016 VicChan. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "NavigationController.h"
#import "LoginViewController.h"

#import "UserInfo.h"
#import "NoteManager.h"


#import <BmobSDK/Bmob.h>

#define DEFAULT_COLOR   [UIColor colorWithRed:50/255.0 green:205/255.0 blue:50/255.0 alpha:0.98]


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bmob registerWithAppKey:@"d27154bf933451e31490cea0fbafd99e"];
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[UINavigationBar appearance]setBarTintColor:DEFAULT_COLOR];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *logined = [userDefaults objectForKey:@"username"];
    //检查用户登录状态
    
    // 是否需要登录。
    if (logined == nil) {
        LoginViewController *login = [[LoginViewController alloc]init];
        _window.rootViewController = login;
    }
    else {
        UserInfo *userInfo = [UserInfo sharedManager];
        
        NSString *pwd = [userDefaults objectForKey:@"pwd"];
        [userInfo setInfoWithName:logined password:pwd];
        NSLog(@"%@",logined);
        NoteManager *noteManager = [NoteManager sharedManager];
        [noteManager getCurrentUserInfo:userInfo];
        MainViewController *mainViewController = [[MainViewController alloc]init];
        NavigationController *nv = [[NavigationController alloc]initWithRootViewController:mainViewController];
        _window.rootViewController = nv;
    }
    [_window makeKeyAndVisible];
    // Override point for customization after application launch.
    return YES;
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
