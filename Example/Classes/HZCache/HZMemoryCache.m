//
//  HZMemoryCache.m
//  HZWBDemo
//
//  Created by 韩政 on 2019/8/14.
//  Copyright © 2019 韩政. All rights reserved.

#import "HZMemoryCache.h"
#import <pthread.h>

@interface HZFileNode : NSObject{
    @package
    HZFileNode *pre;
    HZFileNode *next;
    NSString *key;
    id value;
}
@end

@implementation HZFileNode

@end


@interface HZLRU : NSObject

@property(nonatomic,assign) NSUInteger capacity;

@property(nonatomic,strong) HZFileNode *head;

@property(nonatomic,strong) HZFileNode *tail;

@property(nonatomic,strong) NSMutableDictionary<NSString *,HZFileNode *> *nodeMap;

- (id)get:(NSString *)key;

- (void)putkey:(NSString *)key forValue:(id)value;

@end


@implementation HZLRU{
    pthread_rwlock_t rwlock;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        pthread_rwlock_init(&(self->rwlock), NULL);
        self.capacity = 5;
        self.nodeMap = [NSMutableDictionary new];
        self.head = [HZFileNode new];
        self.tail = [HZFileNode new];
        self.head->next = self.tail;
        self.tail->pre = self.head;
    }
    return self;
}

- (void)moveToTail:(NSString *)key{
    HZFileNode *node = [self.nodeMap objectForKey:key];
    if(node){
        node->pre->next = node->next;
        node->next->pre = node->pre;
        node->pre = self.tail->pre;
        node->next = self.tail;
        self.tail->pre->next = node;
        self.tail->pre = node;
    }
}

- (id)get:(NSString *)key{
    pthread_rwlock_wrlock(&(self->rwlock));
    HZFileNode *node = [self.nodeMap objectForKey:key];
    if(node){
        [self moveToTail:key];
        return node->value;
    }
    pthread_rwlock_unlock(&(self->rwlock));
    return nil;
}

- (void)putkey:(NSString *)key forValue:(id)value{
    pthread_rwlock_wrlock(&(self->rwlock));
    HZFileNode *temp = [self.nodeMap objectForKey:key];
    if(temp){
        [self moveToTail:key];
        [self.nodeMap objectForKey:key]->value = value;
        
    }
    else{
        if([[self.nodeMap allKeys]count] >=self.capacity){
            self.head->next = self.head->next->next;
            self.head->next->pre = self.head;
            [self.nodeMap removeObjectForKey:self.head->next->key];
        }
        HZFileNode *node = [HZFileNode new];
        node->value = value;
        node->key = key;
        [self.nodeMap setObject:node forKey:node->key];
        node->pre = self.tail->pre;
        node->next = self.tail;
        self.tail->pre->next = node;
        self.tail->pre = node;
    }
    pthread_rwlock_unlock(&(self->rwlock));
}

@end

static HZMemoryCache *sharedCache;
@implementation HZMemoryCache{
    HZLRU * cachedIamge;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        cachedIamge = [HZLRU new];
    }
    return self;
}

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[self alloc]init];
    });
    return sharedCache;
}

- (id)getDataForKey:(NSString *)key{
    return [self->cachedIamge get:key];
}

- (void)getDataForKey:(NSString *)key completion:(void(^)(NSString *key, id data))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        id data = [self getDataForKey:key];
        completion(key, data);
    });
}

- (void)putData:(id)data withKey:(NSString *)key{
    [self->cachedIamge putkey:key forValue:data];
}

-(void)debug{
    HZFileNode *temp = self->cachedIamge.head->next;
    while(temp){
        //        NSLog(temp);
        temp = temp->next;
    }
}
@end
