//
//  CGIResponse.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/24/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGICommon.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @name HTTP Status Headers
 */
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAccessControlAllowOrigin;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAcceptPatch;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAcceptRanges;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAge;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAllow;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderCacheControl;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderConnection;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentDisposition;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentEncoding;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentLanguage;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentLength;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentLocation;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentMD5;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentRange;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentType;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderDoNotTrack;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderDate;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderETag;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderExpires;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderLastModified;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderLink;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderLocation;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderP3P;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderPragma;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderProxyAuthenticate;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderPublicKeyPins;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderRefresh;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderRetryAfter;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderServer;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderSetCookie;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderStatus;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderStrictTransportSecurity;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderTrailer;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderTransferEncoding;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderUpgrade;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderVary;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderVia;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderWarning;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderWWWAuthenticate;

FOUNDATION_EXPORT NSString *const CGIHTTPStatusContinue;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusSwitchingProtocols;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusOK;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusCreated;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusAccepted;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusNonAuthoritativeInformation;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusNoContent;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusResetContent;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusPartialContent;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusMultipleChoices;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusMovedPermanently;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusFound;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusSeeOther;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusNotModified;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusUseProxy;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusTemporaryRedirect;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusBadRequest;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusUnauthorized;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusPaymentRequired;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusForbidden;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusNotFound;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusMethodNotAllowed;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusNotAcceptable;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusProxyAuthenticationRequired;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusRequestTimeout;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusConflict;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusGone;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusLengthRequired;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusPreconditionFailed;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusRequestEntityTooLarge;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusRequestURITooLong;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusUnsupportedMediaType;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusRequestedRangeNotSatisfiable;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusExpectationFailed;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusUnavailableForLegalReasons;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusInternalServerError;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusNotImplemented;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusBadGateway;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusServiceUnavailable;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusGatewayTimeout;
FOUNDATION_EXPORT NSString *const CGIHTTPStatusHTTPVersionNotSupported;

FOUNDATION_EXPORT NSString *const CGIHTTPStatusUnknown;

typedef NS_ENUM(NSUInteger, CGIHTTPStatusCode)
{
    CGIHTTPStatusCodeContinue = 100,
    CGIHTTPStatusCodeSwitchingProtocols,
    
    CGIHTTPStatusCodeOK = 200,
    CGIHTTPStatusCodeCreated,
    CGIHTTPStatusCodeAccepted,
    CGIHTTPStatusCodeNonAuthoritativeInformation,
    CGIHTTPStatusCodeNoContent,
    CGIHTTPStatusCodeResetContent,
    CGIHTTPStatusCodePartialContent,
    
    CGIHTTPStatusCodeMultipleChoices = 300,
    CGIHTTPStatusCodeMovedPermanently,
    CGIHTTPStatusCodeFound,
    CGIHTTPStatusCodeSeeOther,
    CGIHTTPStatusCodeNotModified,
    CGIHTTPStatusCodeUseProxy,
    CGIHTTPStatusCodeTemporaryRedirect = 307,
    
    CGIHTTPStatusCodeBadRequest = 400,
    CGIHTTPStatusCodeUnauthorized,
    CGIHTTPStatusCodePaymentRequired,
    CGIHTTPStatusCodeForbidden,
    CGIHTTPStatusCodeNotFound,
    CGIHTTPStatusCodeMethodNotAllowed,
    CGIHTTPStatusCodeNotAcceptable,
    CGIHTTPStatusCodeProxyAuthenticationRequired,
    CGIHTTPStatusCodeRequestTimeout,
    CGIHTTPStatusCodeConflict,
    CGIHTTPStatusCodeGone,
    CGIHTTPStatusCodeLengthRequired,
    CGIHTTPStatusCodePreconditionFailed,
    CGIHTTPStatusCodeRequestEntityTooLarge,
    CGIHTTPStatusCodeRequestURITooLong,
    CGIHTTPStatusCodeUnsupportedMediaType,
    CGIHTTPStatusCodeRequestedRangeNotSatisfiable,
    CGIHTTPStatusCodeExpectationFailed,
    CGIHTTPStatusCodeUnavailableForLegalReasons = 451,
    
    CGIHTTPStatusCodeInternalServerError = 500,
    CGIHTTPStatusCodeNotImplemented,
    CGIHTTPStatusCodeBadGateway,
    CGIHTTPStatusCodeServiceUnavailable,
    CGIHTTPStatusCodeGatewayTimeout,
    CGIHTTPStatusCodeHTTPVersionNotSupported
};

FOUNDATION_EXPORT NSString *CGIStringForStatusCode(CGIHTTPStatusCode code);

@class CGIContext, CGICookie;

typedef NS_ENUM(NSUInteger, CGIResponseStatus)
{
    CGIResponseStatusNone = 0,
    CGIResponseStatusHeader,
    CGIResponseStatusBody
};

@interface CGIResponse : NSObject
{
@protected
    __weak CGIContext *_context;
    
    CGIHTTPStatusCode _statusCode;
    NSString *_statusLine;
    NSString *_protocolVersion;
    NSMutableDictionary <NSString *, NSArray <NSString *> *> *_headers;
    NSMutableArray<CGICookie *> *_cookies;
    NSOutputStream *_outputStream;
    
    CGIResponseStatus _status;
}

@property (readonly, weak) CGIContext *context;
@property (assign) CGIHTTPStatusCode statusCode;
@property (copy, null_resettable) NSString *statusLine;
@property (copy, null_resettable) NSString *protocolVersion;
@property (copy, null_resettable) NSDictionary<NSString *, NSArray<NSString *> *> *headers;
@property (copy, null_resettable) NSArray<CGICookie *> *cookies;
@property (readonly) NSOutputStream *outputStream;
@property (readonly, assign) CGIResponseStatus status;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContext:(CGIContext *)context outputStream:(NSOutputStream *)outputStream NS_DESIGNATED_INITIALIZER;

- (void)addHeaderField:(NSString *)key withValue:(NSString *)value;
- (void)setHeaderField:(NSString *)key withValue:(NSString *)value;
- (void)removeHeaderField:(NSString *)key;

- (void)setObject:(NSString *)value forKeyedSubscript:(NSString *)key;
- (nullable NSString *)objectForKeyedSubscript:(NSString *)key;

- (void)addCookie:(CGICookie *)cookie;
- (void)removeCookie:(CGICookie *)cookie;
- (void)removeAllCookiesWithKey:(NSString *)key;

- (void)error:(NSError *)error;
- (void)systemInformation;

- (void)sendHeaders;
- (void)send;

@end

@interface NSOutputStream (CGIOutputStream)

- (BOOL)writeString:(NSString *)string usingEncoding:(NSStringEncoding)encoding withError:(NSError **)error;
- (BOOL)writeData:(NSData *)data withError:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
