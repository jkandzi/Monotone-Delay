//
//  PotentiometerView.m
//  monotone
//
//  Created by Justus Kandzi on 01.11.13.
//  Copyright (c) 2013 Justus Kandzi. All rights reserved.
//

#import "PotentiometerView.h"

@interface PotentiometerView ()
@property (nonatomic, assign) float touchStartY;
@property (nonatomic, assign) float oldValue;
@end

@implementation PotentiometerView

- (void)setValue:(float)value {
    _value = value;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef con = UIGraphicsGetCurrentContext();
    [[UIImage imageNamed:@"PotentiometerBackground"] drawInRect:rect];
    
    float angle = -160.f + 320.f * self.value;
    
    CGContextTranslateCTM(con, rect.size.width * 0.5f, rect.size.height * 0.5f);
    CGContextRotateCTM(con, angle * (float)M_PI / 180.f);
    CGContextTranslateCTM(con, rect.size.width * -0.5f, rect.size.height * -0.5f);
    [[UIImage imageNamed:@"PotentiometerLine"] drawInRect:rect];
}

#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(event)
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    self.oldValue = self.value;
    self.touchStartY = location.y;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
#pragma unused(event)
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    float tempPotiValue = (self.touchStartY - location.y) / 100 + self.oldValue;
    
    tempPotiValue = MAX(0.f, tempPotiValue);
    tempPotiValue = MIN(1.f, tempPotiValue);
    
    self.value = tempPotiValue;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
