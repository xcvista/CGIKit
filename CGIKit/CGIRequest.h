//
//  CGIRequest.h
//  CGIKit
//
//  Created by Maxthon Chan on 5/24/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

#import <CGIKit/CGICommon.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 @name HTTP Request Headers
 */
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAccept;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAcceptCharset;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAcceptEncoding;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAcceptLanguage;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAcceptDatetime;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderAuthorization;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderCacheControl;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderConnection;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderCookie;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentLength;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentMD5;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderContentType;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderDate;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderExpect;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderFrom;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderHost;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderIfMatch;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderIfModifiedSince;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderIfNoneMatch;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderIfRange;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderIfUnmodifiedSince;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderMaxForwards;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderOrigin;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderPragma;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderProxyAuthorization;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderRange;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderReferer;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderTE;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderUserAgent;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderUpgrade;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderVia;
FOUNDATION_EXPORT NSString *const CGIHTTPHeaderWarning;

/*!
 @name Translation functions
 */

FOUNDATION_EXPORT NSString *_Nullable CGIHTTPHeaderFromEnvironment(NSString *);

/*!
 @name CGI environment variables
 */
FOUNDATION_EXPORT NSString *const CGIEnvironmentAuthType;
FOUNDATION_EXPORT NSString *const CGIEnvironmentContentLength;
FOUNDATION_EXPORT NSString *const CGIEnvironmentContentType;
FOUNDATION_EXPORT NSString *const CGIEnvironmentDocumentRoot;
FOUNDATION_EXPORT NSString *const CGIEnvironmentGatewayInterface;
FOUNDATION_EXPORT NSString *const CGIEnvironmentPathInfo;
FOUNDATION_EXPORT NSString *const CGIEnvironmentPathTranslated;
FOUNDATION_EXPORT NSString *const CGIEnvironmentQueryString;
FOUNDATION_EXPORT NSString *const CGIEnvironmentRemoteAddr;
FOUNDATION_EXPORT NSString *const CGIEnvironmentRemoteHost;
FOUNDATION_EXPORT NSString *const CGIEnvironmentRemoteIdent;
FOUNDATION_EXPORT NSString *const CGIEnvironmentRemoteUser;
FOUNDATION_EXPORT NSString *const CGIEnvironmentRequestMethod;
FOUNDATION_EXPORT NSString *const CGIEnvironmentRequestURI;
FOUNDATION_EXPORT NSString *const CGIEnvironmentScriptName;
FOUNDATION_EXPORT NSString *const CGIEnvironmentServerName;
FOUNDATION_EXPORT NSString *const CGIEnvironmentServerPort;
FOUNDATION_EXPORT NSString *const CGIEnvironmentServerProtocol;
FOUNDATION_EXPORT NSString *const CGIEnvironmentServerSoftware;

@class CGIContext;

/*!
 Object represents the HTTP request body.
 */
@interface CGIRequest : NSObject
{
@protected
    __weak CGIContext *_context;
    
    NSString *_method;
    NSString *_requestURI;
    NSString *_protocolVersion;
    NSDictionary<NSString *, NSString *> *_headers;
    NSInputStream *_inputStream;
    
    NSDictionary<NSString *, NSString *> *_environment;
}

/// @name Web context

/*!
 The associated web context.
 */
@property (readonly, weak) CGIContext *context;

/// @name Packet data

/*!
 HTTP method used by this query.
 */
@property (readonly) NSString *method;

/*!
 The URI requested by the user agent.
 */
@property (readonly) NSString *requestURI;

/*!
 The version of the HTTP protocol used by the request.
 */
@property (readonly) NSString *protocolVersion;

/*!
 Header fields sent by the user agent.
 */
@property (readonly) NSDictionary<NSString *, NSString *> *headers;

/*!
 Body data stream.
 */
@property (readonly) NSInputStream *inputStream;

/*!
 Initialize a <tt>CGIRequest</tt> object with parsed HTTP packet data.
 
 @param context         The associated Web context.
 @param method          The request protocol.
 @param requestURI      The URI requested by the user agent.
 @param protocolVersion HTTP Protocol version used by the user agent.
 @param headers         Parsed header fields.
 @param stream          Upstream data stream for the body.
 
 @return The initialized <tt>CGIRequest</tt> object.
 */
- (instancetype)initWithContext:(CGIContext *)context
                         method:(NSString *)method
                     requestURI:(NSString *)requestURI
                protocolVersion:(NSString *)protocolVersion
                   headerFields:(NSDictionary<NSString *, NSString *> *)headers
                    inputStream:(NSInputStream *)stream NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithContext:(CGIContext *)context
                    requestLine:(NSString *)request
                   headerFields:(NSDictionary<NSString *, NSString *> *)headers
                    inputStream:(NSInputStream *)stream;

/// @name CGI Environment

@property (readonly) NSDictionary<NSString *, NSString *> *environment;

- (instancetype)initWithContext:(CGIContext *)context
                 CGIEnvironment:(NSDictionary <NSString *, NSString *> *)environment
                    inputStream:(NSInputStream *)stream;

/// @name Deprecated methods

/*!
 Do not use <tt>-init</tt> to initialize the <tt>CGIRequest</tt> object.
 
 @return <tt>nil</tt>
 */
- (instancetype)init NS_UNAVAILABLE;

@end

@interface CGIRequest (CGIRequestUtilities)

/// @name Data parsed from the upstream header and body

/*!
 Returns whether HTTPS is enabled.
 */
@property (readonly, getter=isSecure) BOOL secure;

/*!
 Reutrns whether DHT is set.
 
 @note Adhere to the user's choice as expressed by this property as much as possible.
 */
@property (readonly, getter=shouldTrackUser) BOOL trackUser;
@property (readonly) NSURL *requestURL;
@property (readonly) NSUInteger contentLength;
@property (readonly) NSDictionary<NSString *, NSArray<NSString *> *> *queryString;
@property (readonly) NSDictionary<NSString *, NSArray<NSString *> *> *form;
@property (readonly) NSDictionary<NSString *, NSArray<NSString *> *> *cookies;

- (nullable NSArray<NSString *> *)objectForKey:(NSString *)key;
- (nullable NSArray<NSString *> *)objectForKeyedSubscript:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
