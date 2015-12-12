//
//  AppDelegate.m
//  stock
//
//  Created by daniel on 4/23/15.
//  Copyright (c) 2015 DK. All rights reserved.
//

#import "AppDelegate.h"

#import "StockDetailViewController.h"
#import "EarningViewController.h"
#import "deerViewController.h"
#import "IPOListViewController.h"
#import "SettingViewController.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    UITabBarController *tabBars = [[UITabBarController alloc] init];
    tabBars.delegate = self;
    NSMutableArray *localViewControllersArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    StockDetailViewController *stockDetailVC = [[StockDetailViewController alloc] initWithNASDAQSymbol:@"WDAY"];
    stockDetailVC.tabBarItem.title = @"Chart";
    stockDetailVC.tabBarItem.image = [UIImage imageNamed:@"USDollar-25"];
    
    EarningViewController *earningListVC = [[EarningViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:earningListVC];
    earningListVC.tabBarItem.title = @"Earning";
    earningListVC.tabBarItem.image = [UIImage imageNamed:@"Pokemon-25"];
    
    deerViewController *deerVC = [[deerViewController alloc] init];
    deerVC.tabBarItem.title = @"Deer";
    deerVC.tabBarItem.image =[UIImage imageNamed:@"wild_animals_sign"];
    
    IPOListViewController *iposVC = [[IPOListViewController alloc] init];
    iposVC.tabBarItem.title = @"IPO";
    iposVC.tabBarItem.image =[UIImage imageNamed:@"world_cup"];
    
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    settingVC.tabBarItem.title = @"Setting";
    settingVC.tabBarItem.image =[UIImage imageNamed:@"Setting-25"];
    
    [localViewControllersArray addObject:navController];
    [localViewControllersArray addObject:stockDetailVC];
    [localViewControllersArray addObject:deerVC];
    [localViewControllersArray addObject:iposVC];
    [localViewControllersArray addObject:settingVC];

    tabBars.viewControllers =localViewControllersArray;
    tabBars.view.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    
    self.window.rootViewController = tabBars;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
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

# pragma mark - UITabBarController Delegate
// TODO separate later
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[EarningViewController class]]) {
//        [((EarningViewController *)viewController) reloadData];
    } else if ([viewController isKindOfClass:[IPOListViewController class]]) {
        [((IPOListViewController *)viewController) reloadData];
    } else if ([viewController isKindOfClass:[StockDetailViewController class]]) {
        [((StockDetailViewController *)viewController) reloadData];
    }
}

@end
