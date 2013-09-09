//
//  FLObjcCodeGenerator.h
//  CodeGenerator
//
//  Created by Mike Fullerton on 2/3/13.
//  Copyright (c) 2013 Mike Fullerton. All rights reserved.
//

#import "FLCodeGenerator.h"
#import "FLAsyncMessageBroadcaster.h"

@interface FLObjcCodeGenerator : FLAsyncMessageBroadcaster<FLCodeGenerator> {
@private
}

+ (id) objcCodeGenerator;
@end



