//
//  PostLocationViewController.m
//  DemoApp
//
//  Created by Chris Seymour on 7/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PostLocationViewController.h"
#import "FeedItemPoster.h"

@implementation PostLocationViewController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize locationManager;
@synthesize imageView;
@synthesize messageField;
@synthesize postBtn;
@synthesize currentLocation;

- (id)initWithUrl:(NSString*)targetUrl {
    self = [super initWithNibName:@"PostLocationPhone" bundle:nil];
	
    if (self != nil) {
		self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
		feedUrl = [targetUrl retain];
		
		// Strip stuff off the end of the feed url.
		NSRange questionRange = [targetUrl rangeOfString: @"?"];
		feedUrl = [[targetUrl substringToIndex:questionRange.location] retain];
		
		NSLog(@"Location poster got feed url: %@", feedUrl);
		
		keyboardOffset = 0;
    }
	
    return self;
}

- (void)dealloc {
	[currentLocation release];
    [locationManager release];
	[mapPhotoFetcher release];
	[imageView release];
	[messageField release];
	[postBtn release];
	[feedUrl release];
	
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.postBtn setAlpha:0.5];
	[self.postBtn setEnabled:NO];
	[self.locationManager startUpdatingLocation];
	
	[super viewWillAppear:animated];
}

- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
	[self.locationManager stopUpdatingLocation];
	
	NSString* googleStaticMapUrl = 
		[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=14&size=512x512&maptype=roadmap&markers=color:red%%7Clabel:S%%7C%f,%f&sensor=true",
			newLocation.coordinate.latitude,
			newLocation.coordinate.longitude,
		 newLocation.coordinate.latitude,
		 newLocation.coordinate.longitude];
	NSLog(@"Google static map url: %@", googleStaticMapUrl);
	
	self.currentLocation = newLocation;
	
	[mapPhotoFetcher release];
	mapPhotoFetcher = [[PhotoFetcher alloc] initWithTag:@"mapPhoto" photoUrl:googleStaticMapUrl delegate:self];
	[mapPhotoFetcher fetchWithOAuth:FALSE];
}

- (void)locationManager:(CLLocationManager *)manager
didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (void)photoRetrievalCompleted:(NSString*)tag image:(UIImage*)image {
	[self.imageView setImage:image];
	
	[self.postBtn setAlpha:1.0];
	[self.postBtn setEnabled:YES];
}

- (void)recenter {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += keyboardOffset;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	
	keyboardOffset = 0;
	
	// Clear the keyboard.
	[self.messageField resignFirstResponder];
}

- (IBAction)post:(id)sender {
	[self recenter];
	
	FeedItemPoster* poster = [[[FeedItemPoster alloc] initWithUrl:feedUrl] autorelease];
	[poster startPostWithMessage:[messageField text] desc:@"Current Location" filenamePrefix:@"location" image:[self.imageView image]];
}

// =================
// Text field delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textFieldIn {
	// This code is used to move the view when the text field is being edited
	// and the keyboard slides up.
	//
	// From http://cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html
	
    CGRect textFieldRect = [self.view.window convertRect:textFieldIn.bounds fromView:textFieldIn];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
        heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
		keyboardOffset = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else {
		keyboardOffset = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= keyboardOffset;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self recenter];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldIn {
    [textFieldIn resignFirstResponder];
    return YES;
}

@end