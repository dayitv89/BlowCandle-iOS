//
//  ViewController.m
//  BlowCandle
//
//  Created by Gaurav Sharma on 28/04/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import "ViewController.h"
@import AVFoundation;

#define THRESHOLD 75

@implementation ViewController {
    AVAudioRecorder *recorder;
    double lowPassResults;
    NSTimer *levelTimer;
    IBOutlet UISlider *progressView;
    IBOutlet UILabel *lblDone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    [progressView setValue:0.];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    CGFloat percentage = lowPassResults*10000/THRESHOLD;
    NSLog(@"lowPassResults %lf, percentage %lf", lowPassResults, percentage);
    [progressView setValue:percentage];
    if (percentage > 100.) {
        NSLog(@"Candle blow off");
        lblDone.hidden = NO;
        [levelTimer invalidate];
    }
}

@end
