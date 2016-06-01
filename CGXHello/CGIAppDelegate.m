//
//  CGIAppDelegate.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIAppDelegate.h"

@implementation CGIAppDelegate

- (void)listener:(CGIListener *)listener handleContextX:(CGIContext *)context
{
    NSLog(@"CTX: %@ %@", listener, context);
    context.response[CGIHTTPHeaderContentType] = @"text/plain";
    [context.server log:@"hello"];
    [context.response.outputStream writeString:@"hello" usingEncoding:NSUTF8StringEncoding withError:NULL];
}

- (void)listener:(CGIListener *)listener didEncounterError:(NSError *)error
{
    NSLog(@"ERR: %@ %@", listener, error);
}

@end
