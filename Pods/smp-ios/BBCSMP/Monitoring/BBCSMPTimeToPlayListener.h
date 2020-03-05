//
//  BBCSMPTimeToPlayListener.h
//  BBCSMP
//
//  Created by Al Priest on 11/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPStateObserver.h"

@protocol BBCSMPMonitoringClient;
@protocol BBCSMPTimerProvider;

@interface BBCSMPTimeToPlayListener : NSObject <BBCSMPStateObserver>

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient
                        andTimerProvider:(id<BBCSMPTimerProvider>)timerProvider;

@end
