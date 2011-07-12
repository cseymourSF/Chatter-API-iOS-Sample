//
//  FeedItem.m
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

#import "FeedItem.h"

@implementation FeedItem

@synthesize feedItemId;
@synthesize parentId;
@synthesize parentName;
@synthesize createdDate;
@synthesize modifiedDate;
@synthesize type;
@synthesize url;
@synthesize body;
@synthesize author;

+(void)setupMapping:(RKObjectManager*)manager {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[FeedItem class]];
	[mapping mapAttributes:@"createdDate", @"modifiedDate", @"type", @"url", @"parentId", @"parentName", @"isEvent", @"isLikedByCurrentUser", nil];
	[mapping addAttributeMapping:[RKObjectAttributeMapping mappingFromKeyPath:@"id" toKeyPath:@"feedItemId"]];
	
	// Assuming that User and FeedBody already registered mappings.
	RKObjectMapping* userMapping = [[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[User class]];
	RKObjectMapping* bodyMapping = [[[RKObjectManager sharedManager] mappingProvider] objectMappingForClass:[FeedBody class]];
	
	[mapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"user" toKeyPath:@"author" objectMapping:userMapping]];
	[mapping addRelationshipMapping:[RKObjectRelationshipMapping mappingFromKeyPath:@"body" toKeyPath:@"body" objectMapping:bodyMapping]];
	
	[manager.router routeClass:[FeedItem class] toResourcePath:@"/services/data/v22.0/chatter/feed-items/(feedItemId)" forMethod:RKRequestMethodGET];
	[manager.mappingProvider addObjectMapping:mapping];
}
- (void)dealloc {
	[feedItemId release];
	[parentId release];
	[parentName release];
	[createdDate release];
	[modifiedDate release];
	[type release];
	[url release];
	[body release];
	[author release];
	
	[super dealloc];
}

@end
