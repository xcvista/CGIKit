//
//  CGXFastCGIResponse.m
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXFastCGIResponse.h"

@implementation CGXFastCGIResponse
{
    FCGX_Stream *_s;
    NSUInteger _watermark;
}

- (instancetype)initWithContext:(CGIContext *)context FCGXStream:(FCGX_Stream *)stream
{
    if (self = [super initWithContext:context outputStream:[NSOutputStream outputStreamToMemory]])
    {
        _s = stream;
        [_outputStream open];
    }
    return self;
}

- (void)sendHeaders
{
    if (_status == CGIResponseStatusNone)
    {
        @synchronized (self)
        {
            if (_status == CGIResponseStatusNone)
            {
                _status = CGIResponseStatusHeader;
                FCGX_FPrintF(_s,
                             "%s: %lu %s\n",
                             CGIHTTPHeaderStatus.UTF8String,
                             _statusCode,
                             _statusLine.UTF8String);
                
                for (NSString *key in _headers)
                {
                    for (NSString *value in _headers[key])
                    {
                        FCGX_FPrintF(_s,
                                     "%s: %s\n",
                                     key.UTF8String,
                                     value.UTF8String);
                    }
                }
                
                for (CGICookie *cookie in _cookies)
                {
                    FCGX_FPrintF(_s,
                                 "%s: %s\n",
                                 CGIHTTPHeaderSetCookie.UTF8String,
                                 cookie.description.UTF8String);
                }
                
                FCGX_FPrintF(_s, "\n");
                FCGX_FFlush(_s);
            }
        }
    }
}

- (void)send
{
    if (_status == CGIResponseStatusNone)
        [self sendHeaders];
    
    if (_status == CGIResponseStatusHeader)
    {
        @synchronized (self)
        {
            NSData *data = [_outputStream propertyForKey:NSStreamDataWrittenToMemoryStreamKey];
            NSUInteger length = data.length - _watermark;
            if (length)
            {
                NSData *chunk = [data subdataWithRange:NSMakeRange(_watermark, length)];
                _watermark = data.length;
                FCGX_PutStr(chunk.bytes, (int)length, _s);
            }
            
            FCGX_FFlush(_s);
        }
    }
}

@end
