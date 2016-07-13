//
//  MicrophoneBlow.m
//  BlowCandle
//
//  Created by Gaurav Sharma on 13/07/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import "MicrophoneBlow.h"

@implementation MicrophoneBlow {
    CGFloat THRESHOLD;
    StateCompletion completionBlock;
}

#pragma mark - Public Methods
- (void)setThreshold:(CGFloat)value {
    THRESHOLD = value;
}

- (void)prepare {
    THRESHOLD = -1.212;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
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
    } else {
        NSLog(@"%@", [error description]);
    }
}

- (void)start:(CGFloat)frequency andCompletions:(StateCompletion)completion {
    completionBlock = completion;
    [recorder record];
    levelTimer = [NSTimer scheduledTimerWithTimeInterval:frequency
                                                  target:self
                                                selector:@selector(levelTimerCallback:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stop {
    [levelTimer invalidate];
    levelTimer = nil;
}


#pragma mark - Private method
- (void)levelTimerCallback:(NSTimer *)timer {
    [recorder updateMeters];
    
    float peakPower = [recorder peakPowerForChannel:0];
    NSLog(@"power = %f", peakPower);
    
    if (peakPower > -3) {
        NSLog(@"Candle blow moments");
        if (completionBlock) {
            completionBlock(kFlameLidMovement);
        }
        if (peakPower > THRESHOLD) {
            NSLog(@"Candle blow off");
            [self stop];
            if (completionBlock) {
                completionBlock(kFlameLidOff);
            }
        }
    } else {
        NSLog(@"Candle blow stable");
        if (completionBlock) {
            completionBlock(kFlameLidStable);
        }
    }
}

@end
