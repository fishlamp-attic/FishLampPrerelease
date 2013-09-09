//
//  FLCodeGeneratorOperation.h
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLSynchronousOperation.h"

@protocol FLCodeGenerator;
@protocol FLCodeGeneratorProjectProvider;

@interface FLCodeGeneratorOperation : FLSynchronousOperation {
@private
    id<FLCodeGenerator> _codeGenerator;
    id<FLCodeGeneratorProjectProvider> _projectProvider;
}

@property (readonly, strong, nonatomic) id<FLCodeGenerator> codeGenerator;
@property (readonly, strong, nonatomic) id<FLCodeGeneratorProjectProvider> projectProvider;


+ (id) codeGeneratorOperation:(id<FLCodeGenerator>) codeGenerator
              projectProvider:(id<FLCodeGeneratorProjectProvider>) provider;

@end
