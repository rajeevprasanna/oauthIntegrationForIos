//
//  GoogleOauthWebview.h
//  oauthDemo
//
//  Created by Rajeev Kumar on 12/03/14.
//  Copyright (c) 2014 rajeev. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    httpMethod_GET,
    httpMethod_POST,
    httpMethod_DELETE,
    httpMethod_PUT
} HTTP_Method;

@protocol GoogleOAuthDelegate

-(void)authorizationWasSuccessful;
-(void)accessTokenWasRevoked;
-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData;
-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails;
-(void)errorInResponseWithBody:(NSString *)errorMessage;

@end

@interface GoogleOauthWebview : UIWebView<UIWebViewDelegate, NSURLConnectionDelegate>

@property (nonatomic, strong) id<GoogleOAuthDelegate> goAuthDelegate;

-(void)authorizeUserWithClientID:(NSString *)client_ID andClientSecret:(NSString *)clientSecret andParentView:(UIView *)parentView andScopes:(NSArray *)scopes;

-(void)revokeAccessToken;

-(void)callAPI:(NSString *)apiURL withHttpMethod:(HTTP_Method)httpMethod postParameterNames:(NSArray *)params postParameterValues:(NSArray *)value;

@end
