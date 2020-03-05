//
//  BBCSMPMediaResolutionSuccessfulListener.m
//  BBCSMP
//
//  Created by Thomas Sherwood on 22/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPMediaResolutionSuccessfulListener.h"
#import "BBCSMPMonitoringClient.h"
#import "BBCSMPState.h"

@interface BBCSMPMediaResolutionSuccessfulListener ()

@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;

@end

@implementation BBCSMPMediaResolutionSuccessfulListener

#pragma mark Initialization

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient
{
    self = [super init];
    if (self) {
        _monitoringClient = monitoringClient;
    }

    return self;
}

#pragma mark BBCSMPStateObserver

- (void)stateChanged:(BBCSMPState*)state
{
    if (state.state == BBCSMPStateItemLoaded) {
        [_monitoringClient itemDidLoad];
    }
}

@end
