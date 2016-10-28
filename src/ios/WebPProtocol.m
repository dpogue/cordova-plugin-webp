//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at http://mozilla.org/MPL/2.0/.
//
//  Copyright (c) 2013-2014 Scott Talbot.
//  Copyright (c) 2014 Darryl Pogue.

#import "WebPProtocol.h"
#import "STWebPStreamingDecoder.h"


@interface WebPProtocol () <NSURLConnectionDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) STWebPStreamingDecoder *decoder;

@end



@implementation WebPProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if ([NSURLProtocol propertyForKey:@"WebPProtocolHandledKey" inRequest:request]) {
        return NO;
    }

    NSURL* url = [request URL];
    NSString* const requestFiletype = [[url pathExtension] lowercaseString];

    return [@"webp" isEqualToString:requestFiletype] || [[url absoluteString] hasPrefix:@"data:image/webp;"] || [[url query] containsString:@"cdvwebp=true"];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"WebPProtocolHandledKey" inRequest:newRequest];

    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading {
    [self.connection cancel];
    self.connection = nil;
}



#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.decoder = [[STWebPStreamingDecoder alloc] init];

    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.decoder updateWithData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *error = nil;
    UIImage *image = [self.decoder imageWithScale:1 error:&error];
    if (!image) {
        [self.client URLProtocol:self didFailWithError:error];
        return;
    }

    NSData *imagePNGData = UIImagePNGRepresentation(image);
    [self.client URLProtocol:self didLoadData:imagePNGData];

    self.decoder = nil;
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

@end
