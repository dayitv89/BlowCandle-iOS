//
//  MicrophoneBlow.h
//  BlowCandle
//
//  Created by Gaurav Sharma on 13/07/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

@protocol MicrophoneBlowDelegate <NSObject>

- (void)candleLidStable;
- (void)candleLidMoments;
- (void)candleLidOff;

@end

@interface MicrophoneBlow : NSObject {
        AVAudioRecorder *recorder;
        double lowPassResults;
        NSTimer *levelTimer;
}

@property (nonatomic, strong) id<MicrophoneBlowDelegate> delegate;

- (void)setThreshold:(CGFloat)value;
- (void)prepare;
- (void)start:(CGFloat)frequency;
- (void)stop;

@end
