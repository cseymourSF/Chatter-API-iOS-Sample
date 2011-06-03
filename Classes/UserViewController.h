//
//  UserController.h
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

#import <Foundation/Foundation.h>

#import "User.h"
#import "RKObjectLoader.h"
#import "ObjectFetcher.h"
#import "PhotoFetcher.h"

@interface UserViewController : UIViewController<ObjectFetcherDelegate, PhotoFetcherDelegate> {
	User* user;
	ObjectFetcher* userFetcher;
	PhotoFetcher* photoFetcher;
	
	UILabel* nameLbl;
	UILabel* locationLbl;
	UILabel* emailLbl;
	UILabel* aboutLbl;
	UILabel* titleLbl;
	UIImageView* imageView;
}

@property(nonatomic, retain) User* user;
@property(nonatomic, retain) ObjectFetcher* userFetcher;
@property(nonatomic, retain) PhotoFetcher* photoFetcher;

@property(nonatomic, retain) IBOutlet UILabel* nameLbl;
@property(nonatomic, retain) IBOutlet UILabel* locationLbl;
@property(nonatomic, retain) IBOutlet UILabel* emailLbl;
@property(nonatomic, retain) IBOutlet UILabel* aboutLbl;
@property(nonatomic, retain) IBOutlet UILabel* titleLbl;
@property(nonatomic, retain) IBOutlet UIImageView* imageView;

+ (UserViewController*)createWithUserId:(NSString*)userId;

- initWithUserId:(NSString*)inUserId;
- (IBAction)feedClick:(id)sender;
- (void)retrievalCompleted:(NSString*)tag image:(UIImage*)image;

@end
