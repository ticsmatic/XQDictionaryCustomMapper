//
//  NSMutableDictionary+HHAdd.m
//  ticsmatic
//
//  Created by ticsmatic on 2019/11/20.
//  Copyright © 2019 ticsmatic. All rights reserved.
//

#import "NSMutableDictionary+XQAdd.h"

@implementation NSObject (XQAdd)

+ (NSDictionary *)xq_customMapperWithJSON:(id)json {
    NSDictionary *dic = [self _xq_dictionaryWithJSON:json];
    if (!dic) return nil;
    
    Class cls = self;
    if ([cls respondsToSelector:@selector(dictionaryCustomMapper)]) {
        NSDictionary *customMapper = [(id <XQDictionaryCustomMapper>)cls dictionaryCustomMapper];
        NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [mDic xq_customMapper:customMapper];
        dic = mDic.copy;
    }
    return dic;
}

+ (NSDictionary *)_xq_dictionaryWithJSON:(id)json {
    if (!json || json == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSDictionary class]]) {
        dic = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

@end

@implementation NSMutableDictionary (XQAdd)

- (void)xq_customMapper:(NSDictionary *)customMapper {
    if (!customMapper || customMapper.allKeys.count == 0) return;
    
    for (NSString *key in customMapper.allKeys) {
        if ([key containsString:@"["] || [key containsString:@"."]) {
            [self allCollectionValuesToMutable]; break;
        }
    }
    
    [customMapper enumerateKeysAndObjectsUsingBlock:^(NSString *key, id oldKey, BOOL *stop) {
        if ([oldKey isKindOfClass:[NSString class]]) {
            [self setValueForKey:key withOldNodeKey:oldKey];
        } else if ([oldKey isKindOfClass:[NSArray class]]) {
            NSArray *oldKeys = oldKey;
            for (NSString *oldKeyString in oldKeys) {
                if ([self setValueForKey:key withOldNodeKey:oldKeyString]) break;
            }
        }
    }];
}

- (BOOL)setValueForKey:(NSString *)nodeKey withOldNodeKey:(NSString *)oldNodeKey {
    id oldValue = [self valueForNodeKey:oldNodeKey];
    
    if (![nodeKey containsString:@"["] && ![nodeKey containsString:@"."]) {
        self[nodeKey] = oldValue;
        if (!oldValue || [oldValue isKindOfClass:[NSNull class]]) {
            return NO;
        } else {
            return YES;
        }
    }
  
    NSMutableArray<NSString *> *nodes = [nodeKey componentsSeparatedByString:@"."].mutableCopy;
    NSString *lastNode = nodes.lastObject;
    [nodes removeLastObject];
    id nodeValue = self;
    for (NSString *node in nodes) {
        NSUInteger includedArrIndex;
        NSString *includedArrName = nil;
        BOOL isArrayType = [self isArrTypeOfKeysNode:node includedArrName:&includedArrName includedArrIndex:&includedArrIndex];
        id subNodeValue = [self fetchNodeValueInDictionry:nodeValue withNode:node];
        if (!subNodeValue || [subNodeValue isKindOfClass:[NSNull class]]) {
            if (isArrayType && includedArrIndex == 0) {
                subNodeValue = [NSMutableArray arrayWithCapacity:1];
                nodeValue[node] = subNodeValue;
            } else {
                subNodeValue = [NSMutableDictionary dictionary];
                nodeValue[node] = subNodeValue;
            }
        } else {
            if (![subNodeValue isKindOfClass:[NSDictionary class]]) {
                subNodeValue = [NSMutableDictionary dictionary];
                nodeValue[node] = subNodeValue;
            }
        }
        nodeValue = [self fetchNodeValueInDictionry:nodeValue withNode:node];
    }
    
    if ([nodeValue isKindOfClass:[NSMutableDictionary class]]) {
        nodeValue[lastNode] = oldValue;
        return YES;
    }
    return NO;
}

/// 在字典中取某个key的值，支持以点号为分隔符的嵌套结构
/// @param nodeKey 字典的key，可以包含'.'点号作为分隔符
- (id)valueForNodeKey:(NSString *)nodeKey {
    if (!nodeKey.length) return nil;
    if (![nodeKey containsString:@"["] && ![nodeKey containsString:@"."]) return self[nodeKey];
    
    NSMutableArray<NSString *> *nodes = [nodeKey componentsSeparatedByString:@"."].mutableCopy;
    id nodeValue;
    NSString *firstNodeKey = nodes[0];
    [nodes removeObjectAtIndex:0];
    nodeValue = [self fetchNodeValueInDictionry:self withNode:firstNodeKey];;
    if (!nodeValue || [nodeValue isKindOfClass:[NSNull class]]) return nil;
    
    for (NSString *node in nodes) {
        if ([nodeValue isKindOfClass:[NSDictionary class]]) {
            nodeValue = [self fetchNodeValueInDictionry:nodeValue withNode:node];
        } else {
            return nil;
        }
    }
    return nodeValue;
}

// eg: student, students[0]
- (id)fetchNodeValueInDictionry:(NSDictionary *)dictionry withNode:(NSString *)node {
    NSUInteger includedArrIndex;
    NSString *includedArrName = nil;
    if (![self isArrTypeOfKeysNode:node includedArrName:&includedArrName includedArrIndex:&includedArrIndex]) {
        return dictionry[node];
    } else {
        NSArray *prefixComponentValue = dictionry[includedArrName];
        if (prefixComponentValue && [prefixComponentValue isKindOfClass:[NSArray class]] && prefixComponentValue.count > 0) {
            return prefixComponentValue.count > includedArrIndex ? prefixComponentValue[includedArrIndex] : nil;
        } else {
            return nil;
        }
    }
}

- (BOOL)isArrTypeOfKeysNode:(NSString *)node includedArrName:(NSString **)includedArrName includedArrIndex:(NSUInteger *)includedArrIndex {
    if (![node containsString:@"["]) return NO;
    NSUInteger location1 = [node rangeOfString:@"["].location;
    NSUInteger location2 = [node rangeOfString:@"]"].location;
    if (location2 != NSNotFound && location2 > location1) {
        NSString *prefixComponent = [node substringToIndex:location1];
        NSInteger index = [node substringWithRange:NSMakeRange(location1 + 1, location2 - location1 - 1)].integerValue;
        if (prefixComponent.length && index >= 0) {
            if (includedArrName) *includedArrName = prefixComponent;
            if (includedArrIndex) *includedArrIndex = index;
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)allCollectionValuesToMutable {
    for (NSString *key in self.allKeys) {
        id value = self[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            id mutableValue = [value mutableCopy];
            self[key] = mutableValue;
            [mutableValue allCollectionValuesToMutable];
        } else if ([value isKindOfClass:[NSArray class]]) {
            id mutableValue = [value mutableCopy];
            self[key] = mutableValue;
            for (NSInteger i = 0; i < [mutableValue count]; i++) {
                id arrObject = mutableValue[i];
                if ([arrObject isKindOfClass:[NSDictionary class]]) {
                    id arrObjectMutableValue = [arrObject mutableCopy];
                    [mutableValue replaceObjectAtIndex:i withObject:arrObjectMutableValue];
                    [arrObjectMutableValue allCollectionValuesToMutable];
                }
            }
        }
    }
}

@end
