//
//  MessageSegment.m
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

#import "MessageSegment.h"


@implementation MessageSegment

@synthesize type;
@synthesize text;
@synthesize name;
@synthesize tag;
@synthesize url;
@synthesize user;

+ (NSDictionary*)elementToPropertyMappings {  
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"type" forKey:@"type"];
	[dict setObject:@"text" forKey:@"text"];
	[dict setObject:@"name" forKey:@"name"];
	[dict setObject:@"tag" forKey:@"tag"];
	[dict setObject:@"url" forKey:@"url"];
	return [dict autorelease];  
} 

+ (NSDictionary*)elementToRelationshipMappings {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"user" forKey:@"user"];
	return [dict autorelease];
}

- (void)dealloc {
	[type release];
	[text release];
	[name release];
	[tag release];
	[url release];
	[user release];
	
	[super dealloc];
}

@end
