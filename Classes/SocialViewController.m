//
//  SocialViewController.m
//  DemoApp
//
//  Created by Chris Seymour on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SocialViewController.h"
#import "RKDynamicRouter.h"
#import "RKObjectManager.h"
#import "UserViewController.h"
#import "User.h"
#import "Address.h"
#import "FeedItemPage.h"
#import "FeedBody.h"
#import "FeedItem.h"

@implementation SocialViewController

@synthesize newsfeedBtn;
@synthesize twitterBtn;
@synthesize groupPhotoBtn;

+ (SocialViewController*)createWithAuth:(GTMOAuth2Authentication*)auth baseURL:(NSString*)inBaseURL {	
	return [[[SocialViewController alloc] initWithAuth:auth baseURL:inBaseURL nib:@"SocialView"] autorelease];
}

- (void)dealloc {
	[newsfeedBtn release];
	[twitterBtn release];
	[groupPhotoBtn release];
	
	[super dealloc];
}

- (IBAction)newsfeedClick:(id)sender {
	// Push "me" user view.
	// TODO: Should push "me" feed view instead? Or change button label.
	UserViewController* viewController = [UserViewController createWithAuth:auth baseURL:self.baseURL userId:@"me"];
	[[self navigationController] pushViewController:viewController animated:YES];
}

@end
