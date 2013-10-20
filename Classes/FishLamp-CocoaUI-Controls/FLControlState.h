//
//  FLControlState.h
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaUIRequired.h"

// TODO: simplify this


typedef enum {
    FLControlStateNormal                =   0,                       
    FLControlStateHighlighted           =   UIControlStateHighlighted,                  
    FLControlStateDisabled              =   UIControlStateDisabled,
    FLControlStateSelected              =   UIControlStateSelected,                  
    FLControlStateDoubleSelected        =   (1 << 3), // user clicks on an already selected item.                  

    FLControlStateAll                   =   FLControlStateHighlighted | 
                                            FLControlStateDisabled | 
                                            FLControlStateSelected |
                                            FLControlStateDoubleSelected
} FLControlState;
//typedef NSUInteger FLControlStateMask;

//typedef struct {
//    unsigned int isHidden : 1;
//    unsigned int isHighlighted: 1;
//    unsigned int isDisabled: 1;
//    unsigned int isSelected: 1;
//    unsigned int isDoubleSelected: 1;
//} FLControlState;

//@class FLControlState;
//
//@protocol FLControlStateObserver <NSObject>
//- (void) controlStateDidChangeState:(FLControlState*) state 
//                       changedState:(FLControlStateMask) changedState;
//@end

//@interface FLControlState : NSObject<FLControlStateObserver> {
//@private
//    FLControlStateMask _controlState;
//    FLControlStateMask _previousControlState;
//    FLControlStateMask _enabledControlStates;
//    NSMutableArray* _observers;
//}
//
//@property (readwrite, assign, nonatomic) FLControlStateMask enabledControlStates; // FLFrameAll by default
//
//@property (readonly, assign, nonatomic) FLControlStateMask previousControlState;
//
//@property (readwrite, assign, nonatomic) FLControlStateMask controlStateMask;
//
//@property (readwrite, assign, nonatomic, getter=isSelected) BOOL selected;
//
//@property (readwrite, assign, nonatomic, getter=isDoubleSelected) BOOL doubleSelected;
//
//@property (readwrite, assign, nonatomic, getter=isHighlighted) BOOL highlighted; 
//
//@property (readwrite, assign, nonatomic, getter=isDisabled) BOOL disabled; 
//
//- (void) controlStateDidChange:(FLControlStateMask) changedState;
//
//// NOT RETAINED
//- (void) addControlStateObserver:(id<FLControlStateObserver>) observer;
//- (void) removeControlStateObserver:(id<FLControlStateObserver>) observer;
//
//@end
