# JKFacebookPrideEffect
A Library to apply Facebook style pride parade effect to input images
## Demo

![alt text][FacebookPrideEffectDemo]

See the sample project in JKFacebookPrideEffect folder for uses.

Use Cocoapods to integrate into your projects:

```pod 'JKFacebookPrideEffect', :git => 'git@github.com:jayesh15111988/JKFacebookPrideEffect.git'```

This is my basic attempt to create Facebook style pride parade effect for input images. 

Usage :

Initialize ```JKFacebookPrideEffect``` class with required parameters such as,

```inputImage``` - Input image to apply pride effect to   
```size``` - Size of the input image in terms of bounds

**There are various other parameters too which can be applied to this effect such as,**

```PrideEffect prideEffect``` - Desired effect of colored stripes such as vertical, horizontal or diagonal  
```BOOL textRequired``` - To show text on overlay or not   
```NSTextAlignment overlayTextAlignment``` - Alignment of the overlay text  
```UIFont* overlayTextFont``` - Font to be used for overlay text    
```UIColor* overlayTextColor``` -   Color to be used for overlay text   
```BOOL variableTextColors``` - Decided whether to use fixed or variable colors for each series of overlay texts

[FacebookPrideEffectDemo]: https://github.com/jayesh15111988/JKFacebookPrideEffect/blob/master/Demo/FacebookParadePrideEffectDemo.gif "Facebook Style Pride effect for images"
