//
//  ViewController.m
//  StrangerThingsGIFMaker
//
//  Created by Vitor Sousa on 01/08/16.
//  Copyright © 2016 Vitor Sousa. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
 
    
    [_textTextField addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    
    NSLog(@"VIEW WILL DISAPPEAR");
    
    _textoGIF = nil;
    _listaImagemLetras = nil;
    _imagem = nil;
    _kCGImagePropertyGIFDelayTime = nil;
    _kCGImagePropertyGIFDictionary = nil;
    _destination = nil;
    
    _textTextField = nil;
    _invalidoLabel = nil;
    _gerarGIFButtonLabel = nil;
    
}

- (IBAction)generateGIFButton:(id)sender {
    
    [self makeAnimatedGif];
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:YES];
}

#pragma mark - Generate GIF

- (void)makeAnimatedGif {
        
    _textoGIF = _textTextField.text;
    
    NSData* data = [_textoGIF dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    _textoGIF = [[NSString alloc] initWithData: data encoding:NSASCIIStringEncoding];
    

    
    NSMutableArray *lista_letras = [NSMutableArray array];
    for (int i = 0; i < [_textoGIF length]; i++) {
        NSString *ch = [_textoGIF substringWithRange:NSMakeRange(i, 1)];
        [lista_letras addObject:ch];
    }
    
    
    _listaImagemLetras = [[NSMutableArray alloc] init];
    
    
    NSUInteger kFrameCount = lista_letras.count + 3;
    
    for (NSString *letra in lista_letras){
        
        NSString* frase = [NSString stringWithFormat:@"letter_%@", letra.uppercaseString];
        
        _imagem = [UIImage imageNamed:frase];
        
        [_listaImagemLetras addObject:_imagem];

    }

    
    for(int i = 0; i <= 2; i ++){
        _imagem = [UIImage imageNamed:@"letter_ "];
        [_listaImagemLetras addObject:_imagem];
    }

    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @0.95f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"stranger_things.gif"];
    
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    


    for (UIImage *imagemLetra in _listaImagemLetras) {
        CGImageDestinationAddImage(destination, imagemLetra.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setURL:fileURL forKey:@"GIF_URL"];
    [defaults synchronize];
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);

    NSLog(@"url=%@", fileURL);
    
    //[self performSegueWithIdentifier:@"exportGif" sender:nil];
    
    _storeboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    _exportvc = [_storeboard instantiateViewControllerWithIdentifier:@"ExportGIFVC"];
        
    [self presentViewController:_exportvc animated:true completion:nil];
    
}

#pragma mark - Check TextField

- (void)checkTextField:(id)sender{
    
    UITextField *textField = (UITextField *)sender;
    
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@" AÃÂÁÂBCÇDEÉÊFGHÍÎIJKLMNOÓÕPQRSTÚÛUVWXYZaãáâbcçdeéêfghiîéjklmnoóöõpqrstuúüvwxyz"];
    
    validChars = [validChars invertedSet];
    
    NSRange range = [textField.text rangeOfCharacterFromSet:validChars];
    
    if (NSNotFound != range.location) {
        
        textField.textColor = [UIColor redColor];
        _invalidoLabel.hidden = NO;
        _gerarGIFButtonLabel.hidden = YES;
        
    }else{
        
        textField.textColor = [UIColor blackColor];
        _invalidoLabel.hidden = YES;
        _gerarGIFButtonLabel.hidden = NO;
    }
    
}

@end
