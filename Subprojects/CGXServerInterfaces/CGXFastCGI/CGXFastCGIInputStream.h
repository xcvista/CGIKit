//
//  CGXFastCGIInputStream.h
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "fastcgi/fcgiapp.h"

NS_ASSUME_NONNULL_BEGIN

@interface CGXFastCGIInputStream : NSInputStream

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURL:(NSURL *)url NS_UNAVAILABLE;
- (instancetype)initWithData:(NSData *)data NS_UNAVAILABLE;
- (instancetype)initWithFileAtPath:(NSString *)path NS_UNAVAILABLE;
- (instancetype)initWithFCGXStream:(FCGX_Stream *)stream NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
