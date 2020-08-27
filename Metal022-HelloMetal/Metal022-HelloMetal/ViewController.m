//
//  ViewController.m
//  Metal022-HelloMetal
//
//  Created by liushaoyi on 2020/8/27.
//  Copyright © 2020 liushaoyi. All rights reserved.
//

#import "ViewController.h"
#import "CCRender.h"
@interface ViewController ()
{
    MTKView *_view;
    CCRender *_render;
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.获取_view;
    _view = (MTKView *)self.view;
    
    //2. 为 _view 设置 MTLDevice（必须）
    //一个MTLDevice 对象就代表这着一个GPU,通常我们可以调用方法MTLCreateSystemDefaultDevice()来获取代表默认的GPU单个对象.
    _view.device = MTLCreateSystemDefaultDevice();
    
    //3.判断是否创建成功
    if (!_view.device) {
        NSLog(@"Metal is not supported on this device");
        return;
    }
    
    //4.创建 CCRender
    //分开你的渲染循环:
    //在我们开发Metal 程序时,将渲染循环分为自己创建的类,是非常有用的一种方式,使用单独的类,我们可以更好管理初始化Metal,以及Metal视图委托.
    
    _render = [[CCRender alloc] initWithMetalKitView:_view];
    
    //5.判断_render 是否创建成功
    if (!_render) {
        NSLog(@"Render failed initialization");
        return;
    }
    
    //6.设置MTKView 的代理(由CCRender来实现MTKView 的代理方法)
    _view.delegate = _render;
    
    //7.视图可以根据视图属性上设置帧速率(指定时间来调用drawInMTKView方法--视图需要渲染时调用)
    _view.preferredFramesPerSecond = 60;
}


@end
