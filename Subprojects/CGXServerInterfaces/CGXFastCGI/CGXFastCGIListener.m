//
//  CGXFastCGIListener.m
//  CGXServerInterfaces
//
//  Created by Maxthon Chan on 5/23/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGXFastCGIListener.h"

#import "fastcgi/fcgiapp.h"
#import "CGXFastCGIContext.h"
#import "NSError+CGXFastCGIErrors.h"

@implementation CGXFastCGIListener
{
    BOOL _initialized;
    BOOL _terminated;
    
    NSString *_address;
    int _fd;
}

+ (NSString *)listenerType
{
    return CGIFastCGIServerProtocol;
}

- (instancetype)init
{
    return [self initWithAddress:nil];
}

- (instancetype)initWithAddress:(NSString *)address
{
    if (self = [super initWithAddress:address])
    {
        _address = address ?: @":9000";
    }
    return self;
}

- (void)beginAcceptingContext
{
    if (_terminated)
        return;
    
    if (!_initialized)
    {
        _initialized = YES;
        FCGX_Init();
        
        if ((_fd = FCGX_OpenSocket(_address.UTF8String, 128)) < 0)
        {
            [self didEncounterError:CGXFastCGIError(errno)];
        }
        
        [super beginAcceptingContext];
    }
}

- (void)endAcceptingContext
{
    if (!_terminated)
    {
        _terminated = YES;
        FCGX_ShutdownPending();
    }
    [super endAcceptingContext];
}

- (CGIContext *)acceptContextWithError:(NSError * _Nullable __autoreleasing *)error
{
    if (_terminated)
    {
        POINTER_ASSIGN(error, [NSError errorWithDomain:NSPOSIXErrorDomain
                                                  code:EAGAIN
                                              userInfo:nil]);
        return nil;
    }
    
    if (!_initialized)
    {
        _initialized = YES;
        FCGX_Init();
    }
    
    NSError *_error = nil;
    CGXFastCGIContext *ctx = [[CGXFastCGIContext alloc] initWithUpstreamSocket:_fd
                                                                     withError:&_error];
    if (!ctx)
    {
        POINTER_ASSIGN(error, _error);
        return nil;
    }
    
    if (![ctx acceptWithError:&_error])
    {
        POINTER_ASSIGN(error, _error);
        return nil;
    }
    
    return ctx;
}

@end
