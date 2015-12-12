//
//  IPOListTableViewCell.h
//  stock
//
//  Created by Daniel Kong on 11/19/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPOListTableViewCell : UITableViewCell

// main text
@property (nonatomic, strong) UILabel *titleLabel;

// sub-title
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIImageView *subImageView;

@property (nonatomic, strong) UILabel *leftTitle;

@property (nonatomic, strong) UILabel *rightTitle;
@property (nonatomic, strong) UILabel *rightSubTitle;

@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;

@property (nonatomic, strong) UILabel *toggleText;
@property (nonatomic, strong) UISwitch *toggle;

@end
