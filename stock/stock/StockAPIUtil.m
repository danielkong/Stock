//
//  StockAPIUtil.m
//  stock
//
//  Created by daniel on 4/29/15.
//  Copyright (c) 2015 DK. All rights reserved.
//

#import "StockAPIUtil.h"

@implementation StockAPIUtil

+(NSString*) getValidString:(NSString*)string {
    if (![string isKindOfClass:[NSString class]] || [string isKindOfClass:[NSNull class]]){
        return @"-";
    }
    return string;
}

+(NSString*) getVolumeString:(NSString*)data {
    if (nil == data || [data isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    if ([data isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)(data);
        return [number stringValue];
    }
    
    if (![data isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if ([data intValue]/1000000 || [data intValue]/100000) {
        return [NSString stringWithFormat:@"%.02fM", (double)[data intValue]/1000000];
    } else if ([data intValue]/1000) {
        return [NSString stringWithFormat:@"%.02fK", (double)[data intValue]/1000];

    }
        
    return data;
}

+(NSString*) getValidRatio:(NSString*)data {
    if (nil == data || [data isKindOfClass:[NSNull class]]) {
        return @"-";
    }
    
    if ([data isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)(data);
        return [number stringValue];
    }
    
    if (![data isKindOfClass:[NSString class]]) {
        return @"-";
    }
    
    // convert to 2 digit after dot.
    NSString* formattedNumber = [NSString stringWithFormat:@"%.02f", [data floatValue]];
    return formattedNumber;
}

@end
