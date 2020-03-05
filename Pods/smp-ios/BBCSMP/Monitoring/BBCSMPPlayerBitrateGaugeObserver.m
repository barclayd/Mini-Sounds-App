//
//  BBCSMPPlayerBitrateGaugeObserver.m
//  BBCSMP
//
//  Created by Thomas Sherwood on 16/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPPlayerBitrateGaugeObserver.h"
#import "BBCSMPMonitoringClient.h"

@interface BBCSMPPlayerBitrateGaugeObserver ()

@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;

@end

#pragma mark -

@implementation BBCSMPPlayerBitrateGaugeObserver

#pragma mark Initialization

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient
{
    self = [super init];
    if (self) {
        _monitoringClient = monitoringClient;
    }

    return self;
}

#pragma mark BBCSMPPlayerBitrateObserver

- (void)playerBitrateChanged:(double)bitrate
{
    NSString* bitrateString = [@(floor(bitrate)) stringValue];
    [self.monitoringClient updateGaugeMetricNamed:@"videoBitrate" value:bitrateString];
}

@end
