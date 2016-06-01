//
//  CGIRequest.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/24/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIRequest.h"

#import "CGIResponse.h"

NSString *const CGIHTTPHeaderAccept = @"Accept";
NSString *const CGIHTTPHeaderAcceptCharset = @"Accept-Charset";
NSString *const CGIHTTPHeaderAcceptEncoding = @"Accept-Encoding";
NSString *const CGIHTTPHeaderAcceptLanguage = @"Accept-Language";
NSString *const CGIHTTPHeaderAcceptDatetime = @"Accept-Datetime";
NSString *const CGIHTTPHeaderAuthorization = @"Authorization";
NSString *const CGIHTTPHeaderCacheControl = @"Cache-Control";
NSString *const CGIHTTPHeaderConnection = @"Connection";
NSString *const CGIHTTPHeaderCookie = @"Cookie";
NSString *const CGIHTTPHeaderContentLength = @"Content-Length";
NSString *const CGIHTTPHeaderContentMD5 = @"Content-MD5";
NSString *const CGIHTTPHeaderContentType = @"Content-Type";
NSString *const CGIHTTPHeaderDoNotTrack = @"DNT";
NSString *const CGIHTTPHeaderDate = @"Date";
NSString *const CGIHTTPHeaderExpect = @"Expect";
NSString *const CGIHTTPHeaderFrom = @"From";
NSString *const CGIHTTPHeaderHost = @"Host";
NSString *const CGIHTTPHeaderIfMatch = @"If-Match";
NSString *const CGIHTTPHeaderIfModifiedSince = @"If-Modified-Since";
NSString *const CGIHTTPHeaderIfNoneMatch = @"If-None-Match";
NSString *const CGIHTTPHeaderIfRange = @"If-Range";
NSString *const CGIHTTPHeaderIfUnmodifiedSince = @"If-Unmodified-Since";
NSString *const CGIHTTPHeaderMaxForwards = @"Max-Forwards";
NSString *const CGIHTTPHeaderOrigin = @"Origin";
NSString *const CGIHTTPHeaderPragma = @"Pragma";
NSString *const CGIHTTPHeaderProxyAuthorization = @"Proxy-Authorization";
NSString *const CGIHTTPHeaderRange = @"Range";
NSString *const CGIHTTPHeaderReferer = @"Referer";
NSString *const CGIHTTPHeaderTE = @"TE";
NSString *const CGIHTTPHeaderUserAgent = @"User-Agent";
NSString *const CGIHTTPHeaderUpgrade = @"Upgrade";
NSString *const CGIHTTPHeaderVia = @"Via";
NSString *const CGIHTTPHeaderWarning = @"Warning";

NSString *const CGIEnvironmentAuthType = @"AUTH_TYPE";
NSString *const CGIEnvironmentContentLength = @"CONTENT_LENGTH";
NSString *const CGIEnvironmentContentType = @"CONTENT_TYPE";
NSString *const CGIEnvironmentDocumentRoot = @"DOCUMENT_ROOT";
NSString *const CGIEnvironmentGatewayInterface = @"GATEWAY_INTERFACE";
NSString *const CGIEnvironmentPathInfo = @"PATH_INFO";
NSString *const CGIEnvironmentPathTranslated = @"PATH_TRANSLATED";
NSString *const CGIEnvironmentQueryString = @"QUERY_STRING";
NSString *const CGIEnvironmentRemoteAddr = @"REMOTE_ADDR";
NSString *const CGIEnvironmentRemoteHost = @"REMOTE_HOST";
NSString *const CGIEnvironmentRemoteIdent = @"REMOTE_IDENT";
NSString *const CGIEnvironmentRemoteUser = @"REMOTE_USER";
NSString *const CGIEnvironmentRequestURI = @"REQUEST_URI";
NSString *const CGIEnvironmentRequestMethod = @"REQUEST_METHOD";
NSString *const CGIEnvironmentScriptName = @"SCRIPT_NAME";
NSString *const CGIEnvironmentServerName = @"SERVER_NAME";
NSString *const CGIEnvironmentServerPort = @"SERVER_PORT";
NSString *const CGIEnvironmentServerProtocol = @"SERVER_PROTOCOL";
NSString *const CGIEnvironmentServerSoftware = @"SERVER_SOFTWARE";

NSString *_Nullable CGIHTTPHeaderFromEnvironment(NSString *environment)
{
    if ([environment isEqualToString:CGIEnvironmentContentLength])
        return CGIHTTPHeaderContentLength;
    else if ([environment isEqualToString:CGIEnvironmentContentType])
        return CGIHTTPHeaderContentType;
    else if ([environment isEqualToString:@"HTTP_ETAG"])
        return CGIHTTPHeaderETag;
    else if ([environment isEqualToString:@"HTTP_CONTENT_MD5"])
        return CGIHTTPHeaderContentMD5;
    else if ([environment isEqualToString:@"HTTP_DNT"])
        return CGIHTTPHeaderDoNotTrack;
    else if ([environment isEqualToString:@"HTTP_P3P"])
        return CGIHTTPHeaderP3P;
    else if (![environment hasPrefix:@"HTTP_"])
        return nil;
    else
    {
        environment = [environment substringFromIndex:5];
        NSMutableArray<NSString *> *components = [environment componentsSeparatedByString:@"_"].mutableCopy;
        for (NSUInteger idx = 0; idx < components.count; idx++)
            components[idx] = [components[idx] capitalizedString];
        return [components componentsJoinedByString:@"-"];
    }
}

@implementation CGIRequest
{
    NSDictionary<NSString *, NSArray<NSString *> *> *_queryString;
    NSDictionary<NSString *, NSArray<NSString *> *> *_form;
    NSDictionary<NSString *, NSArray<NSString *> *> *_cookies;
}

@synthesize context = _context;
@synthesize method = _method;
@synthesize requestURI = _requestURI;
@synthesize protocolVersion = _protocolVersion;
@synthesize inputStream = _inputStream;
@synthesize environment = _environment;

- (instancetype)initWithContext:(CGIContext *)context method:(NSString *)method requestURI:(NSString *)requestURI protocolVersion:(NSString *)protocolVersion headerFields:(NSDictionary<NSString *,NSString *> *)headers inputStream:(NSInputStream *)stream
{
    if (self = [super init])
    {
        _context = context;
        _method = method;
        _requestURI = requestURI;
        _protocolVersion = protocolVersion;
        _headers = headers;
        _inputStream = stream;
    }
    return self;
}

- (instancetype)initWithContext:(CGIContext *)context requestLine:(NSString *)request headerFields:(NSDictionary<NSString *,NSString *> *)headers inputStream:(NSInputStream *)stream
{
    NSRange firstSpace = [request rangeOfString:@" "];
    NSRange lastSpace = [request rangeOfString:@" " options:NSBackwardsSearch];
    if (firstSpace.location == NSNotFound || lastSpace.location == NSNotFound || firstSpace.location == lastSpace.location)
        return nil;
    
    NSString *method = [request substringToIndex:firstSpace.location];
    NSString *uri = [request substringWithRange:NSMakeRange(NSMaxRange(firstSpace), lastSpace.location - NSMaxRange(firstSpace))];
    NSString *protocol = [request substringFromIndex:NSMaxRange(lastSpace)];
    
    return [self initWithContext:context method:method requestURI:uri protocolVersion:protocol headerFields:headers inputStream:stream];
}

- (instancetype)initWithContext:(CGIContext *)context CGIEnvironment:(NSDictionary<NSString *,NSString *> *)environment inputStream:(NSInputStream *)stream
{
    NSMutableDictionary<NSString *, NSString *> *headers = [NSMutableDictionary dictionaryWithCapacity:environment.count];
    for (NSString *key in environment)
    {
        NSString *headerKey = CGIHTTPHeaderFromEnvironment(key);
        if (headerKey)
            headers[headerKey] = environment[key];
    }
    
    if (self = [self initWithContext:context
                              method:environment[CGIEnvironmentRequestMethod]
                          requestURI:environment[CGIEnvironmentRequestURI]
                     protocolVersion:environment[CGIEnvironmentServerProtocol]
                        headerFields:headers
                         inputStream:stream])
    {
        _environment = environment;
    }
    
    return self;
}

@end

@implementation CGIRequest (CGIRequestUtilities)

- (BOOL)isSecure
{
    if ([self.environment[@"HTTPS"].lowercaseString isEqualToString:@"on"])
        return YES;
    else
        return NO;
}

- (BOOL)shouldTrackUser
{
    if ([self.headers[CGIHTTPHeaderDoNotTrack] isEqualToString:@"1"])
        return NO;
    else
        return YES;
}

- (NSURL *)requestURL
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@%@", self.secure ? @"https" : @"http", self.headers[CGIHTTPHeaderHost] ?: @"localhost", self.requestURI]];
}

- (NSUInteger)contentLength
{
    return self.headers[CGIHTTPHeaderContentLength].integerValue;
}

static inline NSDictionary<NSString *, NSArray<NSString *> *> *__attribute__((always_inline)) _CGXParseMarkedString(NSString *source, NSString *itemMarker, NSString *fieldMarker)
{
    NSArray<NSString *> *components = [source componentsSeparatedByString:itemMarker];
    NSMutableDictionary<NSString *, NSArray<NSString *> *> *outputDictionary = [NSMutableDictionary dictionaryWithCapacity:components.count];
    for (NSString *component in components)
    {
        NSRange equals = [component rangeOfString:fieldMarker];
        NSString *key = [((equals.location == NSNotFound) ? component : [component substringToIndex:equals.location]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].stringByRemovingPercentEncoding;
        NSString *value = [((equals.location == NSNotFound) ? component : [component substringFromIndex:NSMaxRange(equals)]) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].stringByRemovingPercentEncoding;
        NSArray<NSString *> *values = outputDictionary[key];
        outputDictionary[key] = values ? [values arrayByAddingObject:value] : @[value];
    }
    return outputDictionary;
}

- (NSDictionary<NSString *,NSArray<NSString *> *> *)queryString
{
    if (!_queryString)
    {
        @synchronized (self)
        {
            if (!_queryString)
            {
                _queryString = _CGXParseMarkedString(self.requestURL.query, @"&", @"=");
            }
        }
    }
    return _queryString;
}

- (NSDictionary<NSString *,NSArray<NSString *> *> *)form
{
    if (!_form)
    {
        @synchronized (self)
        {
            if (!_form)
            {
                if ([self.headers[CGIHTTPHeaderContentType] isEqualToString:@"application/x-www-form-urlencoded"]) // URL-encoded form data - parse using _CGXParseQueryString
                {
                    NSUInteger length = self.contentLength;
                    if (length)
                    {
                        void *buffer = malloc(length);
                        if (!buffer)
                            @throw [NSException exceptionWithName:NSMallocException
                                                           reason:nil
                                                         userInfo:nil];
                        [self.inputStream read:buffer maxLength:length];
                        NSString *formString = [[NSString alloc] initWithBytesNoCopy:buffer
                                                                              length:length
                                                                            encoding:NSUTF8StringEncoding
                                                                        freeWhenDone:YES]; // Hand the ownership of this malloc() off
                        _form = _CGXParseMarkedString(formString, @"&", @"=");
                    }
                    else
                    {
                        _form = @{};
                    }
                }
                /*else if ([self.headers[CGIHTTPHeaderContentType] isEqualToString:@"multipart/form-data"])
                {
                    // Use the multipart parser system. It will be added later with anew files property.
                }*/
                else
                {
                    _form = @{};
                }
            }
        }
    }
    return _form;
}

- (NSDictionary<NSString *,NSArray<NSString *> *> *)cookies
{
    if (!_cookies)
    {
        @synchronized (self)
        {
            if (!_cookies)
            {
                _cookies = _CGXParseMarkedString(self.headers[CGIHTTPHeaderCookie], @",", @"=");
            }
        }
    }
    return _cookies;
}

- (NSArray<NSString *> *)objectForKey:(NSString *)key
{
    return self.form[key] ?:
        self.queryString[key] ?:
        self.cookies[key] ?:
        self.headers[key] ? @[self.headers[key]] :
        (self.environment[key] ? @[self.environment[key]] : @[]);
}

- (NSArray<NSString *> *)objectForKeyedSubscript:(NSString *)key
{
    return [self objectForKey:key];
}

@end
