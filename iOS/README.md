在线 KTV 是火山引擎实时音视频提供的一个开源示例项目。本文介绍如何快速跑通该示例项目，体验在线 KTV 效果。

## 应用使用说明

使用该工程文件构建应用后，即可使用构建的应用体验在线 KTV。
你和你的同事必须加入同一个房间，才能共同体验在线 KTV。

## 前置条件

- [Xcode](https://developer.apple.com/download/all/?q=Xcode) 12.0+
	

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

1. 打开终端窗口，进入 `RTC_KTV_Demo-master/iOS/veRTC_Demo_iOS` 根目录
	

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_6b2faa8c8c1bb3db6455b47528425479" width="500px" >

2. 执行 `pod install` 命令构建工程
	

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_4d95cd1807a36514ffff872cb624ba39" width="500px" >

3. 进入 `RTC_KTV_Demo-master/iOS/veRTC_Demo_iOS` 根目录，使用 Xcode 打开 `veRTC_Demo.xcworkspace`
	

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_d034aa4e052c226eda518eb9696173dd" width="500px" >

4. 在 Xcode 中打开 `Pods/Development Pods/Core/BuildConfig.h` 文件
	

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_8a6dcad044038b3b89910f3d13a163a2" width="500px" >

5. 填写 **LoginUrl**
	

当前你可以使用 **`https://common.rtc.volcvideo.com/rtc_demo_special/login`** 作为测试服务器域名，仅提供跑通测试服务，无法保障正式需求。

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_99370376d83f3751ed25e0b7ee68e93a" width="500px" >

6. **填写 APPID、APPKey、AccessKeyID 和 SecretAccessKey**
	

使用在火山引擎控制台获取的 **APPID、APPKey、AccessKeyID 和 SecretAccessKey** 填写到 `BuildConfig.h`文件的对应位置。

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_bb28d09f8cd226bd16995d4b4404e56c" width="500px" >

7. 进入 `Pods/Development Pods/KTVDemo/KTVDemoConstants.h` 文件
	

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_e15732e24984ad415b327c2f4bc867c6" width="500px" >

8. 填写 **HiFiveAppID**、**HiFiveServerCode 和 KEY**
	

使用在 HIFIVE 控制台获取的**HiFiveAppID**、**HiFiveServerCode 和 KEY 填写到** `KTVDemoConstants.h` 文件的对应位置。

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_b5cfca60c03be829f1f215a258f85e3b" width="500px" >

### **步骤 5：配置开发者证书**

1. 将手机连接到电脑，在 `iOS Device` 选项中勾选您的 iOS 设备
	

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_767c9fffd909d15392d089773fb935e8" width="500px" >

2. 登录 Apple ID。
	

2.1 选择 Xcode 页面左上角 **Xcode** > **Preferences**，或通过快捷键 **Command** + **,**  打开 Preferences。
2.2 选择 **Accounts**，点击左下部 **+**，选择 Apple ID 进行账号登录。

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_cc2dc2681dbd59dac3a577478a25f096" width="500px" >

3. 配置开发者证书。
	

3.1 单击 Xcode 左侧导航栏中的 `VeRTC_Demo` 项目，单击 `TARGETS` 下的 `VeRTC_Demo` 项目，选择 **Signing & Capabilities** > **Automatically manage signing** 自动生成证书

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_431018403c7be7bdd1d93bdf2b73236d" width="500px" >

3.2 在 **Team** 中选择 Personal Team。

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_db8b76140485b9a0062377ca8b421c3d" width="500px" >

3.3 **修改 Bundle** **Identifier****。** 

默认的 `vertc.veRTCDemo.ios` 已被注册， 将其修改为其他 Bundle ID，格式为 `vertc.xxx`。

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_22ed79ce436c34e32f5df83383cdcc19" width="500px" >

### **步骤 6：编译运行**

选择 **Product** > **Run**， 开始编译。编译成功后你的 iOS 设备上会出现新应用。若为免费苹果账号，需先在`设置->通用-> VPN与设备管理 -> 描述文件与设备管理`中信任开发者 APP。

<img src="https://lf3-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_892b33548946502f6379e66a0ddcb683" width="500px" >

运行开始界面如下：

<img src="https://lf6-volc-editor.volccdn.com/obj/volcfe/sop-public/upload_9e4505338b448ca007ca32a414575cf7" width="200px" >

