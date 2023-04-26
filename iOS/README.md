在线 KTV 是火山引擎实时音视频提供的一个开源示例项目。本文介绍如何快速跑通该示例项目，体验在线 KTV 效果。

## 应用使用说明

使用该工程文件构建应用后，即可使用构建的应用体验在线 KTV。
你和你的同事必须加入同一个房间，才能共同体验在线 KTV。

## 前置条件

- [Xcode](https://developer.apple.com/download/all/?q=Xcode) 14.0+
	

- iOS 12.0+ 真机
	

- 有效的 [AppleID](http://appleid.apple.com/)
	

- 有效的 [火山引擎开发者账号](https://console.volcengine.com/auth/login)
	

- [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started) 1.10.0+
	

## 操作步骤

### **步骤 1：获取 AppID 和 AppKey**

在火山引擎控制台->[应用管理](https://console.volcengine.com/rtc/listRTC)页面创建应用或使用已创建应用获取 AppID 和 AppAppKey

### **步骤 2：获取 AccessKeyID 和 SecretAccessKey**

在火山引擎控制台-> [密钥管理](https://console.volcengine.com/iam/keymanage/)页面获取 **AccessKeyID 和 SecretAccessKey**

### 步骤 3：申请 HIFIVE 权限

1. 获取 **APPID** 和 **ServerCode**
	

在 HIFIVE 控制台-> 授权中心 -> [产品授权管理](https://account.hifiveai.com/admin/auth/productList/edit/baseForm/2795/0/5)页面获取 **APPID** 和**ServerCode**

2. 获取音乐电台 **KEY**
	

在 HIFIVE 控制台 -> 歌单管理 -> [音乐电台](https://account.hifiveai.com/admin/song/operateList)页面获取。如没有音乐电台请新增。

### 步骤 4：构建工程

1. 打开终端窗口，进入 `RTC_KTV_Demo/iOS/RTCSolution` 根目录<br>
	<img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/cd.jpg" width="500px" >	
2. 执行 `pod install` 命令构建工程	<br>
	<img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/podinstall.jpg" width="500px" >	
3. 进入 `RTC_KTV_Demo/iOS/RTCSolution` 根目录，使用 Xcode 打开 `RTCSolution.xcworkspace`<br>
	<img src="https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_111f9afcd030018f2666aba0778ea9d4.png" width="500px" >	

4. 在 Xcode 中打开 `Pods/Development Pods/ToolKit/BuildConfig.h` 文件<br>
	
5. 填写 **HeadUrl**<br>
    当前你可以使用 **https://common.rtc.volcvideo.com/rtc_demo_special** 作为测试服务器域名，仅提供跑通测试服务，无法保障正式需求。<br>
    <img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/cefd021c-0e8b-4f98-a33f-3cb448f4741e.png" width="500px" >

6. **填写 APPID、APPKey、AccessKeyID 和 SecretAccessKey**<br>
	使用在火山引擎控制台获取的 **APPID、APPKey、AccessKeyID 和 SecretAccessKey** 填写到 `BuildConfig.h`文件的对应位置。<br>
    <img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/iosappid.png" width="500px" >
7. 进入 `Pods/Development Pods/KTVDemo/KTVDemoConstants.h` 文件<br>
	<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_e15732e24984ad415b327c2f4bc867c6" width="500px" >

8. 填写 **HiFiveAppID**、**HiFiveServerCode 和 KEY**<br>
	使用在 HIFIVE 控制台获取的**HiFiveAppID**、**HiFiveServerCode 和 KEY 填写到** `KTVDemoConstants.h` 文件的对应位置。<br>
    <img src="https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_d5d704fc28ce159b02a12c05a17ad2a5.png" width="500px" >

### **步骤 5：配置开发者证书**

1. 将手机连接到电脑，在 `iOS Device` 选项中勾选您的 iOS 设备<br>
	<img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/60a2af60-03d1-48cf-8874-75f9751efd20.png" width="500px" >	
2. 登录 Apple ID。<br>
	2.1 选择 Xcode 页面左上角 **Xcode** > **Preferences**，或通过快捷键 **Command** + **,**  打开 Preferences。<br>
	2.2 选择 **Accounts**，点击左下部 **+**，选择 Apple ID 进行账号登录。<br>
		<img src="https://portal.volccdn.com/obj/volcfe/cloud-universal-doc/upload_9c95dc2adabc63e8075213e3d5a6b7dc.png" width="500px" >

3. 配置开发者证书。<br>
	3.1 单击 Xcode 左侧导航栏中的 `RTCSolution` 项目，单击 `TARGETS` 下的 `RTCSolution` 项目，选择 **Signing & Capabilities** > **Automatically manage signing** 自动生成证书<br>
		<img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/8b11f97e-723f-4a37-a628-dadf3b9e0a96.png" width="500px" >

	3.2 在 **Team** 中选择 Personal Team。<br>
		<img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/54af18a8-8542-46f8-abb4-f421c7bcadcf.png" width="500px" >

	3.3 **修改 Bundle Identifier。** <br>
		默认的 `vertc.veRTCDemo.ios` 已被注册， 将其修改为其他 Bundle ID，格式为 `vertc.xxx`。<br>
	    <img src="https://lf3-static.bytednsdoc.com/obj/eden-cn/pkupenuhr/c7994b44-d4e2-427b-94a4-3b6a92084f90.png" width="500px" >

### **步骤 6：编译运行**

选择 **Product** > **Run**， 开始编译。编译成功后你的 iOS 设备上会出现新应用。若为免费苹果账号，需先在`设置->通用-> VPN与设备管理 -> 描述文件与设备管理`中信任开发者 APP。

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_892b33548946502f6379e66a0ddcb683" width="500px" >

运行开始界面如下：

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_9e4505338b448ca007ca32a414575cf7" width="200px" >

