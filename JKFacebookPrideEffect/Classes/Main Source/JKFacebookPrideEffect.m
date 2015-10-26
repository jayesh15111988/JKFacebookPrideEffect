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
#import "JKImageEffectInfo.h"
#import "Constants.h"

@interface JKFacebookPrideEffect ()

@property (strong, nonatomic) UIImageView* outputImageView;
@property (assign, nonatomic) CGSize outputImageViewSize;
@property (assign, nonatomic) CGFloat overlayAlpha;
@property (copy, nonatomic) NSArray* gayPrideColorsCollection;
@property (copy, nonatomic) NSArray* colorLabelTexts;
@property (copy, nonatomic) NSArray* totalHeightFractionCollection;
@property (assign, nonatomic) BOOL textRequired;

@end

@implementation JKFacebookPrideEffect

const NSTextAlignment NSTextAlignmentAlternate = 7;
static NSArray* gradientStartPointsCollection;
static NSArray* gradientEndPointsCollection;
static NSArray* gayPrideCGRefColorsCollection;

+ (void)load {
    gradientStartPointsCollection = @[
        [NSValue valueWithCGPoint:CGPointMake (1, 0)],
        [NSValue valueWithCGPoint:CGPointMake (0, 1)],
        [NSValue valueWithCGPoint:CGPointMake (0, 0)],
        [NSValue valueWithCGPoint:CGPointMake (1, 0)]
    ];
    gradientEndPointsCollection = @[
        [NSValue valueWithCGPoint:CGPointMake (1, 1)],
        [NSValue valueWithCGPoint:CGPointMake (1, 1)],
        [NSValue valueWithCGPoint:CGPointMake (1, 1)],
        [NSValue valueWithCGPoint:CGPointMake (0, 1)]
    ];
    // Ref : https://en.wikipedia.org/wiki/Rainbow_flag_(LGBT_movement)
}

- (instancetype)initWithImageEffectInfo:(JKImageEffectInfo*)imageEffectInfo {

    NSAssert ([imageEffectInfo.colors count] > 0, @"You must supply at least one color value");
    if (imageEffectInfo.texts) {
        NSAssert ([imageEffectInfo.colors count] == [imageEffectInfo.texts count],
                  @"Number of colors should match with array holding text values");
    }

    if (self = [super init]) {
        UIImage* inputImage = imageEffectInfo.inputImage;
        UIImage* grayScaleImage = [inputImage toGrayscale];
        _gayPrideColorsCollection = imageEffectInfo.colors;
        _totalHeightFractionCollection = imageEffectInfo.totalHeightFractions;
        if (imageEffectInfo.texts) {
            _colorLabelTexts = imageEffectInfo.texts;
        }
        _outputImageView = [[UIImageView alloc]
            initWithFrame:CGRectMake (0, 0, imageEffectInfo.imageSize.width, imageEffectInfo.imageSize.height)];
        _outputImageView.contentMode = UIViewContentModeScaleAspectFit;
        _outputImageView.image = grayScaleImage;
        _outputImageView.clipsToBounds = YES;
        //[_outputImageView setFrame:AVMakeRectWithAspectRatioInsideRect(inputImage.size, _outputImageView.frame)];
        _outputImageViewSize = imageEffectInfo.imageSize;
        _prideEffect = PrideEffectHorizontal;
        _textRequired = imageEffectInfo.texts != nil;
        _overlayTextFont = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
        _overlayTextColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        _variableTextColors = YES;
    }
    return self;
}

- (UIImage*)applyEffect {
    NSInteger numberOfColors = _gayPrideColorsCollection.count;
    CGFloat totalHeight = _outputImageView.frame.size.height;
    CGFloat totalWidth = _outputImageView.frame.size.width;
    CGFloat diagonalLength = (sqrt (pow (totalHeight, 2) + pow (totalWidth, 2)));

    UIView* overlayContainerView = [[UIView alloc] init];

    if (self.applyGradientOverlay) {
        CAGradientLayer* gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame =
            CGRectMake (0, 0, self.outputImageView.frame.size.width, self.outputImageView.frame.size.height);
        overlayContainerView.frame = gradientLayer.frame;
        gradientLayer.colors = [self CGRefColorFormatCollection];
        gradientLayer.locations = [self gradientCollectionWithColorCount:numberOfColors];
        // 0 0 +ve diagonal 0 1 vertical 1 0 horizontal 1 0 0 1 -ve diagonal
        gradientLayer.startPoint = [gradientStartPointsCollection[self.prideEffect] CGPointValue];
        gradientLayer.endPoint = [gradientEndPointsCollection[self.prideEffect] CGPointValue];
        [overlayContainerView.layer addSublayer:gradientLayer];
    } else {
        CGFloat diagonalAngle = atan (_outputImageView.frame.size.height / _outputImageView.frame.size.width);
        overlayContainerView.clipsToBounds = YES;
        if (_prideEffect == PrideEffectPositiveDiagonal || _prideEffect == PrideEffectNegativeDiagonal) {
            overlayContainerView.frame = CGRectMake (0, 0, diagonalLength, diagonalLength);
            overlayContainerView.center =
                CGPointMake (CGRectGetWidth (_outputImageView.frame) / 2, CGRectGetHeight (_outputImageView.frame) / 2);
        } else {
            overlayContainerView.frame =
                CGRectMake (0, 0, _outputImageView.frame.size.width, _outputImageView.frame.size.height);
        }

        CGFloat fractionsSum = 0;
        for (NSInteger i = 0; i < numberOfColors; i++) {
            CGRect overlayFrame;
            if (_prideEffect == PrideEffectHorizontal) {
                CGFloat heightForEachColorBar = totalHeight * [_totalHeightFractionCollection[i] floatValue];
                CGFloat heightForPreviousBar = totalHeight * fractionsSum;
                overlayFrame = CGRectMake (0, heightForPreviousBar, totalWidth, heightForEachColorBar);
            } else if (_prideEffect == PrideEffectVertical) {
                CGFloat widthForEachColorBar = totalWidth * [_totalHeightFractionCollection[i] floatValue];
                CGFloat widthForPreviousBar = totalWidth * fractionsSum;
                overlayFrame = CGRectMake (widthForPreviousBar, 0, widthForEachColorBar, totalHeight);
            } else {
                CGFloat individualDiagonalBarWidth = diagonalLength * [_totalHeightFractionCollection[i] floatValue];
                CGFloat widthForPreviousDiagonal = diagonalLength * fractionsSum;
                overlayFrame = CGRectMake (0, widthForPreviousDiagonal, diagonalLength, individualDiagonalBarWidth);
            }
            UIView* overlay = [[UIView alloc] initWithFrame:overlayFrame];
            [overlay setBackgroundColor:self.gayPrideColorsCollection[i]];
            overlay.clipsToBounds = NO;
            [overlayContainerView addSubview:overlay];
            fractionsSum += [_totalHeightFractionCollection[i] floatValue];
        }
        if (_prideEffect == PrideEffectPositiveDiagonal) {
            overlayContainerView.transform = CGAffineTransformMakeRotation (-diagonalAngle);
        } else if (_prideEffect == PrideEffectNegativeDiagonal) {
            overlayContainerView.transform = CGAffineTransformMakeRotation (diagonalAngle);
        }
    }

    if (self.overlayImage) {
        CGFloat overlayImageDimensionFraction = 0.4;
        if (_totalHeightFractionCollection.count > 1) {
            NSInteger desiredIndex = floor (self.totalHeightFractionCollection.count / 2.0);
            overlayImageDimensionFraction = [_totalHeightFractionCollection[desiredIndex] floatValue];
        }
        UIImageView* overlayImageView = [[UIImageView alloc] initWithImage:self.overlayImage];
        overlayImageView.contentMode = UIViewContentModeScaleAspectFit;
        [overlayContainerView addSubview:overlayImageView];
        overlayImageView.frame =
            CGRectMake (0, 0, overlayImageDimensionFraction * totalWidth, overlayImageDimensionFraction * totalHeight);
        overlayImageView.center = overlayContainerView.center;
    }

    [self.outputImageView addSubview:overlayContainerView];

    CGFloat fractionsSum = 0;
    if (_textRequired) {
        for (NSInteger i = 0; i < numberOfColors; i++) {
            CGFloat heightForEachColorBar = totalHeight * [_totalHeightFractionCollection[i] floatValue];

            CGFloat heightForPreviousBar = totalHeight * fractionsSum;

            CATextLayer* overlayTextLayer = [CATextLayer new];
            overlayTextLayer.contentsScale = [UIScreen mainScreen].scale;
            // This filter is to avoid pixalation as label scale increases beyond its capacity.
            overlayTextLayer.magnificationFilter = kCAFilterNearest;
            overlayTextLayer.frame = CGRectMake (10, (heightForPreviousBar) + (heightForEachColorBar - 22) / 2.0,
                                                 _outputImageView.frame.size.width - 20, 22);
            overlayTextLayer.string = self.colorLabelTexts[i];
            overlayTextLayer.foregroundColor =
                _variableTextColors ? [self.gayPrideColorsCollection[i] colorWithAlphaComponent:1.0].CGColor
                                    : _overlayTextColor.CGColor;
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
            fractionsSum += [_totalHeightFractionCollection[i] floatValue];
        }
    }

    CGRect rect = [_outputImageView bounds];
    UIGraphicsBeginImageContextWithOptions (rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext ();
    [_outputImageView.layer renderInContext:context];
    UIImage* capturedImageWithPrideEffect = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();

    return capturedImageWithPrideEffect;
}

- (NSArray*)gradientCollectionWithColorCount:(NSInteger)totalNumberOfColors {
    NSMutableArray* gradientPositionCollection = [[NSMutableArray alloc] initWithObjects:@(0), nil];
    CGFloat positionMultiplier = 1 / (double)totalNumberOfColors;
    NSInteger counter = 1;
    while (counter < totalNumberOfColors) {
        [gradientPositionCollection addObject:@(counter * positionMultiplier)];
        counter++;
    }
    return gradientPositionCollection;
}

- (NSArray*)CGRefColorFormatCollection {
    NSMutableArray* cgrefColorFormats = [NSMutableArray new];
    for (UIColor* color in self.gayPrideColorsCollection) {
        [cgrefColorFormats addObject:(__bridge id)color.CGColor];
    }
    return cgrefColorFormats;
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
