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
    // Do any additional setup after loading the view.

    _photo = [PHPhotoLibrary sharedPhotoLibrary];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    _url = [defaults URLForKey:@"GIF_URL"];
    
    _displayGIFImageView.image = [UIImage animatedImageWithAnimatedGIFURL:_url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    
    NSLog(@"VIEW WILL DISAPPEAR");
    
    _url = nil;
    _displayGIFImageView = nil;
    _photo = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)requestAuthorizationWithRedirectionToSettings {
    dispatch_async(dispatch_get_main_queue(), ^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized)
        {
            //We have permission. Do whatever is needed
        }
        else
        {
            //No permission. Trying to normally request it
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status != PHAuthorizationStatusAuthorized)
                {
                    //User don't give us permission. Showing alert with redirection to settings
                    //Getting description string from info.plist file
                    NSString *accessDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSPhotoLibraryUsageDescription"];
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:accessDescription message:@"Para nos dar permissão aperte o botão 'Mudar Permissão' e autoriza o app o acesso." preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];
                    [alertController addAction:cancelAction];
                    
                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Mudar Permissão" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                    }];
                    [alertController addAction:settingsAction];
                    
//                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }
    });
}




#pragma mark - Share Buttons

//Facebook
- (IBAction)shareFacebookButton:(id)sender {
    
     NSData* gifData = [NSData dataWithContentsOfURL:_url];
    
    [FBSDKMessengerSharer shareAnimatedGIF:gifData withOptions:nil];
    
}


//SaveGIF
- (IBAction)saveGIFButton:(id)sender {
    
    if([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized){
        NSLog(@"Não autorizado");
        [self requestAuthorizationWithRedirectionToSettings];
    }else{
        NSLog(@"Autorizado!");
    
        [_photo performChanges:^{
            [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:_url];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"Sucesso!" message:@"GIF salva em Fotos." preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alerta dismissViewControllerAnimated:YES completion:nil];
                }];

                [alerta addAction:ok];
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
    }
    
}

//ShareMore
- (IBAction)shareMoreButton:(id)sender {
    
    NSString* message = @"Stranger Things GIF Maker";
    
    //UIImage* image = _displayGIFImageView.image;
    
    NSData* gif = [NSData dataWithContentsOfURL:_url];
    
    NSArray* shareItems = [NSArray arrayWithObjects: message, gif, nil];
    
    
    UIActivityViewController* avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    
    [self presentViewController:avc animated:YES completion:nil];
}
@end
