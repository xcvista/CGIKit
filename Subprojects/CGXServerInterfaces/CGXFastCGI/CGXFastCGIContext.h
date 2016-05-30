//
//  CGXFastCGIContext.h
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/28/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CGXFastCGIContext : CGIContext

- (instancetype)init NS_UNAVAILABLE;
- (nullable instancetype)initWithUpstreamSocket:(int)socket withError:(NSError **)error NS_DESIGNATED_INITIALIZER;

- (BOOL)acceptWithError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
