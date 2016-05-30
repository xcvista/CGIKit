//
//  main.m
//  CGXHello
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGIKit.h>

#import "CGIAppDelegate.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        CGIListener *listener = [CGIListener listener];
        CGIAppDelegate *delegate = [[CGIAppDelegate alloc] init];
        listener.delegate = delegate;
        
        NSRunLoop *rl = [NSRunLoop mainRunLoop];
        [listener beginAcceptingContext];
        while (listener.running)
        {
            [rl runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
        [listener endAcceptingContext];
    }
}
