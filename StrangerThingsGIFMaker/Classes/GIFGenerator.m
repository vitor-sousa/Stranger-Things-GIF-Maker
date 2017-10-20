//
//  GIFGenerator.m
//  StrangerThingsGIFMaker
//
//  Created by Vitor Sousa on 19/10/2017.
//  Copyright © 2017 Vitor Sousa. All rights reserved.
//

#import "GIFGenerator.h"

@implementation GIFGenerator

-(NSURL *) generateGifFrom:(NSString*)text{
    
    _textoGIF = text;

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
    _fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"stranger_things.gif"];


    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)_fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);



    for (UIImage *imagemLetra in _listaImagemLetras) {
        CGImageDestinationAddImage(destination, imagemLetra.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }


    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }


    CFRelease(destination);
    
    return _fileURL;
}
@end
