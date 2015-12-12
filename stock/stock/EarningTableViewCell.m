//
//  EarningTableViewCell.m
//  stock
//
//  Created by Daniel Kong on 11/8/15.
//  Copyright © 2015 DK. All rights reserved.
//

#import "EarningTableViewCell.h"
#import "StockSetup.h"

#import "DKNightVersion.h"

#import "UIImage+Tint.h"

static CGFloat const kContentPadding = 15.0;

@implementation EarningTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)cellStyle reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Additional Views
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft; //UITextAlignmentLeft; deprecate in iOS6.
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_titleLabel];
        
        _subImageView = [[UIImageView alloc] init];
        _subImageView.contentMode = UIViewContentModeScaleToFill;
//        _subImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_subImageView];
        
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFill;
        _leftImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_leftImageView];

        _rightTitle = [[UILabel alloc] init];
        _rightTitle.textAlignment = NSTextAlignmentRight;
        _rightTitle.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_rightTitle];

//        _loadingView = [[WDLoadingView alloc] init];
//        _loadingView.indicatorStyle = WDLoadingViewIndicatorStyleGray;
//        [_loadingView stopAnimating];
//        [self.contentView addSubview:_loadingView];
        
        _toggleText = [[UILabel alloc] init];
        _toggleText.text = @"Sort By";
        _toggleText.hidden = YES;
        _toggleText.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_toggleText];

        _toggle = [[UISwitch alloc] init];
        [_toggle sizeToFit];
        [_toggle addTarget:self action:@selector(switchTriggered:) forControlEvents:UIControlEventValueChanged];
        // change size
        _toggle.transform = CGAffineTransformMakeScale(0.55, 0.55);
        _toggle.hidden = YES;
        [self.contentView addSubview:_toggle];

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
    _subImageView.image = nil;
    _leftImageView.image = nil;
    _rightTitle.text = @"";
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
    self.leftImageView.frame = leftImageRectWithInset;
    
    CGRect centerRect, rightTitleRect;
    CGRectDivide(remainderRect, &rightTitleRect, &centerRect, 80.0, CGRectMaxXEdge);
    self.rightTitle.frame = rightTitleRect;
    
    CGRect titleRect, subTitleRect;
    CGRectDivide(centerRect, &titleRect, &subTitleRect, CGRectGetMidY(centerRect), CGRectMinYEdge);
    self.titleLabel.frame = titleRect;
    self.subImageView.frame = subTitleRect;
    
    self.toggleText.frame = CGRectMake(self.rightTitle.frame.origin.x - 40, 2, 40, CGRectGetMidY(self.rightTitle.frame));
    self.toggle.frame = CGRectMake(self.rightTitle.frame.origin.x - 40, CGRectGetMidY(self.rightTitle.frame), 40, CGRectGetMidY(self.rightTitle.frame));
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
    
    @weakify(self);
    [self addColorChangedBlock:^() {
        @strongify(self);
        
        self.titleLabel.normalTextColor = [UIColor darkGrayColor];
        self.titleLabel.nightTextColor = [UIColor yellowColor];
        
        self.normalBackgroundColor = [UIColor whiteColor];
        self.nightBackgroundColor = UIColorFromRGB(0x343434);
        
//        self.toggle.normalTitleColor = [UIColor blueColor];
//        switchButton.nightTitleColor = [UIColor whiteColor];
    
    }];
//    self.imageView.image = nil;
//    self.imageView.layer.shadowRadius = 0;
//    self.imageView.layer.shadowColor = nil;
//    self.imageView.layer.shadowOpacity = 0;
//    self.imageView.layer.shadowOffset = CGSizeZero;
//    
//    self.optionType = WDOptionTypeNone;
}

// TODO: this function may consider as util
//-(void)QZRectDivideWithPadding:(CGRect rect, CGRect *slice, CGRect *remainder, CGFloat amount, CGFloat padding, CGRectEdge edge) {
//    CGRect tmpSlice;
//    
//    CGRectDivide(rect, &tmpSlice, &rect, amount, edge);
//    if (slice) {
//        *slice = tmpSlice;
//    }
//    
//    CGRectDivide(rect, &tmpSlice, &rect, padding, edge);
//    if (remainder) {
//        *remainder = rect;
//    }
//}

#pragma mark - UISwitch

- (void)switchTriggered:(id)sender {
    UISwitch *onoff = (UISwitch *)sender;
    NSLog(@"%@", onoff.on ? @"On" : @"Off");
    if([self.delegate respondsToSelector:@selector(reloadEarningTableViewBySwitch:)]) {
        [self.delegate reloadEarningTableViewBySwitch:onoff];
    }
//    if (onoff.on) {
//        if([self.delegate respondsToSelector:@selector(reloadEarningTableView:)]) {
//            [self.delegate reloadEarningTableView:self];
//        }
//    }
    
//    if (_setting.settingType != WDSettingTypeSwitch) {
//        WDLogError(@"Somehow a switch callback was triggered on a non-switch setting");
//        return;
//    }
//    [_setting setCurrentValue:[NSNumber numberWithBool:_settingSwitch.on]];
//    
//    if ([_setting.userDefaultsKey isEqualToString:[kFeatureOverrideSettingsKeyPrefix stringByAppendingString:kWDFeatureP2PSettingsTransmission]]){
//        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kWDFeatureToggleChangedNotification object:nil]];
//    }
}

@end
