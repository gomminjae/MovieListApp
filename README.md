# MovieListApp
![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
부스트코스 박스오피스 API를 이용한 영화관련정보 앱

## Study
- Custom Multiple collectionView Cell
- DispatchQueue ayncAfter, DispatchGroup
- Protocol oriented programming (feat. extension)
- Network Callback
- Indicator View 

## Image
<div>
<img width="200" src="https://user-images.githubusercontent.com/48856104/94990165-f48c0000-05b4-11eb-902c-c67b40b749a1.png">
<img width="200" src="https://user-images.githubusercontent.com/48856104/94990177-0bcaed80-05b5-11eb-9f53-fad831d8a868.png">
<img width="200" src="https://user-images.githubusercontent.com/48856104/94990196-2309db00-05b5-11eb-90e6-44d660109932.png">
<img width="200" src="https://user-images.githubusercontent.com/48856104/94990214-3ae15f00-05b5-11eb-80ef-8c667385f96a.png">
<img width="200" src="https://user-images.githubusercontent.com/48856104/94990224-4f255c00-05b5-11eb-8f2a-1249cfaa735e.png">
</div>

## Issue
- ** DetailViewController에서 ViewDidLoad가 호출되었을때 getDetail과 getComment를 실행 -> 정상적으로 api데이터가 넘어오지 않음 
해결: DispatchGroup을 사용하여 순차적으로 네트워킹을 실행함 (enter(), leave()를 사용) notify를 사용하였음 -> 정상적으로 데이터가 넘어옴 (추후 정확하게 이 문제에 대하여 공부를 해볼예정)

- ** api에 넘어오늘 데이터들이 다 옵셔널 타입으로 넘어오게해서 하나씩 옵셔널타입을 풀어줘야했음 
해결: UIViewController에 옵셔널 타입을 풀어주는 함수 (safe())를 extension하여서 만들었음 
