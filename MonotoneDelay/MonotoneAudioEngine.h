//
//  MonotoneAudioEngine.h
//  monotone
//
//  Created by Justus Kandzi on 01.11.13.
//  Copyright (c) 2013 Justus Kandzi. All rights reserved.
//

@import AVFoundation;

typedef NS_ENUM(NSUInteger, MonotoneDelayWaveForm) {
    MonotoneDelayWaveFormTriangle,
    MonotoneDelayWaveFormSquare,
};

@interface MonotoneAudioEngine : NSObject

@property (nonatomic, getter=isActive) BOOL active;
@property (nonatomic, readonly, getter=isPlaying) BOOL playing;
@property (nonatomic, readonly) AudioUnit audioUnit;

@property (nonatomic, assign) MonotoneDelayWaveForm lfoWaveForm;
@property (nonatomic, assign) float lfoRate;
@property (nonatomic, assign) float lfoInterval;
@property (nonatomic, assign) float filterCutoff;
@property (nonatomic, assign) float delayTime;
@property (nonatomic, assign) float delayFeedback;
@property (nonatomic, assign) float normalizedPitch;

+ (instancetype)sharedSoundEngine;
- (void)stopPlaying;
- (void)stop;
- (void)savePatch;

@end
