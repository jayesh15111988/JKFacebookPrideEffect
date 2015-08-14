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
@property (assign, nonatomic) CGFloat overlayAlpha;

@end

@implementation JKFacebookPrideEffect

const  NSTextAlignment NSTextAlignmentAlternate = 7;
static NSArray* gradientStartPointsCollection;
static NSArray* gradientEndPointsCollection;
static NSArray* gayPrideColorsCollection;
static NSArray* gayPrideCGRefColorsCollection;
static NSArray* colorLabelTexts;
static NSInteger numberOfColors;

+ (void)load {
    gayPrideColorsCollection = @[UIColorFromRGB(0xFF0000), UIColorFromRGB(0xFBA71C), UIColorFromRGB(0xFFFF01), UIColorFromRGB(0x30CA6A), UIColorFromRGB(0x057BB2), UIColorFromRGB(0x4C2D7B)];
    gayPrideCGRefColorsCollection = @[(__bridge id) UIColorFromRGB(0xFF0000).CGColor, (__bridge id) UIColorFromRGB(0xFBA71C).CGColor, (__bridge id) UIColorFromRGB(0xFFFF01).CGColor, (__bridge id) UIColorFromRGB(0x30CA6A).CGColor, (__bridge id) UIColorFromRGB(0x057BB2).CGColor, (__bridge id) UIColorFromRGB(0x4C2D7B).CGColor];
    gradientStartPointsCollection = @[[NSValue valueWithCGPoint:CGPointMake(1, 0)], [NSValue valueWithCGPoint:CGPointMake(0, 1)], [NSValue valueWithCGPoint:CGPointMake(0, 0)], [NSValue valueWithCGPoint:CGPointMake(1, 0)]];
    gradientEndPointsCollection = @[[NSValue valueWithCGPoint:CGPointMake(1, 1)], [NSValue valueWithCGPoint:CGPointMake(1, 1)], [NSValue valueWithCGPoint:CGPointMake(1, 1)], [NSValue valueWithCGPoint:CGPointMake(0, 1)]];
    // Ref : https://en.wikipedia.org/wiki/Rainbow_flag_(LGBT_movement)
    colorLabelTexts = @[@"LIFE", @"HEALING", @"SUNLIGHT", @"NATURE", @"HARMONY", @"SPIRIT"];
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
        _overlayTextFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        _overlayTextColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        _variableTextColors = YES;
    }
    return self;
}

- (UIImage*)applyEffect {
    CGFloat heightForEachColorBar = _outputImageView.frame.size.height / numberOfColors;
    CGFloat widthForEachColorBar = _outputImageView.frame.size.width / numberOfColors;
    UIView* overlayContainerView = [[UIView alloc] init];
    
    if (self.applyGradientOverlay) {
        CAGradientLayer* gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, self.outputImageView.frame.size.width, self.outputImageView.frame.size.height);
        overlayContainerView.frame = gradientLayer.frame;
        gradientLayer.colors = gayPrideCGRefColorsCollection;
        gradientLayer.locations = @[@0, @0.167, @0.334, @0.501, @0.668, @0.835];
        // 0 0 +ve diagonal 0 1 vertical 1 0 horizontal 1 0 0 1 -ve diagonal
        gradientLayer.startPoint = [gradientStartPointsCollection[self.prideEffect] CGPointValue];
        gradientLayer.endPoint = [gradientEndPointsCollection[self.prideEffect] CGPointValue];
        [overlayContainerView.layer addSublayer:gradientLayer];
    } else {
        CGFloat diagonalLength = (sqrt(pow(_outputImageView.frame.size.height, 2) + pow(_outputImageView.frame.size.width, 2)));
        CGFloat individualDiagonalBarWidth = diagonalLength / numberOfColors;
        CGFloat diagonalAngle =  atan(_outputImageView.frame.size.height / _outputImageView.frame.size.width);
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
            UIView* overlay = [[UIView alloc] initWithFrame:overlayFrame];
            [overlay setBackgroundColor:gayPrideColorsCollection[i]];
            overlay.clipsToBounds = NO;
            [overlayContainerView addSubview:overlay];
        }
        if (_prideEffect == PrideEffectPositiveDiagonal) {
            overlayContainerView.transform = CGAffineTransformMakeRotation(-diagonalAngle);
        } else if(_prideEffect == PrideEffectNegativeDiagonal) {
            overlayContainerView.transform = CGAffineTransformMakeRotation(diagonalAngle);
        }
    }
    [self.outputImageView addSubview:overlayContainerView];
    
    if (_textRequired) {
        for (NSInteger i = 0; i < numberOfColors; i++) {
            CATextLayer* overlayTextLayer = [CATextLayer new];
            overlayTextLayer.contentsScale = [UIScreen mainScreen].scale;
            // This filter is to avoid pixalation as label scale increases beyond its capacity.
            overlayTextLayer.magnificationFilter = kCAFilterNearest;
            overlayTextLayer.frame = CGRectMake(10, (i * heightForEachColorBar) + (heightForEachColorBar - 22) / 2.0, _outputImageView.frame.size.width - 20, 22);
            overlayTextLayer.string = colorLabelTexts[i];
            overlayTextLayer.foregroundColor = _variableTextColors ? [gayPrideColorsCollection[i] colorWithAlphaComponent:1.0].CGColor : _overlayTextColor.CGColor;
            [overlayTextLayer setFont:(__bridge CFTypeRef)(_overlayTextFont.fontName)];
            [overlayTextLayer setFontSize:_overlayTextFont.pointSize];
            if (self.overlayTextAlignment == NSTextAlignmentAlternate) {
                if (i % 2 == 0) {
                    overlayTextLayer.alignmentMode = kCAAlignmentLeft;
                } else {
                    overlayTextLayer.alignmentMode = kCAAlignmentRight;
                }
            } else {
                overlayTextLayer.alignmentMode = [self layerAlignmentFromViewAlignment:self.overlayTextAlignment];
            }
            if (self.prideEffect == PrideEffectVertical || self.prideEffect == PrideEffectHorizontal) {
                [overlayContainerView.layer addSublayer:overlayTextLayer];
            } else {
                [self.outputImageView.layer addSublayer:overlayTextLayer];
            }
        }
    }
    
    CGRect rect = [_outputImageView bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_outputImageView.layer renderInContext:context];
    UIImage* capturedImageWithPrideEffect = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImageWithPrideEffect;
}

- (NSString*)layerAlignmentFromViewAlignment:(NSTextAlignment)alignment {
    switch (alignment) {
        case NSTextAlignmentCenter:
            return kCAAlignmentCenter;
            break;
        case NSTextAlignmentLeft:
            return kCAAlignmentLeft;
            break;
        case NSTextAlignmentRight:
            return kCAAlignmentRight;
        default:
            break;
    }
    return kCAAlignmentCenter;
}

@end
