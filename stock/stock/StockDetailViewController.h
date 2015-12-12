//
//  StockDetailViewController.h
//  stock
//
//  Created by daniel on 4/23/15.
//  Copyright (c) 2015 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StockDetailViewController : UIViewController <UIScrollViewDelegate>

- (id)initWithNASDAQSymbol:(NSString *)string;

- (void)reloadData;

@end

