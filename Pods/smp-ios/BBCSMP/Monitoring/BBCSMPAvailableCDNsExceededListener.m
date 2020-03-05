//
//  BBCSMPAvailableCDNsExceededListener.m
//  BBCSMP
//
//  Created by Thomas Sherwood on 15/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPAvailableCDNsExceededListener.h"
#import "BBCSMPError.h"
#import "BBCSMPMonitoringClient.h"

@interface BBCSMPAvailableCDNsExceededListener ()

@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;

@end

@implementation BBCSMPAvailableCDNsExceededListener

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
    if (error.reason == BBCSMPErrorAvailableCDNsExceeded) {
        [self.monitoringClient availableCDNsExceeded];
    }
}

@end
