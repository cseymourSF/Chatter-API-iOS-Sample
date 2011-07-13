//
//  OAuthViewController.h
//  DemoApp
//
//  Created by Chris Seymour on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface OAuthViewController : UIViewController<UIWebViewDelegate> {
	UIWebView* webView;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;

@end
