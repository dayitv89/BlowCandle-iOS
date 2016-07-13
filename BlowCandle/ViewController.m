//
//  ViewController.m
//  BlowCandle
//
//  Created by Gaurav Sharma on 28/04/16.
//  Copyright © 2016 GDS. All rights reserved.
//

#import "ViewController.h"
#import "CandleAnimation.h"

@implementation ViewController {
    IBOutlet UIImageView *__weak imgViewflame;
    NSMutableArray *arrayLow, *arraySmoke;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayLow = [NSMutableArray new];
    for (int i = 1; i <= 25; i++) {
        NSString *imgName = [NSString stringWithFormat:@"flame_%d", i];
        NSLog(@"low %@", imgName);
        [arrayLow addObject:[UIImage imageNamed:imgName]];
    }
    
    arraySmoke = [NSMutableArray new];
    for (int i = 1; i <= 39; i++) {
        NSString *imgName = [NSString stringWithFormat:@"smoke_%d", i];
        NSLog(@"smoke %@", imgName);
        [arraySmoke addObject:[UIImage imageNamed:imgName]];
    }

    CandleAnimation *candleAnimation = [CandleAnimation new];
    [candleAnimation setFlame:imgViewflame
                 stableImages:@[[UIImage imageNamed:@"flame_1"]]
                   blowImages:arrayLow
                  smokeImages:arraySmoke];
    [candleAnimation startAnimations:^{
        NSLog(@"yupieee now run more animations");
    }];
}

@end
