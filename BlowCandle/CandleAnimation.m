//
//  CandleAnimation.m
//  BlowCandle
//
//  Created by Gaurav Sharma on 13/07/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import "CandleAnimation.h"
#import "MicrophoneBlow.h"

@interface CandleAnimation () <MicrophoneBlowDelegate> {
    MicrophoneBlow *microphoneBlow;
    myCompletion completion;
}

@property (nonatomic, weak) UIImageView *imgViewFlame;
@property (nonatomic, strong) NSArray <UIImage*> *arrStableImages;
@property (nonatomic, strong) NSArray <UIImage*> *arrBlowImages;
@property (nonatomic, strong) NSArray <UIImage*> *arrSmokeImages;

@end


@implementation CandleAnimation

- (void)setFlame:(UIImageView*)imgView
    stableImages:(NSArray <UIImage*>*)arrStableImages
      blowImages:(NSArray <UIImage*>*)arrBlowImages
     smokeImages:(NSArray <UIImage*>*)arrSmokeImages {
    self.imgViewFlame = imgView;
    self.arrStableImages = arrStableImages;
    self.arrBlowImages = arrBlowImages;
    self.arrSmokeImages = arrSmokeImages;
}

- (void)startAnimations:(myCompletion)complete {
    microphoneBlow = [[MicrophoneBlow alloc] init];
    [microphoneBlow setDelegate:self];
    [microphoneBlow prepare];
    [microphoneBlow start:0.1f];
    completion = complete;
}

#pragma mark - MicrophoneBlowDelegate
- (void)candleLidStable {
    [self setImageStable];
}

- (void)candleLidMoments {
    [self setImageBlow];
}

- (void)candleLidOff {
    if (completion) {
        completion();
    }
    [self setImageSmoke];
}

#pragma mark - Animation images
- (void)setImageStable {
    NSLog(@"Stable");
    if (!self.imgViewFlame.isAnimating) {
        [self.imgViewFlame setAnimationImages:self.arrStableImages];
        [self.imgViewFlame setAnimationRepeatCount:1];
        [self.imgViewFlame startAnimating];
    }
}

- (void)setImageBlow {
    NSLog(@"Blow");
    if (!self.imgViewFlame.isAnimating) {
        [self.imgViewFlame setAnimationImages:self.arrBlowImages];
        [self.imgViewFlame setAnimationRepeatCount:1];
        [self.imgViewFlame startAnimating];
    }
}

- (void)setImageSmoke {
    NSLog(@"Smoke");
    [self.imgViewFlame setImage:self.arrSmokeImages[self.arrSmokeImages.count-1]];
    
    NSTimeInterval animationTime = 2;
    [self.imgViewFlame setAnimationImages:self.arrSmokeImages];
    [self.imgViewFlame setAnimationRepeatCount:2];
    [self.imgViewFlame setAnimationDuration:animationTime];
    [self.imgViewFlame startAnimating];
    
    
}

@end
