//
//  CGISessionManager.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/27/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGICommon.h>

NS_ASSUME_NONNULL_BEGIN

@class CGISessionManager, CGISession;

@protocol CGISessionManagerStorage <NSObject>

@required
- (void)setSession:(CGISession *)session withIdentifier:(NSString *)identifier;
- (void)removeSessionWithIdentifier:(NSString *)identifier;
- (CGISession *)sessionWithIdentifier:(NSString *)identifier;

@end

@interface CGISessionManager : NSObject

+ (instancetype)sharedSessionManager;
- (instancetype)init NS_DESIGNATED_INITIALIZER;

@property id<CGISessionManagerStorage> storage;

@end

NS_ASSUME_NONNULL_END
