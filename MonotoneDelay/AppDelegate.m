//
//  AppDelegate.m
//  MonotoneDelay
//
//  Created by Justus Kandzi on 02/03/15.
//
//

#import "AppDelegate.h"
#import "MonotoneAudioEngine.h"

#import <Audiobus/Audiobus.h>

@interface AppDelegate ()
@property (strong, nonatomic) ABAudiobusController *audiobusController;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
#pragma unused(application)
#pragma unused(launchOptions)
    
    [MonotoneAudioEngine sharedSoundEngine].active = YES;
    
    [self setupAudiobus];
    return YES;
}

- (void)setupAudiobus {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionsChanged:)
                                                 name:ABConnectionsChangedNotification
                                               object:nil];
    
    self.audiobusController = [[ABAudiobusController alloc] initWithApiKey:@"MCoqKm1vbm90b25lKioqbW9ub3RvbmUuYXVkaW9idXM6Ly8=:Warrnb2Wdc5wd7s0m+JHlCV23Iy9Um1keHSGchfWhbqSM63BV6XmWV2f0BpPILXeRv6RyFEbfto6ig5FIaOWacelZ6xUEmce97fcpZqfBlcxY73a0LqJdsiAmteRdYWv"];
    
    self.audiobusController.connectionPanelPosition = ABConnectionPanelPositionRight;
    
    ABSenderPort *sender = [[ABSenderPort alloc] initWithName:@"Audio Output"
                                                        title:@"Monotone Delay Output"
                                    audioComponentDescription:(AudioComponentDescription) {
                                        .componentType = kAudioUnitType_RemoteGenerator,
                                        .componentSubType = 'mono',
                                        .componentManufacturer = 'kndz' }
                                                    audioUnit:[MonotoneAudioEngine sharedSoundEngine].audioUnit];
    [_audiobusController addSenderPort:sender];
 
}

- (void)connectionsChanged:(NSNotification*)notification {
#pragma unused(notification)
    MonotoneAudioEngine *soundEngine = [MonotoneAudioEngine sharedSoundEngine];
    [NSObject cancelPreviousPerformRequestsWithTarget:soundEngine
                                             selector:@selector(stop)
                                               object:nil];
    
    if (self.audiobusController.connected && !soundEngine.isActive ) {
        soundEngine.active = YES;
    }
    else if (!self.audiobusController.connected && soundEngine.active
             && [[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground ) {
        [soundEngine performSelector:@selector(stop) withObject:nil afterDelay:10.0];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
#pragma unused(application)
    [[MonotoneAudioEngine sharedSoundEngine] savePatch];
    
    if (!self.audiobusController.connected) {
        [MonotoneAudioEngine sharedSoundEngine].active = NO;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
#pragma unused(application)
    MonotoneAudioEngine *soundEngine = [MonotoneAudioEngine sharedSoundEngine];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:soundEngine selector:@selector(stop) object:nil];
    
    if (!soundEngine.isActive ) {
        soundEngine.active = YES;
    }
}

@end
