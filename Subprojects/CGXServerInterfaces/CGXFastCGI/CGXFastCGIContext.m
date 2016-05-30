//
//  CGXFastCGIContext.m
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/28/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXFastCGIContext.h"
#import "fastcgi/fcgiapp.h"
#import "NSError+CGXFastCGIErrors.h"
#import "CGXFastCGIInputStream.h"

@implementation CGXFastCGIContext
{
    FCGX_Request _req;
}

- (instancetype)initWithUpstreamSocket:(int)socket withError:(NSError * _Nullable __autoreleasing * _Nullable)error
{
    if (self = [super init])
    {
        int err = 0;
        if ((err = FCGX_InitRequest(&_req, socket, FCGI_FAIL_ACCEPT_ON_INTR)))
        {
            POINTER_ASSIGN(error, CGXFastCGIError(err));
            return self = nil;
        }
    }
    return self;
}

- (BOOL)acceptWithError:(NSError * _Nullable __autoreleasing *)error
{
    int rv = 0;
    if ((rv = FCGX_Accept_r(&_req)))
    {
        POINTER_ASSIGN(error, CGXFastCGIError(rv));
        return NO;
    }
    
    // Dictionarialize the environment.
    NSMutableDictionary<NSString *, NSString *> *envp = [NSMutableDictionary dictionary];
    for (char **cp = _req.envp; *cp; cp++)
    {
        @autoreleasepool
        {
            NSString *env = @(*cp);
            NSRange range = [env rangeOfString:@"="];
            NSString *key = (range.location == NSNotFound) ? env : [env substringToIndex:range.location];
            NSString *value = (range.location == NSNotFound) ? env : [env substringFromIndex:NSMaxRange(range)];
            envp[key] = value;
        }
    }
    NSInputStream *requestStream = [[CGXFastCGIInputStream alloc] initWithFCGXStream:_req.in];
    _request = [[CGIRequest alloc] initWithContext:self
                                    CGIEnvironment:envp
                                       inputStream:requestStream];
    
    return YES;
}

- (void)dealloc
{
    FCGX_Finish_r(&_req);
    FCGX_Free(&_req, YES);
}

@end
