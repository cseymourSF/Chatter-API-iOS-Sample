//
//  PostPhotoController.m
//  DemoApp
//
//  Created by Chris Seymour on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PostPhotoController.h"
#import "Config.h"

@implementation PostPhotoController

@synthesize imageView;
@synthesize usePhotoBtn;

- (id)init {
	NSString* nibName;
	//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
	//		nibName = @"UserPad";
	//	} else {
	nibName = @"PostPhotoPhone";
	//	}
	
	self = [super initWithNibName:nibName bundle:nil];
	
	if (self != nil) {		
		poster = [[UserPhotoPoster alloc] initWithUrl:[Config addVersionPrefix:@"/chatter/users/me/photo"]];
	}
	
	return self;
}

- (void)dealloc {
	[imageView release];
	[usePhotoBtn release];
	[poster release];
	
	[super dealloc];
}

- (void)resetUi {
	if (self.imageView.image != nil) {
		[usePhotoBtn setEnabled:YES];
		[usePhotoBtn setAlpha:1.0];
	} else {
		[usePhotoBtn setEnabled:NO];
		[usePhotoBtn setAlpha:0.5];
	}
}

- (void)viewDidAppear:(BOOL)animated {		
	[self resetUi];
	[super viewWillAppear:animated];
}

- (IBAction)takePhoto:(id)sender {
	UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	
	[self presentModalViewController: picker animated:YES];
}

- (IBAction)getLibraryPhoto:(id)sender {
	UIImagePickerController* picker = [[[UIImagePickerController alloc] init] autorelease];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	
	[self presentModalViewController:picker animated:YES];
}

- (IBAction)usePhoto:(id)sender {
	// Try to post the image!
	[poster startPostWithFilename:@"testFile" image:self.imageView.image];
	
	// Exit.
	[self.navigationController popViewControllerAnimated:YES];
}

// UIImagePickerControllerDelegate impl

-(void)imagePickerController:(UIImagePickerController *)picker
	  didFinishPickingImage : (UIImage *)image
				 editingInfo:(NSDictionary *)editingInfo {
	imageView.image = image;
	
	[picker dismissModalViewControllerAnimated:YES];
	
	[self resetUi];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {	
	[picker dismissModalViewControllerAnimated:YES];
}

@end
