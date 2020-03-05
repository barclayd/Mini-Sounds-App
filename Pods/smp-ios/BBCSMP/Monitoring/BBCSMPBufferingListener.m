//
//  BBCSMPMonitoringClient.m
//  BBCSMP
//
//  Created by Al Priest on 19/11/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPBufferingListener.h"
#import "BBCSMPDuration.h"
#import "BBCSMPMonitoringClient.h"
#import "BBCSMPTimeProvider.h"
#import <SMP/SMP-Swift.h>

@interface BBCSMPBufferingListener () <BBCSMPPlaybackStateObserver>

@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;
@property (nonatomic, strong) id<BBCSMPTimerProvider> timeProvider;
@property (nonatomic, strong) id<SMPPlaybackState> currentPlaybackState;
@property (nonatomic, assign) BOOL startedBuffering;

@end

@implementation BBCSMPBufferingListener

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient andTimerProvider:(id<BBCSMPTimerProvider>)timeProvider
{
    self = [super init];
    if (self) {
        self.monitoringClient = monitoringClient;
        self.timeProvider = timeProvider;
    }
    return self;
}

- (void)state:(id<SMPPlaybackState>)state
{
    if ([self didStartBuffering:state]) {
        [self bufferingStarted];
    } else if ([self didResumePlayingAfterBuffering:state]) {
        [self.monitoringClient bufferingDidOccur:[self bufferingDuration]];
    }
    
    self.currentPlaybackState = state;
}

- (NSTimeInterval)bufferingDuration
{
    return self.timeProvider.durationSinceStart;
}

- (void)bufferingStarted
{
    self.startedBuffering = YES;
    [self.timeProvider start];
}

- (BOOL)didStartBuffering:(id<SMPPlaybackState>)newState
{
    id newPlaybackState = newState;
    id currentState = self.currentPlaybackState;
    
    return [currentState isKindOfClass:[SMPPlaybackStatePlaying class]] && [newPlaybackState isKindOfClass:[SMPPlaybackStateLoading class]];
}

- (BOOL)didResumePlayingAfterBuffering:(id<SMPPlaybackState>)newState
{
    id newPlaybackState = newState;
    id currentState = self.currentPlaybackState;
    
    return [currentState isKindOfClass:[SMPPlaybackStateLoading class]] && [newPlaybackState isKindOfClass:[SMPPlaybackStatePlaying class]] && self.startedBuffering;
}

@end
