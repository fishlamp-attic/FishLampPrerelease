//
//  FLCodeGeneratorOperation.m
//  FishLampCodeGenerator
//
//  Created by Mike Fullerton on 6/17/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeGeneratorOperation.h"
#import "FLCodeGenerator.h"
#import "FLCodeGeneratorProjectProvider.h"

@interface FLCodeGeneratorOperation ()
@property (readwrite, strong, nonatomic) id<FLCodeGenerator> codeGenerator;
@property (readwrite, strong, nonatomic) id<FLCodeGeneratorProjectProvider> projectProvider;
@end

@implementation FLCodeGeneratorOperation

@synthesize codeGenerator = _codeGenerator;
@synthesize projectProvider = _projectProvider;

- (id) initWithCodeGenerator:(id<FLCodeGenerator>) codeGenerator
             projectProvider:(id<FLCodeGeneratorProjectProvider>) provider {
	self = [super init];
	if(self) {
		self.codeGenerator = codeGenerator;
        self.projectProvider = provider;
	}
	return self;
}

+ (id) codeGeneratorOperation:(id<FLCodeGenerator>) codeGenerator
              projectProvider:(id<FLCodeGeneratorProjectProvider>) provider {
    return FLAutorelease([[[self class] alloc] initWithCodeGenerator:codeGenerator projectProvider:provider]);
}

- (FLPromisedResult) performSynchronously {

    FLCodeProject* project = nil;
    @try {
        project = [self.projectProvider readProjectForCodeGenerator:self.codeGenerator];

        [self.listeners notify:@selector(codeGenerator:generationWillBeginForProject:) withObject:self.codeGenerator withObject:project];

        [self.codeGenerator generateCodeForProject:project];

        [self.listeners notify:@selector(codeGenerator:generationDidFinishForProject:) withObject:self.codeGenerator withObject:project];

        return project;
    }
    @catch(NSException* ex) {
        [self.listeners notify:@selector(codeGenerator:generationDidFailForProject:withError:) withObject:self.codeGenerator withObject:project withObject:ex.error];
        @throw;
    }

    return nil;
}

#if FL_MRC
- (void)dealloc {
    [_projectProvider release];
    [_codeGenerator release];
	[super dealloc];
}
#endif

@end
