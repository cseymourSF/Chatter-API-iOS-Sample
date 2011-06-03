//
//  User.m
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

#import "User.h"
#import "RKObjectManager.h"

@implementation User

@synthesize about;
@synthesize email;
@synthesize managerId;
@synthesize managerName;
@synthesize url;
@synthesize address;

+ (NSDictionary*)elementToPropertyMappings {  
	NSMutableDictionary *dict = [UserSummary elementToPropertyMappingsMutable];
	[dict setObject:@"about" forKey:@"aboutMe"];
	[dict setObject:@"email" forKey:@"email"];
	[dict setObject:@"managerId" forKey:@"managerId"];
	[dict setObject:@"managerName" forKey:@"managerName"];
	[dict setObject:@"url" forKey:@"url"];
	return dict;  
}  

+ (NSDictionary*)elementToRelationshipMappings {
	NSMutableDictionary *dict = [UserSummary elementToRelationshipMappingsMutable];
	[dict setObject:@"address" forKey:@"address"];
	return dict;
}

- (void)dealloc {
	[about release];
	[email release];
	[managerId release];
	[managerName release];
	[url release];
	[address release];
	
	[super dealloc];
}

@end
