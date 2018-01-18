import json
import itertools
import requests
import urllib
import urllib.parse


# first="sinx + cosy plot"
first= "x+y+z =0" #2x+3y+4z=9 plot 3D"
# first ="x^2 + 4y^2 + z^2 =1 plot 3D"
# first ="(-y)^2 + 4x^2 + z^2 =1 plot 3D"
# first = "8x+2*y^2 + 3z^3=1 plot 3D"
txt = urllib.parse.quote_plus(first)


second=first.replace('x', '%temp%',1).replace('y', '(x)',1).replace('%temp%', '(-y)',1)
third = second.replace('x', '%temp%',1).replace('y', '(x)',1).replace('%temp%', '(-y)',1)
fourth = third.replace('x', '%temp%',1).replace('y', '(x)',1).replace('%temp%', '(-y)',1)
first = fourth.replace('x', '%temp%',1).replace('y', '(x)',1).replace('%temp%', '(-y)',1)
print(first)
print(second)
print(third)
print(fourth)

response1 = requests.get("https://api.wolframalpha.com/v2/query?input="+txt+"&format=image,plaintext&output=JSON&appid=HX99W6-2Y4KV3RWQV" )
response2 = requests.get("https://api.wolframalpha.com/v2/query?input="+second+"&format=image,plaintext&output=JSON&appid=HX99W6-2Y4KV3RWQV" )
response3 = requests.get("https://api.wolframalpha.com/v2/query?input="+third+"&format=image,plaintext&output=JSON&appid=HX99W6-2Y4KV3RWQV" )
response4 = requests.get("https://api.wolframalpha.com/v2/query?input="+fourth+"&format=image,plaintext&output=JSON&appid=HX99W6-2Y4KV3RWQV" )

# response = requests.get("https://api.wolframalpha.com/v2/query?input=2x%2B+3y+%2Bz+%3D5+plot+3D&format=image,plaintext&output=JSON&appid=HX99W6-2Y4KV3RWQV" )

# Get the response data as a python object.  Verify that it's a dictionary.
data1 = response1.json()
data2 = response2.json()
data3 = response3.json()
data4 = response4.json()

#For debugging purposes
# data= {'queryresult': {'success': True, 'error': False, 'numpods': 4, 'datatypes': 'Geometry,Plot', 'timedout': '', 'timedoutpods': '', 'timing': 1.887, 'parsetiming': 0.585, 'parsetimedout': False, 'recalculate': '', 'id': 'MSPa367321a23h189fefii910000545d9d9e13ai4344', 'host': 'https://www4d.wolframalpha.com', 'server': '39', 'related': 'https://www4d.wolframalpha.com/api/v2/relatedQueries.jsp?id=MSPa367421a23h189fefii9100003058933381437955&redisFailed=true&s=39', 'version': '2.6', 'pods': [{'title': 'Input interpretation', 'scanner': 'Identity', 'id': 'Input', 'position': 100, 'error': False, 'numsubpods': 1, 'subpods': [{'title': '', 'img': {'src': 'https://www4d.wolframalpha.com/Calculate/MSP/MSP367521a23h189fefii9100005h6h1c6fgg3fhbde?MSPStoreType=image/gif&s=39', 'alt': '3D plot | 2 x + 3 y + z = 5', 'title': '3D plot | 2 x + 3 y + z = 5', 'width': 206, 'height': 32}, 'plaintext': '3D plot | 2 x + 3 y + z = 5'}]}, {'title': 'Surface plot', 'scanner': 'Geometry', 'id': 'SurfacePlot', 'position': 200, 'error': False, 'numsubpods': 1, 'subpods': [{'title': '', 'img': {'src': 'https://www4d.wolframalpha.com/Calculate/MSP/MSP367621a23h189fefii9100000h802fb4230eg5h1?MSPStoreType=image/gif&s=39', 'alt': '', 'title': '', 'width': 300, 'height': 314}, 'plaintext': ''}]}, {'title': 'Geometric figure', 'scanner': 'Geometry', 'id': 'GeometricFigure (ofBoundary)', 'position': 300, 'error': False, 'numsubpods': 1, 'subpods': [{'title': '', 'img': {'src': 'https://www4d.wolframalpha.com/Calculate/MSP/MSP367721a23h189fefii9100005i5i02c8b3g898ic?MSPStoreType=image/gif&s=39', 'alt': 'plane', 'title': 'plane', 'width': 37, 'height': 18}, 'plaintext': 'plane'}], 'states': [{'name': 'Properties', 'input': 'GeometricFigure (ofBoundary)__Properties'}]}, {'title': '3D contour plot', 'scanner': 'Plot', 'id': '3DContourPlot', 'position': 400, 'error': False, 'numsubpods': 1, 'subpods': [{'title': '', 'img': {'src': 'https://www4d.wolframalpha.com/Calculate/MSP/MSP367821a23h189fefii9100001haafa9f0i90d948?MSPStoreType=image/gif&s=39', 'alt': '', 'title': '', 'width': 280, 'height': 300}, 'plaintext': ''}]}]}}
# try:
#     print(data1)
# except Exception as e:
#     raise
# else:
#     pass
# finally:
#     pass
# print("\n\n")
# for k in data1:
#     print(k)
# if(subpod.get("title")=="Surface plot"or subpod.get("title")=="3D plot" or subpod.get("title")=="3D contour plot"): 

S=[]

pods=data1.get("queryresult").get("pods")
for subpod in pods:
    print(subpod)
    if( subpod.get("title")=="3D plot" or subpod.get("title")=="3D contour plot" or subpod.get("title")=="Plot" ): #or subpod.get("title")=="Surface plot" or 
        sbp=subpod.get("subpods")[0]
        print(sbp)
        src = sbp.get("img").get("src")
        S.append(src)
        break

print("-----------******")
pods=data2.get("queryresult").get("pods")
print(data2)
for subpod in pods:
    print(subpod)
    if( subpod.get("title")=="3D plot" or subpod.get("title")=="3D contour plot" or subpod.get("title")=="Surface plot"or subpod.get("title")=="Plot" ): 

     # if(subpod.get("title")=="Surface plot"or subpod.get("title")=="3D plot"): 
        sbp=subpod.get("subpods")[0]
        print(sbp)
        src = sbp.get("img").get("src")
        S.append(src)
        break

print("-----------")
pods=data3.get("queryresult").get("pods")
for subpod in pods:
    print(subpod)
    if( subpod.get("title")=="3D plot" or subpod.get("title")=="3D contour plot" or subpod.get("title")=="Surface plot"or subpod.get("title")=="Plot" ): 

     # if(subpod.get("title")=="Surface plot"or subpod.get("title")=="3D plot"): 
        sbp=subpod.get("subpods")[0]
        print(sbp)
        src = sbp.get("img").get("src")
        S.append(src)
        break

print("-----------")
#     print("-----------")
pods=data4.get("queryresult").get("pods")
for subpod in pods:
    print(subpod)
    if( subpod.get("title")=="3D plot" or subpod.get("title")=="3D contour plot" or subpod.get("title")=="Surface plot"or subpod.get("title")=="Plot" ): 

     # if(subpod.get("title")=="Surface plot"or subpod.get("title")=="3D plot"): 
        sbp=subpod.get("subpods")[0]
        print(sbp)
        src = sbp.get("img").get("src")
        S.append(src)
        break

print("-----------")

print("\n\n\n\n\n\n\n\n")
print(S)