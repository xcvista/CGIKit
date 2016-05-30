//
//  CGICookie.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/30/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGICookie.h"

@implementation CGICookie

- (instancetype)initWithValue:(NSString *)value forKey:(NSString *)key
{
    if (self = [super init])
    {
        self.value = value;
        self.key = key;
    }
    
    return self;
}

// This is how I deal with cookies: using -[NSObject description]. Pretty smart, eh?
- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"%@=%@", self.key, self.value ?: @"deleted"];
    
    if (!self.value)
    {
        self.expires = [NSDate dateWithTimeIntervalSinceNow:-86400];
    }
    
    if (self.expires)
    {
        if (self.limitAge)
            [description appendFormat:@"; Max-Age=%.0f", self.expires.timeIntervalSinceNow];
        else
            [description appendFormat:@"; Expires=%@", self.expires.rfc1123String];
    }
    
    if (self.domain)
        [description appendFormat:@"; Domain=%@", self.domain];
    
    if (self.path)
        [description appendFormat:@"; Path=%@", self.path];
    
    if (self.HTTPOnly)
        [description appendString:@"; HttpOnly"];
    
    if (self.secure)
        [description appendString:@"; Secure"];
    
    return description.copy;
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@ %@", [super debugDescription], [self description]];
}

@end

@implementation NSDate (CGIRFC1123Format)

- (NSString *)rfc1123String
{
    NSDateComponents *dateComponents = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] componentsInTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0] fromDate:self];
    return [NSString stringWithFormat:@"%@, %02ld %@ %04ld %02ld:%02ld:%02ld GMT",
            @[@"", @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat"][dateComponents.weekday],
            dateComponents.day,
            @[@"", @"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec"][dateComponents.month],
            dateComponents.year,
            dateComponents.hour,
            dateComponents.minute,
            dateComponents.second];
}

@end
