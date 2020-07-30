//
//  ViewController.m
//  TestForGLKitView
//
//  Created by Liushaoyi on 2020/7/30.
//  Copyright © 2020 Liushaoyi. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>


@interface ViewController ()<GLKViewDelegate>
{
    EAGLContext *context;
    GLKBaseEffect *cEffect;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //1.初始化 glkView
    [self setupConfig];
    
    //2.
    [self setupVerTexData];
    
    //3. 加载图片
    [self setupTexture];
    
}

- (void)setupTexture
{
    //1、图片路径
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tu" ofType:@"jpeg"];
    //2.设置纹理参数
    //纹理坐标原点在屏幕左下角，图片显示原点左上
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    //3、GLKit,BaseEffert 加载图片，（包含了顶点着色器，片元着色器）
    cEffect = [[GLKBaseEffect alloc] init];
    cEffect.texture2d0.enabled = GL_TRUE;
    cEffect.texture2d0.name = textureInfo.name;
}

- (void)setupVerTexData
{
    //1、顶点数据（顶点坐标，纹理坐标）
    // 2个三角形；6个顶点
    CGFloat vertextData[] = {
        0.5,-0.5,0.0f,   1.0f,0.0f,//右下角
        0.5,0.5,0.0f,   1.0f,1.0f,//右上角
        -0.5,0.5,0.0f,  0.0f,1.0f,//左上角
        0.5,-0.5,0.0f,  1.0f,0.0f,//右下
        -0.5,0.5,0.0f,  0.0,1.0f,//左上
        -0.5,-0.5,0.0,  0.0,0.0,//左下
    };
    
    //3、顶点缓冲区
    //1)创建
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    
    //2) 绑定顶点缓冲区
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    
    //3)
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertextData), vertextData, GL_STATIC_DRAW);
    
    //打开顶点坐标数据通道
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    //读取（显存顶点->顶点着色器）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL+0);
    //打开纹理坐标数据通道 仅支持两个纹理
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL+3);
    
}

- (void)setupConfig
{
    //1、初始化上线文
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    //2、判断创建是否成功
    if (!context) {
        NSLog(@"Create ES context Failed");
    }
    
    //3.可以多个上线文，当前上线文只有一个
    [EAGLContext setCurrentContext:context];
    
    //4. GLKView
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    //5、设置背景色
    glClearColor(1, 0, 0, 1);
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClear(GL_COLOR_BUFFER_BIT);
    //准备绘制
    [cEffect prepareToDraw];
    
    //开始绘制
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
