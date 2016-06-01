//
//  CGIContext.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/22/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGICommon.h>

@class CGIListener, CGIRequest, CGIResponse, CGIServerHelper;

NS_ASSUME_NONNULL_BEGIN

@class CGIContext;

@protocol CGIContextHandler <NSObject>

- (void)handleContext:(CGIContext *)context;

@end

@interface CGIContext : NSObject
{
@protected
    __weak CGIListener *_listener;
    CGIRequest *_request;
    CGIResponse *_response;
    CGIServerHelper *_server;
    __nullable id _session;
}

@property (readonly, weak) CGIListener *listener;
@property (readonly) CGIRequest *request;
@property (readonly) CGIResponse *response;
@property (readonly) CGIServerHelper *server;
@property (nullable) id session;

@end

NS_ASSUME_NONNULL_END
