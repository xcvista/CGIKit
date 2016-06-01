//
//  CGIListener.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/23/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGICommon.h>

@class CGIContext;
@class CGIListener;
@protocol CGIContextHandler;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const CGIFastCGIServerProtocol;
FOUNDATION_EXPORT NSString *const CGIHypertexrtServerProtocol;
FOUNDATION_EXPORT NSString *const CGIApacheModuleServerProtocol;

FOUNDATION_EXPORT NSString *const CGIDefaultListenerTypeKey;
FOUNDATION_EXPORT NSString *const CGIDefaultListenerAddressKey;

FOUNDATION_EXPORT NSString *const CGISpecialPathMarker;

@protocol CGIListenerDelegate <NSObject>

@optional
- (void)listener:(CGIListener *)listener didAcceptContext:(CGIContext *)context;
- (void)listener:(CGIListener *)listener didEncounterError:(NSError *)error;
- (nullable id<CGIContextHandler>)listener:(CGIListener *)listener handlerForContext:(CGIContext *)context;
- (void)listener:(CGIListener *)listener handleContext:(CGIContext *)context;

@end

@interface CGIListener : NSObject

@property (nullable, weak) id<CGIListenerDelegate> delegate;
@property (readonly, assign, getter=isRunning) BOOL running;

+ (void)scanForPluginsInDirectoryWithURL:(NSURL *)url;
+ (instancetype)listenerWithType:(NSString *)type;
+ (instancetype)listenerWithType:(NSString *)type listeningAddress:(nullable NSString *)address;
+ (instancetype)listenerWithAddress:(nullable NSString *)address;
+ (instancetype)listener;

+ (NSString *)listenerType;

+ (void)addHandler:(id<CGIContextHandler>)handler forSpecialPath:(NSString *)path;
+ (void)removeHandlerForSpecialPath:(NSString *)path;
+ (nullable id<CGIContextHandler>)handlerForSpecialPath:(NSString *)path;

- (instancetype)init;
- (instancetype)initWithType:(NSString *)type;
- (instancetype)initWithAddress:(nullable NSString *)address NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithType:(NSString *)type listeningAddress:(nullable NSString *)address;

- (void)beginAcceptingContext;
- (void)endAcceptingContext;
- (nullable CGIContext *)acceptContextWithError:(NSError **)error;

- (void)didAcceptContext:(CGIContext *)context;
- (void)didEncounterError:(NSError *)error;

@end

@interface CGIListener (CGIListenerDelegate)

- (nullable id<CGIContextHandler>)handlerForContext:(CGIContext *)context;
- (void)handleContext:(CGIContext *)context;

@end

NS_ASSUME_NONNULL_END
