//
//  DX_DingDongMovieHeader.h
//  DingDongMovie
//
//  Created by dllo on 15/9/9.
//  Copyright (c) 2015年 Xu Ding. All rights reserved.
//

#ifndef DingDongMovie_DX_DingDongMovieHeader_h
#define DingDongMovie_DX_DingDongMovieHeader_h

// TabBar 和 Navigation 主题颜色
#define NavigationColor [UIColor colorWithString:@"#56abe4"]

// 夜间模式 主题颜色
#define NightModelThemeColor [UIColor colorWithWhite:0.097 alpha:1.000]

// 影片标签颜色
#define FilmTypeLabelColor [UIColor colorWithString:@"#F2BE1B"]

// 电影_即将上映版块卡片颜色
#define FilmCardColor [UIColor colorWithRed:0.669 green:0.957 blue:1.000 alpha:1.000]

// 电影_导演介绍版块卡片颜色
#define DirectorCardColor [UIColor colorWithWhite:0.950 alpha:1.000]

// 发现_影评版块卡片颜色
#define DiscoverFilmReviewCardColor [UIColor colorWithRed:0.969 green:0.998 blue:1.000 alpha:1.000]

// 发现_首页_背景颜色
#define DiscoverPageBackgroundColor [UIColor colorWithRed:0.922 green:0.943 blue:0.887 alpha:1.000]


// 电影名片, 影片名称字体
#define FilmNameLabelFont [UIFont systemFontOfSize:18]

// 电影名片, 影片类型标签字体
#define FilmTypeLabelFont [UIFont systemFontOfSize:12]

// 影片详情标题字体
#define MovieDetailsFont [UIFont systemFontOfSize:18]

// 发现界面字体
#define DiscoverPageFont [UIFont systemFontOfSize:17]


// 电影_首页_正在热映版块接口
#define HotShowingAddress @"http://api.douban.com/v2/movie/nowplaying?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&city=北京&client=e:iPhone6,2|y:iPhone OS_8.4.1|s:mobile|f:doubanmovie_2|v:3.6.6|m:豆瓣电影|udid:e932445aac997fd5a79a59ec58e5a467e70b16c4&start=0&udid=e932445aac997fd5a7"

// 电影_首页_即将上映板块接口
#define BeAboutToShowAddress @"http://api.douban.com/v2/movie/coming?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&client=e:iPhone6,2|y:iPhone OS_8.4.1|s:mobile|f:doubanmovie_2|v:3.6.6|m:豆瓣电影|udid:e932445aac997fd5a79a59ec58e5a467e70b16c4&start=0&udid=e932445aac997fd5a79a59ec58e5a467e70b16c4&version=2"

// 电影_影片详情版块接口
#define MovieDetailsAddress @"http://api.douban.com/v2/movie/subject/%@?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&city=北京&client=e:iPhone6,2|y:iPhone OS_8.4.1|s:mobile|f:doubanmovie_2|v:3.6.6|m:豆瓣电影|udid:e932445aac997fd5a79a59ec58e5a467e70b16c4&udid=e932445aac997fd5a79a59ec58e5a467e70b16c4&version=2"

// 电影_导演版块接口
#define DirectorAddress @"http://api.douban.com/v2/movie/celebrity/%@?udid=9bbf32a0f7ef5c8acbb6ea34ef1aa0fe1346e847&client=s:mobile|y:Android%204.4.2|o:V6.6.1.0.KHBCNCF|f:70|v:2.7.4|m:Xiaomi_Market|d:864645021742181|e:Xiaomi%20HM2013023|ss:720x1280&apikey=0b2bdeda43b5688921839c8ecb20399b"

// 电影_演员版块接口
#define ActorAddress @"http://api.douban.com/v2/movie/celebrity/%@?udid=9bbf32a0f7ef5c8acbb6ea34ef1aa0fe1346e847&client=s:mobile|y:Android%204.4.2|o:V6.6.1.0.KHBCNCF|f:70|v:2.7.4|m:Xiaomi_Market|d:864645021742181|e:Xiaomi%20HM2013023|ss:720x1280&apikey=0b2bdeda43b5688921839c8ecb20399b"

// 发现_视频版块接口
#define VideoAddress @"http://api.douban.com/v2/movie/subject/%@?alt=json&apikey=0df993c66c0c636e29ecbb5344252a4a&app_name=doubanmovie&city=北京&client=e:iPhone6,2|y:iPhone OS_8.4.1|s:mobile|f:doubanmovie_2|v:3.6.6|m:豆瓣电影|udid:e932445aac997fd5a79a59ec58e5a467e70b16c4&udid=e932445aac997fd5a79a59ec58e5a467e70b16c4&version=2"

// 发现_短评版块接口
#define ShortCommentaryAddress @"http://api.douban.com/v2/movie/subject/%@/comments?count=50&udid=9bbf32a0f7ef5c8acbb6ea34ef1aa0fe1346e847&client=s:mobile|y:Android 4.4.2|o:V6.6.1.0.KHBCNCF|f:70|v:2.7.4|m:Xiaomi_Market|d:864645021742181|e:Xiaomi HM2013023|ss:720x1280&apikey=0b2bdeda43b5688921839c8ecb20399b"

// 发现_影评版块接口
#define FilmReviewAddress @"http://api.douban.com/v2/movie/subject/%@/reviews?count=50&udid=9bbf32a0f7ef5c8acbb6ea34ef1aa0fe1346e847&client=s:mobile|y:Android 4.4.2|o:V6.6.1.0.KHBCNCF|f:70|v:2.7.4|m:Xiaomi_Market|d:864645021742181|e:Xiaomi HM2013023|ss:720x1280&apikey=0b2bdeda43b5688921839c8ecb20399b"

// 发现_互动版块接口
#define InteractionAddress @"http://www.mtime.com/community/"

// 发现_搜索版块接口
#define SearchListAddress @"http://api.douban.com/v2/movie/search?count=20&udid=9bbf32a0f7ef5c8acbb6ea34ef1aa0fe1346e847&client=s:mobile|y:Android 4.4.2|o:V6.6.1.0.KHBCNCF|f:70|v:2.7.4|m:Xiaomi_Market|d:864645021742181|e:Xiaomi HM2013023|ss:720x1280&apikey=0b2bdeda43b5688921839c8ecb20399b&q=%@"

// 我的_推荐电影版块接口
#define MovieRecommendAddress @"http://api.douban.com/v2/movie/top250?count=%ld&udid=9bbf32a0f7ef5c8acbb6ea34ef1aa0fe1346e847&client=s:mobile|y:Android 4.4.2|o:V6.6.1.0.KHBCNCF|f:70|v:2.7.4|m:Xiaomi_Market|d:864645021742181|e:Xiaomi HM2013023|ss:720x1280&apikey=0b2bdeda43b5688921839c8ecb20399b"


// 友盟 AppKey
#define AppKey @"55ff5d9e67e58e0bac00388a"

// QQ AppKey
#define QQAppId @"1104804097"

// Wechat AppId
#define WechatAppId @"wx0e4f79ac35ae9d46"

// Wechat AppSecret
#define WechatAppSecret @"4c34a23bdbcf56e13ab1775843c5cd3c"


// 设备屏幕宽度
#define MobileDevicesScreenWidth [[UIScreen mainScreen] bounds].size.width
// 设备屏幕高度
#define MobileDevicesScreenHeight [[UIScreen mainScreen] bounds].size.height

// iPhone
#define OffWidth [UIScreen mainScreen].bounds.size.width / 375
#define OffHeight [UIScreen mainScreen].bounds.size.height / 667

// iPhone 6 Plus
#define iPhone6PlusWidth 414
#define iPhone6PlusHeight 736

// iPhone 6
#define iPhone6Width 375
#define iPhone6Height 667

// iPhone 5 和 iPhone 5S
#define iPhone5Width 320
#define iPhone5Height 568

// iPhone 4S
#define iPhone4SWidth 320
#define iPhone4SHeight 480

#endif
