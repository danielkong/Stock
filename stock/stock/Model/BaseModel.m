//
//  BaseModel.m
//  stock
//
//  Created by Daniel Kong on 11/3/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import "BaseModel.h"
#import "TFHpple.h"

@implementation BaseModel

- (id)initWithHTMLTFHppleElement:(TFHppleElement *)element {
    // must override in different cases.
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
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
