//
//  JKFacebookPrideEffect.m
//  JKFacebookPrideEffect
//
//  Created by Jayesh Kawli Backup on 8/4/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "JKFacebookPrideEffect.h"
#import "UIImage+toGrayScale.h"
#import "Constants.h"

@implementation JKFacebookPrideEffect

+ (UIImageView*)applyEffectToInputImage:(UIImage *)inputImage andEffectType:(PrideEffect)prideEffect andTextRequired:(BOOL)textRequired {
    
    NSArray* gayPrideColorsCollection = @[UIColorFromRGB(0xFF0000), UIColorFromRGB(0xFBA71C), UIColorFromRGB(0xFFFF01), UIColorFromRGB(0x30CA6A), UIColorFromRGB(0x057BB2), UIColorFromRGB(0x4C2D7B)];
    
    UIImage* grayScaleImage = [inputImage toGrayscale];
    UIImageView* outputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(44, 44, 300, 250)];
    outputImageView.contentMode = UIViewContentModeScaleAspectFit;
    outputImageView.image = grayScaleImage;
    [outputImageView setFrame:AVMakeRectWithAspectRatioInsideRect(inputImage.size, outputImageView.frame)];
    
    UIView* overlayContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, outputImageView.frame.size.width, outputImageView.frame.size.height)];
    overlayContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    overlayContainerView.clipsToBounds = YES;
    overlayContainerView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    
    
    [outputImageView addSubview:overlayContainerView];
    [outputImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hPadding-[overlayContainerView]|" options:kNilOptions metrics:@{@"width": @(outputImageView.frame.size.width), @"hPadding": @(0)} views:NSDictionaryOfVariableBindings(overlayContainerView)]];
    [outputImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vPadding-[overlayContainerView]|" options:kNilOptions metrics:@{@"height": @(outputImageView.frame.size.height), @"vPadding": @(0)} views:NSDictionaryOfVariableBindings(overlayContainerView)]];
    return outputImageView;
}

@end
