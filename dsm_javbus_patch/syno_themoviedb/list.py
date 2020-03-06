#!/usr/bin/python
#-*- coding:utf8 -*-
# By sanyle 2018-05-03

import requests
import re,sys,json,os
from bs4 import BeautifulSoup
def decodetext(text):
    if sys.version_info.major == 2:
        return text.decode("utf-8")
    else:
        return text
def javlist(title):
    url = "https://www.javbus.com/search/"+title+"&type=&parent=ce"
    r = requests.get(url)
    r = r.content.decode("utf-8")
    soup = BeautifulSoup(r,"lxml")
    list = soup.select("#waterfall .item")
    json = {}
    listnum = len(list)
    json['total'] = listnum
    data = []
    for i in range(len(list)):
        if i>3:
            break
        vmsg = {}
        id = list[i].select("date")[0].text
        title = list[i].select(".photo-frame >img")[0].get("title").strip()
        vmsg['summary'] = title
        title = id + " "+ title
        poster = list[i].select(".photo-frame > img")[0].get("src")
        # if poster.find("http")==-1:
        #     poster="https:"+poster
        vmsg['id'] = id
        
        vmsg['sub_title'] = id
        #???????
        if list[i].select(".item-tag")[0].select(".btn-warning"):
            vmsg['caption']=1
            title = decodetext("[??]")+title
        else:
            vmsg['caption']=0
        vmsg['title'] = title
        vmsg['subtype'] = 'movie'
        vmsg['lang'] = 'jpn'
        vmsg['poster'] = poster
        data.append(vmsg)

    json['data'] = data
    return json

def main(argv):
    title = "".join(argv)
    list =  javlist(title)
    data = json.dumps(list, ensure_ascii=False)
    print(data)
if __name__ == '__main__':
    main(sys.argv[1:])