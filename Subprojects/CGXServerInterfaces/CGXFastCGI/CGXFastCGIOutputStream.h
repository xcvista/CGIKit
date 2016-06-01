//
//  CGXFastCGIOutputStream.h
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "fastcgi/fcgiapp.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGXFastCGIOutputStream : NSOutputStream

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initToMemory NS_UNAVAILABLE;
- (instancetype)initToBuffer:(uint8_t *)buffer capacity:(NSUInteger)capacity NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url append:(BOOL)shouldAppend NS_UNAVAILABLE;
- (instancetype)initWithFCGXStream:(FCGX_Stream *)stream;

@end

NS_ASSUME_NONNULL_END
