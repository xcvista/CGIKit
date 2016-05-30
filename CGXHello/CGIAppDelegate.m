//
//  CGIAppDelegate.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIAppDelegate.h"

@implementation CGIAppDelegate

- (void)listener:(CGIListener *)listener didAcceptContext:(CGIContext *)context
{
    NSLog(@"CTX: %@ %@", listener, context);
}

- (void)listener:(CGIListener *)listener didEncounterError:(NSError *)error
{
    NSLog(@"ERR: %@ %@", listener, error);
}

@end
