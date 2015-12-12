//
//  EarningTableViewCell.h
//  stock
//
//  Created by Daniel Kong on 11/8/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EarningTableViewCell;

@protocol EarningTableViewCellDelegate <NSObject>
// if no <NSObject>, then "no known instance method for selector 'respondsToSelector:' "

-(void)reloadEarningTableView:(EarningTableViewCell *)cell;
-(void)reloadEarningTableViewBySwitch:(id)sender;

@end


@interface EarningTableViewCell : UITableViewCell

// main text
@property (nonatomic, strong) UILabel *titleLabel;

// sub-title
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIImageView *subImageView;

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UILabel *rightTitle;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property (nonatomic, strong) UILabel *toggleText;
@property (nonatomic, strong) UISwitch *toggle;
@property (nonatomic, weak) id<EarningTableViewCellDelegate> delegate;

@end
