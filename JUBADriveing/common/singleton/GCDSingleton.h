//
//  GCDSingleton.h
//  ciwenKids
//
//  Created by ciwenkids on 14-3-26.
//  Copyright (c) 2014年 xhb. All rights reserved.
//

#ifndef ciwenKids_GCDSingleton_h
#define ciwenKids_GCDSingleton_h

#ifndef SINGLETON_GCD
#define SINGLETON_GCD(classname)                        \
+ (classname *)shared##classname {                      \
static dispatch_once_t pred;                            \
__strong static classname *shared##classname = nil;     \
dispatch_once(&pred, ^{                                 \
shared##classname = [[self alloc] init];                \
});                                                     \
return shared##classname;                               \
}
#endif

#endif
