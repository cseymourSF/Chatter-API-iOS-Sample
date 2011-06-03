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

@synthesize itemId;
@synthesize parentId;
@synthesize parentName;
@synthesize createdDate;
@synthesize modifiedDate;
@synthesize type;
@synthesize url;
@synthesize body;
@synthesize user;

+ (NSDictionary*)elementToPropertyMappings {  
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"itemId" forKey:@"id"];
	[dict setObject:@"parentId" forKey:@"parentId"];
	[dict setObject:@"parentName" forKey:@"parentName"];
	[dict setObject:@"createdDate" forKey:@"createdDate"];
	[dict setObject:@"modifiedDate" forKey:@"modifiedDate"];
	[dict setObject:@"type" forKey:@"type"];
	[dict setObject:@"url" forKey:@"url"];
	[dict setObject:@"isEvent" forKey:@"event"];
	[dict setObject:@"isLikedByCurrentUser" forKey:@"isLikedByCurrentUser"];
	return [dict autorelease];  
} 

+ (NSDictionary*)elementToRelationshipMappings {  
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"body" forKey:@"body"];
	[dict setObject:@"user" forKey:@"user"];
	return [dict autorelease];  
} 

- (void)dealloc {
	[itemId release];
	[parentId release];
	[parentName release];
	[createdDate release];
	[modifiedDate release];
	[type release];
	[url release];
	[body release];
	[user release];
	
	[super dealloc];
}

@end
