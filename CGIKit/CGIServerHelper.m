//
//  CGIServerHelper.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/24/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIServerHelper.h"

#import "CGIContext.h"
#import "CGIRequest.h"
#import "CGIResponse.h"

#import <pthread.h>
#import <syslog.h>

@implementation NSString (CGIHTTPStringManipulator)

- (NSString *)stringByAddingHTMLEscaping
{
    return CFBridgingRelease(CFXMLCreateStringByEscapingEntities(kCFAllocatorDefault,
                                                                 (__bridge CFStringRef)self,
                                                                 NULL));
}

- (NSString *)stringByRemovingHTMLEncoding
{
    return CFBridgingRelease(CFXMLCreateStringByUnescapingEntities(kCFAllocatorDefault,
                                                                   (__bridge CFStringRef)self,
                                                                   NULL));
}

@end

@implementation CGIServerHelper

@synthesize context = _context;
@synthesize documentRoot = _documentRoot;
@synthesize errorStream = _errorStream;

+ (void)initialize
{
    if (self == [CGIServerHelper class])
    {
        openlog([NSProcessInfo processInfo].processName.UTF8String, LOG_CONS, LOG_USER);
    }
}

- (instancetype)initWithContext:(CGIContext *)context documentRoot:(NSURL *)documentRoot errorStream:(NSOutputStream *)stream
{
    if (self = [super init])
    {
        _context = context;
        _documentRoot = documentRoot;
        _errorStream = stream;
    }
    return self;
}

- (NSURL *)mapPath:(NSString *)virtualPath
{
    return nil;
}

- (void)log:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    [self log:format withArguemnts:args];
    va_end(args);
}

- (void)log:(NSString *)format withArguemnts:(va_list)args
{
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:args];
    
    NSString *logString = [NSString stringWithFormat:@"%@ %@[%d:%u-%@:%@ %@ %@ 0x%016lx] %@\n",
                           [NSDate date],
                           [NSProcessInfo processInfo].processName,
                           [NSProcessInfo processInfo].processIdentifier,
                           pthread_mach_thread_np(pthread_self()),
                           _context.request.environment[CGIEnvironmentRemoteAddr],
                           _context.request.environment[@"REMOTE_PORT"],
                           _context.request.method,
                           _context.request.requestURI,
                           (uintptr_t)_context,
                           formattedString];
    syslog(LOG_INFO, "%s", logString.UTF8String);
    fprintf(stderr, "%s", logString.UTF8String);
    [_errorStream writeString:logString
                usingEncoding:NSUTF8StringEncoding
                    withError:NULL];
}

@end
