//
//  DemoAppViewController.h
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

#import "OAuthViewController.h"
#import "User.h"
#import "PhotoFetcher.h"
#import "AuthContext.h"

@interface DemoAppViewController : UIViewController<RKObjectLoaderDelegate, PhotoFetcherDelegate, AccessTokenRefreshDelegate> {
	UIButton* exploreBtn;
	UILabel* stateLbl;
	UILabel* nameLbl;
	UILabel* titleLbl;
	UIImageView* picView;
	UIView* infoView;
	
	User* user;
	PhotoFetcher* photoFetcher;
}

@property (nonatomic, retain) IBOutlet UIButton* exploreBtn;
@property (nonatomic, retain) IBOutlet UILabel* stateLbl;
@property (nonatomic, retain) IBOutlet UILabel* nameLbl;
@property (nonatomic, retain) IBOutlet UILabel* titleLbl;
@property (nonatomic, retain) IBOutlet UIImageView* picView;
@property (nonatomic, retain) IBOutlet UIView* infoView;

- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)explore:(id)sender;

@end
