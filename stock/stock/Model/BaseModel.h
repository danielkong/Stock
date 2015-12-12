//
//  BaseModel.h
//  stock
//
//  Created by Daniel Kong on 11/3/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"

@interface BaseModel : NSObject <NSCopying>

@property (nonatomic, copy) NSString *value;

// XML Parsing
//- (id)initWithXMLDictionary:(NSDictionary *)xmlDictionary;
//- (void)updateWithXMLDictionary:(NSDictionary *)xmlDictionary;
//- (BOOL)needsModelTransform;
//- (BaseModel *)modelTransform;

// JSON Parsing
//- (id)initWithJSONDictionary:(NSDictionary *)jsonDictionary;
//- (void)updateWithJSONDictionary:(NSDictionary *)jsonDictionary; // Remember to call [super updateWithJSONDictionary:] _last_!

// HTML Parsing
- (id)initWithHTMLTFHppleElement:(TFHppleElement *)element;

//- (void)didFinishParsing; //must call super!
//- (void)didFinishParsingXML; // must call super first!
//- (void)didFinishParsingJSON;

//- (void)updateEditValue:(id)editValue;
//- (void)updateWithModel:(BaseModel *)model;

# pragma mark - common function

- (NSString *)trimContentSpace:(NSString *)string;

@end
