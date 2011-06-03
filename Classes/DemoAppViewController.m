//
//  DemoAppViewController.m
//  DemoApp
//
//  Copyright 2011 Salesforce.com. All rights reserved.
//
//  This is sample code provided as a learning tool. Feel free to 
//  learn from it and incorporate elements into your own code. 
//  No guarantees are made about the quality or security of this code.
//
//  THIS SOFTWARE IS PROVIDED BY Salesforce.com "AS IS" AND ANY EXPRESS OR IMPLIED
//  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
//  FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Salesforce.com OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//  ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
//  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "DemoAppViewController.h"
#import "ConfigController.h"
#import "NewsFeedViewController.h"
#import "Authenticator.h"
#import "DemoAppAppDelegate.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2Authentication.h"

#import "RKObjectManager.h"

#import "Address.h"
#import "User.h"
#import "FeedItem.h"
#import "FeedBody.h"
#import "UserFeedPage.h"
#import "NewsFeedPage.h"
#import "MessageSegment.h"

@implementation DemoAppViewController

@synthesize testLabel;
@synthesize socialButton;
@synthesize configButton;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		showSocial = NO;
		viewJustAppeared = NO;
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
	NSLog(@"In viewWillAppear");
	
	[super viewWillAppear:animated];

	BOOL loggedIn = NO;

	if ([Authenticator auth] != nil) {
		[self initRestkit];
		loggedIn = YES;
	} else if ([Authenticator authenticateSilently]) {
		if ([[Authenticator auth] accessToken] == nil) {
			// TODO: Why this this always fail like this?
			NSLog(@"Got nil access token, clearing auth");
			[Authenticator clearAuth];
		} else {
			[self initRestkit];
			loggedIn = YES;
		}
	}
	
	if (loggedIn) {
		[testLabel setText:@"Logged in"];
	} else {
		[testLabel setText:@"Not logged in"];
	}
	
	[socialButton setEnabled:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"In viewDidAppear");
	[super viewDidAppear:animated];
	
	viewJustAppeared = YES;
	
	if (showSocial) {
		[self initRestkit];
		[self.navigationController pushViewController:[NewsFeedViewController create] animated:YES];
		showSocial = NO;
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[testLabel release];
	[socialButton release];
	[configButton release];
	
    [super dealloc];
}

- (IBAction)configClicked:(id)sender {
	[self.navigationController pushViewController:[ConfigController create] animated:YES];
}

- (IBAction)exploreSocialClicked:(id)sender {	
	if ([Authenticator auth] == nil) {
		// Try to log in.
		// TODO: Fail gracefully if this doesn't work?
		viewJustAppeared = NO;
		showSocial = NO;
		[Authenticator authenticateWithNavigationController:[self navigationController] delegate:self];
	} else {
		[self.navigationController pushViewController:[NewsFeedViewController create] animated:YES];
	}
}

- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
	  finishedWithAuth:(GTMOAuth2Authentication *)auth
				 error:(NSError *)error {
	if (error != nil) {
		// Sign-in failed
		[Authenticator clearAuth];
	    [testLabel setText:@"Login Failed"];
	} else {
		// Sign-in succeeded.
		NSLog(@"in GTM callback, sign in succeeded");
		
		if (viewJustAppeared) {
			viewJustAppeared = NO;
			
			// Sign-in succeeded
			[self initRestkit];
			[self.navigationController pushViewController:[NewsFeedViewController create] animated:YES];
		} else {
			// Wait until the view appears.
			// TODO: Do something less crazy hacky! The problem is that
			// sometimes the view appears before the callback is over and 
			// sometimes it doesn't. I guess it's on a separate thread and we
			// should use a synchronization object...
			showSocial = YES;
		}
	}
}

- (void)initRestkit {
	NSString* fullBaseUrl = [NSString stringWithFormat:@"https://%@", [Authenticator baseUrl]];	
	RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:fullBaseUrl auth:[Authenticator auth]];
	[RKObjectManager setSharedManager:manager];

	// Register routes for objects accessible from URLs.
	RKDynamicRouter* router = [RKDynamicRouter new];  
	[router routeClass:[User class] toResourcePath:@"/services/data/v22.0/chatter/users/(userId)"];
	[router routeClass:[UserFeedPage class] toResourcePath:@"/services/data/v22.0/chatter/feeds/user-profile/(userId)/feed-items"];
	[router routeClass:[NewsFeedPage class] toResourcePath:@"/services/data/v22.0/chatter/feeds/news/me/feed-items"];
	[RKObjectManager sharedManager].router = router;  

	// Register classes for objects not accessible from URLs.
	RKObjectMapper * mapper = [RKObjectManager sharedManager].mapper;
	[mapper registerClass:[Address class] forElementNamed:@"address"];
	[mapper registerClass:[Photo class] forElementNamed:@"photo"];
	[mapper registerClass:[FeedItem class] forElementNamed:@"items"];
	[mapper registerClass:[FeedBody class] forElementNamed:@"body"];
	[mapper registerClass:[MessageSegment class] forElementNamed:@"messageSegments"];
	[mapper registerClass:[UserSummary class] forElementNamed:@"user"];
}

@end
