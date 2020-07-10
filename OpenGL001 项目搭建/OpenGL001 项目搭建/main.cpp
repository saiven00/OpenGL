//
//  main.cpp
//  OpenGL001 项目搭建
//
//  Created by liushaoyi on 2020/7/10.
//  Copyright © 2020 liushaoyi. All rights reserved.
//

#include "GLTools.h"
#include <GLUT/GLUT.h>


GLBatch triangleBatch;

GLShaderManager shaderManager;



// 程序初始化设置
void SetupRC ()
{
    //清理背景颜色为xx色
    glClearColor(0.0f, 1.0f, 0.0f, 1.0);
    
    //初始化着色器
    shaderManager.InitializeStockShaders();
    
    //设置三角形，其中数组vVerts 包含3个顶点的x,y,z 笛卡尔坐标
    GLfloat vVerts[] = {
        -0.5f,0.0f,0.0f,
        0.5f,0.0f,0.0f,
        0.0f,0.5f,0.0f
    };
    
    //批次处理
    triangleBatch.Begin(GL_TRIANGLES,3);
    
    triangleBatch.CopyVertexData3f(vVerts);
    
    triangleBatch.End();
    
}

//开始渲染

void RenderScene (void)
{
    //清楚一个或者特定的缓冲区，使用了什么就清理什么
    glClear(GL_COLOR_BUFFER_BIT);
    
    //设置一个颜色数组
    GLfloat vRed[] = {1.0f,0.0f,0.0f,1.0f};
    
    //将颜色传递到着色器,即GLT_SHADER_IDENTITY着色器，这个着色器知识使用指定颜色，已默认笛卡尔坐标在屏幕上渲染几何图形
    shaderManager.UseStockShader(GLT_SHADER_IDENTITY,vRed);
    
    //提交着色器
    triangleBatch.Draw();
    
    glutSwapBuffers();
    
}



//第一次加载窗口 和 窗口发生改变时候 接收新的宽度和高度， 其中 0,0 代表窗口中的左下角坐标，w，h 是像素单位
void ChangeSize(int w, int h)
{
    
    glViewport(0, 0, w, h);
    
}




int main(int argc, char * argv[])
{
    
    //设置当前工作目录，准队MAC OS X
    
    gltSetWorkingDirectory(argv[0]);
    
    //初始化GLUT库
    
    glutInit(&argc, argv);
    
    //初始化双缓冲区窗口，之中标志GLUT_DOUBLE、GLUT_RGBA、GLUT_DEPTH、GLUT_STENCIL 分别指
    //                      双缓冲窗口、RGBA颜色模式、深度测试、模板缓冲区
    glutInitDisplayMode(GLUT_DOUBLE|GLUT_DEPTH|GLUT_STENCIL);
    
    //GLUT窗口大小，标题窗口
    
    glutInitWindowSize(800, 800);
    
    glutCreateWindow("Triangle");
    
    //注册回调函数
    glutReshapeFunc(ChangeSize);
    glutDisplayFunc(RenderScene);
    
    
    //驱动程序的初始换问题
    GLenum err = glewInit();
    
    if (GLEW_OK != err) {
        fprintf(stderr, "glew error:%s\n",glewGetErrorString(err));
        return 1;
    }
    
    //调用初始化函数
    SetupRC();
    
    glutMainLoop();
    
    
    return 0;
}
