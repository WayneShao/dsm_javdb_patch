#!/usr/bin/python2
#-*- coding:utf8 -*-
# By sanyle 2018-05-03

import requests,sys,os,time, re
from bs4 import BeautifulSoup
import json
import urllib

reload(sys)
sys.setdefaultencoding('utf8')

def getvalues(item):
    values = []
    list = item.select("a")
    for item in list:
        values.append(item.text)
    return values
def decodetext(text):
    if sys.version_info.major == 2:
        return text.decode("utf-8")
    else:
        return text
def getdata(vid):
    if vid.find("-")==-1:
        match = re.findall(r"[\d]+|[a-zA-Z]+",vid)
        vid = "-".join(match)
        if(vid.endswith("-C")):
            vid = vid.replace("-C","C")    
        if(vid.endswith("-c")):
            vid = vid.replace("-c","C")    
    print(vid)
    url = "https://www.javbus.com/"+vid
    r = requests.get(url)
    r = r.content.decode("utf-8")
    soup = BeautifulSoup(r,'lxml')
    list = soup.select(".info")[0].select("p")
    rt = {}
    rt["id"] = vid
    for item in list:
        if item.get("class"):
            for cla in item.get("class"):
                if cla and cla=="header" :
                    if item.text.strip()==decodetext('類別:') and list.index(item)+1 < len(list):
                        rt["genres"] = getvalues(list[list.index(item)+1])
                elif cla and cla=="star-show" and list.index(item)+1 < len(list):
                    rt["actors"] = getvalues(list[list.index(item)+1])
        elif item.select(".header"):
            title=item.select(".header")[0].text
            if title ==decodetext('類別:'):
                rt["genres"] = getvalues(list[list.index(item)+1])
            if title ==decodetext('發行日期:'):
                rt["release_date"] = item.text.replace(decodetext('發行日期:'),"").strip()
            elif title ==decodetext('導演:'):
                rt["directors"] =getvalues(item)
            elif title == decodetext('製作商:'):
                rt["writers"] =getvalues(item)
            elif title == decodetext('系列:'):
                rt["series"] = getvalues(item)
    rt["summary"]=soup.select('h3')[0].text
    rt['backdrop'] = soup.select('.bigImage')[0].select("img")[0].get("src")
    if rt['backdrop'].find("http")==-1:
        if rt['backdrop'].find("https")==-1:
            rt['backdrop']="https://www.javbus.com"+rt['backdrop']

    data = json.dumps(rt, ensure_ascii=False)
    return data

def main(argv):
    vid = argv[0]
    data = getdata(vid)
    print (data)

if __name__ == '__main__':
    main(sys.argv[1:])