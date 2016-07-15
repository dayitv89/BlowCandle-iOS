//
//  CandleAnimation.h
//  BlowCandle
//
//  Created by Gaurav Sharma on 13/07/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myCompletion)();

@interface CandleAnimation : NSObject

- (void)setFlame:(UIImageView*)imgView
    stableImages:(NSArray <UIImage*>*)arrStableImages
      blowImages:(NSArray <UIImage*>*)arrBlowImages
     smokeImages:(NSArray <UIImage*>*)arrSmokeImages;
- (void)startAnimations:(myCompletion)complete;

@end
