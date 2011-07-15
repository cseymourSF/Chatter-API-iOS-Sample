//
//  OAuthViewController.m
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// TODO: Add error handling!


#import "OAuthViewController.h"
#import "Config.h"
#import "AuthContext.h"

@implementation OAuthViewController

@synthesize webView;

- (id)init {	
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
	// Load login request in web view.
	NSURLRequest* loginRequest = [NSMutableURLRequest requestWithURL:[AuthContext fullLoginUrl]
														 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
													 timeoutInterval:60];
	[self.webView loadRequest:loginRequest];
	
	[super viewWillAppear:animated];
}

- (BOOL)webView:(UIWebView *)webViewIn
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {		
	NSURL* callbackUrl = [NSURL URLWithString:[Config callbackUrl]];
	
	if ([[callbackUrl host] isEqual:[[request URL] host]] &&
		[[callbackUrl path] isEqual:[[request URL] path]]) {
		// Extract auth values from the callback URL.
		[[AuthContext context] processCallbackUrl:[request URL]];
		
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
	// As reccommended by Apple to avoid memory issues.
	self.webView.delegate = nil;
	
	[self.webView release];
	
    [super dealloc];
}

@end
