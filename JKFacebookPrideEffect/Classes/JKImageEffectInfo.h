//
//  JKImageEffectInfo.h
//  JKFacebookPrideEffect
//
//  Created by Jayesh Kawli Backup on 10/11/15.
//  Copyright © 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JKImageEffectInfo : NSObject

- (instancetype)initWithInputImage:(UIImage*)image andSize:(CGSize)imageSize andColors:(NSArray*)colors andTexts:(NSArray*)texts;
- (instancetype)initWithInputImage:(UIImage*)image andSize:(CGSize)imageSize andColors:(NSArray*)colors;
@property (nonatomic, strong, readonly) UIImage* inputImage;
@property (nonatomic, assign, readonly) CGSize imageSize;
@property (nonatomic, copy, readonly) NSArray* colors;
@property (nonatomic, copy, readonly) NSArray* texts;

@end
