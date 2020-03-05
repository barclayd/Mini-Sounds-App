//
//  BBCSMPMediaTypeListener.h
//  BBCSMP
//
//  Created by Timothy James Condon on 05/04/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCSMPObserver.h"

@protocol BBCSMPMonitoringClient;

@interface BBCSMPMetadataListener : NSObject <BBCSMPObserver>

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient;

@end
