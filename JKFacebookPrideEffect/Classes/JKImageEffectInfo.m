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
    }
    return self;
}

- (instancetype)initWithInputImage:(UIImage*)image andSize:(CGSize)imageSize andColors:(NSArray*)colors {
    if (self = [super init]) {
        _inputImage = image;
        _imageSize = imageSize;
        _colors = colors;
    }
    return self;
}

@end
