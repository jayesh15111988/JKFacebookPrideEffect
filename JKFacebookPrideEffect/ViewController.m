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
    JKFacebookPrideEffect* prideEffectApplier = [[JKFacebookPrideEffect alloc] initWithInputImage:inputImage andSize:CGSizeMake(300, 300)];
    prideEffectApplier.prideEffect = PrideEffectPositiveDiagonal;
    prideEffectApplier.textRequired = YES;
    prideEffectApplier.variableTextColors = NO;
    UIImageView* outputImageView = [prideEffectApplier applyEffect];
    outputImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:outputImageView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[outputImageView(width)]" options:kNilOptions metrics:@{@"width": @(outputImageView.frame.size.width)} views:NSDictionaryOfVariableBindings(outputImageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[outputImageView(height)]" options:kNilOptions metrics:@{@"height": @(outputImageView.frame.size.height)} views:NSDictionaryOfVariableBindings(outputImageView)]];
}

@end
