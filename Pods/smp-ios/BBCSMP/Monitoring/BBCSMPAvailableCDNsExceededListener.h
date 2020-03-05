//
//  BBCSMPAvailableCDNsExceededListener.h
//  BBCSMP
//
//  Created by Thomas Sherwood on 15/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPErrorObserver.h"

@protocol BBCSMPMonitoringClient;

@interface BBCSMPAvailableCDNsExceededListener : NSObject <BBCSMPErrorObserver>

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient;

@end
