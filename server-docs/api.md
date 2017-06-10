# ticketing-server API

* 当前请求 domain 为：`https://movie.kaocat.com`

* 请求附加`format`参数可获取格式化后 json 数据，如：`https://movie.kaocat.com/api/movie?format`

<!-- MarkdownTOC -->

- [返回数据格式](#返回数据格式)
    - [错误码说明](#错误码说明)

---

### API

- [电影类](#电影类)
    - [获取上映及待映电影列表](#获取上映及待映电影列表)
    - [获取电影详情信息](#获取电影详情信息)
    - [获取电影预告片URL](#获取电影预告片URL)
- [区域类](#区域类)
    - [获取全部区域列表](#获取全部区域列表)
    - [获取当前所在区域](#获取当前所在区域)
- [影院类](#影院类)
    - [获取全部影院列表](#获取影院信息)
    - [获取所在区域影院列表](#获取影院信息)
    - [获取按距离获取所在区域影院列表](#获取按距离获取所在区域影院列表)
    - [获取影院实时上映详情](#获取影院实时上映详情)
- [电影排期类](#电影排期类)
    - [获取电影排期](#获取电影排期)
- [座位类](#座位类)
    - [获取场次座位实时信息](#获取场次座位实时信息)
- [用户类](#用户类)
    - [换取token](#换取token)
- [订单类](#票务类)
    - [下单](#下单)
    - [获取订单列表](#获取订单列表)

<!-- /MarkdownTOC -->

<a name="返回数据格式"></a>
## 返回数据格式

请求返回数据为 JSON 对象，里面包含 `code`, `message` 和 `data` 三字段，分别表示错误码，错误描述信息以及相关数据，其中 `code` 为 0 表示一个成功的请求。

比如，一个成功请求的返回数据：

```javascript
{
    "code": 0,
    "message": "OK",
    "data": {
        ...
    }
}
```

一个失败请求的返回数据：

```javascript
{
    "code": 1001,
    "message": "DataBase Select Error",
    "data": {}
}
```



<a name="错误码说明"></a>
### 错误码说明

| Code | Description |
|:----:|:-----------:|
|0|成功|
|-1|未知错误|
|1001|读取数据库数据错误|
|1002|爬取实时数据错误|
|1003|读取缓存错误|
|2000|未知用户OpenID|
|2001|下单失败|


- [电影类](#电影类)
    - [获取电影详情信息](#获取电影详情信息)
    - [获取电影预告片URL](#获取电影预告片URL)
<a name="电影类"></a>
## 电影类

<a name="获取上映及待映电影列表"></a>
### 获取上映及待映电影列表

Request URI:

```
GET /api/movie
```

返回数据为一组*电影简介数据*集合

*电影简介数据* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  id | INTEGER | 电影id |
|  showInfo | STRING | 上映信息 |
|  img | STRING | 海报URL |
|  sc | FLOAT | 评分 |
|  ver | STRING | 上映版本信息 |
|  imax | BOOLEAN | 是否为IMAX |
|  snum | INTEGER | 上映数 |
|  preSale | INTEGER | 是否为预售 0-否 1-是 |
|  dir | STRING | 导演 |
|  star | STRING | 演员 |
|  cat | STRING | 电影类别 |
|  wish | INTEGER | 想看人数 |
|  3d | BOOLEAN | 是否为IMAX |
|  scm | STRING | 电影简介 |
|  nm | STRIN | 电影名称 |

Response Example:

```json
{
    "code": 0,
    "message": "OK",
    "data": [
      {
        "id": 78888,
        "showInfo": "2017-06-16 下周五上映",
        "img": "http://p1.meituan.net/165.220/movie/732d8d3f60ae22fbeaa0f5b9cbb32a84391769.jpg",
        "sc": 7.5,
        "ver": "2D/IMAX 2D/中国巨幕",
        "imax": true,
        "snum": 220,
        "preSale": 1,
        "dir": "雷德利·斯科特",
        "star": "迈克尔·法斯宾德,凯瑟琳·沃特斯顿,比利·克鲁德普",
        "cat": "恐怖,惊悚,科幻",
        "wish": 125957,
        "3d": false,
        "scm": "天堂实假象，险象险中还",
        "nm": "异形：契约"
      },
      {
        "id": 246012,
        "showInfo": "今天32家影院放映135场",
        "img": "http://p0.meituan.net/165.220/movie/ee5e691b425292f455c3eac5c628cfc7904509.png",
        "sc": 8.9,
        "ver": "2D/3D/IMAX 3D/中国巨幕/全景声",
        "imax": true,
        "snum": 346169,
        "preSale": 0,
        "dir": "乔阿吉姆·罗恩尼,艾斯彭·山德伯格",
        "star": "约翰尼·德普,哈维尔·巴登,布兰顿·思怀兹",
        "cat": "喜剧,动作,奇幻",
        "wish": 518761,
        "3d": true,
        "scm": "亡灵要复仇，船长好发愁",
        "nm": "加勒比海盗5：死无对证"
      },
      ...
    ]
}
```

<a name="获取电影详情信息"></a>
### 获取电影详情信息

Request URI:

```
GET /api/movie/:movieId
```

返回数据为`details`,`photos`,`comments`三组数据的集合

`detail` Properties:

| Property | Type | Description |
|----------|------|-------------|
| id | INTEGER | 电影的id |
| dra | STRING | 电影的简介 |
| isShowing | BOOLEAN | 是否已经上映 |
| showInfo | STRING | 上映信息 |
| img | STRING | 电影海报 |
| sc | FLOAT | 评分 |
| ver | STRING | 上映版本信息 |
| imax | BOOLEAN | 是否为IMAX |
| snum | INTEGER | 上映数 |
| preSale | INTEGER | 是否为预售 0-否 1-是 |
| dir | STRING | 导演 |
| star | STRING | 演员 |
| cat | STRING | 电影类别 |
| wish | INTEGER | 想看人数 |
| 3d | BOOLEAN | 是否为3D |
| scm | STRING | 电影简介 |
| nm | STRIN | 电影名称 |
| rt | STRING | 上映时间 |
| vd | STRING | 预告片 |

`photo` Properties:

| Property | Type | Description |
|----------|------|-------------|
| id | INTEGER | 图片的id |
| movieId | INTEGER | 对应电影的id |
| src | STRING | 图片的链接 |

`comment` Properties:

| Property | Type | Description |
|----------|------|-------------|
| id | INTEGER | 评论id |
| movieId | INTEGER | 对应电影的id |
| nick | STRING | 用户名 |
| approve | INTEGER | 赞成数 |
| oppose | INTEGER | 反对数 |
| reply | INTEGER | 回复数 |
| avatarurl | STRING | 用户头像 |
| nickName | STRING | 昵称 |
| score | INTEGER | 用户评分 |
| userId | INTEGER | 用户id |
| time | STRING | 发表时间 |
| content | STRING | 评论内容 |

Response Example:

```json
{
  "code": 0,
  "data": {
    "detail": {
      "id": 38977,
      "dra": "1925年,英国上校福赛特（查理·汉纳姆 饰）深入亚马逊丛林寻找失落的古老文明,希望找到历史上最重大的发现。几个世纪以来,欧洲人一直坚信亚马逊这个世界上最大的丛林里掩藏着一个黄金国,然而,成干上万闯入丛林探险的人都丧身其中,这使得很多科学家认为亚马逊是人类无法进入的。但福赛特上校却三次深入丛林探险,他下定决心要证明给世人,这个被他称为“Z城”的古老文明是真实存在过的。",
      "isShowing": true,
      "showInfo": null,
      "img": "http://p0.meituan.net/165.220/movie/771d86af04b8d2ac9ee3999ba0815c79902502.jpg",
      "sc": 5.9,
      "ver": "2D",
      "imax": false,
      "snum": 5934,
      "preSale": 0,
      "dir": "詹姆士·格雷 ",
      "star": "查理·汉纳姆 罗伯特·帕丁森 西耶娜·米勒 汤姆·赫兰德 伊恩·麦克迪阿梅德 Edward Ashley 安古斯·麦克菲登 Raquel Arraes 鲍比·斯莫德里奇 尼古拉斯·阿格纽 叶莲娜·索洛韦伊 穆雷·梅尔文 哈利·米尔林 弗兰科·尼罗 大卫·卡尔德 Colin Carnegie Bill Hurst Richard Croxford Clive Francis         Louise Parker Robert Fawsitt Patrick McBrearty Niall Cusack",
      "cat": "动作,冒险,传记",
      "wish": 8713,
      "3d": null,
      "scm": "探秘亚马逊，失踪无处寻",
      "nm": "迷失Z城",
      "rt": "2017-06-02上映",
      "vd": "http://maoyan.meituan.net/movie/videos/854x4806430a77dc1b64706a0e54b60cebbff80.mp4"
    },
    "photos": [
      {
        "id": 1,
        "movieId": 38977,
        "src": "http://p0.meituan.net/w.h/movie/a4cc488923b69326c3a2653c449eed48707236.jpg"
      },
      {
        "id": 2,
        "movieId": 38977,
        "src": "http://p0.meituan.net/w.h/movie/6736eb5382a9ee440cc065240c43ac4d1048176.jpg"
      },
      ...
    ],
    "comments": [
      {
        "id": 108224640,
        "movieId": 38977,
        "nick": "ggb525992156",
        "approve": 202,
        "oppose": 0,
        "reply": 36,
        "avatarurl": "https://img.meituan.net/avatar/d4ce2521f7cc2168423e1b37dd47c0ea233962.jpg",
        "nickName": "吾爱",
        "score": 1,
        "userId": 170422691,
        "time": "2017-06-02 09:46",
        "content": "我无话可说，不知道删没删，但是有一点肯定我看不懂，剧情完全接不上，搞不清是谁在回忆，哪个正在发生，整部片子没有什么打斗场面特效嘛肯定没有，结尾更是扯淡，我看了第一反应事，啥？这就结束了？这啥玩意，总体来说我还是给一颗星，毕竟演员是无辜的，人家演技还是到位的"
      },
      {
        "id": 108229932,
        "movieId": 38977,
        "nick": "刘潘峰",
        "approve": 26,
        "oppose": 0,
        "reply": 3,
        "avatarurl": "https://img.meituan.net/avatar/2fa483a28172446cc1e0b07092df781a265090.jpg",
        "nickName": "刘潘峰",
        "score": 4,
        "userId": 33331097,
        "time": "2017-06-02 10:55",
        "content": "包场看的，就两个人"
      },
      ...
    ]
  },
  "message": "OK"
}
```


- [排场信息](#排场信息)
    - [影院上映信息及排场信息](#影院上映信息及排场信息)
## 排场信息
Request URI:

```
GET /api/show?cinemaId&movieId
```

返回数据为是否有改场次电影

返回数据为一组*电影简介数据*集合

*排场信息* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  code | INTEGER | 状态码 |
|  data | STRING | 状态信息 |
|  message | STRING | 返回状态 |

Response Example:

```json
{
    "code": 0,
	"data":{}
    "message": "OK"
}
```

### 影片上映信息及排场信息

返回数据为影厅及对应排场信息

*影片上映信息及排场信息* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  code | INTEGER | 状态码 |
|  Dates | STRING | 上映日期 |
|  cinemaDetailModel | MAP | 影院详情 |
|  sells | BOOLEAN | 是否在售 |
|  lat | STRING | 纬度 |
|  lng | STRING | 经度 |
|  ct | STRING | 城市 |
|  ... | ... | ... |

Response Example:

```json
{
	"code":0,
	"data":
		{"Dates":[],
		"currentMovie":"",
		"cinemaDetailModel":{"callboard":"","brd":"其它","dis":"","tel"["029-84561999","400-899-9527"],"suw":"","dri":"","note":"","dealtp":0,"deals":"","preferential":0,"sellmin":0,"sell":true,"lat":34.20359,"lng":108.98846,"ct":"安","imax":0,"snum":42,"nm":"奥斯卡金地国际影城(金地广场)","price":0,"s":8.285714,"s1":8.285714,"s2":8.476191,"s3":8.238095,"featureTags":[{"desc":"限网上选座后取票","type":1,"tag":"取票机"},
		{"desc":"一号激光厅，152个座位；二号激光厅，152个座位；三号激光厅，152个座位；四号厅，195个座位；五号激光厅，113个座位；六号激光厅，116个座位；七号激光厅，113个座位","type":19,"tag":"60帧厅"},{"desc":"I Do巨幕厅，447个座位；巨幕厅","type":15,"tag":"杜比全景声厅"},{"desc":"1.3米以下儿童可免费观看电影（无座），每位成人仅限携带1名免票儿童。","type":7,"tag":"儿童优惠"}],"park":"","addr":"雁塔区曲江池东路金地广场4楼（飞象披萨对面）","area":"雁塔区","bus":"","id":11533},"movies":[{"img":"http://p1.meituan.net/165.220/movie/4185bf22758d232e15c5bf52f89a7553867763.png","sc":7,"preferential":0,"ver":"2D/3D/IMAX 3D/中国巨幕","nm":"新木乃伊","isShowing":true,"id":249895},{"img":"http://p1.meituan.net/165.220/movie/f013c57e9506cd2e7c609397c8da04d9213647.jpg","sc":8.6,"preferential":0,"ver":"3D/IMAX 3D/中国巨幕/全景声","nm":"神奇女侠","isShowing":true,"id":247731},
		...
```

- [选座信息](#选座信息)

## 选座信息

Request

```
GET /api/seat?showId&showDate
```

返回数据为一组*座位状态信息*

*选座信息* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  code | INTEGER | 该座位状态码 |
|  messege | STRING | 状态信息 |

Response Example:

```json
{
    "code":0,
	"message":"OK"
}
```

- [区域类](#区域类)
    - [获取全部区域列表](#获取全部区域列表)
<a name="电影类"></a>
## 区域类

<a name="获取全部区域列表"></a>
### 获取全部区域列表

Request URI:

```
GET /api/air
```

返回数据为一组*全部区域*集合

*获取全部区域列表* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  code | INTEGER | 状态码 |
|  id | INTEGER | 区域编码 |
|  nm | STRING | 区域名称 |
|  message | STRING | 状态信息 |

Response Example:

```json
{
    {"code":0,
	"data":[{"id":0,"nm":"番禺区"},
	{"id":1,"nm":"白云区"},
	{"id":2,"nm":"天河区"},
	{"id":3,"nm":"海珠区"},
	{"id":4,"nm":"越秀区"},
	{"id":5,"nm":"荔湾区"},
	{"id":6,"nm":"增城区"},
	{"id":7,"nm":"花都区"},
	{"id":8,"nm":"黄埔区"},
	{"id":9,"nm":"南沙区"},
	{"id":10,"nm":"从化区"}],
	"message":"OK"}
}
```

- [影院类](#影院类)
    - [获取全部影院列表](#获取影院信息)
    - [获取所在区域影院列表](#获取影院信息)
    - [获取按距离获取所在区域影院列表](#获取按距离获取所在区域影院列表)
<a name="影院类"></a>
## 影院类

<a name="获取影院信息"></a>
### 获取全部影院信息

Request URI:

```
GET /api/cinema
```

返回数据为一组*所有影院信息*集合

*全部影院信息* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  id | INTEGER | 影院id |
|  addr | STRING | 影院地址 |
|  brd | STRING | 影城名称 |
|  lat | FLOAT | 经度 |
|  lng | FLOAT | 维度 |
|  imax | BOOLEAN | 是否为IMAX |
|  sellPrice | INTEGER | 票价 |
|  sell | BOOL | 是否在售 falte-否 true-是 |
|  nm | STRING | 影院名 |
|  area | STRING | 区域 |
|  areaId | INTEGER | 区域ID |

Response Example:

```json
{
    "code": 0,
    "data": [
      {
        "id":3,
		"addr":"荔湾区逢源路153号3-5楼（长寿路地铁站恒宝广场北门宝源路红绿灯右转50米）",
		"brd":"华影万晟国际影城",
  		"lat":23.1208,
		"lng":113.239,
		"imax":0,
		"sellPrice":34,"sell":true,
		"nm":"华影万晟国际影城",
		"area":"荔湾区",
		"areaId":5
    ]
	...,
    "message": "OK"
}
```

### 获取所在区域影院信息

Request URI:

```
GET /api/cinema//${areaId}
```

返回数据为一组*所在区域影院信息*集合

*所在区域影院信息* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  id | INTEGER | 影院id |
|  addr | STRING | 影院地址 |
|  brd | STRING | 影城名称 |
|  lat | FLOAT | 经度 |
|  lng | FLOAT | 维度 |
|  imax | BOOLEAN | 是否为IMAX |
|  sellPrice | INTEGER | 票价 |
|  sell | BOOL | 是否在售 falte-否 true-是 |
|  nm | STRING | 影院名 |
|  area | STRING | 区域 |
|  areaId | INTEGER | 区域ID |

Response Example:

```json
{
    "code": 0,
    "data": [
      {
        "id":3,
		"addr":"荔湾区逢源路153号3-5楼（长寿路地铁站恒宝广场北门宝源路红绿灯右转50米）",
		"brd":"华影万晟国际影城",
  		"lat":23.1208,
		"lng":113.239,
		"imax":0,
		"sellPrice":34,"sell":true,
		"nm":"华影万晟国际影城",
		"area":"荔湾区",
		"areaId":5
    ]
	...,
    "message": "OK"
}
```

### 获取按经纬度排序区域影院信息

Request URI:

```
GET /api/cinema/${areaId}/${lat}/${lng} 
```

返回数据为一组*所在区域影院信息（按经纬度排序）*集合

*按经纬度排序区域影院信息* Properties:

| Property | Type | Description |
|----------|------|-------------|
|  id | INTEGER | 影院id |
|  addr | STRING | 影院地址 |
|  brd | STRING | 影城名称 |
|  lat | FLOAT | 经度 |
|  lng | FLOAT | 维度 |
|  imax | BOOLEAN | 是否为IMAX |
|  sellPrice | INTEGER | 票价 |
|  sell | BOOL | 是否在售 falte-否 true-是 |
|  nm | STRING | 影院名 |
|  area | STRING | 区域 |
|  areaId | INTEGER | 区域ID |

Response Example:

```json
{
    "code": 0,
    "data": [
      {
        "id":3,
		"addr":"荔湾区逢源路153号3-5楼（长寿路地铁站恒宝广场北门宝源路红绿灯右转50米）",
		"brd":"华影万晟国际影城",
  		"lat":23.1208,
		"lng":113.239,
		"imax":0,
		"sellPrice":34,"sell":true,
		"nm":"华影万晟国际影城",
		"area":"荔湾区",
		"areaId":5
    ]
	...,
    "message": "OK"
}
```

