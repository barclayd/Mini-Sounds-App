//
//  BBCSMPAVTelemetryService.h
//  BBCSMP
//
//  Created by Thomas Sherwood - TV&Mobile Platforms - Core Engineering on 26/04/2017.
//  Copyright © 2017 BBC. All rights reserved.
//

#import "BBCSMPAVType.h"
#import "BBCSMPStreamType.h"

@class BBCSMPDuration;
@class BBCSMPTime;
@class BBCSMPTimeRange;
@class BBCSMPError;
@class BBCSMPMediaBitrate;

@protocol BBCSMPCommonAVReporting <NSObject>
@required

- (void)trackIntentToPlayWithVPID:(NSString *)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType;
- (void)trackHeartbeatWithVPID:(NSString*)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime*)currentTime duration:(BBCSMPDuration*)duration seekableRange:(BBCSMPTimeRange*)seekableRange supplier:(NSString*)supplier transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate;
- (void)trackErrorWithVPID:(NSString *)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime*)currentTime duration:(BBCSMPDuration*)duration seekableRange:(BBCSMPTimeRange*)seekableRange smpError:(BBCSMPError*)smpError transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate;
-(void)trackPlaySuccessWithVPID:(NSString *)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType supplier:(NSString*)supplier transferFormat:(NSString *)transferFormat;

@end
