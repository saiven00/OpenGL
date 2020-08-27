//
//  CCRender.h
//  Metal022-HelloMetal
//
//  Created by liushaoyi on 2020/8/27.
//  Copyright © 2020 liushaoyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@import MetalKit;
@interface CCRender : NSObject <MTKViewDelegate>

- (instancetype)initWithMetalKitView:(MTKView *)mtkView;

@end

NS_ASSUME_NONNULL_END
