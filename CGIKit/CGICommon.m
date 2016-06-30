//
//  CGICommon.m
//  CGIKit
//
//  Created by Maxthon Chan on 6/6/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGICommon.h"

#import "CGIServerHelper.h"

@implementation NSObject (CGIHTMLDescription)

- (NSString *)descriptionInInnerHTML
{
    NSString *string = self.description.stringByAddingHTMLEscaping;
    return string.length ? string : @"<i>empty</i>";
}

- (NSString *)descriptionInHTML
{
    return self.descriptionInInnerHTML;
}

@end

@implementation NSDictionary (CGIHTMLDescription)

- (NSString *)descriptionInHTML
{
    return [NSString stringWithFormat:@"<table>\n%@\n</table>", self.descriptionInInnerHTML];
}

NSInteger _CGXHtmlStringSorter(id a, id b, void *self)
{
    return [[a descriptionInHTML] compare:[b descriptionInHTML]];
}

- (NSString *)descriptionInInnerHTML
{
    NSMutableString *output = [NSMutableString string];
    if (!self.count)
    {
        return @"<tr><td><i>empty</i></td></tr>\n";
    }
    else
    {
        NSArray *keys = [self.allKeys sortedArrayUsingFunction:_CGXHtmlStringSorter
                                                       context:(__bridge void *)self];
        for (id key in keys)
        {
            id value = self[key];
            NSString *keyString = [key descriptionInHTML];
            if ([value isKindOfClass:[NSSet class]])
            {
                value = [value allObjects];
            }
            else if ([value isKindOfClass:[NSOrderedSet class]])
            {
                value = [value array];
            }
            
            if ([value isKindOfClass:[NSArray class]])
            {
                NSArray *array = value;
                if (array.count)
                {
                    for (NSUInteger idx = 0; idx < array.count; idx++)
                    {
                        id object = array[idx];
                        if (idx)
                            [output appendFormat:@"<tr><th rowspan=\"%lu\">%@</th><td>%@</td></tr>\n", array.count, keyString, [object descriptionInHTML]];
                        else
                            [output appendFormat:@"<tr><td>%@</td></tr>\n", [object descriptionInHTML]];
                    }
                }
                else
                {
                    [output appendFormat:@"<tr><th>%@</th><td><i>empty</i></td></tr>\n", keyString];
                }
            }
            else
            {
                [output appendFormat:@"<tr><th>%@</th><td>%@</td></tr>\n", keyString, [value descriptionInHTML]];
            }
        }
    }
    
    return output;
}

@end

@implementation NSArray (CGIHTMLDescription)

- (NSString *)descriptionInHTML
{
    return [NSString stringWithFormat:@"<table>\n%@\n</table>", self.descriptionInInnerHTML];
}

- (NSString *)descriptionInInnerHTML
{
    NSMutableString *output = [NSMutableString string];
    if (!self.count)
    {
        return @"<tr><td><i>empty</i></td></tr>\n";
    }
    else for (id key in self)
    {
        [output appendFormat:@"<tr><td>%@</td></tr>\n", [key descriptionInHTML]];
    }
    return output;
}

@end

@implementation NSSet (CGIHTMLDescription)

- (NSString *)descriptionInHTML
{
    return [NSString stringWithFormat:@"<table>\n%@\n</table>", self.descriptionInInnerHTML];
}

- (NSString *)descriptionInInnerHTML
{
    return self.allObjects.descriptionInInnerHTML;
}

@end

@implementation NSOrderedSet (CGIHTMLDescription)

- (NSString *)descriptionInHTML
{
    return [NSString stringWithFormat:@"<table>\n%@\n</table>", self.descriptionInInnerHTML];
}

- (NSString *)descriptionInInnerHTML
{
    return self.array.descriptionInInnerHTML;
}

@end

@implementation NSNull (CGIHTMLDescription)

- (NSString *)descriptionInInnerHTML
{
    return @"<i>null</i>";
}

@end
