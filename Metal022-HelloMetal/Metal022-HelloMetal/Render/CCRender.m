
//
//  CCRender.m
//  Metal022-HelloMetal
//
//  Created by liushaoyi on 2020/8/27.
//  Copyright © 2020 liushaoyi. All rights reserved.
//

#import "CCRender.h"

@implementation CCRender
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commanQueue;
}

//颜色结构体
typedef struct {
    float red ,green, blue, alpha;
}Color;

- (instancetype)initWithMetalKitView:(MTKView *)mtkView
{
    if (self = [super init]) {
        
        _device = mtkView.device;
        //所有应用程序需要与GPU交互的第一个对象是一个对象。MTLCommandQueue.
        //你使用MTLCommandQueue 去创建对象,并且加入MTLCommandBuffer 对象中.确保它们能够按照正确顺序发送到GPU.对于每一帧,一个新的MTLCommandBuffer 对象创建并且填满了由GPU执行的命令.
        _commanQueue = [_device newCommandQueue];
    }
    
    return self;
}


//设置颜色
- (Color)makeFancyColor
{
    //1. 增加颜色、减小颜色标记
    static BOOL growing = YES;
    //2. 颜色通道
    static NSUInteger primaryChannel = 0;
    //3. 颜色通道数组 colorChannel （颜色值）
    static float colorChanels[] = {1.0,0.0,0.0,1.0};
    //4. 颜色调整步长
    const float DynamicColorRate = 0.005;
    
    //5. 判断
    if (growing) {
        
        //动态信道索引（1，2，3，0）通道切换
        NSUInteger dynamicChanelIndex = (primaryChannel +1)%3;
        
        //修改对应通道的颜色值 调整步长为 0.015
        colorChanels[dynamicChanelIndex] += DynamicColorRate;
        
        if (colorChanels[dynamicChanelIndex] >= 1.0) {
            //设置为NO
            growing = NO;
            //将颜色通道改为动态颜色通道
            primaryChannel = dynamicChanelIndex;
        }
        
        
    }else{
        //获取动态颜色通道
        NSUInteger dynamicChannelIndex = (primaryChannel+2)%3;
        
        //将当前颜色的值 减去0.015
        colorChanels[dynamicChannelIndex] -= DynamicColorRate;
        
        //当颜色值小于等于0.0
        if(colorChanels[dynamicChannelIndex] <= 0.0)
        {
            //又调整为颜色增加
            growing = YES;
        }
    }
    
    Color color;
    color.red   = colorChanels[0];
    color.green = colorChanels[1];
    color.blue  = colorChanels[2];
    color.alpha = colorChanels[3];
    
    return color;
}

#pragma mark - MTKViewDelegate methods

- (void)drawInMTKView:(MTKView *)view
{
    //1. 获取颜色值
    Color color = [self makeFancyColor];
    
    //2. 设置View的clearColor
    view.clearColor = MTLClearColorMake(color.red, color.green, color.blue, color.red);
    
    //3. Create a new command buffer for each render pass to the current drawable
    //使用MTLCommandQueue 创建对象并且加入到MTCommandBuffer对象中去.
    //为当前渲染的每个渲染传递创建一个新的命令缓冲区
    
    id<MTLCommandBuffer> commandBuffer = [_commanQueue commandBuffer];
    commandBuffer.label = @"MyCommand";
    
    //4. 从试图绘制中，获取渲染描述
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    //5. 判断renderPassDescriptor 渲染描述符是否创建成功，搜则跳过任何渲染
    
    if (renderPassDescriptor != nil) {
        //6. 通过渲染描述符RenderPassDescirptor 创建 MTLRenderCommandEncoder 对象 命令编码对象
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyrenderEncoder";
        
        /* 中间可以防止metal绘制文件  */
        
        //7. 我们可以使用MtlRenderCommandEncoder来绘制对象，但是这个demo 我们仅仅创建编码器就可以了，我们没有让metal去执行我们绘制的东西，这个时候表示我们的任务已经完成。
        //即可结束MTLRenderCommandEncoder 工作
        [renderEncoder endEncoding];
        
        /*
         当编码器结束之后,命令缓存区就会接受到2个命令.
         1) present
         2) commit
         因为GPU是不会直接绘制到屏幕上,因此你不给出去指令.是不会有任何内容渲染到屏幕上.
        */
        //8.添加一个最后的命令来显示清除的可绘制的屏幕
        [commandBuffer presentDrawable:view.currentDrawable];
        
        
    }
    
    //9. 在这里完成渲染并将命令缓冲区提价给GPU
    [commandBuffer commit];
}

//当MTKView视图发生大小改变时调用
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
     
}


@end
