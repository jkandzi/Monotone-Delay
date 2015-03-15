//
//  SwitchView.m
//  monotone
//
//  Created by Justus Kandzi on 01.11.13.
//  Copyright (c) 2013 Justus Kandzi. All rights reserved.
//

#import "SwitchView.h"

@implementation SwitchView

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _switchPosition = SwitchViewSwitchPositionUp;
        
        UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown)];
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:swipeDownRecognizer];
        
        UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp)];
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeUpRecognizer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [[UIImage imageNamed:@"SwitchBackground"] drawInRect:rect];
    
    CGRect switchLineRect = CGRectMake(6.f, 6.f, 14.f, 17.f);
    if (self.switchPosition == SwitchViewSwitchPositionDown) {
        switchLineRect.origin.y += 35.f;
    }
    
    [[UIImage imageNamed:@"SwitchLine"] drawInRect:switchLineRect];
}

- (void)setSwitchPosition:(SwitchViewSwitchPosition)switchPosition {
    _switchPosition = switchPosition;
    [self setNeedsDisplay];
}

- (void)swipeDown {
    if (self.switchPosition == SwitchViewSwitchPositionUp) {
        self.switchPosition = SwitchViewSwitchPositionDown;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)swipeUp {
    if (self.switchPosition == SwitchViewSwitchPositionDown) {
        self.switchPosition = SwitchViewSwitchPositionUp;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}


@end
