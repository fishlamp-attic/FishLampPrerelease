//
//  FLControlState.m
//  FishLampiOS
//
//  Created by Mike Fullerton on 6/3/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLControlState.h"

//@implementation FLControlState
//
//@synthesize controlStateMask = _controlState;
//@synthesize previousControlState = _previousControlState;
//@synthesize enabledControlStates = _enabledControlStates;
//
//- (id) init {
//    self = [super init]; 
//    if(self) {
//        _enabledControlStates = FLControlStateAll;
//    }
//    return self;
//}
//
//- (void) controlStateDidChange:(FLControlStateMask) changedState {
//    
//    if(_observers) {
//        for(NSValue* observer in _observers) {
//            [observer.nonretainedObjectValue controlStateDidChangeState:self changedState:changedState];
//        }
//    }
//}
//
//- (void) controlStateDidChangeState:(FLControlState*) state 
//                       changedState:(FLControlStateMask) changedState {
//    self.controlStateMask = state.controlStateMask;
//}
//
//#if FL_MRC
//- (void) dealloc {
//    FLRelease(_observers);
//    FLSuperDealloc();
//}
//#endif
//
//- (void) removeControlStateObserver:(id<FLControlStateObserver>) observer {
//    [_observers removeObject:[NSValue valueWithNonretainedObject:observer]];
//}
//
//- (void) addControlStateObserver:(id<FLControlStateObserver>) observer {
//    if(!_observers) {
//        _observers = [[NSMutableArray alloc] init];
//    }
//    
//    [_observers addObject:[NSValue valueWithNonretainedObject:observer]];
//}
//
//- (void) setControlState:(FLControlStateMask) state {
//    if( state != _controlState && FLTestBits(_enabledControlStates, state)) {
//        _previousControlState = _controlState;
//        _controlState = state;
//        [self controlStateDidChange:_controlState | _previousControlState];
//    }
//}
//
//- (BOOL) isHighlighted {
//	return FLTestBits(_controlState, FLControlStateHighlighted);
//}
//
//- (void) setHighlighted:(BOOL) highlighted {
//	FLSetOrClearBits(_controlState, FLControlStateHighlighted, highlighted);
//}
//
//- (BOOL) isSelected {
//    return FLTestBits(_controlState, FLControlStateSelected);
//}
//
//- (BOOL) isDoubleSelected {
//    return FLTestBits(_controlState, FLControlStateDoubleSelected);
//}
//
//- (void) setSelected:(BOOL) selected {
//    FLSetOrClearBits(_controlState, FLControlStateSelected, selected);
//}
//
//- (void) setDoubleSelected:(BOOL) selected {
//    FLSetOrClearBits(_controlState, FLControlStateSelected, selected);
//}
//
//- (BOOL) isDisabled {
//	return FLTestBits(_controlState, FLControlStateDisabled);
//}
//
//- (void) setDisabled:(BOOL) disabled {
//    FLSetOrClearBits(_controlState, FLControlStateDisabled, disabled);
//}
//
//
//@end
