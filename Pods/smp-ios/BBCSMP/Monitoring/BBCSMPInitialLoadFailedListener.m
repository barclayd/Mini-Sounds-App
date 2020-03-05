//
//  BBCSMPInitialLoadFailedListener.m
//  BBCSMP
//
//  Created by Al Priest on 14/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPInitialLoadFailedListener.h"
#import "BBCSMPError.h"
#import "BBCSMPMonitoringClient.h"

@interface BBCSMPInitialLoadFailedListener ()

@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;

@end

@implementation BBCSMPInitialLoadFailedListener

- (id)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient
{
    self = [super init];
    if (self) {
        _monitoringClient = monitoringClient;
    }

    return self;
}

- (void)errorOccurred:(BBCSMPError*)error
{
    if (error.reason == BBCSMPErrorInitialLoadFailed) {
        [self.monitoringClient itemDidFailToLoad];
    }
}

@end
