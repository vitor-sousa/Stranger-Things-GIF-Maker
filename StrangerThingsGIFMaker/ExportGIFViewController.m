//
//  ExportGIFViewController.m
//  StrangerThingsGIFMaker
//
//  Created by Vitor Sousa on 04/09/16.
//  Copyright © 2016 Vitor Sousa. All rights reserved.
//

#import "ExportGIFViewController.h"
#import "UIImage+animatedGIF.h"

@interface ExportGIFViewController ()

@end

@implementation ExportGIFViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _photo = [PHPhotoLibrary sharedPhotoLibrary];
    
    _displayGIFImageView.image = [UIImage animatedImageWithAnimatedGIFURL:_fileURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.988 green:0.165 blue:0.110 alpha:1.00];
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"Compartilhar";
    
}



#pragma mark - Request Authorization Method

- (void)requestAuthorizationWithRedirectionToSettings {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusAuthorized) {
            //We have permission. Do whatever is needed
        
        }else{
            
            //No permission. Trying to normally request it
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status != PHAuthorizationStatusAuthorized)
                {
                    //User don't give us permission. Showing alert with redirection to settings
                    //Getting description string from info.plist file
                    
                    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:accessDescription message:@"Para nos dar permissão aperte o botão 'Mudar Permissão', autoriza o acesso ao app e tente novamente." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Mudar Permissão" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    
                    [alertController addAction:settingsAction];

                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }
        
    });
    
    
}






#pragma mark - Share Buttons

//Facebook
- (IBAction)shareFacebookButton:(id)sender {
    
     NSData* gifData = [NSData dataWithContentsOfURL:_fileURL];

    [FBSDKMessengerSharer shareAnimatedGIF:gifData withOptions:nil];
    
}




//SaveGIF
- (IBAction)saveGIFButton:(id)sender {
    
    if([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized){
        
        NSLog(@"Não autorizado");
        [self requestAuthorizationWithRedirectionToSettings];
        
    }else{
        
        NSLog(@"Autorizado!");
    
        UIAlertController *pending = [UIAlertController alertControllerWithTitle:nil
                                                                         message:@"Por favor, aguarde...\n\n"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.color = [UIColor blackColor];
        indicator.translatesAutoresizingMaskIntoConstraints=NO;
        [pending.view addSubview:indicator];
        
        NSDictionary * views = @{@"pending" : pending.view, @"indicator" : indicator};
        
        NSArray * constraintsVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[indicator]-(20)-|" options:0 metrics:nil views:views];
        NSArray * constraintsHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[indicator]|" options:0 metrics:nil views:views];
        NSArray * constraints = [constraintsVertical arrayByAddingObjectsFromArray:constraintsHorizontal];
        
        [pending.view addConstraints:constraints];
        [indicator setUserInteractionEnabled:NO];
        [indicator startAnimating];
        
        [self presentViewController:pending animated:YES completion:nil];
        
        
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [_photo performChanges:^{
                [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:_fileURL];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if(success){
                    
                    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Sucesso!" message:@"Salvo com sucesso." preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [alerta dismissViewControllerAnimated:YES completion:nil];
                    }];

                    [alerta addAction:ok];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];

                    
                    [self presentViewController:alerta animated:YES completion:nil];


                }else{
                    
                    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Erro!" message:@"Erro. Tente novamente, por favor!" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [alerta dismissViewControllerAnimated:YES completion:nil];
                    }];

                    [alerta addAction:ok];
                    
                    [self presentViewController:alerta animated:YES completion:nil];
                
                }
                
            }];
            
        });
        
        
    }
    
    
}



//ShareMore
- (IBAction)shareMoreButton:(id)sender {
    
    NSString* message = @"Stranger Things GIF Maker";
    NSData* gif = [NSData dataWithContentsOfURL:_fileURL];
    
    NSArray* shareItems = [NSArray arrayWithObjects: message, gif, nil];
    
    
    UIActivityViewController* avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    [self presentViewController:avc animated:YES completion:nil];
}

@end
