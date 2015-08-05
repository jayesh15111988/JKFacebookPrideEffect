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

@interface JKFacebookPrideEffect : NSObject

+ (UIImageView*)applyEffectToInputImage:(UIImage *)inputImage andEffectType:(PrideEffect)prideEffect andTextRequired:(BOOL)textRequired;


@end
