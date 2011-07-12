//
//  Identity.h
//  DemoApp
//
//  Created by Chris Seymour on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Identity : NSObject {
	NSString* instanceUrl;
	NSString* identityUrl;
	NSString* signature;
	NSString* accessToken;
	NSString* issuedAt;
}

+(RKObjectMapping*)getMapping;

@property(nonatomic, retain) NSString* instanceUrl;
@property(nonatomic, retain) NSString* identityUrl;
@property(nonatomic, retain) NSString* signature;
@property(nonatomic, retain) NSString* accessToken;
@property(nonatomic, retain) NSString* issuedAt;

@end

