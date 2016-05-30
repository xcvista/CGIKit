//
//  CGISessionManager.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/27/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGISessionManager.h"

@interface NSMutableDictionary (CGISessionStorage) <CGISessionManagerStorage>

@end

@implementation NSMutableDictionary (CGISessionStorage)

- (void)setSession:(CGISession *)session withIdentifier:(NSString *)identifier
{
    self[identifier] = session;
}

- (void)removeSessionWithIdentifier:(NSString *)identifier
{
    [self removeObjectForKey:identifier];
}

- (CGISession *)sessionWithIdentifier:(NSString *)identifier
{
    return self[identifier];
}

@end

static CGISessionManager *_CGXDefaultSessionManager;

@implementation CGISessionManager

@synthesize storage = _storage;

+ (instancetype)sharedSessionManager
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = nil;
    if (!_CGXDefaultSessionManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (!_CGXDefaultSessionManager)
            {
                if ((_CGXDefaultSessionManager = [super init]))
                {
                    _storage = [NSMutableDictionary dictionary];
                }
            }
        });
    }
    
    return _CGXDefaultSessionManager;
}

@end
