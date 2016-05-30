//
//  CGXFastCGIInputStream.m
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXFastCGIInputStream.h"

@implementation CGXFastCGIInputStream
{
    FCGX_Stream *_s;
}

- (instancetype)initWithFCGXStream:(FCGX_Stream *)stream
{
    if (self = [super initWithData:[NSData data]])
    {
        _s = stream;
    }
    return self;
}

- (NSInteger)read:(uint8_t *)buffer maxLength:(NSUInteger)len
{
    return FCGX_GetStr((char *)buffer, (int)len, _s);
}

- (BOOL)getBuffer:(uint8_t * _Nullable *)buffer length:(NSUInteger *)len
{
    return NO;
}

- (BOOL)hasBytesAvailable
{
    return !FCGX_HasSeenEOF(_s);
}

@end
