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
#import "NewsFeedViewController.h"
#import "AuthContext.h"
#import "MappingManager.h"

@implementation DemoAppViewController

@synthesize exploreBtn;
@synthesize stateLbl;
@synthesize nameLbl;
@synthesize titleLbl;
@synthesize picView;
@synthesize infoView;

- (void)dealloc {
	[exploreBtn release];
	[stateLbl release];
	[nameLbl release];
	[titleLbl release];
	[picView release];
	[infoView release];
	
	[user release];
	[photoFetcher release];
	
    [super dealloc];
}

- (void)updateUi {
	// Clear the UI.
	[nameLbl setText:@""];
	[titleLbl setText:@""];
	[picView setImage:nil];
	
	if ([[AuthContext context] accessToken] == nil) {
		[stateLbl setText:@"Not logged in"];
		[exploreBtn setEnabled:FALSE];
		[exploreBtn setAlpha:0.5];
		[infoView setHidden:TRUE];
	} else {
		// TODO: Verify the token actually works...
		
		[stateLbl setText:@"Logged in"];
		[exploreBtn setEnabled:TRUE];
		[exploreBtn setAlpha:1.0];
		[infoView setHidden:FALSE];
	}
}

- (void)viewWillAppear:(BOOL)animated {	
	[self updateUi];
	
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {	
	if ([[AuthContext context] accessToken] != nil) {
		// Initialize RestKit mappings.
		[MappingManager initWithBaseURL:[AuthContext context].instanceUrl];
		
		// Request population of the User by RestKit.
		[user release];
		user = [[User alloc] init];
		user.userId = @"me";
		
		RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:user method:RKRequestMethodGET delegate:self];
		[[AuthContext context] addOAuthHeader:loader];	
		[loader setObjectMapping:[[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[User class]]];
		[loader send];
	}
	
	[super viewDidAppear:animated];
}

- (IBAction)login:(id)sender {
	// Retrieve the "PPConsumerKey" value from the info plist.	
	NSString* consumerKey = (NSString*)[[NSBundle mainBundle] objectForInfoDictionaryKey:@"PPConsumerKey"];
	if ((consumerKey == nil) || ([consumerKey length] <= 0)) {
		NSLog(@"!!!!!!!YOU MUST SET THE PPConsumerKey VALUE IN THE INFO PLIST FOR THIS APP TO RUN!!!!!!!!!");
		[[NSThread mainThread] exit];
	}
	
	OAuthViewController* oauthViewController = 
	[[[OAuthViewController alloc] 
	  initWithLoginUrl:@"https://gus.soma.salesforce.com/services/oauth2/authorize"
	  callbackUrl:@"https://login.salesforce.com/services/oauth2/success"
	  consumerKey:consumerKey] autorelease];
	
	[[self navigationController] pushViewController:oauthViewController animated:YES];
}

- (IBAction)logout:(id)sender {
	[[AuthContext context] clear];
	
	[self updateUi];
}

- (IBAction)explore:(id)sender {	
	[self.navigationController pushViewController:[NewsFeedViewController create] animated:YES];
}

// RKObjectLoaderDelegate implementation.

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {
	[nameLbl setText:[user name]];
	[titleLbl setText:[user title]];
	
	// Retrieve the user's photo.
	photoFetcher = [[PhotoFetcher alloc] initWithTag:@"userPhoto" photoUrl:user.photo.largePhotoUrl delegate:self];
	[photoFetcher fetch];
}

- (void)objectLoaderDidLoadUnexpectedResponse:(RKObjectLoader *)objectLoader {
	NSLog(@"User fetch failed unexpectedly");
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
	NSLog(@"User fetch failed with error: %@", error);
}

// PhotoFetcherDelegate implementation.

- (void)retrievalCompleted:(NSString*)tag image:(UIImage*)image {
	[picView setImage:image];
}

@end
