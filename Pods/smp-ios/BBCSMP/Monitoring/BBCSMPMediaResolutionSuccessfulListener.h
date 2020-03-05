//
//  BBCSMPMediaResolutionSuccessfulListener.h
//  BBCSMP
//
//  Created by Thomas Sherwood on 22/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPStateObserver.h"

@protocol BBCSMPMonitoringClient;

@interface BBCSMPMediaResolutionSuccessfulListener : NSObject <BBCSMPStateObserver>

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient;

@end
