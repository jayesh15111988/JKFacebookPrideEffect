//
//  ViewController.m
//  JKFacebookPrideEffect
//
//  Created by Jayesh Kawli Backup on 8/4/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "ViewController.h"
#import "JKFacebookPrideEffect.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSample;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* inputImage = [UIImage imageNamed:@"sohini_patil.jpg"];
    JKFacebookPrideEffect* prideEffectApplier = [[JKFacebookPrideEffect alloc] initWithInputImage:inputImage andSize:self.imageViewSample.frame.size];
    prideEffectApplier.prideEffect = PrideEffectHorizontal;
    prideEffectApplier.textRequired = YES;
    prideEffectApplier.variableTextColors = NO;
    prideEffectApplier.overlayTextAlignment = NSTextAlignmentAlternate;
    UIImage* gayProudImage = [prideEffectApplier applyEffect];
    self.imageViewSample.image = gayProudImage;
}

@end
