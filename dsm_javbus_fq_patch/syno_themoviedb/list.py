#!/usr/bin/python
#-*- coding:utf8 -*-
# By sanyle 2018-05-03

import requests
import re,sys,json,os
from bs4 import BeautifulSoup

reload(sys)
sys.setdefaultencoding('utf8')

def javlist(title):    
    if title.find("-")==-1:
        match = re.findall(r"[\d]+|[a-zA-Z]+",title)
        title = "-".join(match)
        if(title.endswith("-C")):
            title = title.replace("-C","C")
        if(title.endswith("-c")):
            title = title.replace("-c","C")
    print title
    url = "https://www.javbus.com/search/"+title+"&type=&parent=ce"
    r = requests.get(url)
    r = r.content.decode("utf-8")
    soup = BeautifulSoup(r,"lxml")
    list = soup.select("#waterfall .item")
    json = {}
    listnum = len(list)
    total = listnum
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
        
        if poster.find("http")==-1:
            if poster.find("https")==-1:
                poster="https://www.javbus.com"+poster
        
        vmsg['id'] = id
        
        vmsg['sub_title'] = id
        #是否含有字幕
        if list[i].select(".item-tag")[0].select(".btn-warning"):
            vmsg['caption']=1
            #title = "[字幕]"+title
        else:
            vmsg['caption']=0
        vmsg['title'] = title
        vmsg['subtype'] = 'movie'
        vmsg['lang'] = 'jpn'
        vmsg['poster'] = poster
        data.append(vmsg)
    #搜索无码资源
    url = "https://www.javbus.com/uncensored/search/"+title+"&type=&parent=ce"
    r = requests.get(url)
    r = r.content.decode("utf-8")
    soup = BeautifulSoup(r,"lxml")
    list = soup.select("#waterfall .item")
    json = {}
    listnum = len(list)
    json['total'] = total+listnum
    for i in range(len(list)):
        if i>2:
            break
        vmsg = {}
        id = list[i].select("date")[0].text
        title = list[i].select(".photo-frame >img")[0].get("title").strip()
        vmsg['summary'] = title
        title = id + " "+ title
        poster = list[i].select(".photo-frame > img")[0].get("src")
        if poster.find("http")==-1:
            if poster.find("https")==-1:
                poster="https://www.javbus.com"+poster
        vmsg['id'] = id
        
        vmsg['sub_title'] = id
        #是否含有字幕
        if list[i].select(".photo-info"):
            if list[i].select(".photo-info")[0].select(".btn-warning"):
                vmsg['caption']=1
                title = "[??]"+title
            else:
                vmsg['caption']=0
        vmsg['title'] = title
        vmsg['subtype'] = 'movie'
        vmsg['lang'] = 'jpn'
        vmsg['type']=1
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