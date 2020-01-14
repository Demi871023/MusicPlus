#!/usr/bin/env python
# coding: utf-8

import requests
import urllib
import urllib.parse
import re
from bs4 import BeautifulSoup

URL_ROOT = 'http://mojim.com/' # 魔鏡歌詞網首頁當作root
#check = ["ti:", "ar:", "al:", "by:" ]

def get_lyric(url):
    url = urllib.parse.urljoin(URL_ROOT, url)
    response = requests.get(url) # 使用 requests 的 GET method 將網頁抓下來
    soup = BeautifulSoup(response.text, 'lxml') # 將 lxml 指定為解析器
    lyric = soup.find('dl', 'fsZx1')
    garbage = soup.select('ol') # 為了把某些歌詞最後的 xxx 提供歌詞排除掉
    check = list()
    
    for i in garbage:
        check.append(i.text)
    
    #print(notlyric)

    a = re.compile('^\[\d+:')

    lyric_list = list()
    for string in lyric.stripped_strings:
        if string == '更多更詳盡歌詞 在' or string == '※ Mojim.com　魔鏡歌詞網':
            continue
        if a.match(string):
            break
        if string in check[0]:
            continue
        temp = string.replace("\u3000", " ") # 特殊狀況 \u3000 的排除
        lyric_list.append(temp)

    singer = lyric_list.pop(0)
    name = lyric_list.pop(0)
    #lyric_list.pop(-1) # take off [offset:0]
    #lyric_list.pop(-1) # take off [by:Shiny]
    #lyric_list.pop(-1) # take off [al:0]
    #lyric_list.pop(-1) # take off [ar:Ellie Goulding ]
    #lyric_list.pop(-1) # take off [ti:Love Me Like You Do]

    song_detail = {
        'singer':singer,
        'name':name,
        'lyric':lyric_list,
    }
    print(lyric_list)
    #return song_detail

get_lyric('https://mojim.com/twy118727x3x1.htm');
