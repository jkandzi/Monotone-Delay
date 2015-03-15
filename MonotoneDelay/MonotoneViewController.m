//
//  MonotoneViewController.m
//  monotone
//
//  Created by Justus Kandzi on 31.10.13.
//  Copyright (c) 2013 Justus Kandzi. All rights reserved.
//

#import "MonotoneViewController.h"
#import "PotentiometerView.h"
#import "RibbonView.h"
#import "SwitchView.h"

#import "MonotoneAudioEngine.h"

@interface MonotoneViewController () <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet SwitchView *lfoWaveSwitch;
@property (weak, nonatomic) IBOutlet PotentiometerView *ratePotentiometer;
@property (weak, nonatomic) IBOutlet PotentiometerView *intervalPotentiometer;
@property (weak, nonatomic) IBOutlet PotentiometerView *filterCutoffPotentiometer;
@property (weak, nonatomic) IBOutlet PotentiometerView *delayTimePotentiometer;
@property (weak, nonatomic) IBOutlet PotentiometerView *delayFeedbackPotentiometer;

@property (nonatomic, weak) MonotoneAudioEngine *soundEngine;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ribbonBackgroundImageView;
@end

@implementation MonotoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.soundEngine = [MonotoneAudioEngine sharedSoundEngine];
    
    UIImage *ribbonBackgroundImage = [[UIImage imageNamed:@"RibbonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(29.f, 0.f, 6.f, 0.f)];
    self.ribbonBackgroundImageView.image = ribbonBackgroundImage;
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"Background"] resizableImageWithCapInsets:UIEdgeInsetsMake(75.f, 0.f, 75.f, 0.f)];
    self.backgroundImageView.image = backgroundImage;
    
    self.ratePotentiometer.value = self.soundEngine.lfoRate;
    self.intervalPotentiometer.value = self.soundEngine.lfoInterval;
    self.filterCutoffPotentiometer.value = self.soundEngine.filterCutoff;
    self.delayTimePotentiometer.value = self.soundEngine.delayTime;
    self.delayFeedbackPotentiometer.value = self.soundEngine.delayFeedback;
    
    if (self.soundEngine.lfoWaveForm == MonotoneDelayWaveFormTriangle) {
        self.lfoWaveSwitch.switchPosition = SwitchViewSwitchPositionUp;
    }
    else {
        self.lfoWaveSwitch.switchPosition = SwitchViewSwitchPositionDown;
    }
}

#pragma mark - button actions

- (IBAction)waveChanged {
    if (self.lfoWaveSwitch.switchPosition == SwitchViewSwitchPositionUp) {
        self.soundEngine.lfoWaveForm = MonotoneDelayWaveFormTriangle;
    }
    else {
        self.soundEngine.lfoWaveForm = MonotoneDelayWaveFormSquare;
    }
}

- (IBAction)rateChanged {
    self.soundEngine.lfoRate = self.ratePotentiometer.value;
}

- (IBAction)intervalChanged {
    self.soundEngine.lfoInterval = self.intervalPotentiometer.value;
}

- (IBAction)filterCutoffChanged {
    self.soundEngine.filterCutoff = self.filterCutoffPotentiometer.value;
}

- (IBAction)delayTimeChanged {
    self.soundEngine.delayTime = self.delayTimePotentiometer.value;
}

- (IBAction)delayFeedbackChanged {
    self.soundEngine.delayFeedback = self.delayFeedbackPotentiometer.value;
}

@end
