//
//  BBCSMPMonitoringClient.h
//  BBCSMP
//
//  Created by Al Priest on 19/11/2015.
//  Copyright © 2015 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBCSMPMonitoringClient <NSObject>

- (void)bufferingDidOccur:(NSTimeInterval)duration;
- (void)itemDidLoad;
- (void)itemDidStartPlaying:(NSTimeInterval)duration;
- (void)itemDidFailToLoad;
- (void)availableCDNsExceeded;
- (void)mediaResolutionFailed;
- (void)updateGaugeMetricNamed:(NSString*)gaugeName value:(NSString*)value;
- (void)setParameter:(NSString*)value forKey:(NSString*)key;

@end
