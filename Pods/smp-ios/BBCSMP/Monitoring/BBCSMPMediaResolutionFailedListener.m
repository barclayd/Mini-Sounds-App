//
//  BBCSMPMediaResolutionFailedListener.m
//  BBCSMP
//
//  Created by Thomas Sherwood on 15/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPMediaResolutionFailedListener.h"
#import "BBCSMPMonitoringClient.h"
#import "BBCSMPError.h"

@interface BBCSMPMediaResolutionFailedListener ()

@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;

@end

@implementation BBCSMPMediaResolutionFailedListener

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient
{
    self = [super init];
    if (self) {
        _monitoringClient = monitoringClient;
    }

    return self;
}

- (void)errorOccurred:(BBCSMPError*)error
{
    if (error.reason == BBCSMPErrorMediaResolutionFailed) {
        [self.monitoringClient mediaResolutionFailed];
    }
}

@end
