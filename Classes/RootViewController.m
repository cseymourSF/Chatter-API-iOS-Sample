//
//  RootViewController.m
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

#import "RootViewController.h"
#import "NewsFeedViewController.h"
#import "MappingManager.h"

@implementation RootViewController

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

- (void)initRestKitAndUser {
	// Re-initialize RestKit with the current instance URL.
	[MappingManager initialize];
	
	// Request population of the User by RestKit.
	[user release];
	user = [[User alloc] init];
	user.userId = @"me";
	
	RKObjectLoader* loader = [[RKObjectManager sharedManager] objectLoaderForObject:user method:RKRequestMethodGET delegate:self];
	[[AuthContext context] addOAuthHeader:loader];	
	[loader setObjectMapping:[[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[User class]]];
	[loader send];
}

- (void)viewDidAppear:(BOOL)animated {	
	if ([[AuthContext context] accessToken] == nil) {		
		BOOL isGetting = [[AuthContext context] startGettingAccessTokenWithDelegate:self];
		if (isGetting) {
			[stateLbl setText:@"Fetching access token..."];
		}
	} else {
		[self initRestKitAndUser];
	}
	
	[super viewDidAppear:animated];
}

- (void)refreshCompleted {
	NSLog(@"Finished trying to fetch access token: %@", [[AuthContext context] accessToken]);
	
	[self updateUi];
	if ([[AuthContext context] accessToken] != nil) {
		[self initRestKitAndUser];
	}
}

- (IBAction)login:(id)sender {	
	OAuthViewController* oauthViewController = [[[OAuthViewController alloc] init] autorelease]; 
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
	[[AuthContext context] setUserId:[user userId]];
	
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

- (void)photoRetrievalCompleted:(NSString*)tag image:(UIImage*)image {
	[picView setImage:image];
}

@end
