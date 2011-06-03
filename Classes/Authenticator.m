//
//  Authenticator.m
//  DemoApp
//
//  Copyright 2011 Salesforce.com. All rights reserved.
//
//  This is sample code provided as a learning tool. Feel free to 
//  learn from it and incorporate elements into your own code. 
//  No guarantees are made about the quality or security of this code.
//
//  THIS SOFTWARE IS PROVIDED BY Salesforce.com "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Salesforce.com OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "Authenticator.h"
#import "DemoAppAppDelegate.h"
#import "GTMOAuth2ViewControllerTouch.h";

@implementation Authenticator

static NSString *const kKeychainItemName = @"Connect Test App";
static NSString *const kClientIdKey = @"clientID";
static NSString *const kClientSecretKey = @"clientSecret";
static NSString *const kCallbackUriKey = @"callbackUri";
static NSString *const kServerRootKey = @"serverRoot";

// TODO: Double-check memory management for this!
static GTMOAuth2Authentication* globalAuth = nil;

+ (GTMOAuth2Authentication*)auth {
	return globalAuth;
}

+ (void)saveConfigWithClientId:(NSString*)clientId secret:(NSString*)secret callbackUri:(NSString*)callbackUri baseUrl:(NSString*)baseUrl {
	// Save config.
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:clientId forKey:kClientIdKey];
	[defaults setObject:secret forKey:kClientSecretKey];
	[defaults setObject:callbackUri forKey:kCallbackUriKey];
	[defaults setObject:baseUrl forKey:kServerRootKey];
	[defaults synchronize];
}

+ (NSString*)clientId {
	return [[NSUserDefaults standardUserDefaults] stringForKey:kClientIdKey];
}

+ (NSString*)callbackUri {
	return [[NSUserDefaults standardUserDefaults] stringForKey:kCallbackUriKey];
}

+ (NSString*)baseUrl {
	return [[NSUserDefaults standardUserDefaults] stringForKey:kServerRootKey];
}

+ (NSString*)secret {
	return [[NSUserDefaults standardUserDefaults] stringForKey:kClientSecretKey];
}

+ (BOOL)authenticateSilently {
	// Common intialization.
	[Authenticator makeAuth];
	
	// Authorize from the keychain.
	if ([GTMOAuth2ViewControllerTouch authorizeFromKeychainForName:kKeychainItemName authentication:globalAuth]) {
		return YES;
	} else {
		[self clearAuth];
		return NO;
	}
}

+ (void)authenticateWithNavigationController:(UINavigationController*)navController delegate:(id)delegate {
	// Common intialization.
	[Authenticator makeAuth];
	
	// Log-in and authorize.	
	NSString* authURLString = [NSString stringWithFormat:@"https://%@/services/oauth2/authorize", [Authenticator baseUrl]];
	NSURL* authURL = [NSURL URLWithString:authURLString];
	
	// Display the authentication view
	GTMOAuth2ViewControllerTouch *viewController;
	viewController = [[[GTMOAuth2ViewControllerTouch alloc] initWithAuthentication:globalAuth
																  authorizationURL:authURL
																  keychainItemName:kKeychainItemName
																		  delegate:delegate
																  finishedSelector:@selector(viewController:finishedWithAuth:error:)] autorelease];
	
	// Push into sign-in view
	[navController pushViewController:viewController animated:YES];
}

+ (void)clearAuth {
	if (globalAuth != nil) {
		[globalAuth release];
		globalAuth = nil;
	}
}

+ (void)makeAuth {
	[self clearAuth];
	
	// Load config.
	NSString* clientId = [Authenticator clientId];
	NSString* clientSecret = [Authenticator secret];
	NSString* callbackUri = [Authenticator callbackUri];
	NSString* baseUrl = [Authenticator baseUrl];

	NSString* tokenURLString = [NSString stringWithFormat:@"https://%@/services/oauth2/token", baseUrl];
	NSURL* tokenURL = [NSURL URLWithString:tokenURLString];
	
	// Make auth object.
	globalAuth = [[GTMOAuth2Authentication authenticationWithServiceProvider:@"Salesforce.com" 
																				  tokenURL:tokenURL
																			   redirectURI:callbackUri
																	 clientID:clientId
																	clientSecret:clientSecret] retain];

	// TODO: Do we need a scope for Connect?
	globalAuth.scope = @"myScope";
}

@end
