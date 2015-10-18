//
//  ViewController.m
//  JKFacebookPrideEffect
//
//  Created by Jayesh Kawli Backup on 8/4/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "ViewController.h"
#import "JKFacebookPrideEffect.h"
#import "Constants.h"
#import "JKImageEffectInfo.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, ImageSource) {
    ImageSourceLocal,
    ImageSourceRemote
};

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSample;
@property (strong, nonatomic) UIImage* inputImage;
@property (assign, nonatomic) PrideEffect prideEffect;
@property (assign, nonatomic) NSUInteger imageSource;
@property (assign, nonatomic) BOOL showTextOverImage;
@property (assign, nonatomic) NSTextAlignment textAlignment;
@property (weak, nonatomic) IBOutlet UISwitch *showGradientSwitch;
@property (assign, nonatomic) BOOL toShowGradient;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputImage = [UIImage imageNamed:@"parade.jpg"];
    self.prideEffect = PrideEffectHorizontal;
    self.toShowGradient = NO;
    [self applyPrideEffect];
}

- (void)applyPrideEffect {
    NSArray* colors = @[UIColorFromRGB(0xFF0000), UIColorFromRGB(0xFBA71C), UIColorFromRGB(0xFFFF01), UIColorFromRGB(0x30CA6A), UIColorFromRGB(0x057BB2), UIColorFromRGB(0x4C2D7B)];
    NSArray* colorTexts = @[@"LIFE", @"HEALING", @"SUNLIGHT", @"NATURE", @"HARMONY", @"SPIRIT"];
    
    JKImageEffectInfo* facebookPrideEffect = [[JKImageEffectInfo alloc] initWithInputImage:self.inputImage andSize:self.imageViewSample.frame.size andColors:colors andTexts:colorTexts];
    JKImageEffectInfo* indianFlagEffect = [[JKImageEffectInfo alloc] initWithInputImage:self.inputImage andSize:self.imageViewSample.frame.size andColors:@[UIColorFromRGB(0xFF9933), UIColorFromRGB(0xFFFFFF), UIColorFromRGB(0x138808)] andTexts:@[@"Strength", @"Peace", @"Growth"]];
    JKFacebookPrideEffect* prideEffectApplier = [[JKFacebookPrideEffect alloc] initWithImageEffectInfo:facebookPrideEffect];
    
    prideEffectApplier.prideEffect = self.prideEffect;
    prideEffectApplier.overlayTextAlignment = self.textAlignment;
    prideEffectApplier.variableTextColors = NO;
    prideEffectApplier.applyGradientOverlay = self.toShowGradient;
    UIImage* gayProudImage = [prideEffectApplier applyEffect];
    self.imageViewSample.image = gayProudImage;
}

- (IBAction)showTextSwitchToggled:(UISwitch*)sender {
    self.showTextOverImage = sender.isOn;
}

- (IBAction)showGradientSwitchToggled:(UISwitch*)sender {
    self.toShowGradient = sender.isOn;
}


- (IBAction)imageSourceChanged:(UISegmentedControl*)sender {
    self.imageSource = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == ImageSourceRemote) {
        UIAlertView* inputTextAlertBox = [[UIAlertView alloc] initWithTitle:@"Remote Image" message:@"Please provide URL for remote image source" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        inputTextAlertBox.alertViewStyle = UIAlertViewStylePlainTextInput;
        [inputTextAlertBox show];
    } else if (self.imageSource == ImageSourceLocal) {
        self.inputImage = [UIImage imageNamed:@"parade.jpg"];
    }
}

- (IBAction)prideEffectStyleChanged:(UISegmentedControl*)sender {
    self.prideEffect = sender.selectedSegmentIndex;
}

- (IBAction)applyEffect:(id)sender {
    [self applyPrideEffect];
}

- (IBAction)textAlignmentChanged:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex < 3) {
        self.textAlignment = sender.selectedSegmentIndex;
    } else {
        self.textAlignment = NSTextAlignmentAlternate;
    }
}

#pragma delegate for UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        UITextField* remoteImageURLTextField = [alertView textFieldAtIndex:0];
        NSURL* imageURL = [NSURL URLWithString:remoteImageURLTextField.text];
        NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
        if (imageData) {
            self.inputImage = [UIImage imageWithData:imageData];
            self.imageViewSample.image = self.inputImage;
        } else {
            UIAlertView* errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get image from specified URL" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }
}

@end
