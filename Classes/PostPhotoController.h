//
//  PostPhotoController.h
//  DemoApp
//
//  Created by Chris Seymour on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UserPhotoPoster.h"

@interface PostPhotoController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
	UIImageView* imageView;
	UIButton* usePhotoBtn;
	
	UserPhotoPoster* poster;
}

-(id)init;
- (IBAction)takePhoto:(id)sender;
- (IBAction)getLibraryPhoto:(id)sender;
- (IBAction)usePhoto:(id)sender;

@property(nonatomic, retain) IBOutlet UIImageView* imageView;
@property(nonatomic, retain) IBOutlet UIButton* usePhotoBtn;

@end
