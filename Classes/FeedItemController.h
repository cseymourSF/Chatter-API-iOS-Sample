//
//  FeedItemController.h
//  DemoApp
//
//  Created by Chris Seymour on 11/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedItem.h"
#import "PhotoFetcher.h"

@interface FeedItemController : UIViewController<PhotoFetcherDelegate> {
	FeedItem* feedItem;
	UILabel* dateLbl;
	UILabel* actorLbl;
	UIImageView* actorImg;
	UIView* segmentsView;
	UISwitch* likeSwitch;
	PhotoFetcher* photoFetcher;
}

@property(nonatomic, retain) IBOutlet UIView* segmentsView;
@property(nonatomic, retain) IBOutlet UILabel* dateLbl;
@property(nonatomic, retain) IBOutlet UILabel* actorLbl;
@property(nonatomic, retain) IBOutlet UIImageView* actorImg;
@property(nonatomic, retain) IBOutlet UISwitch* likeSwitch;

@property(nonatomic, retain) FeedItem* feedItem;
@property(nonatomic, retain) PhotoFetcher* photoFetcher;

- initWithFeedItem:(FeedItem*)inFeedItem;
- (IBAction)toggleLike:(id)sender;
	
@end
