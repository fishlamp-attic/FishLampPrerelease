//
//  FLObjcCodeGenerator.m
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLObjcCodeGenerator.h"
#import "FLObjcCodeGeneratorHeaders.h"
#import "FLCodeGeneratorProjectProvider.h"

@implementation FLObjcCodeGenerator

- (id) initWithProjectProvider:(id<FLCodeGeneratorProjectProvider>) projectProvider {
	self = [super init];
	if(self) {
		_projectProvider = FLRetain(projectProvider);
        FLAssertNotNil(_projectProvider);
	}
	return self;
}

- (id) init {	
    return [self initWithProjectProvider:nil];
}

+ (id) objcCodeGenerator:(id<FLCodeGeneratorProjectProvider>) projectProvider {
    return FLAutorelease([[[self class] alloc] initWithProjectProvider:projectProvider]);
}

#if FL_MRC
- (void)dealloc {
	[_projectProvider release];
	[super dealloc];
}
#endif

- (void) generateCode {

    FLCodeProject* inputProject = nil;

    @try {
        FLAssertNotNil(_projectProvider);

        inputProject = [_projectProvider readProjectForCodeGenerator:self];
        FLAssertNotNil(inputProject);

        [self.observers notify:@selector(codeGenerator:generationWillBeginForProject:)
                    withObject:self
                    withObject:inputProject];

        FLObjcProject* project = [FLObjcProject objcProject];
        [project configureWithProjectInput:inputProject];
        [project.fileManager writeFilesToDisk:self];

        [self.observers notify:@selector(codeGenerator:generationDidFinishForProject:)
                    withObject:self
                    withObject:inputProject];
    }
    @catch(NSException* ex) {
        [self.observers notify:@selector(codeGenerator:generationDidFailForProject:withError:)
                    withObject:self
                    withObject:inputProject
                    withObject:ex.error];
        @throw;
        
    }
}

- (FLPromisedResult) performSynchronously {
    [self generateCode];
    return FLSuccess;
}

@end


