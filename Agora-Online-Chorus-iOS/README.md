# AgoraChooseSongDemo AgoraChorusDemo



*Read this in other languages: [English](README.en.md)*

这个开源示例项目演示了如何实现合唱的功能。

## 运行示例程序
首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。将 AppID 填写进 ViewController.m


```
[AgoraRtcEngineKit sharedEngineWithAppId:@"<#APP_ID#>" delegate:self] 

```
AgoraChooseSongDemo指定房间
```
[self.rtcEngine joinChannelByToken:nil channelId:@"<#roomname#>"  info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
}];

```

联系声网商务下载 iOS 平台合唱 SDK。详情请洽 sales@agora.io ，电话 4006326626。将其中的 **AgoraRtcEngineKit.framework** 分别复制到本项目的 “AgoraChooseSongDemo/AgoraChooseSongDemo” 和 “AgoraChorusDemo/AgoraChorusDemo” 文件夹下。

最后使用 XCode 打开 AgoraChooseSongDemo.xcodeproj 和 AgoraChorusDemo.xcodeproj 工程 ，连接 iPhone／iPad 测试设备，设置有效的开发者签名后即可运行。

## 实现合唱的方法
* 运行AgoraChooseSongDemo  创建房间播放伴奏
* 运行AgoraChorusDemo 连接两个手机 真机运行 加入到同一一个房间中 有四组参数可选 推荐第四组参数
* 双方拿着AgoraChorusDemo运行的手机随着伴奏合唱即可




## 运行环境
* XCode 8.0 +
* iOS 真机设备
* 不支持模拟器

## 联系我们

- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题，你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题，可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持，你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的bug，欢迎提交 [issue](https://github.com/AgoraIO/Agora-client-side-AV-capturing-for-streaming-iOS/issues)

## 代码许可

The MIT License (MIT).
