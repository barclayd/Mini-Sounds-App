//
//  BBCSMPMediaTypeListener.m
//  BBCSMP
//
//  Created by Timothy James Condon on 05/04/2016.
//  Copyright © 2016 BBC. All rights reserved.
//

#import "BBCSMPMetadataListener.h"
#import "BBCSMPItemObserver.h"
#import "BBCSMPPreloadMetadataObserver.h"
#import "BBCSMPItemMetadata.h"
#import "BBCSMPItemPreloadMetadata.h"
#import "BBCSMPItem.h"
#import "BBCSMPMonitoringClient.h"

@interface BBCSMPMetadataListener () <BBCSMPItemObserver, BBCSMPPreloadMetadataObserver>

@property (nonatomic, strong) id<BBCSMPMonitoringClient> monitoringClient;

@end

@implementation BBCSMPMetadataListener

static NSString* const BBCSMPMonitoringParametersMediaTypeKey = @"content";
static NSString* const BBCSMPMonitoringParametersMediaSupplierKey = @"mediaResolved.supplier";
static NSString* const BBCSMPMonitoringParametersMediaIdentifierKey = @"mediaContentIdentifier";

- (instancetype)initWithMonitoringClient:(id<BBCSMPMonitoringClient>)monitoringClient
{
    self = [super init];
    if (self) {
        self.monitoringClient = monitoringClient;
    }
    return self;
}

- (void)metadataUpdated:(BBCSMPItemMetadata*)metadata
{
    if (!metadata) {
        [self.monitoringClient setParameter:nil forKey:BBCSMPMonitoringParametersMediaTypeKey];
        [self.monitoringClient setParameter:nil forKey:BBCSMPMonitoringParametersMediaSupplierKey];
        [self.monitoringClient setParameter:nil forKey:BBCSMPMonitoringParametersMediaIdentifierKey];
        return;
    }
    
    NSString* mediaType = nil;
    NSString* identifier = nil;
    switch (metadata.mediaRetrievalType) {
        case BBCSMPMediaRetrievalTypeStream: {
            switch (metadata.streamType) {
                case BBCSMPStreamTypeVOD: {
                    mediaType = @"ondemand";
                    identifier = metadata.versionId;
                    break;
                }
                case BBCSMPStreamTypeSimulcast: {
                    mediaType = @"simulcast";
                    identifier = metadata.serviceId;
                    break;
                }
                case BBCSMPStreamTypeUnknown: {
                    break;
                }
            }
            break;
        }
        case BBCSMPMediaRetrievalTypeDownload: {
            mediaType = @"download";
            identifier = metadata.versionId;
            break;
        }
    }
    
    if (mediaType) {
        NSString* avType = metadata.avType == BBCSMPAVTypeAudio ? @".audio" : @".video";
        mediaType = [mediaType stringByAppendingString:avType];
    } else {
        mediaType = @"unknown";
    }
        
    if (mediaType) {
        [self.monitoringClient setParameter:mediaType forKey:BBCSMPMonitoringParametersMediaTypeKey];
    }
    
    if (metadata.supplier) {
        [self.monitoringClient setParameter:metadata.supplier forKey:BBCSMPMonitoringParametersMediaSupplierKey];
    }
    
    if (identifier) {
        [self.monitoringClient setParameter:identifier forKey:BBCSMPMonitoringParametersMediaIdentifierKey];
    }
}

- (void)preloadMetadataUpdated:(BBCSMPItemPreloadMetadata*)preloadMetadata
{
    [self metadataUpdated:preloadMetadata.partialMetadata];
}

- (void)itemUpdated:(id<BBCSMPItem>)playerItem
{
    [self metadataUpdated:playerItem.metadata];
}

@end
