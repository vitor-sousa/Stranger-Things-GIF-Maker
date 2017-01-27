//
//  ViewController.h
//  StrangerThingsGIFMaker
//
//  Created by Vitor Sousa on 01/08/16.
//  Copyright © 2016 Vitor Sousa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageIO/ImageIO.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ExportGIFViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@import Photos;

@interface ViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *textTextField;
@property (weak, nonatomic) IBOutlet UILabel *invalidoLabel;
@property (weak, nonatomic) IBOutlet UIButton *gerarGIFButtonLabel;

@property (weak, nonatomic) UIStoryboard *storeboard;
@property (weak, nonatomic) ExportGIFViewController *exportvc;

@property NSString *textoGIF;
@property NSMutableArray* listaImagemLetras;
@property UIImage* imagem;

@property NSString *kCGImagePropertyGIFDelayTime;
@property NSString *kCGImagePropertyGIFDictionary;

@property CGImageDestinationRef destination;


- (IBAction)generateGIFButton:(id)sender;

@end

