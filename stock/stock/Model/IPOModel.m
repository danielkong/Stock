//
//  IPOModel.m
//  stock
//
//  Created by Daniel Kong on 11/20/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import "IPOModel.h"

@implementation IPOModel
- (id)initWithHTMLTFHppleElement:(TFHppleElement *)element {
    NSArray * tdArr = [element searchWithXPathQuery:@"//td"];
    
    if ([tdArr count] > 1) {
        
        if ([tdArr count] == 4) {
            // filings
            self.name = [self trimContentSpace:[tdArr[0] content]];
            self.NASDAQSymbol = [self trimContentSpace:[tdArr[1] content]];
            self.offerAmount = [self trimContentSpace:[tdArr[2] content]];
            self.expectedIPODate = [self trimContentSpace:[tdArr[3] content]];

        } else {
            // type as coming and listed
            self.name = [self trimContentSpace:[tdArr[0] content]];
            self.NASDAQSymbol = [self trimContentSpace:[tdArr[1] content]];
            self.market = [self trimContentSpace:[tdArr[2] content]];
            self.price = [self trimContentSpace:[tdArr[3] content]];
            self.shares = [self trimContentSpace:[tdArr[4] content]];
            self.offerAmount = [self trimContentSpace:[tdArr[5] content]];
            self.expectedIPODate = [self trimContentSpace:[tdArr[6] content]];
        }

    } else {
        // introduction
        NSArray * thArr = [element searchWithXPathQuery:@"//th"];
        if ([thArr count] == 4) {
            self.name = [self trimContentSpace:[thArr[0] content]];
            self.NASDAQSymbol = [self trimContentSpace:[thArr[1] content]];
            self.offerAmount = [self trimContentSpace:[thArr[2] content]];
            self.expectedIPODate = [self trimContentSpace:[thArr[3] content]];
        } else {
            self.name = [self trimContentSpace:[thArr[0] content]];
            self.NASDAQSymbol = [self trimContentSpace:[thArr[1] content]];
            self.market = [self trimContentSpace:[thArr[2] content]];
            self.price = [self trimContentSpace:[thArr[3] content]];
            self.shares = [self trimContentSpace:[thArr[4] content]];
            self.offerAmount = [self trimContentSpace:[thArr[5] content]];
            self.expectedIPODate = [self trimContentSpace:[thArr[6] content]];
        }
    }

    return self;
}

# pragma mark - trim space and \n \t \r

- (NSString *)trimContentSpace:(NSString *)string {
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
