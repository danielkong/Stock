//
//  IPOListTableViewCell.m
//  stock
//
//  Created by Daniel Kong on 11/19/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import "IPOListTableViewCell.h"
#import "StockSetup.h"

#import "DKNightVersion.h"

static CGFloat const kContentPadding = 15.0;

@implementation IPOListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Additional Views
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft; //UITextAlignmentLeft; deprecate in iOS6.
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_titleLabel];
        
        _subTitle = [[UILabel alloc] init];
        _subTitle.contentMode = UIViewContentModeScaleToFill;
        //        _subImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_subTitle];
        
//        _leftTitle = [[UILabel alloc] init];
//        _leftTitle.contentMode = UIViewContentModeScaleAspectFill;
//        _leftTitle.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
//        [self.contentView addSubview:_leftTitle];
        
        _leftTitle = [[UILabel alloc] init];
        _leftTitle.textAlignment = NSTextAlignmentLeft;
        _leftTitle.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_leftTitle];

        
        _rightTitle = [[UILabel alloc] init];
        _rightTitle.textAlignment = NSTextAlignmentRight;
        _rightTitle.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_rightTitle];
        
        _rightSubTitle = [[UILabel alloc] init];
        _rightSubTitle.textAlignment = NSTextAlignmentRight;
        _rightSubTitle.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_rightSubTitle];
        
        //        _loadingView = [[WDLoadingView alloc] init];
        //        _loadingView.indicatorStyle = WDLoadingViewIndicatorStyleGray;
        //        [_loadingView stopAnimating];
        //        [self.contentView addSubview:_loadingView];
        
        _toggleText = [[UILabel alloc] init];
        _toggleText.text = @"Sort By";
        _toggleText.hidden = YES;
        _toggleText.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_toggleText];
        
        [self setupDefaults];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _titleLabel.text = @"";
//    _subImageView.image = nil;
    _subTitle.text = @"";
    _leftTitle.text = @"";
    _rightTitle.text = @"";
    _rightSubTitle.text = @"";
    _toggle.hidden = YES;
    // fix 'show toggleText on other cell'
    _toggleText.hidden = YES;
    
    [self setupDefaults];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentViewBounds = self.contentView.bounds;
    
    // TODO: This code will be removed once all cells use layouts
    //    CGFloat imageWidth = self.leftImageView.image ? [[self class] defaultImageSize].width : 0;
    //    CGFloat textSpacing = 5;
    
    
    CGRect contentRect = UIEdgeInsetsInsetRect(contentViewBounds, _contentEdgeInsets);
    
    CGRect leftImageRect, remainderRect;
    //    CGRectDivide
    CGRectDivide(contentRect, &leftImageRect, &remainderRect, 40.0, CGRectMinXEdge);
    CGRect leftImageRectWithInset = UIEdgeInsetsInsetRect(leftImageRect, UIEdgeInsetsMake(15, 0, 15, 15));
    self.leftTitle.frame = leftImageRectWithInset;
    
    CGRect centerRect, rightRect;
    CGRectDivide(remainderRect, &rightRect, &centerRect, 80.0, CGRectMaxXEdge);
//    self.rightTitle.frame = rightRect;
    
    CGRect titleRect, subTitleRect;
    CGRectDivide(centerRect, &titleRect, &subTitleRect, CGRectGetMidY(centerRect), CGRectMinYEdge);
    self.titleLabel.frame = titleRect;
    self.subTitle.frame = subTitleRect;
    
    CGRect rightTitleRect, rightSubTitleRect;
    CGRectDivide(rightRect, &rightTitleRect, &rightSubTitleRect, CGRectGetMidY(rightRect), CGRectMinYEdge);
    self.rightTitle.frame = rightTitleRect;
    self.rightSubTitle.frame = rightSubTitleRect;
    
    self.toggleText.frame = CGRectMake(self.rightTitle.frame.origin.x - 40, 2, 40, CGRectGetMidY(self.rightTitle.frame));
    self.toggle.frame = CGRectMake(self.rightTitle.frame.origin.x - 40, CGRectGetMidY(self.rightTitle.frame), 40, CGRectGetMidY(self.rightTitle.frame));
    
    @weakify(self);
    [self addColorChangedBlock:^() {
        @strongify(self);
        self.nightBackgroundColor = UIColorFromRGB(0x343434);
    }];
    
}

- (void)setLoading:(BOOL)loading {
    //    _loading = loading;
    //    self.textLabel.hidden = _loading;
    //    self.subtitleTextLabel.hidden = _loading;
    //    self.detailTextLabel.hidden = _loading;
    //    self.imageView.hidden = _loading;
    //    self.optionImageView.hidden = _loading;
    //    self.supplementaryImageView.hidden = _loading;
    //    if (_loading) {
    //        [_loadingView startAnimating];
    //    } else {
    //        [_loadingView stopAnimating];
    //    }
}

+ (CGSize)defaultImageSize
{
    CGFloat imageDiameter = (IS_IPHONE) ? 40 : 50;
    return CGSizeMake(imageDiameter, imageDiameter);
}

// setNeedsLayout after contentEdgeInsets changed
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    _contentEdgeInsets = contentEdgeInsets;
    [self setNeedsLayout];
}

- (void)setupDefaults
{
    //    self.backgroundColor = [UIColor clearColor];
    //    [self.textLabel applyLabelStyle:WDLabelStyleTitleDark];
    //    [self.subtitleTextLabel applyLabelStyle:WDLabelStyleBodyDark];
    //    [self.detailTextLabel applyLabelStyle:WDLabelStyleBodyDark];
    //
    //    self.loading = NO;
    
    //    CGFloat top, CGFloat left, CGFloat bottom, CGFloat right
    _contentEdgeInsets = UIEdgeInsetsMake(0, kContentPadding, 0, kContentPadding);
    
    //    self.imageView.image = nil;
    //    self.imageView.layer.shadowRadius = 0;
    //    self.imageView.layer.shadowColor = nil;
    //    self.imageView.layer.shadowOpacity = 0;
    //    self.imageView.layer.shadowOffset = CGSizeZero;
    //
    //    self.optionType = WDOptionTypeNone;
}

@end
