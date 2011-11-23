//
//  FeedController.h
//  DemoApp
//
//  Created by Chris Seymour on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ObjectFetcher.h"
#import "FeedItemPage.h"
#import "FeedItem.h"

@interface FeedController : NSObject<UITableViewDataSource, ObjectFetcherDelegate>  {
	FeedItemPage* feedPage;
	ObjectFetcher* feedFetcher;
	UINavigationController* navController;
	
	NSMutableDictionary* segmentActions;
	UITableView* feedTable;
}

@property(nonatomic, retain) IBOutlet UITableView* feedTable;
@property(nonatomic, retain) FeedItemPage* feedPage;
@property(nonatomic, retain) UINavigationController* navController;
@property(nonatomic, retain) ObjectFetcher* feedFetcher;

- (void)fetchWithNavController:(UINavigationController*)navControllerIn page:(FeedItemPage*)pageIn;
- (IBAction)onSegmentClick:(id)sender;

+ (void)renderFeedItem:(FeedItem*)feedItem maxWidth:(int)maxWidth startingX:(int)initialXOffset view:(UIView*)view actions:(NSMutableDictionary*)actions actionDelegate:(id)delegate;

@end