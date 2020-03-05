//
//  BBCSMPPlayerBitrateGaugeObserver.h
//  BBCSMP
//
//  Created by Thomas Sherwood on 16/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPPlayerBitrateObserver.h"

@protocol BBCSMPMonitoringClient;

@interface BBCSMPPlayerBitrateGaugeObserver : NSObject <BBCSMPPlayerBitrateObserver>

- (nullable instancetype)init NS_UNAVAILABLE;
- (nonnull instancetype)initWithMonitoringClient:(nonnull id<BBCSMPMonitoringClient>)monitoringClient NS_DESIGNATED_INITIALIZER;

@end
