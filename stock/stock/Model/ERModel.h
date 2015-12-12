//
//  ERModel.h
//  stock
//
//  Created by Daniel Kong on 11/6/15.
//  Copyright © 2015 DK. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BaseModel.h"
@class UIImage;

@interface ERModel : BaseModel

//tdArr[0]
@property(nonatomic, copy) NSString *timeImgUrlString;
//tdArr[1]
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *marketCap;
@property(nonatomic, copy) NSString *NASDAQSymbol;
//tdArr[2]
@property(nonatomic, copy) NSString *expReportDate;
@property(nonatomic, copy) NSString *fiscalQuarterEnding;
@property(nonatomic, copy) NSString *EPSforecast;
@property(nonatomic, copy) NSString *numOfEsts;
@property(nonatomic, copy) NSString *lastYearReportDate;
@property(nonatomic, copy) NSString *lastYearEPS;

// Recommendation Small Chart
@property(nonatomic, strong) UIImage *RecommendationChart;


@end
