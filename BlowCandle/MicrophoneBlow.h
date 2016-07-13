//
//  MicrophoneBlow.h
//  BlowCandle
//
//  Created by Gaurav Sharma on 13/07/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import <Foundation/Foundation.h>
@import AVFoundation;

typedef NS_ENUM(NSUInteger, MicrophoneBlowState) {
    kFlameLidStable,
    kFlameLidMovement,
    kFlameLidOff
};

typedef void(^StateCompletion)(MicrophoneBlowState state);

@interface MicrophoneBlow : NSObject {
        AVAudioRecorder *recorder;
        double lowPassResults;
        NSTimer *levelTimer;
}

- (void)setThreshold:(CGFloat)value;
- (void)prepare;
- (void)start:(CGFloat)frequency andCompletions:(StateCompletion)completion;
- (void)stop;

@end
