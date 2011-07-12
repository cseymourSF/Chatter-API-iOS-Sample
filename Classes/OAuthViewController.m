//
//  OAuthViewController.m
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//s
// TODO: Add error handling!

#import "OAuthViewController.h"
#import "AuthContext.h"

@implementation OAuthViewController

@synthesize webView;

- (id)initWithLoginUrl:(NSString*)loginUrl 
           callbackUrl:(NSString*)callbackUrlIn
           consumerKey:(NSString*)consumerKey {
	callbackUrl = [[NSURL URLWithString:callbackUrlIn] retain];
	
	// URL-encode the callback URL.
	NSString* encodedCallbackUrl = [callbackUrlIn stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* targetUrl = [NSString stringWithFormat:
						   @"%@?response_type=token&client_id=%@&redirect_uri=%@",
						   loginUrl, consumerKey, encodedCallbackUrl];
	
	// Make the request.
	loginRequest = [[NSMutableURLRequest requestWithURL:[NSURL URLWithString:targetUrl]
											cachePolicy:NSURLRequestReloadIgnoringLocalCacheData // Don't use the cache.
										timeoutInterval:60] retain];
	
	// Load up UI.
	self = [self initWithNibName:@"OAuthViewController" bundle:nil];
	if (self != nil) {
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
	// Load request in web view.
	[self.webView loadRequest:loginRequest];
	
	[super viewWillAppear:animated];
}

+ (NSString*)extractParameterValue:(NSString*)parameter
							  from:(NSString*)source {
	NSError* error = nil;
	NSString* pattern = [NSString stringWithFormat:@"%@=([%%.\\w\\d]*)", parameter];
	
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
	NSTextCheckingResult* result = [regex firstMatchInString:source options:0 range:NSMakeRange(0, [source length])];		
	if ([result numberOfRanges] > 1) {
		NSRange tokenRange = [result rangeAtIndex:1];
		NSString* encodedValue = [source substringWithRange:tokenRange];
		return [encodedValue stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	} else {
		// TODO: Better error handling.
		NSLog(@"Could not find parameter %@", parameter);
		return nil;
	}
}

- (BOOL)webView:(UIWebView *)webViewIn
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {		
	if ([[callbackUrl host] isEqual:[[request URL] host]] &&
		[[callbackUrl path] isEqual:[[request URL] path]]) {
		// Extract tokens from redirect url.
		NSString* fragment = [[request URL] fragment];
		NSLog(@"OAuth fragment: %@", fragment);
		
		NSString* accessToken = [OAuthViewController extractParameterValue:@"access_token" from:fragment];
		NSString* refreshToken = [OAuthViewController extractParameterValue:@"refresh_token" from:fragment];
		NSString* instanceUrl = [OAuthViewController extractParameterValue:@"instance_url" from:fragment];
		
		// Save the tokens.
		AuthContext* context = [AuthContext context];
		[context setAccessToken:accessToken];
		[context setRefreshToken:refreshToken];
		[context setInstanceUrl:instanceUrl];
		
		// Pop back out.
		[self.navigationController popViewControllerAnimated:YES];
		
		// Web view should not request the url.
		return NO;
	} else {
		// Not done yet. Web view should request the url.
		return YES;
	}
}

- (void)dealloc {
	[self.webView release];
	[loginRequest release];
	[callbackUrl release];
	
    [super dealloc];
}

@end
