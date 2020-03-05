//
//  BBCSMPMonitoringClient.h
//  BBCSMP
//
//  Created by Al Priest on 19/11/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPObserver.h"

@protocol BBCSMPMonitoringClient;
@protocol BBCSMPTimerProvider;

@interface BBCSMPBufferingListener : NSObject <BBCSMPObserver>

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient
                        andTimerProvider:(id<BBCSMPTimerProvider>)timeProvider;

@end
