//
//  UIImage+toGrayScale.m
//  JKImageDataInterpret
//
//  Created by Jayesh Kawli Backup on 2/8/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "UIImage+toGrayScale.h"
#import "Constants.h"

//This class is a courtesy of following StackOVerflow post
//http://stackoverflow.com/questions/23133469/convert-rgb-image-to-grayscale-and-grayscale-to-rgb-image

@implementation UIImage(toGrayScale)

-(UIImage*)toGrayscale {
    
    //Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    
    NSInteger width = imageRect.size.width;
    NSInteger height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t* pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, BITS_PER_SAMPLE, width * sizeof(uint32_t), CGColorSpaceCreateDeviceRGB(),
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(NSInteger y = 0; y < height; y++) {
        for(NSInteger x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) (&PIXEL(x, y));
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint8_t gray = (uint8_t) ((30 * rgbaPixel[RED] + 59 * rgbaPixel[GREEN] + 11 * rgbaPixel[BLUE]) / 100);
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    free(pixels);
    
    // make a new UIImage to return
    UIImage* resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:self.scale
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

@end
