//
//  AuthContext.h
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface AuthContext : NSObject {
	NSString* accessToken;
	NSString* refreshToken;
	NSString* instanceUrl;
}

+ (AuthContext*)context;

- (NSString*)getOAuthHeaderValue;
- (void)addOAuthHeader:(RKRequest*)request;
- (void)addOAuthHeaderToNSRequest:(NSMutableURLRequest*)request;
- (void)clear;

@property(nonatomic, retain) NSString* accessToken;
@property(nonatomic, retain) NSString* refreshToken;
@property(nonatomic, retain) NSString* instanceUrl;

@end
