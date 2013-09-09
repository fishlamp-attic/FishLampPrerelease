//
//  FLDatabaseObjectStorage.m
//  FishLampCocoa
//
//  Created by Mike Fullerton on 4/1/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDatabaseStorageService.h"

@interface FLDatabaseStorageService ()
@property (readwrite, strong, nonatomic) FLObjectDatabaseController* databaseController;
@end

@implementation FLDatabaseStorageService

@synthesize databaseController = _databaseController;
@synthesize databaseFilePath = _databaseFilePath;

+ (id) databaseStorageService {
    return FLAutorelease([[[self class] alloc] init]);
}

- (id<FLObjectStorage>) objectStorage {
    return self.databaseController;
}

#if FL_MRC
- (void) dealloc {
    [_databaseController release];
    [super dealloc];
}
#endif

- (void) openSelf {

    [self.listeners.notify databaseStorageServiceWillOpen:self];

    NSString* databasePath = [self databaseFilePath];
    FLConfirmStringIsNotEmpty(databasePath);
    
    self.databaseController = [FLObjectDatabaseController  objectDatabaseController:databasePath];
    
    [self.databaseController dispatchAsync:^(FLObjectDatabase* database) {
        [database openDatabase];

        [self.listeners.notify databaseStorageServiceDidOpen:self];
    }
    completion:^(FLPromisedResult result) {
        if([result isError]) {
            FLLog(@"database error: %@", result)
        }
    }];
 }

- (void) closeSelf {
    [self.listeners.notify databaseStorageServiceWillClose:self];

    [self.databaseController dispatchAsync:^(FLObjectDatabase* database) {
        [database closeDatabase];
        [self.listeners.notify databaseStorageServiceDidClose:self];
    }
    completion:^(FLPromisedResult result) {
        if([result isError]) {
            FLLog(@"database error: %@", result)
        }
    }];

}


@end
