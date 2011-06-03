//
//  UserSummary.m
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

#import "UserSummary.h"
#import "RKObjectManager.h"

@implementation UserSummary

@synthesize userId;
@synthesize firstName;
@synthesize lastName;
@synthesize name;
@synthesize title;
@synthesize photo;

+ (NSDictionary*)elementToPropertyMappings {  
	return [UserSummary elementToPropertyMappingsMutable];
}

+ (NSMutableDictionary*)elementToPropertyMappingsMutable {  
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"userId" forKey:@"id"];
	[dict setObject:@"firstName" forKey:@"firstName"];
	[dict setObject:@"lastName" forKey:@"lastName"];
	[dict setObject:@"name" forKey:@"name"];
	[dict setObject:@"title" forKey:@"title"];
	return [dict autorelease];  
}  

+ (NSDictionary*)elementToRelationshipMappings {
	return [UserSummary elementToRelationshipMappingsMutable];
}

+ (NSMutableDictionary*)elementToRelationshipMappingsMutable {
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	[dict setObject:@"photo" forKey:@"photo"];
	return [dict autorelease];
}

- (void)dealloc {
	[userId release];
	[firstName release];
	[lastName release];
	[name release];
	[title release];
	[photo release];
	
	[super dealloc];
}

@end
