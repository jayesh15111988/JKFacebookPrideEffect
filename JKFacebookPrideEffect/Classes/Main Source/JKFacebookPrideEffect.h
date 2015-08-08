//
//  JKFacebookPrideEffect.h
//  JKFacebookPrideEffect
//
//  Created by Jayesh Kawli Backup on 8/4/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PrideEffectHorizontal,
    PrideEffectVertical,
    PrideEffectPositiveDiagonal,
    PrideEffectNegativeDiagonal
} PrideEffect;

extern const NSTextAlignment NSTextAlignmentAlternate;

@interface JKFacebookPrideEffect : NSObject

@property (assign, nonatomic) PrideEffect prideEffect;
@property (assign, nonatomic) BOOL textRequired;
@property (assign, nonatomic) NSTextAlignment overlayTextAlignment;
@property (strong, nonatomic) UIFont* overlayTextFont;
@property (strong, nonatomic) UIColor* overlayTextColor;
@property (assign, nonatomic) BOOL variableTextColors;

- (instancetype)initWithInputImage:(UIImage*)inputImage andSize:(CGSize)size;
- (UIImage*)applyEffect;


@end
