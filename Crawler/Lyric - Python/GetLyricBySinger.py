#!/usr/bin/env python
# coding: utf-8


import requests
import urllib
import urllib.parse
import re
from bs4 import BeautifulSoup

URL_ROOT = 'http://mojim.com/' # 魔鏡歌詞網首頁當作root
MOJIM_ROOT_URL = 'http://mojim.com'


def get_lyric(url):
    url = urllib.parse.urljoin(URL_ROOT, url)
    response = requests.get(url) # 使用 requests 的 GET method 將網頁抓下來
    soup = BeautifulSoup(response.text, 'lxml') # 將 lxml 指定為解析器
    lyric = soup.find('dl', 'fsZx1')
    if lyric == None:
        print('No lyric')
        return
    
    a = re.compile('^\[\d+')
    
    lyric_list = list()
    for string in lyric.stripped_strings:
        if string == '更多更詳盡歌詞 在' or string == '※ Mojim.com　魔鏡歌詞網':
            continue
        if a.match(string):
            break
        lyric_list.append(string)

    singer = lyric_list.pop(0)
    name = lyric_list.pop(0)

    print(lyric_list)


def get_song_href(url):
    url = urllib.parse.urljoin(URL_ROOT, url)
    response = requests.get(url) # 使用 requests 的 GET method 將網頁抓下來
    soup = BeautifulSoup(response.text, 'lxml') # 將 lxml 指定為解析器
    each_content = soup.find_all('dd', 'hb3')
    href_list = soup.find_all('a') # 透過 tag a 搜尋所有元素，回傳一個該元素類別的陣列
    
    #for tag in each_content:
    #print(tag.string)
    
    #selector = ".hc1 a"
    #elem = soup.select(selector)


    
    #相關教學：https://ithelp.ithome.com.tw/articles/10204390?sc=iThelpR

    song_tags_one = soup.select('span.hc3 a')
    song_tags_two = soup.select('span.hc4 a')

    

    for i in song_tags_one:
        songname = i.text
        print(songname)
        songhref = i.get('href')
        print(songhref)
        GET_LYRIC_URL = MOJIM_ROOT_URL + songhref
        get_lyric(GET_LYRIC_URL)

    for i in song_tags_two:
        songname = i.text
        #print(songname)
        songhref = i.get('href')
        #print(songhref)
    




get_song_href('https://mojim.com/twh100951.htm');
