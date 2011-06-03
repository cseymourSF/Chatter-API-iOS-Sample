//
//  ConfigController.m
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

#import "ConfigController.h"
#import "Authenticator.h"
#import "GTMOAuth2ViewControllerTouch.h"

@implementation ConfigController

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@synthesize secretField;
@synthesize clientIdField;
@synthesize baseUrlField;
@synthesize callbackUriField;

+ (ConfigController*)create {
	return [[[ConfigController alloc] init] autorelease];
}

- init {
	self = [super initWithNibName:@"SFConfigPhone" bundle:nil];
	
	if (self != nil) {
		animatedDistance = 0;
	}
	
	return self;
}

- (void)dealloc {
	[secretField release];
	[clientIdField release];
	[baseUrlField release];
	[callbackUriField release];
	
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[self.navigationItem setTitle:@"Config"];
	
	animatedDistance = 0;
	 
	// Fill in the config values.		
	[self.clientIdField setText:[Authenticator clientId]];
	[self.secretField setText:[Authenticator secret]];
	[self.callbackUriField setText:[Authenticator callbackUri]];
	[self.baseUrlField setText:[Authenticator baseUrl]];
}	 

- (void)saveConfig {
	// Save config.
	[Authenticator saveConfigWithClientId:[clientIdField text] secret:[secretField text] callbackUri:[callbackUriField text] baseUrl:[baseUrlField text]];
	NSLog(@"Saved config");
}

// =================
// Text field input

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	// From http://cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html
	
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
	
	CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
	CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
	CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
	CGFloat heightFraction = numerator / denominator;
	if (heightFraction < 0.0)
	{
        heightFraction = 0.0;
	}
	else if (heightFraction > 1.0)
	{
		heightFraction = 1.0;
	}
	
	UIInterfaceOrientation orientation =
	[[UIApplication sharedApplication] statusBarOrientation];
	if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
		animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
	}
	else {
		animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
	}
	
	CGRect viewFrame = self.view.frame;
	viewFrame.origin.y -= animatedDistance;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	
	[self.view setFrame:viewFrame];
	
	[UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self recenter];
	[self saveConfig];
}

- (void)recenter {
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
	
	animatedDistance = 0;
	
	// Clear the keyboard.
	[self.clientIdField resignFirstResponder];
	[self.callbackUriField resignFirstResponder];
	[self.secretField resignFirstResponder];
	[self.baseUrlField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
