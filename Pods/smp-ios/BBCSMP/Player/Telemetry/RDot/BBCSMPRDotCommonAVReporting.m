//
//  BBCSMPRDotAVTelemetryService.m
//  BBCSMP
//
//  Created by Richard Gilpin on 03/07/2017.
//  Copyright © 2017 BBC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HTTPClient/HTTPClient.h>
#import "BBCSMPRDotCommonAVReporting.h"
#import "BBCSMPUUIDSessionIdentifierProvider.h"
#import "BBCSMPDuration.h"
#import "BBCSMPTimeRange.h"
#import "BBCSMPTime.h"
#import "BBCSMPError.h"
#import <SMP/SMP-Swift.h>
#import "BBCSMPLibraryUserAgentProvider.h"

static id<BBCHTTPClient> sBBCSMPWorkaroundToKeepHTTPClientAliveWhileServiceDeallocates;

@implementation BBCSMPRDotCommonAVReporting {
    id<BBCHTTPClient> _httpClient;
    NSURL *_baseUrl;
    id<BBCSMPSessionIdentifierProvider> _sessionIdentifierProvider;
    BBCLogger *_logger;
}

#pragma mark Initialization

- (instancetype)init
{
    return self = [self initWithHTTPClient:BBCHTTPNetworkClient.networkClient sessionIdentifierProvider:[[BBCSMPUUIDSessionIdentifierProvider alloc] init]];
}

- (instancetype)initWithHTTPClient:(id<BBCHTTPClient>)httpClient sessionIdentifierProvider: (id<BBCSMPSessionIdentifierProvider>)sessionIdentifierProvider
{
    self = [super init];
    if(self) {
        _httpClient = httpClient;
        _baseUrl = [NSURL URLWithString:@"https://r.bbci.co.uk"];
        _sessionIdentifierProvider = sessionIdentifierProvider;
        _logger = [[BBCLoggingDomain smpDomain] loggerWithSubdomain:@"RDot"];
    }
    return self;
}

#pragma mark BBCSMPAVTelemetryService

- (void)trackIntentToPlayWithVPID:(NSString *)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType
{
    [_sessionIdentifierProvider newSessionStarted];
    [self sendIntentToPlayMessageWithVPID:vpid AVType:AVType streamType:streamType sessionIdentifier:[_sessionIdentifierProvider getSessionIdentifier]];
}

- (void)trackHeartbeatWithVPID:(NSString *)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime *)currentTime duration:(BBCSMPDuration *)duration seekableRange:(BBCSMPTimeRange *)seekableRange supplier:(NSString *)supplier transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate
{
    [self sendHeartbeatMessageWithVPID:vpid AVType:AVType streamType:streamType currentTime:currentTime duration:duration seekableRange:seekableRange sessionIdentifier:[_sessionIdentifierProvider getSessionIdentifier] supplier: supplier transferFormat:transferFormat mediaBitrate: mediaBitrate];
}

- (void)trackErrorWithVPID:(NSString *)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime *)currentTime duration:(BBCSMPDuration *)duration seekableRange:(BBCSMPTimeRange *)seekableRange smpError:(BBCSMPError*)smpError transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate *)mediaBitrate
{
    [self sendErrorWithVPID:vpid AVType:AVType streamType:streamType currentTime:currentTime duration:duration seekableRange:seekableRange sessionIdentifier:[_sessionIdentifierProvider getSessionIdentifier] smpError:smpError transferFormat:transferFormat mediaBitrate:mediaBitrate];
}

- (void)trackPlaySuccessWithVPID:(NSString *)vpid AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType supplier:(NSString*)supplier transferFormat:(NSString *)transferFormat
{
    NSURL *url = [self preparePlaybackStartedURL:vpid AVType:AVType streamType:streamType sessionIdentifier:[_sessionIdentifierProvider getSessionIdentifier] supplier:supplier transferFormat:transferFormat];
    [self performFireAndForgetRequestWithURL: url];
}


#pragma mark Private

- (void)sendIntentToPlayMessageWithVPID:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType sessionIdentifier:(NSString *)sessionIdentifier
{
    NSURL *intentToPlayURL = [self prepareIntentToPlayURL:VPID AVType:AVType streamType: streamType sessionIdentifier:sessionIdentifier];
    [self performFireAndForgetRequestWithURL:intentToPlayURL];
}

- (void)sendHeartbeatMessageWithVPID:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime *)currentTime duration:(BBCSMPDuration *)duration seekableRange:(BBCSMPTimeRange *)seekableRange sessionIdentifier:(NSString *)sessionIdentifier supplier:(NSString *)supplier transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate
{
    [self performFireAndForgetRequestWithURL:[self prepareHeartbeatURL:VPID AVType:AVType streamType:streamType currentTime: currentTime duration: duration seekableRange: seekableRange sessionIdentifier:(NSString *)sessionIdentifier supplier:supplier transferFormat:transferFormat mediaBitrate:(BBCSMPMediaBitrate *)mediaBitrate]];
}

- (void)sendErrorWithVPID:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime *)currentTime duration:(BBCSMPDuration *)duration seekableRange:(BBCSMPTimeRange *)seekableRange sessionIdentifier:(NSString *)sessionIdentifier smpError:(BBCSMPError *)smpError transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate
{
    
    NSURLComponents *components = [self prepareCommonRDotComponents];
    if (!transferFormat) {
        transferFormat = @"-";
    }
    components.path = [NSString stringWithFormat:@"%@/e/%@/%@%ld/-/", components.path, [self prepareCommonPathComponents:VPID AVType:AVType streamType:streamType sessionIdentifier:sessionIdentifier supplier: @"-" transferFormat:transferFormat], [self prepareCommonPlaybackPathComponents:currentTime liveEdgeComponent:[self prepareLiveEdgeComponent:duration streamType:streamType seekableRange:seekableRange] mediaBitrate:mediaBitrate], (long)smpError.error.code];
    
    [self performFireAndForgetRequestWithURL:components.URL];
}

- (void)overrideBaseUrl:(NSString *)baseUrl {
    _baseUrl = [NSURL URLWithString:baseUrl];
}

- (NSURLComponents *)prepareCommonRDotComponents
{
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = _baseUrl.scheme;
    components.port = _baseUrl.port;
    components.host = _baseUrl.host;
    components.path = _baseUrl.path;
    
    return components;
}

- (NSString *)prepareCommonPathComponents:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType sessionIdentifier:(NSString *)sessionIdentifier supplier:(NSString *)supplier transferFormat:(NSString *)transferFormat
{
    NSString* avTypeAsString = @"audio";
    if (AVType == BBCSMPAVTypeVideo){
        avTypeAsString = @"video";
    }
    
    NSString* streamTypeAsString = @"live";
    if (streamType == BBCSMPStreamTypeVOD) {
        streamTypeAsString = @"ondemand";
    }
    
    if (VPID == nil || [VPID isEqualToString:@""]) {
        VPID = @"-";
    }
    
    if (supplier == nil || [supplier isEqualToString: @""]) {
        supplier = @"-";
    }
    
    if (transferFormat == nil || [transferFormat isEqualToString:@""]) {
        transferFormat = @"-";
    }
    
    return [NSString stringWithFormat:@"av/0/-/-/-/smp-ios/-/%@/-/-/%@/%@/%@/%@/-/%@", sessionIdentifier, supplier, transferFormat, avTypeAsString, streamTypeAsString, VPID];
}

- (NSURL *)prepareIntentToPlayURL:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType sessionIdentifier:(NSString *)sessionIdentifier
{
    NSURLComponents *components = [self prepareCommonRDotComponents];
    components.path = [NSString stringWithFormat:@"%@%@/", components.path, [self prepareIntentToPlayPathWithVPID:VPID AVType:AVType streamType:streamType sessionIdentifier:sessionIdentifier]];
    
    return components.URL;
}

- (NSString *)prepareIntentToPlayPathWithVPID:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType sessionIdentifier:(NSString *)sessionIdentifier
{
    NSString *commonPathComponents = [self prepareCommonPathComponents:VPID AVType:AVType streamType:streamType sessionIdentifier:sessionIdentifier supplier:@"-" transferFormat:@"-"];
    return [NSString stringWithFormat:@"/p/%@", commonPathComponents];
}

- (NSURL *)preparePlaybackStartedURL:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType sessionIdentifier:(NSString *)sessionIdentifier supplier:(NSString *)supplier transferFormat:(NSString *)transferFormat
{
    NSURLComponents *components = [self prepareCommonRDotComponents];
    components.path = [NSString stringWithFormat:@"%@%@/", components.path, [self preparePlaybackStartedWithVPID:VPID AVType:AVType streamType:streamType sessionIdentifier:sessionIdentifier supplier:supplier transferFormat:transferFormat]];
    
    return components.URL;
}

- (NSString *)preparePlaybackStartedWithVPID:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType sessionIdentifier:(NSString *)sessionIdentifier supplier:(NSString *)supplier transferFormat:(NSString *)transferFormat
{
    NSString *commonPathComponents = [self prepareCommonPathComponents:VPID AVType:AVType streamType:streamType sessionIdentifier:sessionIdentifier supplier:supplier transferFormat:transferFormat];
    return [NSString stringWithFormat:@"/ps/%@", commonPathComponents];
}

- (NSURL *)prepareHeartbeatURL:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime*)currentTime duration:(BBCSMPDuration*) duration seekableRange:(BBCSMPTimeRange*)seekableRange sessionIdentifier:(NSString *)sessionIdentifier supplier:(NSString *)supplier transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate
{
    NSURLComponents *components = [self prepareCommonRDotComponents];
    
    double liveEdgeComponent = [self prepareLiveEdgeComponent:duration streamType:streamType seekableRange:seekableRange];
    
    components.path = [NSString stringWithFormat:@"%@%@", components.path, [self prepareHeartbeatPathWithVPID:VPID AVType:AVType streamType:streamType currentTime:currentTime liveEdgeComponent:liveEdgeComponent sessionIdentifier:sessionIdentifier supplier:supplier transferFormat:transferFormat mediaBitrate:(BBCSMPMediaBitrate *)mediaBitrate]];
    
    return components.URL;
}

- (double)prepareLiveEdgeComponent:(BBCSMPDuration *)duration streamType:(BBCSMPStreamType)streamType seekableRange:(BBCSMPTimeRange*)seekableRange {
    double liveEdgeComponent = duration.seconds;
    if (streamType == BBCSMPStreamTypeSimulcast) {
        liveEdgeComponent = seekableRange.end;
    }
    return liveEdgeComponent;
}

- (NSString *)prepareHeartbeatPathWithVPID:(NSString *)VPID AVType:(BBCSMPAVType)AVType streamType:(BBCSMPStreamType)streamType currentTime:(BBCSMPTime*)currentTime liveEdgeComponent:(double)liveEdgeComponent sessionIdentifier:(NSString *)sessionIdentifier supplier:(NSString *)supplier transferFormat:(NSString *)transferFormat mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate
{
    NSString *commonPathComponents = [self prepareCommonPathComponents:VPID AVType:AVType streamType:streamType sessionIdentifier:sessionIdentifier supplier:supplier transferFormat:transferFormat];
    return [NSString stringWithFormat:@"/i/%@/%@", commonPathComponents, [self prepareCommonPlaybackPathComponents:currentTime liveEdgeComponent:liveEdgeComponent mediaBitrate:(BBCSMPMediaBitrate *)mediaBitrate]];
}

- (NSString *)prepareCommonPlaybackPathComponents:(BBCSMPTime *)currentTime liveEdgeComponent:(double)liveEdgeComponent mediaBitrate:(BBCSMPMediaBitrate*)mediaBitrate {
    NSString * bitrate = [self prepareBitrateComponent:mediaBitrate];
    return [NSString stringWithFormat:@"-/%@/-/-/-/%.01f/%.01f/", bitrate, currentTime.seconds, liveEdgeComponent];
}

- (NSString *)prepareBitrateComponent:(BBCSMPMediaBitrate *)mediaBitrate {
    NSString* bitrate = @"";
    
    if (mediaBitrate == nil || mediaBitrate.mediaBitrate == -1) {
        bitrate = @"-";
    } else {
        bitrate = [NSString stringWithFormat:@"%.0f", (mediaBitrate.mediaBitrate / 1000)];
    }
    return bitrate;
}

- (void)performFireAndForgetRequestWithURL:(NSURL *)URL
{
    BBCStringLogMessage *message = [BBCStringLogMessage messageWithMessage:[URL absoluteString]];
    [_logger logMessage:message];
    
    BBCHTTPNetworkRequest *request = [BBCHTTPNetworkRequest requestWithURL:URL];
    BBCHTTPLibraryUserAgent* libraryUserAgent = [BBCHTTPLibraryUserAgent userAgentWithLibraryName:@"smpiOS" libraryVersion:@BBC_SMP_VERSION];
    [request withUserAgent: libraryUserAgent];

    sBBCSMPWorkaroundToKeepHTTPClientAliveWhileServiceDeallocates = _httpClient;
    [_httpClient sendRequest:request
                     success:^(id<BBCHTTPRequest>  _Nonnull request, id<BBCHTTPResponse>  _Nullable response) {
                         NSLog(@"");
                     }
                     failure:^(id<BBCHTTPRequest>  _Nonnull request, id<BBCHTTPError>  _Nullable error) {}];
}

@end
