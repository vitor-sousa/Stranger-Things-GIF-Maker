//
//  ViewController.h
//  StrangerThingsGIFMaker
//
//  Created by Vitor Sousa on 01/08/16.
//  Copyright © 2016 Vitor Sousa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExportGIFViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GIFGenerator.h"


@interface ViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) NSURL *fileURL;

@property (strong, nonatomic) IBOutlet UITextField *textTextField;
@property (strong, nonatomic) IBOutlet UILabel *invalidoLabel;
@property (strong, nonatomic) IBOutlet UIButton *gerarGIFButton;

@property (strong, nonatomic) UIStoryboard *storeboard;
@property (strong, nonatomic) ExportGIFViewController *exportvc;

@property (strong, nonatomic) GIFGenerator *gifGenerator;


- (IBAction)generateGIFButtonPressed:(id)sender;

@end

