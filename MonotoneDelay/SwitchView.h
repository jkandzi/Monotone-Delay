//
//  SwitchView.h
//  monotone
//
//  Created by Justus Kandzi on 01.11.13.
//  Copyright (c) 2013 Justus Kandzi. All rights reserved.
//

@import UIKit;

typedef NS_ENUM(NSUInteger, SwitchViewSwitchPosition) {
    SwitchViewSwitchPositionUp,
    SwitchViewSwitchPositionDown,
};

@interface SwitchView : UIControl
@property (nonatomic, assign) SwitchViewSwitchPosition switchPosition;
@end
