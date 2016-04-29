//
//  ViewController.m
//  BlowCandle
//
//  Created by Gaurav Sharma on 28/04/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

#define THRESHOLD -0.04

@implementation ViewController {
    AVAudioRecorder *recorder;
    double lowPassResults;
    NSTimer *levelTimer;
    IBOutlet UIImageView *imgViewflame;
    NSMutableArray *arrayLow, *arraySmoke;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayLow = [NSMutableArray new];
    for (int i = 0; i < 75; i++) {
        NSString *imgName = [NSString stringWithFormat:@"flame_low_%d", i];
        NSLog(@"low %@", imgName);
        [arrayLow addObject:[UIImage imageNamed:imgName]];
    }
    
    arraySmoke = [NSMutableArray new];
    for (int i = 1; i < 30; i++) {
        NSString *imgName = [NSString stringWithFormat:@"flame_smoke_0%d", i];
        NSLog(@"smoke %@", imgName);
        [arraySmoke addObject:[UIImage imageNamed:imgName]];
    }

    
    lowPassResults = 0.0;
    [self readyToBlow1];
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    if (recorder) {
        [recorder prepareToRecord];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        recorder.meteringEnabled = YES;
        [recorder record];
        levelTimer = [NSTimer scheduledTimerWithTimeInterval:0.05
                                                      target:self
                                                    selector:@selector(levelTimerCallback:)
                                                    userInfo:nil
                                                     repeats:YES];
    } else {
        NSLog(@"%@", [error description]);
    }
}

- (void)readyToBlow1 {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    
    float peakPower = [recorder peakPowerForChannel:0];
    NSLog(@"power = %f", peakPower);
    
    if (peakPower > -3) {
        [self setImageLow];
        if (peakPower > THRESHOLD) {
            NSLog(@"Candle blow off");
//            [levelTimer invalidate];
            [self setImageSmoke];
        }
    }
}

- (void)setImageLow {
    NSLog(@"Low");
    if (!imgViewflame.isAnimating) {
        [imgViewflame setAnimationImages:arrayLow];
        [imgViewflame setAnimationRepeatCount:1];
        [imgViewflame startAnimating];
    }
}

- (void)setImageSmoke {
    NSLog(@"Smoke");
    [imgViewflame setAnimationImages:arraySmoke];
    [imgViewflame setAnimationRepeatCount:2];
    [imgViewflame startAnimating];
}

@end
