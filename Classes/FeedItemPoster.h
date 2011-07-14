//
//  FeedItemPoster.h
//  DemoApp
//
//  Created by Chris Seymour on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface FeedItemPoster : NSObject {
	NSString* url;
	NSMutableData* responseData;
	int statusCode;
}

-(id)initWithUrl:(NSString*)urlIn;
-(void)startPostWithMessage:(NSString*)message desc:(NSString*)desc filenamePrefix:(NSString*)filenamePrefix image:(UIImage*)image;

@end
