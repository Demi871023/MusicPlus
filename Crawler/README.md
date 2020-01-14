# node.js

# Python
#### 相關語法教學

<img src="https://i.imgur.com/lBZkvSy.png">
可以看出它在a標籤裡面，但若我們直接抓取所有a標籤，會把葉庫存檔,類似內容等內容也抓到，所以我們往上一層看，會發現a包覆在h3且class為r的標籤裡面，程式碼：

``` python=
a_tags = soup.select('h3.r a')
for t in a_tags:
    print(t.text)
```
透過以上程式碼可以取得tag之間的文字
<img src="https://i.imgur.com/648PfGW.png">

#### 歌詞爬蟲 Resource
* [Genius Music](https://genius.com)
* [磨鏡歌詞網](https://mojim.com/twznew.htm)

#### 教學連結
* [Python 使用 Beautiful Soup 抓取與解析網頁資料，開發網路爬蟲教學](https://blog.gtwang.org/programming/python-beautiful-soup-module-scrape-web-pages-tutorial/)
* [Python爬蟲學習筆記(一) - Requests, BeautifulSoup, 正規表達式](https://medium.com/@yanweiliu/python爬蟲學習筆記-一-beautifulsoup-1ee011df8768)
* [[Day 08] Beautiful Soup 解析HTML元素](https://ithelp.ithome.com.tw/articles/10204390?sc=iThelpR)
* [爬虫学习——爬虫之soup.select()用法浅析](https://blog.csdn.net/geerniya/article/details/77842421)
* [網路爬蟲Day4 - html檔的解析](https://ithelp.ithome.com.tw/articles/10191259)
* [Python 初學第四講 — 迴圈](https://medium.com/ccclub/ccclub-python-for-beginners-tutorial-4990a5757aa6)
* [學習筆記 Beautiful Soup語法基本使用](https://www.itread01.com/content/1549274594.html)
* [給初學者的 Python 網頁爬蟲與資料分析 (3) 解構並擷取網頁資料](http://blog.castman.net/%E6%95%99%E5%AD%B8/2016/12/22/python-data-science-tutorial-3.html)
* [Python3數據類型轉換](http://tw.gitbook.net/t/python3/article-67.html)


#### Error
1. ~~歌詞裡面夾帶\u3000~~
2. ~~有些歌詞沒有人提供，抓取下來會是空集合，丟入get_lyric裡面會噴error，需要做例外處理~~
3. 魔鏡歌詞網會夾帶[ti:]、[ar:]、[al:]、[by:]
4. 有些歌詞的後面會有 xxx 提供歌詞，利用先抓出該歌詞的那些句子，在進行歌次塞入list的時候進行比對，但此處發生error待修正
<img src="https://i.imgur.com/GbnWxOP.png">
