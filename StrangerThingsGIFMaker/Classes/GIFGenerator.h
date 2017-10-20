//
//  GIFGenerator.h
//  StrangerThingsGIFMaker
//
//  Created by Vitor Sousa on 19/10/2017.
//  Copyright © 2017 Vitor Sousa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageIO/ImageIO.h"
#import <MobileCoreServices/MobileCoreServices.h>

@import Photos;

@interface GIFGenerator : NSObject

@property NSString *textoGIF;
@property (strong, nonatomic) NSURL *fileURL;
@property NSMutableArray* listaImagemLetras;
@property UIImage* imagem;

@property NSString *kCGImagePropertyGIFDelayTime;
@property NSString *kCGImagePropertyGIFDictionary;

@property CGImageDestinationRef destination;

-(NSURL *) generateGifFrom:(NSString*)text;


@end
