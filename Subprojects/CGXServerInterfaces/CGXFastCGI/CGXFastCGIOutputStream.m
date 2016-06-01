//
//  CGXFastCGIOutputStream.m
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 6/1/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXFastCGIOutputStream.h"

@implementation CGXFastCGIOutputStream
{
    FCGX_Stream *_s;
}

- (instancetype)initWithFCGXStream:(FCGX_Stream *)stream
{
    if (self = [super initToMemory])
    {
        _s = stream;
    }
    return self;
}

- (NSInteger)write:(const uint8_t *)buffer maxLength:(NSUInteger)len
{
    int rv = FCGX_PutStr((const char *)buffer, (int)len, _s);
    FCGX_FFlush(_s);
    return rv;
}

- (BOOL)hasSpaceAvailable
{
    return YES;
}

@end
