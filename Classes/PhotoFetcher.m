//
//  PhotoFetcher.m
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

#import "PhotoFetcher.h"
#import "AuthContext.h"

@implementation PhotoFetcher

@synthesize tag;
@synthesize delegate;
@synthesize url;
@synthesize conn;
@synthesize data;

- initWithTag:(NSString*)inTag photoUrl:(NSString*)photoUrl delegate:(NSObject<PhotoFetcherDelegate>*)inDelegate {
	self = [super init];
	
	if (self != nil) {
		self.url = [NSURL URLWithString:photoUrl];
		self.tag = inTag;
		self.delegate = inDelegate;
	}
	
	return self;
}

- (void)dealloc {
	[tag release];
	[url release];
	[conn release];
	[data release];
	
	[super dealloc];
}

- (void)fetch {
	// Make a request.
	NSMutableURLRequest* photoRequest = [[[NSMutableURLRequest alloc] initWithURL:self.url] autorelease];
	[photoRequest setHTTPMethod:@"GET"];
	[[AuthContext context] addOAuthHeaderToNSRequest:photoRequest];
	self.conn = [NSURLConnection connectionWithRequest:photoRequest delegate:self];
}

// ================
// NSURLConnection delegate implementation

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"Failed to finish user photo retrieval: %@", error);
	
	// Report to the delegate.
	[self.delegate photoRetrievalCompleted:self.tag image:nil];
	
	// Reset state.
	self.data = nil;
	self.conn = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.data = [NSMutableData dataWithCapacity:1024];
	[self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)inData {
	[self.data appendData:inData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	UIImage* image = [UIImage imageWithData:self.data];
	
	// Report to the delegate.
	[self.delegate photoRetrievalCompleted:self.tag image:image];
	
	// Reset state.
	self.data = nil;
	self.conn = nil;
}

@end
