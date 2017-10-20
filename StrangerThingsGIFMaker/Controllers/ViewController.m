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
    
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    
//    float Y_Co = self.view.frame.size.height - loginButton.frame.size.height;
//    [loginButton setFrame:CGRectMake(0.0, Y_Co, loginButton.frame.size.width, loginButton.frame.size.height)];
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
 
    
    [_textTextField addTarget:self action:@selector(checkTextField:) forControlEvents:UIControlEventEditingChanged];
    
    _textTextField.delegate = self;
    _gerarGIFButton.layer.cornerRadius = 4;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:YES];
    
}






#pragma mark - Generate GIF

- (IBAction)generateGIFButtonPressed:(id)sender {
    
    _gifGenerator = [[GIFGenerator alloc] init];
    _fileURL = [_gifGenerator generateGifFrom:_textTextField.text];
    
    [self performSegueWithIdentifier:@"exportGIFVCSegue" sender:nil];
    
}





#pragma mark - Navigation 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[ExportGIFViewController class]]){
        
        ExportGIFViewController *exportVC = segue.destinationViewController;
        exportVC.fileURL = _fileURL;
        
    }
    
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
        _gerarGIFButton.hidden = YES;
        
    }else{
        
        textField.textColor = [UIColor blackColor];
        _invalidoLabel.hidden = YES;
        _gerarGIFButton.hidden = NO;
        
    }
    
    
}




#pragma mark - TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [_textTextField resignFirstResponder];
    return YES;
}

@end
