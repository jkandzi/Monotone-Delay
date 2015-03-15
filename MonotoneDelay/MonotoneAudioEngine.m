//
//  MonotoneAudioEngine.m
//  monotone
//
//  Created by Justus Kandzi on 01.11.13.
//  Copyright (c) 2013 Justus Kandzi. All rights reserved.
//

#import "MonotoneAudioEngine.h"
#import <libpd/PdAudioController.h>
#import <libpd/PdBase.h>

// makes the AudioUnit accessible
@interface PdAudioController (Private)
@property (nonatomic, retain) PdAudioUnit *audioUnit;
@end

@interface MonotoneAudioEngine ()
@property (nonatomic, strong) PdAudioController *audioController;
@property (nonatomic, assign) void *patch;
@property (nonatomic, readwrite) BOOL playing;
@end

static NSString *const MonotoneDelayLFOWaveFormKey = @"MonotoneDelayLFOWaveFormKey";
static NSString *const MonotoneDelayLFORateKey = @"MonotoneDelayLFORateKey";
static NSString *const MonotoneDelayLFOIntervalKey = @"MonotoneDelayLFOIntervalKey";
static NSString *const MonotoneDelayFilterCutoffKey = @"MonotoneDelayFilterCutoffKey";
static NSString *const MonotoneDelayDelayTimeKey = @"MonotoneDelayDelayTimeKey";
static NSString *const MonotoneDelayDelayFeedbackKey = @"MonotoneDelayDelayFeedbackKey";

@implementation MonotoneAudioEngine

+ (instancetype)sharedSoundEngine {
    static MonotoneAudioEngine *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _audioController = [[PdAudioController alloc] init];
        if ([_audioController configurePlaybackWithSampleRate:44100 numberChannels:2 inputEnabled:NO mixingEnabled:YES] != PdAudioOK) {
            NSLog(@"failed to initialize audio components");
        }
        
        _patch = [PdBase openFile:@"monopatch.pd" path:[[NSBundle mainBundle] resourcePath]];
        
        NSMutableDictionary *defaults = [[NSMutableDictionary alloc] init];
        defaults[MonotoneDelayFilterCutoffKey] = @1.0f;
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults registerDefaults:defaults];

        self.lfoWaveForm = [userDefaults integerForKey:MonotoneDelayLFOWaveFormKey];
        self.lfoRate = [userDefaults floatForKey:MonotoneDelayLFORateKey];
        self.lfoInterval = [userDefaults floatForKey:MonotoneDelayLFOIntervalKey];
        self.filterCutoff = [userDefaults floatForKey:MonotoneDelayFilterCutoffKey];
        self.delayTime = [userDefaults floatForKey:MonotoneDelayDelayTimeKey];
        self.delayFeedback = [userDefaults floatForKey:MonotoneDelayDelayFeedbackKey];
    }
    return self;
}

- (AudioUnit)audioUnit {
    PdAudioUnit *pdAudioUnit = self.audioController.audioUnit;
    return pdAudioUnit.audioUnit;
}

- (void)setActive:(BOOL)active {
    self.audioController.active = active;
}

- (BOOL)isActive {
    return self.audioController.isActive;
}

- (void)stop {
    self.active = NO;
}

- (void)setNormalizedPitch:(float)normalizedPitch {
    _normalizedPitch = normalizedPitch;
    if (!self.isPlaying) {
        [PdBase sendFloat:normalizedPitch toReceiver:@"newPitch"];
        [PdBase sendBangToReceiver:@"start"];
        self.playing = YES;
    }
    else {
        [PdBase sendFloat:normalizedPitch toReceiver:@"pitch"];
    }
}

- (void)stopPlaying {
    [PdBase sendBangToReceiver:@"stop"];
    self.playing = NO;
}

- (void)setLfoWaveForm:(MonotoneDelayWaveForm)lfoWaveForm {
    _lfoWaveForm = lfoWaveForm;
    if (lfoWaveForm == MonotoneDelayWaveFormTriangle) {
        [PdBase sendBangToReceiver:@"triangle"];
    }
    else {
        [PdBase sendBangToReceiver:@"square"];
    }
}

- (void)setLfoRate:(float)lfoRate {
    _lfoRate = lfoRate;
    [PdBase sendFloat:lfoRate toReceiver:@"rate"];
}

- (void)setLfoInterval:(float)lfoInterval {
    _lfoInterval = lfoInterval;
    [PdBase sendFloat:lfoInterval toReceiver:@"interval"];
}

- (void)setFilterCutoff:(float)filterCutoff {
    _filterCutoff = filterCutoff;
    [PdBase sendFloat:filterCutoff toReceiver:@"cutoff"];
}

- (void)setDelayTime:(float)delayTime {
    _delayTime = delayTime;
    [PdBase sendFloat:delayTime toReceiver:@"time"];
}

- (void)setDelayFeedback:(float)delayFeedback {
    _delayFeedback = delayFeedback;
    [PdBase sendFloat:delayFeedback toReceiver:@"feedback"];
}

- (void)savePatch {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_lfoWaveForm forKey:MonotoneDelayLFOWaveFormKey];
    [userDefaults setFloat:_lfoRate forKey:MonotoneDelayLFORateKey];
    [userDefaults setFloat:_lfoInterval forKey:MonotoneDelayLFOIntervalKey];
    [userDefaults setFloat:_filterCutoff forKey:MonotoneDelayFilterCutoffKey];
    [userDefaults setFloat:_delayTime forKey:MonotoneDelayDelayTimeKey];
    [userDefaults setFloat:_delayFeedback forKey:MonotoneDelayDelayFeedbackKey];
}

@end
