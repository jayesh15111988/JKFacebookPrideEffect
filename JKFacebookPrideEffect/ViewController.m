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
    UIImageView* outputImageView = [JKFacebookPrideEffect applyEffectToInputImage:inputImage andEffectType:PrideEffectPositiveDiagonal andTextRequired:NO];
    outputImageView.translatesAutoresizingMaskIntoConstraints = NO;
    outputImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:outputImageView];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[outputImageView(width)]" options:kNilOptions metrics:@{@"width": @(outputImageView.frame.size.width)} views:NSDictionaryOfVariableBindings(outputImageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[outputImageView(height)]" options:kNilOptions metrics:@{@"height": @(outputImageView.frame.size.height)} views:NSDictionaryOfVariableBindings(outputImageView)]];

//    UIImageView* im = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 300, 200)];
//    im.contentMode = UIViewContentModeScaleAspectFit;
//    NSLog(@"%@ Original frame", NSStringFromCGRect(im.frame));
//
//    
//    
//    [im setFrame:AVMakeRectWithAspectRatioInsideRect(inputImage.size, im.frame)];
//    NSLog(@"Frame after %@", NSStringFromCGRect(im.frame));
//    im.image = inputImage;
//    [self.view addSubview:im];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
