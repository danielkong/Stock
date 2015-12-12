//
//  StockSetup.h
//  stock
//
//  Created by Daniel Kong on 11/9/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_TALL_SCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)

// http://stackoverflow.com/questions/7848766/how-can-we-programmatically-detect-which-ios-version-is-device-running-on
#define IOS9 ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#if DEBUG

#ifndef StockSetup_h
#define StockSetup_h


#endif /* StockSetup_h */

#else // Release, Ad Hoc, AppStore

#define NSLog(format,...) // comment out to enable logging in release mode

#endif // DEBUG

//#import <WDCore/WDLogging.h>
//#import <WDCore/UIView+WDFrankAutomation.h>
//#import <WDCore/URLUtils.h>
//#import <WDCore/WDSettingsManager.h>
//#import <WDCore/WDFeatureManager.h>
//#import <WDCore/WDFeature.h>
//#import <WDCore/WDLocalization.h>
//#import <WDCore/WDApplicationManager.h>

