//
//  NSWindowController+FLModalAdditions.h
//  FishLampOSX
//
//  Created by Mike Fullerton on 4/17/13.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//
#import "FishLamp.h"

@class FLResponderChainState;

@interface FLSheetHandler : NSResponder {
@private
    NSModalSession _modalSession;
    NSWindow* _modalWindow;
    NSWindow* _hostWindow;
    NSWindowController* _modalWindowController;
    BOOL _appModal;
    NSButton* _defaultButton;

    FLResponderChainState* _responderState;
}
@property (readwrite, strong, nonatomic) NSWindow* modalWindow;
@property (readwrite, strong, nonatomic) NSWindow* hostWindow;
@property (readwrite, strong, nonatomic) NSWindowController* modalWindowController;
@property (readwrite, strong, nonatomic) NSButton* defaultButton;
@property (readwrite, assign, nonatomic) BOOL appModal;

+ (id) sheetHandler;

- (void) beginSheet;
@end


@interface NSViewController (FLModalAdditions)

- (FLSheetHandler*) showModalWindow:(NSWindowController*) window 
       withDefaultButton:(NSButton*) button;

- (FLSheetHandler*) showModalWindow:(NSWindowController*) windowController;
@end

@interface NSWindow (FLModalAdditions)
- (IBAction) closeModalWindow:(id) sender;

- (FLSheetHandler*) showModalWindow:(NSWindowController*) modalWindow 
            withDefaultButton:(NSButton*) button;

- (FLSheetHandler*) showModalWindow:(NSWindowController*) modalWindow;

#if DEBUG
- (NSString*) stringFromResponderChain;
#endif

@end

@interface NSWindowController (FLModalAdditions)
- (NSButton*) closeModalWindowButton;
@end
