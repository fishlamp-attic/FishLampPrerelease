//
//  FLPredicate.h
//  FishLamp
//
//  Created by Mike Fullerton on 10/8/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLCocoaRequired.h"

@protocol FLPredicate <NSObject>
- (BOOL) isSatisfiedByObject:(id) object;

- (id<FLPredicate>) andPredicate:(id<FLPredicate>) rhs;
- (id<FLPredicate>) orPredicate:(id<FLPredicate>) rhs;
- (id<FLPredicate>) noPredicate;
- (id<FLPredicate>) yesPredicate;
@end


@interface FLAbstractPredicate : NSObject<FLPredicate> {
@private
    id<FLPredicate> _lhs;
    id<FLPredicate> _rhs;
}
@end

@interface FLAndPredicate : FLAbstractPredicate {
}

+ (id) andPredicate:(id<FLPredicate>) first rhs:(id<FLPredicate>) rhs;

@end

@interface FLOrPredicate : FLAbstractPredicate {
}

+ (id) orPredicate:(id<FLPredicate>) first rhs:(id<FLPredicate>) rhs;

@end

@interface FLNoPredicate : FLAbstractPredicate {
}
+ (id) noPredicate:(id<FLPredicate>) predicate;

@end

@interface FLYesPredicate : FLAbstractPredicate {
}

+ (id) yesPredicate:(id<FLPredicate>) predicate;

@end

@interface FLNoDecision : FLAbstractPredicate {
}

+ (id) noDecision;

@end

@interface FLYesDecision : FLAbstractPredicate {
}

+ (id) yesDecision;

@end

typedef BOOL (^FLPredicateDeciderBlock)(id object);

@interface FLDecision : FLAbstractPredicate {
@private
    FLPredicateDeciderBlock _decider;
}

@property (readonly, copy, nonatomic) FLPredicateDeciderBlock decider;

- (id) initWithDecider:(FLPredicateDeciderBlock) predicate;
+ (id) decision:(FLPredicateDeciderBlock) decider;
@end
