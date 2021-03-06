//
//  CHChatVIewModel.m
//  CHChatDemo
//
//  Created by Chasusson on 15/11/14.
//  Copyright © 2015年 Chausson. All rights reserved.
//


#import "CHChatViewModel.h"
#import "CHChatConfiguration.h"
#import "CHChatMessageViewModel.h"
#import "CHChatMessageVMFactory.h"
#import "CHMessageTextEvent.h"
#import "CHMessageReceiveEvent.h"
#import "XEBEventBus.h"
#import "XEBSubscriber.h"
#import "NSObject+KVOExtension.h"
#import "NSString+CHExtensions.h"

@interface CHChatViewModel ()<XEBSubscriber>

@end
@implementation CHChatViewModel{

    XEBEventBus* _eventBus;

    NSDate *_lastPlaySoundDate;
}
+ (NSArray<Class>*)handleableEventClasses {
    return @[[CHMessageReceiveEvent class]];
}
- (instancetype)initWithMessageHistroy:(NSArray <CHChatMessageViewModel *>*)histroyMessage
                         configuration:(CHChatConfiguration *)config{
    
    self = [super init];
    if (self) {
        _eventBus = [XEBEventBus defaultEventBus];
        [_eventBus registerSubscriber:self];
        _refreshName = @"CHCHAT_REFRESH_TABLEVIEW";
        _configuration = config;
        [self ch_registerForKVO:[NSArray arrayWithObjects:@"cellViewModels", nil]];
        self.cellViewModels = histroyMessage;
    }
    
    return self;
}
- (void)setUserId:(long long)userId{
    _userId = userId;
    _dataBase = [CHMessageDatabase databaseWithUserId:(int)userId];

}

- (void)onEvent:(CHMessageReceiveEvent *)event{
    if((event.item.receiveId == self.receiveId && event.item.receiveId != 0 ) || (event.item.groupId != 0 && event.item.groupId == self.groupId )){
        NSMutableArray *cellTempArray = [NSMutableArray arrayWithArray:[_cellViewModels copy]];
        event.item.owner?(event.item.avatar = self.userIcon):(event.item.avatar = (event.item.groupId == 0?self.receiverIcon:event.item.avatar));
        [event.item sortOutWithTime:[_cellViewModels lastObject]?[_cellViewModels lastObject].date:nil];
        event.item.hasRead = YES;
        [cellTempArray addObject:event.item];
        self.cellViewModels = [cellTempArray copy];
    }

}
#pragma mark - KVO

- (void)ch_ObserveValueForKey:(NSString *)key
                     ofObject:(id )obj
                       change:(NSDictionary *)change{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:key waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:key];
    }
}
- (void)updateUIForKeypath:(NSString *)keyPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:_refreshName object:nil];
}

- (void)dealloc{
    [self ch_unregisterFromKVO];
    [_eventBus unregisterSubscriber: self];
}

@end
