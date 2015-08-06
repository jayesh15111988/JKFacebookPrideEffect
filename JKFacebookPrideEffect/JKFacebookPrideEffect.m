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

@interface JKFacebookPrideEffect ()

@property (strong, nonatomic) UIImageView* outputImageView;
@property (assign, nonatomic) CGSize outputImageViewSize;

@end

@implementation JKFacebookPrideEffect

static NSArray* gayPrideColorsCollection;
static NSInteger numberOfColors;

+ (void)load {
    gayPrideColorsCollection = @[UIColorFromRGB(0xFF0000), UIColorFromRGB(0xFBA71C), UIColorFromRGB(0xFFFF01), UIColorFromRGB(0x30CA6A), UIColorFromRGB(0x057BB2), UIColorFromRGB(0x4C2D7B)];
    numberOfColors = 6;
    NSAssert([gayPrideColorsCollection count] == numberOfColors, @"Number of colors should match the size of array holding successive color values");
    NSAssert(numberOfColors > 0, @"You must supply at least one color value");
}

- (instancetype)initWithInputImage:(UIImage *)inputImage andSize:(CGSize)size {
    
    if (self = [super init]) {
        UIImage* grayScaleImage = [inputImage toGrayscale];
        _outputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _outputImageView.contentMode = UIViewContentModeScaleAspectFit;
        _outputImageView.image = grayScaleImage;
        _outputImageView.clipsToBounds = YES;
        [_outputImageView setFrame:AVMakeRectWithAspectRatioInsideRect(inputImage.size, _outputImageView.frame)];
            _outputImageViewSize = size;
        _prideEffect = PrideEffectHorizontal;
        _textRequired = NO;
        _overlayAlpha = 0.6;
    }
    return self;
}

- (UIImageView*)applyEffect {
    CGFloat heightForEachColorBar = _outputImageView.frame.size.height / numberOfColors;
    CGFloat widthForEachColorBar = _outputImageView.frame.size.width / numberOfColors;
    CGFloat diagonalLength = (sqrt(pow(_outputImageView.frame.size.height, 2) + pow(_outputImageView.frame.size.width, 2)));
    CGFloat individualDiagonalBarWidth = diagonalLength / numberOfColors;
    
    CGFloat diagonalAngle =  atan(_outputImageView.frame.size.height / _outputImageView.frame.size.width);
    UIView* overlayContainerView = [[UIView alloc] init];
    overlayContainerView.clipsToBounds = YES;
    
    if (_prideEffect == PrideEffectPositiveDiagonal || _prideEffect == PrideEffectNegativeDiagonal) {
        overlayContainerView.frame = CGRectMake(0, 0, diagonalLength, diagonalLength);
        overlayContainerView.center = CGPointMake(CGRectGetWidth(_outputImageView.frame)/2, CGRectGetHeight(_outputImageView.frame)/2);
    } else {
        overlayContainerView.frame = CGRectMake(0, 0, _outputImageView.frame.size.width, _outputImageView.frame.size.height);
    }
    
    for (NSInteger i = 0; i < numberOfColors; i++) {
        CGRect overlayFrame;
        if (_prideEffect == PrideEffectHorizontal) {
            overlayFrame = CGRectMake(0, i * heightForEachColorBar, _outputImageView.frame.size.width, heightForEachColorBar);
        } else if (_prideEffect == PrideEffectVertical) {
            overlayFrame = CGRectMake((i * widthForEachColorBar), 0, widthForEachColorBar, _outputImageView.frame.size.height);
        } else {
            overlayFrame = CGRectMake(0, i * individualDiagonalBarWidth, diagonalLength, individualDiagonalBarWidth);
        }
        UIView *overlay = [[UIView alloc] initWithFrame:overlayFrame];
        [overlay setBackgroundColor:gayPrideColorsCollection[i]];
        overlay.alpha = _overlayAlpha;
        [overlayContainerView addSubview:overlay];
    }
    
    [_outputImageView addSubview:overlayContainerView];
    if (_prideEffect == PrideEffectPositiveDiagonal) {
        overlayContainerView.transform = CGAffineTransformMakeRotation(-diagonalAngle);
    } else if(_prideEffect == PrideEffectNegativeDiagonal) {
        overlayContainerView.transform = CGAffineTransformMakeRotation(diagonalAngle);
    }
    return _outputImageView;
}

@end
