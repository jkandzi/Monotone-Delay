//
//  RibbonView.m
//  monotone
//
//  Created by Justus Kandzi on 01.11.13.
//  Copyright (c) 2013 Justus Kandzi. All rights reserved.
//

#import "RibbonView.h"
#import "MonotoneAudioEngine.h"

@interface RibbonView ()
@property (nonatomic, strong) NSMutableSet *touchesSet;
@end

@implementation RibbonView

- (void)awakeFromNib {
    _touchesSet = [[NSMutableSet alloc] init];
    self.multipleTouchEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(event)
    for (UITouch *touch in touches) {
        [self.touchesSet addObject:touch];
    }
    
    [self updateTouchValue];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(touches)
#pragma unused(event)
    [self updateTouchValue];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(event)
    for (UITouch *touch in touches) {
        [self.touchesSet removeObject:touch];
    }
    
    [self updateTouchValue];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(event)
    for (UITouch *touch in touches) {
        [self.touchesSet removeObject:touch];
    }
    [self updateTouchValue];
}

- (void)updateTouchValue {
    if (self.touchesSet.count == 0) {
        [[MonotoneAudioEngine sharedSoundEngine] stopPlaying];
    }
    else {
        float average = 0.f;
        for (UITouch *touch in self.touchesSet) {
            CGPoint location = [touch locationInView:self];
            average += location.x;
        }
        average = average / self.touchesSet.count;
        
        [[MonotoneAudioEngine sharedSoundEngine] setNormalizedPitch:[self normalizedValue:average]];
    }
}

- (float)normalizedValue:(float)touchX {
    float normalizedValue = touchX / CGRectGetWidth(self.frame);
    normalizedValue = MAX(0.f, normalizedValue);
    normalizedValue = MIN(1.f, normalizedValue);
    return normalizedValue;
}

@end
