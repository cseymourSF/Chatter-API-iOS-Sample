//
//  AuthContext.m
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthContext.h"
#import "Identity.h"

@implementation AuthContext

static AuthContext* contextSingleton;

static const NSString* keychainIdentifier = @"com.salesforce.DemoApp.AuthKeychain";

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
		// TODO: Get base URL from config.
		restManager = [[RKObjectManager objectManagerWithBaseURL:@"https://login.salesforce.com/"] retain];
		
		// Load the refresh token and instance URL from the keychain, and 
		// retrieve a new access token.
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

- (BOOL)startGettingAccessTokenWithConsumerKey:(NSString*)consumerKey delegate:(id<AccessTokenRefreshDelegate>)delegateIn {
	if (self.refreshToken == nil) {
		// We need the user to log-in.
		return FALSE;
	}
	
	// URL-encode the callback URL.
	NSString* encodedRefreshToken = [self.refreshToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	NSString* targetUrl = [NSString stringWithFormat:
						   @"services/oauth2/token?grant_type=refresh_token&client_id=%@&refresh_token=%@",
						   consumerKey, encodedRefreshToken];
	
	// Save the delegate for later (do not retain).
	delegate = delegateIn;
	
	// Send off the request.
	[identity release];
	identity = [[Identity alloc] init];
	NSLog(@"Making loader");
	RKObjectLoader* loader = [RKObjectLoader loaderWithResourcePath:targetUrl objectManager:restManager delegate:self];
	NSLog(@"Made loader");
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
		NSLog(@"Error retrieving auth values from keychain: %d", keychainErr);
	}
	
	[refreshTokenData release];
}

- (void)save {
	// Update the instance URL and refresh token values in the existing keychain item.
	NSMutableDictionary* updateDict = [AuthContext createKeychainDict];
	[updateDict removeObjectForKey:(id)kSecClass];
	
	NSLog(@"Saving refresh token: %@ ", self.refreshToken);
	
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
