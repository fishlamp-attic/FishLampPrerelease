//
//	Debug.m
//	FishLamp
//
//	Created by Mike Fullerton on 5/23/09.
//	Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLDebug.h"

#import <execinfo.h>
#import <stdio.h>
#import <objc/runtime.h>

//#undef alloc
//#undef release
//#undef allocWithZone
//
//#if __FL_MEMORY_MONITOR
//#import "FLMemoryMonitor.h"
//#endif


//#if 0
//
//void init_state_if_needed(FLDebugTrackerState* state)
//{
//    if(state->history == nil)
//    {
//        state->history = [[NSMutableArray alloc] init];
//        state->retainCount = 1;
//    }
//}
//
//void add_msg_to_state(NSString* msg, FLDebugTrackerState* state)
//{
//    FLLog(msg);
//    [state->history addObject:[NSString stringWithFormat:@"%@: %@", msg, FLStackTrace_t()]];
//}
//
//void debug_retain(id object,  FLDebugTrackerState* state)
//{
//    init_state_if_needed(state);
//    FLAssertWithComment(!state->did_dealloc, @"dealloc already called for class: %@",  NSStringFromClass([object class]));
//    FLAssertWithComment(state->retainCount >= 1, @"retain count < 1"); 
//    add_msg_to_state([NSString stringWithFormat:@"retain: %d", state->retainCount++], state);
//}
//
//void debug_release(id object,  FLDebugTrackerState* state)
//{
//    init_state_if_needed(state);
//    FLAssertWithComment(!state->did_dealloc, @"dealloc already called for class: %@",  NSStringFromClass([object class]));
//    FLAssertWithComment(state->retainCount >= 1, @"retain count <= 1"); 
//    if(--state->retainCount == 0)
//    {
//        state->did_dealloc = YES;
//        add_msg_to_state([NSString stringWithFormat:@"dealloc %@", NSStringFromClass([object class])], state); 
//    }
//    else
//    {
//        add_msg_to_state([NSString stringWithFormat:@"release: %d", state->retainCount], state);
//    }
//}
//
//void debug_autorelease(id object,  FLDebugTrackerState* state)
//{
//    init_state_if_needed(state);
//    FLAssertWithComment(!state->did_dealloc, @"dealloc already called for class: %@",  NSStringFromClass([object class]));
//    FLAssertWithComment(state->retainCount >= 1, @"retain count <= 1 in autorelease"); 
//    add_msg_to_state([NSString stringWithFormat:@"auto-release: %d", state->retainCount], state);
//}
//
//void debug_print_history(id object, FLDebugTrackerState* state)
//{
//    NSMutableString* history = [NSString stringWithFormat:@"history for %@", NSStringFromClass([object class])];
//    
//    for(NSString* stack in state->history)
//    {
//        [history appendString:@"\n"];
//        [history appendString:stack];
//    }
//    
//    FLLog(history);
//}
//
//@implementation NSObject (FLLog)
//
//#if ALLOCATION_HOOKS
//
//static id<FLAllocationHookProtocol> s_hook = nil;
//
////
////- (oneway void) release
////{
////	  if(s_hook != nil)
////	  {
////		  [s_hook allocationHookRelease:self];
////	  }
////	  
////	  object_dispose(self);
////}
//
//+ (id<FLAllocationHookProtocol>) setAllocHook:(id<FLAllocationHookProtocol>) hook
//{
//	id<FLAllocationHookProtocol> old = s_hook;
//	s_hook = hook;
//	return old;
//}
//
//+ (id<FLAllocationHookProtocol>) allocationHook
//{
//	return s_hook;
//}
//
//+ (id) alloc
//{
//	id obj = [[self class] allocWithZone:NSDefaultMallocZone()];
//	return s_hook != nil ? [s_hook allocationHookAlloc:obj]: obj;
//}
//
//#endif
//
////- (NSMutableString*) debugDescription
////{
////	  return [NSMutableString stringWithString:[self description]];
////}
//
//@end
//
//#endif

