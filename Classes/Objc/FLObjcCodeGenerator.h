//
//  FLObjcCodeGenerator.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLSynchronousOperation.h"
#import "FLCodeGenerator.h"

@interface FLObjcCodeGenerator : FLSynchronousOperation<FLCodeGenerator> {
@private
    id<FLCodeGeneratorProjectProvider> _projectProvider;
}

+ (id) objcCodeGenerator:(id<FLCodeGeneratorProjectProvider>) projectProvider;

@end



