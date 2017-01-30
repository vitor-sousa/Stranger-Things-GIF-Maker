//
//  ExportGIFViewController.h
//  StrangerThingsGIFMaker
//
//  Created by Vitor Sousa on 04/09/16.
//  Copyright © 2016 Vitor Sousa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>

@import Photos;


@interface ExportGIFViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *buttonsView;
@property (strong, nonatomic) IBOutlet UIImageView *displayGIFImageView;
@property (strong, nonatomic) NSURL *fileURL;
@property PHPhotoLibrary *photo;


- (IBAction)shareFacebookButton:(id)sender;
- (IBAction)saveGIFButton:(id)sender;
- (IBAction)shareMoreButton:(id)sender;


@end
