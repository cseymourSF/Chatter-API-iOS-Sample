//
//  MappingManager.m
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MappingManager.h"

#import "Photo.h"
#import "Address.h"
#import "User.h"
#import "FeedItem.h"
#import "NewsFeedPage.h"
#import "UserFeedPage.h"
#import "MessageSegment.h"

@implementation MappingManager

+ (void)initWithBaseURL:(NSString*)baseURL {	
	// Set-up the RestKit manager.
	RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:baseURL];
	[RKObjectManager setSharedManager:manager];

	// Initialize mappings. Dependencies first.
	[Photo setupMapping:manager];
	[Address setupMapping:manager];
	[UserSummary setupMapping:manager];
	[User setupMapping:manager];
	[MessageSegment setupMapping:manager];
	[FeedBody setupMapping:manager];
	[FeedItem setupMapping:manager];
	[NewsFeedPage setupMapping:manager];
	[UserFeedPage setupMapping:manager];

	// RestKit logging.
	RKLogConfigureByName("RestKit", RKLogLevelDebug);
	RKLogConfigureByName("RestKit/Network", RKLogLevelDebug);
	RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
	RKLogConfigureByName("RestKit/Network/Queue", RKLogLevelDebug);
}

@end
