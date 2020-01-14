#!/usr/bin/env python
# coding: utf-8


import requests
import urllib
import urllib.parse
import re
from bs4 import BeautifulSoup

URL_ROOT = 'https://music.bugs.co.kr/' # Bugs首頁當作root

#lyric_list 存放一首歌的歌詞list

# 取得歌詞
def get_lyric(url):
    url = urllib.parse.urljoin(URL_ROOT, url)
    response = requests.get(url) # 使用 requests 的 GET method 將網頁抓下來
    soup = BeautifulSoup(response.text, 'lxml') # 將 lxml 指定為解析器
    lyric = soup.find('div', 'lyricsCont')
    lyric_list = list()
    
    a = re.compile('^\[\d+:')
    
    if lyric == None:
        print('No lyric')
        return
    
    for string in lyric.stripped_strings:
        if a.match(string):
            continue
        temp = string.replace("\u3000", " ") # 特殊狀況 \u3000 的排除
        lyric_list.append(temp)
    print(lyric_list)

# 將歌詞的頁面URL，轉變成能夠透過HTML爬蟲取得歌詞的URL
def ReplaceURL(url):
    lyricurl = url.replace("music", "m")
    lyricurl = lyricurl + "?_redir=n"
    return lyricurl


# 從歌手的單個歌曲頁面取得每一首歌的歌詞頁面URL
def GetLyricURL(url):
    url = urllib.parse.urljoin(URL_ROOT, url)
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'lxml')
    lyric = soup.select('td.lyrics a')
    songname = soup.select('td a.btnActions')
    songcount = 0
    count = len(lyric)
    while songcount < count:
        song = songname[songcount].get('track_title')
        print(song)
        tempurl = ReplaceURL(lyric[songcount].get('href'))
        print(tempurl)
        get_lyric(tempurl)
        #for i in songname:
        #print(i.get('track_title'))
        #for i in lyric:
        #temp = i.get('href')
        #temp = ReplaceURL(temp)
        #get_lyric(temp)
        songcount = songcount + 1
    return



# 歌手歌曲頁面URL https://music.bugs.co.kr/search/lyrics?q=마마무&sort=A&page=1
# 歌詞頁面URL https://music.bugs.co.kr/track/3773908
# 轉換後URL https://m.bugs.co.kr/track/3773908?_redir=n'



page = 1
count = 5
    #while page <= count:
    #print(page)
    #url = "https://music.bugs.co.kr/search/lyrics?q=마마무&sort=A&page=" + str(page)
    #print(url)
    #GetLyricURL(url)
    #page = page + 1
GetLyricURL('https://music.bugs.co.kr/search/lyrics?q=마마무&sort=A&page=1')



# url + ?_redir=n


