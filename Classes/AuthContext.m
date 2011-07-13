//
//  AuthContext.m
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthContext.h"
#import "Identity.h"
#import "Config.h"

@implementation AuthContext

static AuthContext* contextSingleton;

static const NSString* keychainIdentifier = @"com.salesforce.PhotoPoster.AuthKeychain";

@synthesize accessToken;
@synthesize refreshToken;
@synthesize instanceUrl;

+ (void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        contextSingleton = [[AuthContext alloc] init];
    }
}

+ (AuthContext*)context {
	return contextSingleton;
}

// Keychain code based on:
// http://developer.apple.com/library/mac/#documentation/Security/Conceptual/keychainServConcepts/iPhoneTasks/iPhoneTasks.html
// See also:
// http://developer.apple.com/library/mac/#documentation/Security/Conceptual/keychainServConcepts/02concepts/concepts.html

- (id)init {
	self = [super init];
	if (self != nil) {
		restManager = [[RKObjectManager objectManagerWithBaseURL:[Config tokenUrlServer]] retain];
		
		// Load the refresh token from the keychain, or initialize the keychain.
		[self load];
	}
	return self;
}

+ (NSMutableDictionary*)createKeychainDict {
	NSMutableDictionary* keychainFetcher = [[NSMutableDictionary alloc] init];
	[keychainFetcher setObject:(id)kSecClassGenericPassword
						forKey:(id)kSecClass];
	[keychainFetcher setObject:keychainIdentifier forKey:(id)kSecAttrGeneric];
	[keychainFetcher setObject:keychainIdentifier forKey:(id)kSecAttrAccount];
	
	return [keychainFetcher autorelease];
}

- (BOOL)startGettingAccessTokenWithDelegate:(id<AccessTokenRefreshDelegate>)delegateIn {
	if (self.refreshToken == nil) {
		// We need the user to log-in.
		return FALSE;
	}
	
	// Build up the URL to POST to.
	NSString* encodedRefreshToken = [self.refreshToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString* targetUrl = 
	[NSString stringWithFormat: @"%@?grant_type=refresh_token&client_id=%@&refresh_token=%@",
	 [Config tokenUrlPath], [Config consumerKey], encodedRefreshToken];
	NSLog(@"Refresh url: %@", targetUrl);
	
	// Save the delegate for later (do not retain).
	delegate = delegateIn;
	
	// Reset the identity.
	[identity release];
	identity = [[Identity alloc] init];
	
	RKObjectLoader* loader = [RKObjectLoader loaderWithResourcePath:targetUrl objectManager:restManager delegate:self];
	loader.method = RKRequestMethodPOST;
	loader.sourceObject = nil; // Don't POST any data.
	loader.targetObject = identity;
	loader.objectMapping = [Identity getMapping];
	[loader send];
	
	return TRUE;
}

- (void)load {
	// Set up the keychain search dictionary:
	NSMutableDictionary* keychainFetcher = [AuthContext createKeychainDict];
	[keychainFetcher setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
	[keychainFetcher setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
	NSData* refreshTokenData = nil;
	OSStatus keychainErr = SecItemCopyMatching((CFDictionaryRef)keychainFetcher, (CFTypeRef*)&refreshTokenData);
	if (keychainErr == noErr) {
		// Convert refresh token to a String.
		if ([refreshTokenData length] > 0) {
			self.refreshToken = [[[NSString alloc] initWithData:refreshTokenData encoding:NSUTF8StringEncoding] autorelease];
		} else {
			self.refreshToken = nil;
		}
		
		NSLog(@"Loaded refresh token: %@", self.refreshToken);
	} else if (keychainErr == errSecItemNotFound) {
		// Could not find keychain, initialize it.
		NSLog(@"Creating missing keychain");
		
		NSMutableDictionary* keychainCreator = [AuthContext createKeychainDict];
		[keychainCreator setObject:[NSData data] forKey:(id)kSecValueData]; // Refresh token
		
		keychainErr = SecItemAdd((CFDictionaryRef)keychainCreator, NULL);
		if (noErr != keychainErr) {
			NSLog(@"Error trying to create keychain: %d", keychainErr);
		}
	} else {
		NSLog(@"Error retrieving refresh token from keychain: %d", keychainErr);
	}
	
	[refreshTokenData release];
}

- (void)save {
	// Update the refresh token value in the existing keychain item.
	NSMutableDictionary* updateDict = [AuthContext createKeychainDict];
	[updateDict removeObjectForKey:(id)kSecClass];
	
	if (self.refreshToken == nil) {
		[updateDict setObject:[NSData data] forKey:(id)kSecValueData];
	} else {
		NSData* refreshTokenData = [self.refreshToken dataUsingEncoding:NSUTF8StringEncoding];
		[updateDict setObject:refreshTokenData forKey:(id)kSecValueData];
	}
	
	NSMutableDictionary* keychainDict = [AuthContext createKeychainDict];
	OSStatus err = SecItemUpdate((CFDictionaryRef)keychainDict, (CFDictionaryRef)updateDict);
	if (err != errSecSuccess) {
		NSLog(@"Error updating keychain: %d", err);
	}
}

- (void)clear {
	self.refreshToken = nil;
	self.instanceUrl = nil;
	self.accessToken = nil;
	
	[self save];
}

+ (NSURL*)fullLoginUrl {
	// URL-encode the callback URL.
	NSString* encodedCallbackUrl = [[Config callbackUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	// Construct the URL for the first login page.
	return [NSURL URLWithString:[NSString stringWithFormat:
								 @"%@?response_type=token&client_id=%@&redirect_uri=%@",
								 [Config loginUrl], [Config consumerKey], encodedCallbackUrl]];
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

- (void)processCallbackUrl:(NSURL*)callbackUrl {
	// Extract tokens from callback url.
	
	// "fragment" gives the substring after the "#".
	NSString* fragment = [callbackUrl fragment];
	
	self.accessToken = [AuthContext extractParameterValue:@"access_token" from:fragment];
	self.refreshToken = [AuthContext extractParameterValue:@"refresh_token" from:fragment];
	self.instanceUrl = [AuthContext extractParameterValue:@"instance_url" from:fragment];
	[self save];
}

- (NSString*)getOAuthHeaderValue {
	return [NSString stringWithFormat:@"OAuth %@", [self accessToken]];
}

- (void)addOAuthHeader:(RKRequest*)request {
	NSMutableDictionary* headerDict = [[[NSMutableDictionary alloc] initWithCapacity:1] autorelease];
	[headerDict setObject:[self getOAuthHeaderValue] forKey:@"Authorization"];
	[request setAdditionalHTTPHeaders:headerDict];
}

- (void)addOAuthHeaderToNSRequest:(NSMutableURLRequest*)request {
	[request addValue:[self getOAuthHeaderValue] forHTTPHeaderField:@"Authorization"];
}

- (void)dealloc {
	[accessToken release];
	[refreshToken release];
	[instanceUrl release];
	
	[restManager release];
	[identity release];
	
	[super dealloc];
}

// RKObjectLoaderDelegate implementation
- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
	NSLog(@"RestKit retrieved Identity on refresh, got new access token: %@ instanceURL: %@", identity.accessToken, identity.instanceUrl);
	self.accessToken = identity.accessToken;
	self.instanceUrl = identity.instanceUrl;
	
	[delegate refreshCompleted];
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
	NSLog(@"RestKit failed to retrieve Identity on refresh");
	[delegate refreshCompleted];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSLog(@"RestKit failed to retrieve Identity on refres, with error: %@", error); 
	[delegate refreshCompleted];
}

@end

