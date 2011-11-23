//
//  FeedItemController.m
//  DemoApp
//
//  Created by Chris Seymour on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedItemController.h"
#import "FeedController.h"
#import "AuthContext.h"

@implementation FeedItemController

@synthesize feedItem;
@synthesize segmentsView;
@synthesize dateLbl;
@synthesize actorLbl;
@synthesize actorImg;
@synthesize photoFetcher;

- initWithFeedItem:(FeedItem*)inFeedItem {
	self = [super initWithNibName:@"FeedItemPhone" bundle:nil];	
	if (self != nil) {
		self.feedItem = inFeedItem;
	}
	return self;
}

- (void)dealloc {
	[feedItem release];
	[segmentsView release];
	[dateLbl release];
	[actorLbl release];
	[actorImg release];
	[photoFetcher release];
		
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// TODO: Improve efficiency - don't create date formatterse each time through.
	NSDateFormatter* dateFormatterIn = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatterIn.dateFormat = @"yyyy-MM-d'T'HH:mm:ss.SSS'Z'";
	NSDate* date = [dateFormatterIn dateFromString:self.feedItem.createdDate];
	
	NSDateFormatter* dateFormatterOut = [[[NSDateFormatter alloc] init] autorelease];
	dateFormatterOut.dateFormat = @"hh:mm MMMM dd yyyy"; 
	
	[self.dateLbl setText:[dateFormatterOut stringFromDate:date]];
	[self.actorLbl setText:self.feedItem.author.name];
	
	// Render feed item segments.
	[FeedController renderFeedItem:self.feedItem 
						  maxWidth:self.segmentsView.bounds.size.width
						 startingX:0
							  view:self.segmentsView 
						   actions:nil
					actionDelegate:nil];
	
	// Asynchronously retrieve the actor photo.
	NSString* photoUrlStr = self.feedItem.author.photo.smallPhotoUrl;
	if (![photoUrlStr hasPrefix:@"https"]) { // Some orgs give relative urls, others absolute.
		photoUrlStr = [NSString stringWithFormat:@"%@%@", [AuthContext context].instanceUrl, photoUrlStr];
	}
	
	// Fetch the photo.
	self.photoFetcher = [[PhotoFetcher alloc] initWithTag:@"actorPhoto" photoUrl:photoUrlStr delegate:self];
	[self.photoFetcher fetch];
}

// =========================
// PhotoFetcherDelegate implementation
- (void)photoRetrievalCompleted:(NSString*)tag image:(UIImage*)image {
	if (image == nil) {
		NSLog(@"Error retrieving actor photo");
	} else {
		[self.actorImg setImage:image];
		
		// Release the fetcher.
		self.photoFetcher = nil;
	}
}

@end
