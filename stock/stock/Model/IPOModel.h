//
//  IPOListModel.h
//  stock
//
//  Created by Daniel Kong on 11/20/15.
//  Copyright © 2015 DK. All rights reserved.
//
//Company Name | Symbol | Market | Price | Shares | Offer | Amount | Expected IPO Date

#import "BaseModel.h"

@interface IPOModel : BaseModel


//tdArr[1]
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *market;
@property(nonatomic, copy) NSString *NASDAQSymbol;
//tdArr[2]
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *shares;
@property(nonatomic, copy) NSString *offerAmount;
@property(nonatomic, copy) NSString *expectedIPODate;



@end
