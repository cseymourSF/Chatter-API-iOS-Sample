//
//  FeedItem.h
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

#import "RKObject.h"
#import "FeedBody.h"
#import "UserSummary.h"

@interface FeedItem : RKObject {
	NSString* itemId;
	NSString* parentId;
	NSString* parentName;
	NSString* createdDate;
	NSString* modifiedDate;
	NSString* type;
	NSString* url;
	
	bool isEvent;
	bool isLikedByCurrentUser;
	FeedBody* body;
	UserSummary* user;
}

@property(nonatomic, retain) NSString* itemId;
@property(nonatomic, retain) NSString* parentId;
@property(nonatomic, retain) NSString* parentName;
@property(nonatomic, retain) NSString* createdDate;
@property(nonatomic, retain) NSString* modifiedDate;
@property(nonatomic, retain) NSString* type;
@property(nonatomic, retain) NSString* url;

@property(nonatomic, retain) FeedBody* body;
@property(nonatomic, retain) UserSummary* user;

@end
