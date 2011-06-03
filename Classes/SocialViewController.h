//
//  SocialViewController.h
//  DemoApp
//
//  Created by Chris Seymour on 5/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AuthedViewController.h"

@interface SocialViewController : AuthedViewController {
	UIButton* newsfeedBtn;
	UIButton* twitterBtn;
	UIButton* groupPhotoBtn;
}

@property(nonatomic, retain) IBOutlet UIButton* newsfeedBtn;
@property(nonatomic, retain) IBOutlet UIButton* twitterBtn;
@property(nonatomic, retain) IBOutlet UIButton* groupPhotoBtn;

+ (SocialViewController*)createWithAuth:(GTMOAuth2Authentication*)auth baseURL:(NSString*)inBaseURL;

- (IBAction)newsfeedClick:(id)sender;

@end
