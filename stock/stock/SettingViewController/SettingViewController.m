//
//  SettingViewController.m
//  stock
//
//  Created by Daniel Kong on 12/1/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import "SettingViewController.h"
#import "DKNightVersion.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(self.view.frame.size.height / 2.0, 0, self.view.frame.size.width, self.view.frame.size.height / 2.0)];
    button.center = CGPointMake(self.view.center.x, self.view.center.y * 1.5);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    
    UIButton *switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchButton addTarget:self action:@selector(switchColor) forControlEvents:UIControlEventTouchUpInside];
    [switchButton setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 2.0)];
    switchButton.center = CGPointMake(self.view.center.x, self.view.center.y * 0.5);
    [switchButton setTitle:@"SwitchColor" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    [self.view addSubview:switchButton];
    
    @weakify(self);
    [self addColorChangedBlock:^{
        @strongify(self);
        self.view.normalBackgroundColor = [UIColor whiteColor];
        self.view.nightBackgroundColor = UIColorFromRGB(0x343434);
        button.normalTitleColor = [UIColor blueColor];
        button.nightTitleColor = [UIColor whiteColor];
        switchButton.normalTitleColor = [UIColor blueColor];
        switchButton.nightTitleColor = [UIColor whiteColor];
    }];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)switchColor {
    if ([DKNightVersionManager currentThemeVersion] == DKThemeVersionNormal) {
        [DKNightVersionManager nightFalling];
    } else {
        [DKNightVersionManager dawnComing];
    }
}

@end
