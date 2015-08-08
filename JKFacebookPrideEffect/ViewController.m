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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputImage = [UIImage imageNamed:@"parade.jpg"];
    [self applyPrideEffect];
}

- (void)applyPrideEffect {
    JKFacebookPrideEffect* prideEffectApplier = [[JKFacebookPrideEffect alloc] initWithInputImage:self.inputImage andSize:self.imageViewSample.frame.size];
    if (self.imageSource == ImageSourceLocal) {
        self.inputImage = [UIImage imageNamed:@"parade.jpg"];
        self.imageViewSample.image = self.inputImage;
    }
    
    prideEffectApplier.prideEffect = self.prideEffect;
    prideEffectApplier.textRequired = self.showTextOverImage;
    prideEffectApplier.overlayTextAlignment = self.textAlignment;
    prideEffectApplier.variableTextColors = NO;
    UIImage* gayProudImage = [prideEffectApplier applyEffect];
    self.imageViewSample.image = gayProudImage;
}

- (IBAction)showTextSwitchToggled:(UISwitch*)sender {
    self.showTextOverImage = sender.isOn;
}

- (IBAction)imageSourceChanged:(UISegmentedControl*)sender {
    self.imageSource = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == ImageSourceRemote) {
        UIAlertView* inputTextAlertBox = [[UIAlertView alloc] initWithTitle:@"Remote Image" message:@"Please provide URL for remote image source" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        inputTextAlertBox.alertViewStyle = UIAlertViewStylePlainTextInput;
        [inputTextAlertBox show];
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
