//
//  PostLocationViewController.h
//  DemoApp
//
//  Created by Chris Seymour on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "PhotoFetcher.h"

@interface PostLocationViewController : UIViewController<CLLocationManagerDelegate, PhotoFetcherDelegate> {
	NSString* feedUrl;
	CLLocationManager* locationManager;
	PhotoFetcher* mapPhotoFetcher;
	UIImageView* imageView;
	UITextField* messageField;
	UIButton* postBtn;
	CGFloat keyboardOffset;
	CLLocation* currentLocation;
}

@property(nonatomic, retain) CLLocation* currentLocation;
@property(nonatomic, retain) CLLocationManager *locationManager;  

@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UITextField* messageField;
@property(nonatomic, retain) IBOutlet UIButton* postBtn;

- (id)initWithUrl:(NSString*)targetUrl;
- (IBAction)post:(id)sender;

@end