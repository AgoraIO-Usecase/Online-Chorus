# AgoraChooseSongDemo AgoraChorusDemo

*其他语言版本： [简体中文](README.md)*

The client show the method of  how to chorus 

## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Update "ViewController.m" with your App ID.

```
[AgoraRtcEngineKit sharedEngineWithAppId:@"<#APP_ID#>" delegate:self] 
```
AgoraChooseSongDemo assign a room
```
[self.rtcEngine joinChannelByToken:nil channelId:@"<#roomname#>"  info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
}];

```
Contact voice net business to download Android platform chorus SDK.For details, please contact sales@agora.io, telephone 4006326626.
Unzip the downloaded SDK package and copy the **libs/AgoraRtcEngineKit.framework** to the "AgoraChooseSongDemo/AgoraChooseSongDemo" folder in project, copy the **libs/AgoraRtcEngineKit.framework** to the "AgoraChorusDemo/AgoraChorusDemo" folder in project . 

Finally, Open AgoraChooseSongDemo.xcodeproj,  AgoraChorusDemo.xcodeproj  connect your iPhone／iPad device, setup your development signing and run.

## Operating steps
* Run AgoraChooseSongDemo.xcodeproj create a room.
* Run AgoraChorusDemo join the same room.
* two people with running  the AgoraChorusDemo singing the same song with each other.
## Developer Environment Requirements
* XCode 8.0 +
* Real devices (iPhone or iPad)
* iOS simulator is NOT supported

## Connect Us

- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-client-side-AV-capturing-for-streaming-iOS/issues)

## License

The MIT License (MIT).
