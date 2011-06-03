//
//  FeedPage.m
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

#import "FeedPage.h"

@implementation FeedPage

@synthesize currentPageUrl;
@synthesize nextPageUrl;
@synthesize feedItems;

+ (NSDictionary*)elementToPropertyMappings {  
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"currentPageUrl" forKey:@"currentPageUrl"];
	[dict setObject:@"nextPageUrl" forKey:@"nextPageUrl"];
	return [dict autorelease];  
}  

+ (NSDictionary*)elementToRelationshipMappings {  
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"feedItems" forKey:@"items"];
	return [dict autorelease];  
}  

- (void)dealloc {
	[currentPageUrl release];
	[nextPageUrl release];
	[feedItems release];
	
	[super dealloc];
}

@end
