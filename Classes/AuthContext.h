//
//  AuthContext.h
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Identity.h"
#import "LoginSuccess.h"
#import "ObjectFetcher.h"

@protocol AccessTokenRefreshDelegate<NSObject>
- (void)refreshCompleted;
@end


@interface AuthContext : NSObject<RKObjectLoaderDelegate> {
	NSString* accessToken;
	NSString* refreshToken;
	NSString* instanceUrl;
	
	NSString* userId;
	
	RKObjectManager* restManager;
	RKObjectManager* identityManager;
	ObjectFetcher* identityFetcher;
	LoginSuccess* loginSuccess;
	Identity* identity;
	NSObject<AccessTokenRefreshDelegate>* delegate;
	
	BOOL loggedIn;
}

+ (AuthContext*)context;
+ (NSURL*)fullLoginUrl;

- (BOOL)startGettingAccessTokenWithDelegate:(id<AccessTokenRefreshDelegate>)delegateIn;
- (void)clear;
- (void)save;
- (void)load;
- (NSString*)getOAuthHeaderValue;
- (void)addOAuthHeader:(RKRequest*)request;
- (void)addOAuthHeaderToNSRequest:(NSMutableURLRequest*)request;
- (void)processCallbackUrl:(NSURL*)callbackUrl;

- (NSString*)userId;
- (void)setUserId:(NSString*)value;

@property(nonatomic, retain) NSString* accessToken;
@property(nonatomic, retain) NSString* refreshToken;
@property(nonatomic, retain) NSString* instanceUrl;
@property(nonatomic, retain) Identity* identity;

@end
