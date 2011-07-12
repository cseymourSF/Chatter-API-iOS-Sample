//
//  UserController.m
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

#import "UserViewController.h"
#import "UserFeedViewController.h"
#import "AuthContext.h"
#import "FeedBody.h"

@implementation UserViewController

@synthesize user;
@synthesize userFetcher;
@synthesize imageView;
@synthesize nameLbl;
@synthesize locationLbl;
@synthesize emailLbl;
@synthesize aboutLbl;
@synthesize titleLbl;
@synthesize photoFetcher;

+ (UserViewController*)createWithUserId:(NSString*)userId{
	return [[[UserViewController alloc] initWithUserId:userId] autorelease];
}

- initWithUserId:(NSString*)inUserId{
	self = [super initWithNibName:@"UserPhone" bundle:nil];
	
	if (self != nil) {
		self.user = [[User alloc] init];
		self.user.userId = inUserId;
	}
	
	return self;
}

- (void)dealloc {
	[nameLbl release];
	[locationLbl release];
	[emailLbl release];
	[titleLbl release];
	[aboutLbl release];
	[user release];
	[userFetcher release];
	[photoFetcher release];
	[imageView release];
	
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Clear the UI.
	[nameLbl setText:@""];
	[emailLbl setText:@""];
	[locationLbl setText:@""];
	[aboutLbl setText:@""];
	[titleLbl setText:@""];

	// Fetch the User.
	self.userFetcher = [[ObjectFetcher alloc] initWithTag:@"user" object:self.user delegate:self];
	[self.userFetcher fetch];
}

- (IBAction)feedClick:(id)sender {
	// Push the user feed view.
	UserFeedViewController* feedController = [UserFeedViewController createWithUserId:[self.user userId] userName:[self.user name]];
	[[self navigationController] pushViewController:feedController animated:YES];
}

- (NSString*)appendAddr:(NSString*)base part:(NSString*)part {
	if (part == nil) {
		return base;
	} else if (base == nil) {
		return part;
	} else {
		return [NSString stringWithFormat:@"%@, %@", base, part];
	}
}

// ================
// ObjectFetcherDelegate implementation
- (void)retrievalCompleted:(NSString*)tag withSuccess:(bool)succeeded {	
	if (succeeded) {
		if ([tag compare:@"user"] == NSOrderedSame) {
			self.userFetcher = nil;
			
			// Update the UI.
			self.title  = [self.user name];
			
			[nameLbl setText:[self.user name]];
			[emailLbl setText:[self.user email]];
			[titleLbl setText:[self.user title]];
			[aboutLbl setText:[self.user about]];
		
			Address* address = [self.user address];
			NSString* addrStr = address.city;
			addrStr = [self appendAddr:addrStr part:address.state];
			addrStr = [self appendAddr:addrStr part:address.country];
			[locationLbl setText:addrStr];
			
			// Asynchronously retrieve the user photo.
			NSString* photoUrlStr = self.user.photo.largePhotoUrl;
			if (![photoUrlStr hasPrefix:@"https"]) { // Some orgs give relative urls, others absolute.
				photoUrlStr = [NSString stringWithFormat:@"%@%@", [AuthContext context].instanceUrl, photoUrlStr];
			}
			
			// Fetch the photo.
			self.photoFetcher = [[PhotoFetcher alloc] initWithTag:@"userPhoto" photoUrl:photoUrlStr delegate:self];
			[self.photoFetcher fetch];
		}
	} else {
		NSLog(@"Retrieval of object %@ failed", tag);
	}
}

// =========================
// PhotoFetcherDelegate implementation
- (void)retrievalCompleted:(NSString*)tag image:(UIImage*)image {
	if (image == nil) {
		NSLog(@"Error retrieving user photo");
	} else {
		[self.imageView setImage:image];
		
		// Release the fetcher.
		self.photoFetcher = nil;
	}
}

@end
