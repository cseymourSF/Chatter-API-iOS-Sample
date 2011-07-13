//
//  AuthContext.h
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Identity.h"

@protocol AccessTokenRefreshDelegate<NSObject>
- (void)refreshCompleted;
@end


@interface AuthContext : NSObject<RKObjectLoaderDelegate> {
	NSString* accessToken;
	NSString* refreshToken;
	NSString* instanceUrl;
	
	RKObjectManager* restManager;
	Identity* identity;
	NSObject<AccessTokenRefreshDelegate>* delegate;
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

@property(nonatomic, retain) NSString* accessToken;
@property(nonatomic, retain) NSString* refreshToken;
@property(nonatomic, retain) NSString* instanceUrl;

@end
