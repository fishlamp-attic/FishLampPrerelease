//
//  FLObjcCodeGenerator.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeGenerator.h"
#import "FLObjcCodeGeneratorHeaders.h"

@implementation FLObjcCodeGenerator

+ (id) objcCodeGenerator {
    return FLAutorelease([[[self class] alloc] init]);
}

- (void) generateCodeForProject:(FLCodeProject*) inputProject {
    FLObjcProject* project = [FLObjcProject objcProject];
    [project configureWithProjectInput:inputProject];
    [project.fileManager writeFilesToDisk:self];
}

@end


