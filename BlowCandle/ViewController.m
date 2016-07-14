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
    NSMutableArray *arrayLow, *arraySmoke, *arrayStable;
    CandleAnimation *candleAnimation;
    IBOutlet UIButton *__weak btnStart;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayStable = [NSMutableArray new];
    for (int i = 1; i <= 8; i++) {
        NSString *imgName = [NSString stringWithFormat:@"flame_%d", i];
        [arrayStable addObject:[UIImage imageNamed:imgName]];
    }
    for (int i = 7; i > 0; i--) {
        NSString *imgName = [NSString stringWithFormat:@"flame_%d", i];
        [arrayStable addObject:[UIImage imageNamed:imgName]];
    }
    
    arrayLow = [NSMutableArray new];
    for (int i = 1; i <= 25; i++) {
        NSString *imgName = [NSString stringWithFormat:@"flame_%d", i];
        NSLog(@"low %@", imgName);
        [arrayLow addObject:[UIImage imageNamed:imgName]];
    }
    
    arraySmoke = [NSMutableArray new];
    for (int i = 1; i <= 40; i++) {
        NSString *imgName = [NSString stringWithFormat:@"smoke_%d", i];
        NSLog(@"smoke %@", imgName);
        [arraySmoke addObject:[UIImage imageNamed:imgName]];
    }

    candleAnimation = [CandleAnimation new];
    [candleAnimation setFlame:imgViewflame
                 stableImages:arrayStable
                   blowImages:arrayLow
                  smokeImages:arraySmoke];
}

- (IBAction)btnStartTapped:(id)sender {
    btnStart.enabled = NO;
    [candleAnimation startAnimations:^{
        btnStart.enabled = YES;
        NSLog(@"yupieee now run more animations");
    }];
}

@end
