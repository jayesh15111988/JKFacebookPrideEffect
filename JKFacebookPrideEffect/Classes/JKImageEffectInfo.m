//
//  JKImageEffectInfo.m
//  JKFacebookPrideEffect
//
//  Created by Jayesh Kawli Backup on 10/11/15.
//  Copyright © 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKImageEffectInfo.h"

@implementation JKImageEffectInfo

- (instancetype)initWithInputImage:(UIImage*)image andSize:(CGSize)imageSize andColors:(NSArray*)colors andTexts:(NSArray*)texts {
    if (self = [super init]) {
        _inputImage = image;
        _imageSize = imageSize;
        _colors = colors;
        _texts = texts;
        _totalHeightFractions = [self fractionCollectionFromColorsCount:colors.count];
    }
    return self;
}

- (instancetype)initWithInputImage:(UIImage*)image andSize:(CGSize)imageSize andColors:(NSArray*)colors {
    if (self = [super init]) {
        _inputImage = image;
        _imageSize = imageSize;
        _colors = colors;
        _totalHeightFractions = [self fractionCollectionFromColorsCount:colors.count];
    }
    return self;
}

- (NSArray*)fractionCollectionFromColorsCount:(NSInteger)count {
    CGFloat individualFraction = 1/(CGFloat)count;
    NSMutableArray* fractionsCollection = [NSMutableArray new];
    for (NSInteger i = 0; i < count; i++) {
        [fractionsCollection addObject:@(individualFraction)];
    }
    return fractionsCollection;
}

- (instancetype)initWithInputImage:(UIImage*)image andSize:(CGSize)imageSize andColors:(NSArray*)colors andTexts:(NSArray*)texts andTotalHeightFractions:(NSArray*)fractions {
    if (self = [super init]) {
        _inputImage = image;
        _imageSize = imageSize;
        _colors = colors;
        _texts = texts;
        _totalHeightFractions = fractions;
    }
    return self;
}

- (instancetype)initWithInputImage:(UIImage*)image andSize:(CGSize)imageSize andColors:(NSArray*)colors andTotalHeightFractions:(NSArray*)fractions {
    if (self = [super init]) {
        _inputImage = image;
        _imageSize = imageSize;
        _colors = colors;
        _totalHeightFractions = fractions;
    }
    return self;
}

@end
