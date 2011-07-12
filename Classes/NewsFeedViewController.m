//
//  NewsFeedController.m
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

#import "NewsFeedViewController.h"


@implementation NewsFeedViewController

@synthesize newsPage;

+ (NewsFeedViewController*)create {
	return [[[NewsFeedViewController alloc] init] autorelease];
}

- init {
	self = [super init];
	
	if (self != nil) {
		self.newsPage = [[NewsFeedPage alloc] init];
	}
	
	return self;
}

- (NSString*)name {
	return @"News";
}

- (FeedItemPage*)page {
	return self.newsPage;
}

- (void)fetchCompleted {
	// TODO: Do any extra stuff with the userPage...
}

- (void)dealloc {
	[newsPage release];
	
	[super dealloc];
}

@end