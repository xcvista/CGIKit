//
//  CGIResponse.m
//  CGIKit
//
//  Created by Maxthon Chan on 5/24/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import "CGIResponse.h"

#import "CGICookie.h"
#import "CGXErrorHandler.h"
#import "CGXSystemInfoHandler.h"

#import <pthread.h>

NSString *const CGIHTTPHeaderAccessControlAllowOrigin = @"Access-Control-Allow-Origin";
NSString *const CGIHTTPHeaderAcceptPatch = @"Accept-Patch";
NSString *const CGIHTTPHeaderAcceptRanges = @"Accept-Ranges";
NSString *const CGIHTTPHeaderAge = @"Age";
NSString *const CGIHTTPHeaderAllow = @"Allow";
NSString *const CGIHTTPHeaderContentDisposition = @"Content-Disposition";
NSString *const CGIHTTPHeaderContentEncoding = @"Content-Encoding";
NSString *const CGIHTTPHeaderContentLanguage = @"Content-Language";
NSString *const CGIHTTPHeaderContentLocation = @"Content-Location";
NSString *const CGIHTTPHeaderContentRange = @"Content-Range";
NSString *const CGIHTTPHeaderETag = @"ETag";
NSString *const CGIHTTPHeaderExpires = @"Expires";
NSString *const CGIHTTPHeaderLastModified = @"Last-Modified";
NSString *const CGIHTTPHeaderLink = @"Link";
NSString *const CGIHTTPHeaderLocation = @"Location";
NSString *const CGIHTTPHeaderP3P = @"P3P";
NSString *const CGIHTTPHeaderProxyAuthenticate = @"Proxy-Authenticate";
NSString *const CGIHTTPHeaderPublicKeyPins = @"Public-Key-Pins";
NSString *const CGIHTTPHeaderRefresh = @"Refresh";
NSString *const CGIHTTPHeaderRetryAfter = @"Retry-After";
NSString *const CGIHTTPHeaderServer = @"Server";
NSString *const CGIHTTPHeaderSetCookie = @"Set-Cookie";
NSString *const CGIHTTPHeaderStatus = @"Status";
NSString *const CGIHTTPHeaderStrictTransportSecurity = @"Strict-Transport-Security";
NSString *const CGIHTTPHeaderTrailer = @"Trailer";
NSString *const CGIHTTPHeaderTransferEncoding = @"Transfer-Encoding";
NSString *const CGIHTTPHeaderVary = @"Vary";
NSString *const CGIHTTPHeaderWWWAuthenticate = @"WWW-Authenticate";

NSString *const CGIHTTPStatusContinue = @"Continue";
NSString *const CGIHTTPStatusSwitchingProtocols = @"Switching Protocols";
NSString *const CGIHTTPStatusOK = @"OK";
NSString *const CGIHTTPStatusCreated = @"Created";
NSString *const CGIHTTPStatusAccepted = @"Accepted";
NSString *const CGIHTTPStatusNonAuthoritativeInformation = @"Non-Authoritative Information";
NSString *const CGIHTTPStatusNoContent = @"No Content";
NSString *const CGIHTTPStatusResetContent = @"Reset Content";
NSString *const CGIHTTPStatusPartialContent = @"Partial Content";
NSString *const CGIHTTPStatusMultipleChoices = @"Multiple Choices";
NSString *const CGIHTTPStatusMovedPermanently = @"Moved Permanently";
NSString *const CGIHTTPStatusFound = @"Found";
NSString *const CGIHTTPStatusSeeOther = @"See Other";
NSString *const CGIHTTPStatusNotModified = @"Not Modified";
NSString *const CGIHTTPStatusUseProxy = @"Use Proxy";
NSString *const CGIHTTPStatusTemporaryRedirect = @"Temporary Redirect";
NSString *const CGIHTTPStatusBadRequest = @"Bad Request";
NSString *const CGIHTTPStatusUnauthorized = @"Unauthorized";
NSString *const CGIHTTPStatusPaymentRequired = @"Payment Required";
NSString *const CGIHTTPStatusForbidden = @"Forbidden";
NSString *const CGIHTTPStatusNotFound = @"Not Found";
NSString *const CGIHTTPStatusMethodNotAllowed = @"Method Not Allowed";
NSString *const CGIHTTPStatusNotAcceptable = @"Not Acceptable";
NSString *const CGIHTTPStatusProxyAuthenticationRequired = @"Proxy Authentication Required";
NSString *const CGIHTTPStatusRequestTimeout = @"Request Timeout";
NSString *const CGIHTTPStatusConflict = @"Conflict";
NSString *const CGIHTTPStatusGone = @"Gone";
NSString *const CGIHTTPStatusLengthRequired = @"Length Required";
NSString *const CGIHTTPStatusPreconditionFailed = @"Precondition Failed";
NSString *const CGIHTTPStatusRequestEntityTooLarge = @"Request Entity Too Large";
NSString *const CGIHTTPStatusRequestURITooLong = @"RequestURI Too Long";
NSString *const CGIHTTPStatusUnsupportedMediaType = @"Unsupported Media Type";
NSString *const CGIHTTPStatusRequestedRangeNotSatisfiable = @"Requested Range Not Satisfiable";
NSString *const CGIHTTPStatusExpectationFailed = @"Expectation Failed";
NSString *const CGIHTTPStatusUnavailableForLegalReasons = @"Unavailable For Legal Reasons";
NSString *const CGIHTTPStatusInternalServerError = @"Internal Server Error";
NSString *const CGIHTTPStatusNotImplemented = @"Not Implemented";
NSString *const CGIHTTPStatusBadGateway = @"Bad Gateway";
NSString *const CGIHTTPStatusServiceUnavailable = @"Service Unavailable";
NSString *const CGIHTTPStatusGatewayTimeout = @"Gateway Timeout";
NSString *const CGIHTTPStatusHTTPVersionNotSupported = @"HTTP Version Not Supported";
NSString *const CGIHTTPStatusUnknown = @"Unknown";

NSDictionary<NSNumber *, NSString *> *__CGIStatusCodeMapping = nil;
pthread_once_t __CGIStatusCodeMappingInitializer = PTHREAD_ONCE_INIT;

void __CGIStatusCodeMappingInitialize(void)
{
    if (!__CGIStatusCodeMapping)
        __CGIStatusCodeMapping = @{
                                   @(CGIHTTPStatusCodeContinue): CGIHTTPStatusContinue,
                                   @(CGIHTTPStatusCodeSwitchingProtocols): CGIHTTPStatusSwitchingProtocols,
                                   @(CGIHTTPStatusCodeOK): CGIHTTPStatusOK,
                                   @(CGIHTTPStatusCodeCreated): CGIHTTPStatusCreated,
                                   @(CGIHTTPStatusCodeAccepted): CGIHTTPStatusAccepted,
                                   @(CGIHTTPStatusCodeNonAuthoritativeInformation): CGIHTTPStatusNonAuthoritativeInformation,
                                   @(CGIHTTPStatusCodeNoContent): CGIHTTPStatusNoContent,
                                   @(CGIHTTPStatusCodeResetContent): CGIHTTPStatusResetContent,
                                   @(CGIHTTPStatusCodePartialContent): CGIHTTPStatusPartialContent,
                                   @(CGIHTTPStatusCodeMultipleChoices): CGIHTTPStatusMultipleChoices,
                                   @(CGIHTTPStatusCodeMovedPermanently): CGIHTTPStatusMovedPermanently,
                                   @(CGIHTTPStatusCodeFound): CGIHTTPStatusFound,
                                   @(CGIHTTPStatusCodeSeeOther): CGIHTTPStatusSeeOther,
                                   @(CGIHTTPStatusCodeNotModified): CGIHTTPStatusNotModified,
                                   @(CGIHTTPStatusCodeUseProxy): CGIHTTPStatusUseProxy,
                                   @(CGIHTTPStatusCodeTemporaryRedirect): CGIHTTPStatusTemporaryRedirect,
                                   @(CGIHTTPStatusCodeBadRequest): CGIHTTPStatusBadRequest,
                                   @(CGIHTTPStatusCodeUnauthorized): CGIHTTPStatusUnauthorized,
                                   @(CGIHTTPStatusCodePaymentRequired): CGIHTTPStatusPaymentRequired,
                                   @(CGIHTTPStatusCodeForbidden): CGIHTTPStatusForbidden,
                                   @(CGIHTTPStatusCodeNotFound): CGIHTTPStatusNotFound,
                                   @(CGIHTTPStatusCodeMethodNotAllowed): CGIHTTPStatusMethodNotAllowed,
                                   @(CGIHTTPStatusCodeNotAcceptable): CGIHTTPStatusNotAcceptable,
                                   @(CGIHTTPStatusCodeProxyAuthenticationRequired): CGIHTTPStatusProxyAuthenticationRequired,
                                   @(CGIHTTPStatusCodeRequestTimeout): CGIHTTPStatusRequestTimeout,
                                   @(CGIHTTPStatusCodeConflict): CGIHTTPStatusConflict,
                                   @(CGIHTTPStatusCodeGone): CGIHTTPStatusGone,
                                   @(CGIHTTPStatusCodeLengthRequired): CGIHTTPStatusLengthRequired,
                                   @(CGIHTTPStatusCodePreconditionFailed): CGIHTTPStatusPreconditionFailed,
                                   @(CGIHTTPStatusCodeRequestEntityTooLarge): CGIHTTPStatusRequestEntityTooLarge,
                                   @(CGIHTTPStatusCodeRequestURITooLong): CGIHTTPStatusRequestURITooLong,
                                   @(CGIHTTPStatusCodeUnsupportedMediaType): CGIHTTPStatusUnsupportedMediaType,
                                   @(CGIHTTPStatusCodeRequestedRangeNotSatisfiable): CGIHTTPStatusRequestedRangeNotSatisfiable,
                                   @(CGIHTTPStatusCodeExpectationFailed): CGIHTTPStatusExpectationFailed,
                                   @(CGIHTTPStatusCodeUnavailableForLegalReasons): CGIHTTPStatusUnavailableForLegalReasons,
                                   @(CGIHTTPStatusCodeInternalServerError): CGIHTTPStatusInternalServerError,
                                   @(CGIHTTPStatusCodeNotImplemented): CGIHTTPStatusNotImplemented,
                                   @(CGIHTTPStatusCodeBadGateway): CGIHTTPStatusBadGateway,
                                   @(CGIHTTPStatusCodeServiceUnavailable): CGIHTTPStatusServiceUnavailable,
                                   @(CGIHTTPStatusCodeGatewayTimeout): CGIHTTPStatusGatewayTimeout,
                                   @(CGIHTTPStatusCodeHTTPVersionNotSupported): CGIHTTPStatusHTTPVersionNotSupported
                                   };
}

NSDictionary<NSNumber *, NSString *> *_CGIStatusCodeMapping(void)
{
    if (!__CGIStatusCodeMapping)
    {
        pthread_once(&__CGIStatusCodeMappingInitializer, __CGIStatusCodeMappingInitialize);
    }
    
    return __CGIStatusCodeMapping;
}

NSString *CGIStringForStatusCode(CGIHTTPStatusCode code)
{
    return _CGIStatusCodeMapping()[@(code)] ?: CGIHTTPStatusUnknown;
}

NSString *const _CGXHTTPDefaultProtocol = @"HTTP/1.0";

@implementation CGIResponse

@synthesize context = _context;
@synthesize outputStream = _outputStream;
@synthesize status = _status;

- (NSString *)statusLine
{
    @synchronized (self)
    {
        return _statusLine.copy;
    }
}

- (void)setStatusLine:(NSString *)statusLine
{
    @synchronized (self)
    {
        _statusLine = statusLine ?: CGIStringForStatusCode(self.statusCode);
    }
}

- (CGIHTTPStatusCode)statusCode
{
    @synchronized (self)
    {
        return _statusCode;
    }
}

- (void)setStatusCode:(CGIHTTPStatusCode)statusCode
{
    @synchronized (self)
    {
        _statusCode = statusCode;
        _statusLine = CGIStringForStatusCode(self.statusCode);
    }
}

- (NSString *)protocolVersion
{
    @synchronized (self)
    {
        return _protocolVersion.copy;
    }
}

- (void)setProtocolVersion:(NSString *)protocolVersion
{
    @synchronized (self)
    {
        _protocolVersion = protocolVersion ?: _CGXHTTPDefaultProtocol;
    }
}

- (NSDictionary<NSString *,NSArray<NSString *> *> *)headers
{
    @synchronized (self)
    {
        return _headers.copy;
    }
}

- (void)setHeaders:(NSDictionary<NSString *,NSArray<NSString *> *> *)headers
{
    @synchronized (self)
    {
        _headers = headers.mutableCopy ?: [NSMutableDictionary dictionary];
        [_headers removeObjectForKey:CGIHTTPHeaderSetCookie]; // Cookies have to be set elsewhere.
    }
}

- (NSArray<CGICookie *> *)cookies
{
    @synchronized (self)
    {
        return _cookies.copy;
    }
}

- (void)setCookies:(NSArray<CGICookie *> *)cookies
{
    @synchronized (self)
    {
        _cookies = cookies.mutableCopy ?: [NSMutableArray array];
    }
}

- (instancetype)initWithContext:(CGIContext *)context outputStream:(nonnull NSOutputStream *)outputStream
{
    if (self = [super init])
    {
        _context = context;
        
        _statusCode = CGIHTTPStatusCodeOK;
        _statusLine = CGIHTTPStatusOK;
        _protocolVersion = _CGXHTTPDefaultProtocol;
        _headers = [NSMutableDictionary dictionary];
        _cookies = [NSMutableArray array];
        _outputStream = outputStream;
        
        [self setHeaderField:CGIHTTPHeaderContentType withValue:@"text/html"];
        
        _status = CGIResponseStatusNone;
    }
    return self;
}

- (void)addHeaderField:(NSString *)key withValue:(NSString *)value
{
    if ([key isEqualToString:CGIHTTPHeaderSetCookie])
        return;
    
    @synchronized (self)
    {
        NSArray<NSString *> *header = _headers[key];
        if (header)
            _headers[key] = [header arrayByAddingObject:value];
        else
            _headers[key] = @[value];
    }
}

- (void)setHeaderField:(NSString *)key withValue:(NSString *)value
{
    if ([key isEqualToString:CGIHTTPHeaderSetCookie])
        return;
    
    @synchronized (self)
    {
        _headers[key] = @[value];
    }
}

- (void)removeHeaderField:(NSString *)key
{
    if ([key isEqualToString:CGIHTTPHeaderSetCookie])
        return;
    
    @synchronized (self)
    {
        [_headers removeObjectForKey:key];
    }
}

- (void)setObject:(NSString *)value forKeyedSubscript:(NSString *)key
{
    [self setHeaderField:key withValue:value];
}

- (NSString *)objectForKeyedSubscript:(NSString *)key
{
    return _headers[key].firstObject;
}

- (void)addCookie:(CGICookie *)cookie
{
    @synchronized (self)
    {
        [_cookies addObject:cookie];
    }
}

- (void)removeCookie:(CGICookie *)cookie
{
    @synchronized (self)
    {
         [_cookies removeObject:cookie];
    }
}

- (void)removeAllCookiesWithKey:(NSString *)key
{
    @synchronized (self)
    {
        NSMutableIndexSet *cookieIndexes = [NSMutableIndexSet indexSet];
        for (NSUInteger idx = 0; idx < _cookies.count; idx++)
        {
            CGICookie *cookie = _cookies[idx];
            if ([cookie.key isEqualToString:key])
                [cookieIndexes addIndex:idx];
        }
        [_cookies removeObjectsAtIndexes:cookieIndexes];
    }
}

CGXErrorHandler *_CGXErrorHandler;
pthread_once_t _CGXErrorToken = PTHREAD_ONCE_INIT;

void _CGXErrorHandlerInit(void)
{
    _CGXErrorHandler = [[CGXErrorHandler alloc] init];
}

- (void)error:(NSError *)error
{
    pthread_once(&_CGXErrorToken, _CGXErrorHandlerInit);
    
    objc_setAssociatedObject(_context, (__bridge const void *)([NSError class]), error, OBJC_ASSOCIATION_RETAIN);
    [_CGXErrorHandler handleContext:_context];
}

CGXSystemInfoHandler *_CGXSystemInfoHandler;
pthread_once_t _CGXSystemInfoToken = PTHREAD_ONCE_INIT;

void _CGXSystemInfoHandlerInit(void)
{
    _CGXSystemInfoHandler = [[CGXSystemInfoHandler alloc] init];
}

- (void)systemInformation
{
    pthread_once(&_CGXSystemInfoToken, _CGXSystemInfoHandlerInit);
    
    [_CGXSystemInfoHandler handleContext:_context];
}

- (void)sendHeaders
{
    [self doesNotRecognizeSelector:_cmd];
}

- (void)send
{
    [self doesNotRecognizeSelector:_cmd];
}

@end

@implementation NSOutputStream (CGIOutputStream)

- (BOOL)writeString:(NSString *)string usingEncoding:(NSStringEncoding)encoding withError:(NSError * _Nullable __autoreleasing *)error
{
    return [self writeData:[string dataUsingEncoding:encoding]
                 withError:error];
}

- (BOOL)writeData:(NSData *)data withError:(NSError * _Nullable __autoreleasing *)error
{
    NSInteger rv = [self write:data.bytes maxLength:data.length];
    if (rv < 0)
    {
        POINTER_ASSIGN(error, [NSError errorWithDomain:NSPOSIXErrorDomain
                                                  code:errno
                                              userInfo:nil]);
        return NO;
    }
    return YES;
}

@end
