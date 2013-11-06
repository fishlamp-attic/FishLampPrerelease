//
//  FLPredicate.m
//  FishLamp
//
//  Created by Mike Fullerton on 10/8/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLPredicate.h"

@interface FLAbstractPredicate ()

- (id) initWithLhs:(id<FLPredicate>) lhs rhs:(id<FLPredicate>) rhs;
@property (readwrite, strong, nonatomic) id<FLPredicate> lhs;
@property (readwrite, strong, nonatomic) id<FLPredicate> rhs;

@end

@implementation FLAbstractPredicate

@synthesize lhs = _lhs;
@synthesize rhs = _rhs;

- (id) initWithLhs:(id<FLPredicate>) lhs rhs:(id<FLPredicate>) rhs {
    self = [super init];
    if(self) {
        self.lhs = lhs;
        self.rhs = rhs;
    }
    return self;
}

- (BOOL) isSatisfiedByObject:(id) object {
    return YES;
}

- (id<FLPredicate>) andPredicate:(id<FLPredicate>) other {
    return [FLAndPredicate andPredicate:self rhs:other];
}

- (id<FLPredicate>) orPredicate:(id<FLPredicate>) other {
    return [FLOrPredicate orPredicate:self rhs:other];

}

- (id<FLPredicate>) noPredicate {
    return [FLNoPredicate noPredicate:self];
}

- (id<FLPredicate>) yesPredicate {
    return [FLYesPredicate yesPredicate:self];
}

#if FL_MRC
- (void) dealloc {
    [_lhs release];
    [_rhs release];
    [super dealloc];
}
#endif

@end

@implementation FLAndPredicate

+ (id) andPredicate:(id<FLPredicate>) lhs rhs:(id<FLPredicate>) rhs {
    return FLAutorelease([[[self class] alloc] initWithLhs:lhs rhs:rhs]);
}

- (BOOL) isSatisfiedByObject:(id) object {
    return [self.lhs isSatisfiedByObject:object] && [self.rhs isSatisfiedByObject:object];
}

@end

@implementation FLOrPredicate

+ (id) orPredicate:(id<FLPredicate>) lhs rhs:(id<FLPredicate>) rhs  {
    return FLAutorelease([[[self class] alloc] initWithLhs:lhs rhs:rhs]);
}

- (BOOL) isSatisfiedByObject:(id) object {
    return [self.lhs isSatisfiedByObject:object] || [self.rhs isSatisfiedByObject:object];
}

@end

@implementation FLNoPredicate

+ (id) noPredicate:(id<FLPredicate>) predicate {
    return FLAutorelease([[[self class] alloc] initWithLhs:predicate rhs:nil]);
}

- (BOOL) isSatisfiedByObject:(id) object {
    return ![self.lhs isSatisfiedByObject:object];
}

@end

@implementation FLYesPredicate

+ (id) yesPredicate:(id<FLPredicate>) predicate {
    return FLAutorelease([[[self class] alloc] initWithLhs:predicate rhs:nil]);
}

- (BOOL) isSatisfiedByObject:(id) object {
    return [self.lhs isSatisfiedByObject:object];
}

@end

@implementation FLNoDecision

+ (id) noDecision {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) isSatisfiedByObject:(id) object {
    return NO;
}

@end

@implementation FLYesDecision

+ (id) yesDecision {
    return FLAutorelease([[[self class] alloc] init]);
}

- (BOOL) isSatisfiedByObject:(id) object {
    return YES;
}

@end

@interface FLDecision ()
@property (readwrite, copy, nonatomic) FLPredicateDeciderBlock decider;
@end

@implementation FLDecision

@synthesize decider = _decider;

- (id) initWithDecider:(FLPredicateDeciderBlock) block {
    self = [super init];
    if(self) {
        self.decider = block;
    }
    return self;
}

+ (id) decision:(FLPredicateDeciderBlock) decider {
    return FLAutorelease([[[self class] alloc] initWithDecider:decider]);
}

#if FL_MRC
- (void) dealloc {
    [_decider release];
    [super dealloc];
}
#endif

- (BOOL) isSatisfiedByObject:(id) object {
    if(_decider) {
        return _decider(object);
    }
    
    return [super isSatisfiedByObject:object];
}

@end

