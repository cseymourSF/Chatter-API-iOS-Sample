//
//  FeedViewController.m
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

#import "FeedViewController.h"
#import "WebViewController.h"
#import "UserViewController.h"
#import "PostLocationViewController.h"

@implementation FeedViewController

@synthesize feedController;

- (id)init {
	self = [super initWithNibName:@"FeedPhone" bundle:nil];
	
	if (self != nil) {
	}
	
	return self;
}

- (void)dealloc {
	[feedController release];
	
	[super dealloc];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.title = self.name;

	[self.feedController fetchWithNavController:self.navigationController page:self.page];
}

- (IBAction)postLocationClick:(id)sender {
	// HACK: Using nextPageUrl for now because currentPageUrl seems to be unpopulated...
	[self.navigationController pushViewController:[[[PostLocationViewController alloc] initWithUrl:[self page].nextPageUrl] autorelease] animated:YES];
}

// ================
// To be implemented in subclass

- (FeedItemPage*)page {
	return nil;
}

- (NSString*)name {
	return nil;
}

@end
