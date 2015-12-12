//
//  ERModel.m
//  stock
//
//  Created by Daniel Kong on 11/6/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERModel.h"

@implementation ERModel

- (id)initWithHTMLTFHppleElement:(TFHppleElement *)element {
    
    NSArray * tdArr = [element searchWithXPathQuery:@"//td"];

    
    if ([tdArr count] > 1) {
        
        //    tdArr[0] for pre-market/after-hour
//        (lldb) po [[[tdArr[0] searchWithXPathQuery:@"//img"] objectAtIndex:0] attributes]
//        {
//            alt = "After Hours Quotes";
//            height = 16;
//            src = "http://www.nasdaq.com/images/half_moon.jpg";
//            width = 16;
//        }

        
        // name, symbol and market cap.
        NSString *trimmedString = [self trimContentSpace:[tdArr[1] content]];
        NSArray *companyAndMarketCap = [trimmedString componentsSeparatedByString:@" Market Cap: "];
        if ([companyAndMarketCap count] > 1) {
            // confirmed by Zacks
            if ([[tdArr[0] searchWithXPathQuery:@"//img"] count] > 0) {
                if ([((TFHppleElement *)[[tdArr[0] searchWithXPathQuery:@"//img"] objectAtIndex:0]) objectForKey:@"src"]) {
                    self.timeImgUrlString = [((TFHppleElement *)[[tdArr[0] searchWithXPathQuery:@"//img"] objectAtIndex:0]) objectForKey:@"src"];
                }
            }
            else {
                self.timeImgUrlString = @"";
            }
            
            self.marketCap = companyAndMarketCap[1];
            NSMutableArray *companyWordAndSymbol = [[companyAndMarketCap[0] componentsSeparatedByString:@" "] mutableCopy];
            // symbol need remove (AAPL)
            self.NASDAQSymbol = [companyWordAndSymbol lastObject];
            self.NASDAQSymbol = [[self.NASDAQSymbol stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            [companyWordAndSymbol removeLastObject];
            self.name = [companyWordAndSymbol componentsJoinedByString:@" "];
            
            self.expReportDate = [self trimContentSpace:[tdArr[2] content]];
            self.fiscalQuarterEnding = [self trimContentSpace:[tdArr[3] content]];
            self.numOfEsts = [self trimContentSpace:[tdArr[4] content]];
            self.lastYearReportDate = [self trimContentSpace:[tdArr[5] content]];;
            self.lastYearEPS = [self trimContentSpace:[tdArr[6] content]];
        } else {
            // estimated by Zacks
            self.timeImgUrlString = @"estimated";
            trimmedString = [self trimContentSpace:[tdArr[0] content]];
            companyAndMarketCap = [trimmedString componentsSeparatedByString:@" Market Cap: "];
            self.marketCap = companyAndMarketCap[1];
            NSMutableArray *companyWordAndSymbol = [[companyAndMarketCap[0] componentsSeparatedByString:@" "] mutableCopy];
            // symbol need remove (AAPL)
            self.NASDAQSymbol = [companyWordAndSymbol lastObject];
            self.NASDAQSymbol = [[self.NASDAQSymbol stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            [companyWordAndSymbol removeLastObject];
            self.name = [companyWordAndSymbol componentsJoinedByString:@" "];
            
            self.expReportDate = [self trimContentSpace:[tdArr[1] content]];
            self.fiscalQuarterEnding = [self trimContentSpace:[tdArr[2] content]];
            self.numOfEsts = [self trimContentSpace:[tdArr[3] content]];
            self.lastYearReportDate = [self trimContentSpace:[tdArr[4] content]];;
            self.lastYearEPS = [self trimContentSpace:[tdArr[5] content]];
        }
        


        
        //Recommendation chart http://www.nasdaq.com//charts/WDAY_smallrm.jpeg
//        cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:modelItem.timeImgUrlString]]];
        
//        self.RecommendationChart = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.nasdaq.com//charts/%@_smallrm.jpeg",_NASDAQSymbol]]]];
    
    } else {
        // introduction
//        cell.textLabel.text = @"Company Name (Symbol)  Market Cap";
        self.name = @"Company Name";
        self.marketCap = @"Market Cap";
        self.NASDAQSymbol = @"Symbol";
        
        NSArray * thArr = [element searchWithXPathQuery:@"//th"];
        self.expReportDate = [self trimContentSpace:[thArr[2] content]];
        self.fiscalQuarterEnding = [self trimContentSpace:[thArr[3] content]];
        self.numOfEsts = [self trimContentSpace:[thArr[4] content]];
        self.lastYearReportDate = [self trimContentSpace:[thArr[5] content]];;
        self.lastYearEPS = [self trimContentSpace:[thArr[6] content]];
        
    }
    
    
    
    return self;
}



@end
