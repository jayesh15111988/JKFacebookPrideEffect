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
    NSInteger numberOfColors = 6;
    
    UIImage* grayScaleImage = [inputImage toGrayscale];
    UIImageView* outputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 300, 250)];
    outputImageView.contentMode = UIViewContentModeScaleAspectFit;
    outputImageView.image = grayScaleImage;
    outputImageView.clipsToBounds = YES;
    [outputImageView setFrame:AVMakeRectWithAspectRatioInsideRect(inputImage.size, outputImageView.frame)];
    
    UIView* overlayContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, outputImageView.frame.size.width, outputImageView.frame.size.height)];
    overlayContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    overlayContainerView.clipsToBounds = YES;
    overlayContainerView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    CGFloat heightForEachLayer = outputImageView.frame.size.height / numberOfColors;
    CGFloat widthForEachLayer = outputImageView.frame.size.width / numberOfColors;
    CGFloat diagonalLength = (sqrt(pow(outputImageView.frame.size.height, 2) + pow(outputImageView.frame.size.width, 2)));
    CGFloat individualDiagonalBarWidth = diagonalLength/numberOfColors;
    
    CGFloat angle = atan(outputImageView.frame.size.height/outputImageView.frame.size.width);
    CGFloat initialValueAlongDiameter = individualDiagonalBarWidth/2.0;
    CGFloat dimensionsRatio = outputImageView.frame.size.height/outputImageView.frame.size.width;
    
    if (outputImageView.frame.size.height < outputImageView.frame.size.width) {
        dimensionsRatio = outputImageView.frame.size.width/outputImageView.frame.size.height;
    }
    
    [outputImageView addSubview:overlayContainerView];
    [outputImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[overlayContainerView]|" options:kNilOptions metrics:@{@"width": @(outputImageView.frame.size.width)} views:NSDictionaryOfVariableBindings(overlayContainerView)]];
    [outputImageView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[overlayContainerView]|" options:kNilOptions metrics:@{@"height": @(outputImageView.frame.size.height)} views:NSDictionaryOfVariableBindings(overlayContainerView)]];
    
    for (NSInteger i = 0; i < numberOfColors; i++) {
        
        CGRect overlayFrame;
        if (prideEffect == PrideEffectHorizontal) {
            overlayFrame = CGRectMake(0, i * heightForEachLayer, outputImageView.frame.size.width, heightForEachLayer);
        } else if (prideEffect == PrideEffectVertical) {
            overlayFrame = CGRectMake((i * widthForEachLayer), 0, widthForEachLayer, outputImageView.frame.size.height);
        } else {
            overlayFrame = CGRectMake((i * individualDiagonalBarWidth) + outputImageView.frame.origin.x, outputImageView.frame.origin.y, dimensionsRatio * diagonalLength, individualDiagonalBarWidth);
        }
        
        UIView *overlay = [[UIView alloc] initWithFrame:overlayFrame];
        [overlay setBackgroundColor:gayPrideColorsCollection[i]];
        overlay.alpha = 1.0;
        
        if (prideEffect == PrideEffectPositiveDiagonal || prideEffect == PrideEffectNegativeDiagonal) {
            CGFloat xCenterForCurrentBar = (prideEffect == PrideEffectPositiveDiagonal) ? (initialValueAlongDiameter * cos(angle)) : outputImageView.frame.size.width - (initialValueAlongDiameter * cos(angle));
            NSInteger multiplyingFactorForBarTransform = (prideEffect == PrideEffectPositiveDiagonal) ? -1 : 1;
            overlay.center = CGPointMake(xCenterForCurrentBar, (initialValueAlongDiameter * sin(angle)));
            overlay.transform = CGAffineTransformMakeRotation(multiplyingFactorForBarTransform * angle);
            initialValueAlongDiameter += individualDiagonalBarWidth;
        }
        [overlayContainerView addSubview:overlay];
    }
    return outputImageView;
}

@end
