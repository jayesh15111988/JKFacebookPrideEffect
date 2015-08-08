//
//  Constants.m
//  JKImageDataInterpret
//
//  Created by Jayesh Kawli Backup on 2/8/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BITS_PER_SAMPLE 8
#define SAMPLEX_PER_PIXEL 4

#define RED 1
#define GREEN 2
#define BLUE 3
#define ALPHA 4

//Referecne : https://www.mikeash.com/pyblog/friday-qa-2012-09-14-implementing-a-flood-fill.html
#define PIXEL_TO_INDEX(x, y) ((x) + (y) * width)
#define INDEX_TO_X(index) ((index) % width)
#define INDEX_TO_Y(index) ((index) / width)

#define PIXEL(x, y) (pixels[PIXEL_TO_INDEX(x, y)])

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.4]