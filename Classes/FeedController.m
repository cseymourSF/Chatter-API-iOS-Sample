//
//  FeedController.m
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

#import "FeedController.h"
#import "FeedItem.h"
#import "MessageSegment.h"

#import "WebViewController.h"
#import "UserViewController.h"

@implementation FeedController

@synthesize feedFetcher;
@synthesize feedTable;
@synthesize feedPage;
@synthesize navController;

- (id)init {
	self = [super init];	
	if (self != nil) {
		segmentActions = [[NSMutableDictionary alloc] init];		
	}
	return self;
}

- (void)dealloc {
	[feedPage release];
	[feedFetcher release];
	[segmentActions release];
	[navController release];
	
	[super dealloc];
}

- (void)fetchWithNavController:(UINavigationController*)navControllerIn page:(FeedItemPage*)pageIn {
	self.feedPage = pageIn;
	self.navController = navControllerIn;
	
	self.feedFetcher = [[ObjectFetcher alloc] initWithTag:@"feed" object:self.feedPage delegate:self];
	[self.feedFetcher fetch];
}

- (IBAction)onSegmentClick:(id)sender {
	UIView* viewSender = (UIView*)sender;
	int tag = [viewSender tag];
	
	UIViewController* viewController;
	NSString* actionId = [segmentActions objectForKey:[NSNumber numberWithInt:tag]];
	
	if ([actionId hasPrefix:@"link:"]) {
		NSString* url = [actionId substringFromIndex:[@"link:" length]];
		viewController = [[[WebViewController alloc] initWithUrl:url] autorelease];
	} else if ([actionId hasPrefix:@"mention:"]) {
		NSString* userId = [actionId substringFromIndex:[@"mention:" length]];
		viewController = [UserViewController createWithUserId:userId];
	}
	
	if (viewController != nil) {
		[self.navController pushViewController:viewController animated:YES];
	}
}

// ================
// ObjectFetcherDelegate implementation

- (void)retrievalCompleted:(NSString*)tag withSuccess:(bool)succeeded {
	// Reset state.
	self.feedFetcher = nil;
	[segmentActions removeAllObjects];
		
	if (succeeded) {				
		// Reload the table view UI, now that we have feed data to populate it.
		[self.feedTable reloadData];
	} else {
		NSLog(@"Retrieval of feed failed");
	}
}

// ================
// UITableViewDataSource implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.feedPage.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
    }
	
	FeedItem* feedItem = [self.feedPage.items objectAtIndex:indexPath.row];	
	
	// Add feed item text.
	UIView* content = [cell contentView];
	int xOffset = 0;
	
	// TODO: Put mention adding into shared function.
	UIFont* authorFont = [UIFont boldSystemFontOfSize:12];
	CGSize stringsize = [[[feedItem author] name] sizeWithFont:authorFont];
	UIButton* authorBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[authorBtn setTitle:[[feedItem author] name] forState:UIControlStateNormal];
	authorBtn.frame = CGRectMake(xOffset, 0, stringsize.width + 5, 22);
	[authorBtn titleLabel].font = authorFont;
	
	int actionIndex = [segmentActions count];
	authorBtn.tag = actionIndex;
	
	[segmentActions setObject:[NSString stringWithFormat:@"mention:%@", [[feedItem author] userId]] forKey:[NSNumber numberWithInt:actionIndex]];
	[authorBtn addTarget:self action:@selector(onSegmentClick:) forControlEvents:UIControlEventTouchDown];
	
	[content addSubview:authorBtn];
	
	xOffset += stringsize.width + 5;
	
	// Add segments.
	CGFloat maxWidth = [cell bounds].size.width;
	int rowHeight = 22;
	int yOffset = 0;
	UIFont* font = [UIFont systemFontOfSize:12];
	for (int i = 0; i < [[[feedItem body] messageSegments] count]; i++) {
		MessageSegment* segment = (MessageSegment*)[[[feedItem body] messageSegments] objectAtIndex:i];
		
		int segWidth = 0;
		UIView* subView = nil;
		
		if ([[segment type] compare:@"Link"] == NSOrderedSame) {
			segWidth = [[segment text] sizeWithFont:font].width + 5;
			UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[btn setTitle:[segment text] forState:UIControlStateNormal];
			btn.frame = CGRectMake(xOffset, yOffset, segWidth, rowHeight);
			[btn titleLabel].font = font;
			
			actionIndex = [segmentActions count];
			btn.tag = actionIndex;
			
			[segmentActions setObject:[NSString stringWithFormat:@"link:%@", [segment url]] forKey:[NSNumber numberWithInt:actionIndex]];
			[btn addTarget:self action:@selector(onSegmentClick:) forControlEvents:UIControlEventTouchDown];
			
			subView = btn;
		} else if ([[segment type] compare:@"Mention"] == NSOrderedSame) {
			segWidth = [[segment name] sizeWithFont:font].width + 5;
			UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[btn setTitle:[segment name] forState:UIControlStateNormal];
			btn.frame = CGRectMake(xOffset, yOffset, segWidth, rowHeight);
			[btn titleLabel].font = font;
			
			actionIndex = [segmentActions count];
			btn.tag = actionIndex;
			
			[segmentActions setObject:[NSString stringWithFormat:@"mention:%@", [[segment user] userId]] forKey:[NSNumber numberWithInt:actionIndex]];
			[btn addTarget:self action:@selector(onSegmentClick:) forControlEvents:UIControlEventTouchDown];
			
			subView = btn;
		}
		else if ([[segment type] compare:@"FieldChange"] != NSOrderedSame) {
			// Don't render field changes for now... they take up too many lines and we are not
			// yet able to support varying cell heights. The delegate height call takes place BEFORE
			// this call (ugh!).
			segWidth = [[segment text] sizeWithFont:font].width;
			UILabel* lbl = [[[UILabel alloc] initWithFrame:CGRectMake(xOffset, yOffset, segWidth, rowHeight)] autorelease];
			lbl.text = [segment text];
			lbl.font = font;
			
			subView = lbl;
		}
		
		if (subView != nil) {
			xOffset += segWidth;
			
			if (xOffset > maxWidth) {
				// Render in next row.
				// TODO: Add string-splitting support.
				yOffset += rowHeight;
				subView.frame = CGRectMake(0, yOffset, segWidth, rowHeight);
				xOffset = segWidth;
			}
			
			[content addSubview:subView];
		}
	}
	
	//	CGRect oldFrame = cell.frame;
	//	NSLog(@"Old cell height: %.0f", oldFrame.size.height);
	//	cell.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, oldFrame.size.width, yOffset + rowHeight);
	//	NSLog(@"New cell height: %.0f", cell.frame.size.height);
	return cell;
}

@end
