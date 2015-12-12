//
//  UIImage+Tint.h
//  ImageBlend
//
//  Created by Daniel Kong on 15-11-29.
//  Copyright (c) 2015 DK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;
- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

@end
