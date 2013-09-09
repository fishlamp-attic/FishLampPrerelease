//
//  FLAppInfo.m
//  FishLamp
//
//  Created by Mike Fullerton on 11/28/12.
//  Copyright (c) 2013 GreenTongue Software LLC, Mike Fullerton. 
//  The FishLamp Framework is released under the MIT License: http://fishlamp.com/license 
//

#import "FLAppInfo.h"

@implementation FLAppInfo

static NSDictionary* s_infoDictionary = nil;

+ (void) setInfoDictionary:(NSDictionary*) dictionary {
    FLSetObjectWithRetain(s_infoDictionary, dictionary);
}

+ (NSBundle*) bundleForInfo {
    NSBundle* bundle = [NSBundle currentBundle];
    if(!bundle) {
        bundle = [NSBundle mainBundle];
    }
    return bundle;
}

+ (NSDictionary*) infoDictionary {
    return s_infoDictionary ? s_infoDictionary : [[self bundleForInfo] infoDictionary];
}

+ (id) objectForKey:(id) key {
    return [[self infoDictionary] objectForKey:key];
}

+ (NSString*) appVersion {
    static NSString* s_version = nil; 
	if(!s_version) {
        s_version = [self objectForKey:FLAppBundleInfoVersionKey];
        FLAssertNotNil(s_version);
	}

    return s_version;
}

+ (NSString*) appMarketingVersion {
    static NSString* s_version = nil; 
	if(!s_version) {
        s_version = [self objectForKey:FLAppBundleInfoShortVersionKey];
        FLAssertNotNil(s_version);
	}

    return s_version;
}

+ (NSString*) appName {
	static NSString* s_appName = nil;
	if(!s_appName) {
		s_appName = [self objectForKey:FLAppBundleInfoAppNameKey];
        FLAssertNotNil(s_appName);
	}

	return s_appName; 
}

+ (NSString*) bundleIdentifier {
	static NSString* s_identifier = nil;
	if(!s_identifier) {
		s_identifier = [self objectForKey:FLAppBundleInfoIdentifierKey];
        FLAssertNotNil(s_identifier);
	}

	return s_identifier; 
}

+ (void) setAppInfo:(NSString*) bundleIdentifier
            appName:(NSString*) appName
            version:(NSString*) version {
            
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
        bundleIdentifier, FLAppBundleInfoIdentifierKey,
        appName, FLAppBundleInfoAppNameKey,
        version, FLAppBundleInfoShortVersionKey,
        version, FLAppBundleInfoVersionKey,
        nil];
        
    [self setInfoDictionary:dict];
}            

+ (NSString*) appSpecificKey:(NSString*) key {
    return [key hasPrefix:[self bundleIdentifier]] ? key : [NSString stringWithFormat:@"%@.%@", [self bundleIdentifier], key];
}
+ (BOOL) isAppSpecificKey:(NSString*) key {
    return [key hasPrefix:[self bundleIdentifier]];
}


@end
