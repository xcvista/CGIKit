//
//  CGICookie.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGICookie : NSObject

@property NSString *key;
@property (nullable) NSString *value;

@property (nullable) NSDate *expires;
@property (nullable) NSString *domain;
@property (nullable) NSString *path;
@property BOOL limitAge;
@property BOOL HTTPOnly;
@property BOOL secure;

@property (copy, readonly) NSString *description;
@property (copy, readonly) NSString *debugDescription;

- (instancetype)initWithValue:(NSString *)value forKey:(nullable NSString *)key NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

@end

@interface NSDate (CGIRFC1123Format)

@property (readonly) NSString *rfc1123String;

@end

NS_ASSUME_NONNULL_END
