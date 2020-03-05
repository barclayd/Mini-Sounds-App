//
//  BBCSMPInitialLoadFailedListener.h
//  BBCSMP
//
//  Created by Al Priest on 14/12/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import "BBCSMPErrorObserver.h"

@protocol BBCSMPMonitoringClient;

@interface BBCSMPInitialLoadFailedListener : NSObject <BBCSMPErrorObserver>

- (id)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient;

@end
