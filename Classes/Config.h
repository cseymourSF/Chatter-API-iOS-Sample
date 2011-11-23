//
//  Config.h
//  DemoApp
//
//  Created by Chris Seymour on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface Config : NSObject {
	
}

+(NSString*)consumerKey;
+(NSString*)callbackUrl;
+(NSString*)loginServer;
+(NSString*)tokenUrlPath;
+(NSString*)authorizeUrl;

+(NSString*)addVersionPrefix:(NSString*)url;
+(int)getVersion;

@end
