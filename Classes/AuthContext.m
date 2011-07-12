//
//  AuthContext.m
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AuthContext.h"

@implementation AuthContext

static AuthContext* contextSingleton;

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

- (void)dealloc {
	[accessToken release];
	[refreshToken release];
	[instanceUrl release];
	[super dealloc];
}

+ (AuthContext*)context {
	return contextSingleton;
}

- (void) clear {
	self.accessToken = nil;
	self.refreshToken = nil;
	self.instanceUrl = nil;
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


@end
