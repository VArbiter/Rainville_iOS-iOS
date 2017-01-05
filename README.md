# Rainville_iOS-iOS
Rainville For iOS /  聆雨 iOS 版本

## 目前尚未开发完成 . 

#### 聆雨原创_GITHUB : [feelinglucky](https://github.com/feelinglucky/Rainville/)

##### 为什么要写 聆雨_iOS 版本

		三年前 (2014) , 我第一次接触了 <<聆雨>> 这款安卓的 App . 瞬间就被吸引了 . 怎么说呢 .
		我是典型的失眠患者 , 易烦躁 , 而 <<聆雨>> 在这时候能给我提供一个非常安静的环境 ,
		最舒服的事情 , 就是在雨声中睡大觉啦 !
		现在成为了标准的iOS 程序员 ... 
		挂着 <<聆雨>> 敲代码是个不错的选择哦 ~~
		
		既然喜欢 , 就移植过来 .
		
##### 关于音频播放
	
		因为使用的音频长度都不相同 , 所以本来打算是用合成后的文件来循环播放的 , 
		就是比如两个音频播放 , 12s 和 8s , 取最小公倍数 24s , 
		即为先拼接两段 12s 的 , 和 三段 8s 的 , 然后两个音轨按照百分比音量叠加合成 . 
		 
		但是发现 , 用精确计数读出来的文件长度 , 让人特别抑郁 . 
		比如 , 12s 和 8s 的精确实际上是 11.966666 和 8.355555 ... 
		这就尴尬了 . 所以最后还是决定采用多重播放的方式 ... 一口老血 ... 
		就和明城兄说的一样 ... 很 Dirty 的方式 . 好在内存占用还行 ... 
		
		关于抽取音轨视频轨合成之类的 , 会增加实际文件体积 ;
		多个播放的 , 会增加内存占用 . 
		我想 , 如果不是音频长度比较抑郁 , 我还是会选择合成的方式的 ... 
		
		嗯 ... 耳朵 ... 看来我距离玄学的道路不远了 ... 😂😂😂

##### App Store 下载地址 : `开发完成后 , 上线放出`

#### 注意 : 聆雨完全遵循 __*GPL*__ 协议

#### 感谢 [明城](lucky@gracecode.com) (原作者) 在我开发 iOS 版本`聆雨`时给我的支持和技术指导 

__*Contact*__ : [ElwinFrederick](elwinfrederick@163.com) 

__*Email*__ : <elwinfrederick@163.com>