//
//  BBCSMPTimeToPlayListener.m
//  BBCSMP
//
//  Created by Al Priest on 11/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPTimeToPlayListener.h"
#import "BBCSMPMonitoringClient.h"
#import "BBCSMPState.h"
#import "BBCSMPTimeProvider.h"
#import "BBCSMPMonitoringClient.h"

@interface BBCSMPTimeToPlayListener ()
@property (nonatomic, assign) BOOL shouldMonitorForPlayingState;
@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;
@property (nonatomic, strong) id<BBCSMPTimerProvider> timerProvider;
@property (nonatomic, assign) NSTimeInterval loadedTimeDuration;
@end

@implementation BBCSMPTimeToPlayListener

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient andTimerProvider:(id<BBCSMPTimerProvider>)timerProvider;
{
    self = [super init];
    if (self) {
        self.monitoringClient = monitoringClient;
        self.timerProvider = timerProvider;
    }
    return self;
}

- (void)stateChanged:(BBCSMPState*)state
{

    if (state.state == BBCSMPStateLoadingItem) {
        self.shouldMonitorForPlayingState = YES;
        [self.timerProvider start];
    }

    if (state.state == BBCSMPStatePlaying && self.shouldMonitorForPlayingState) {
        [self itemDidStartPlaying];
    }
}

- (void)itemDidStartPlaying
{
    [self.monitoringClient itemDidStartPlaying:[self.timerProvider durationSinceStart]];
    self.shouldMonitorForPlayingState = NO;
}

@end
