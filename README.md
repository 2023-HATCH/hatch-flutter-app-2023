# Pocket Pose : PoPo


<div align="center">

**실시간 온라인 랜덤플레이댄스 및 댄스 숏폼 커뮤니티 앱서비스**


<img src="https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/7c092e0a-4bd4-4dff-8eb5-a08c4af114a8" width=250px>

</div>


### Introduction
> 2023년도 덕성여자대학교 컴퓨터공학과 졸업작품 <br />
> 팀: HATCH <br />
> 개발 기간: 2023.04 ~ 2023.11

### Achivement
> 2023년도 이브와 ICT멘토링 🥉**동상**🥉 수상 (IT여성기업인협회장상) <br/>
> '실시간 랜덤 플레이 댄스 공간 서비스 제공 방법' **특허 출원** (출원 번호: 10-2023-0166410) <br/>
> '실시간 온라인 랜덤 플레이 댄스 플랫폼 설계와 구현' **논문 투고**(ACK 2023)


### Repository
> Frontend: https://github.com/2023-HATCH/hatch-flutter-app-2023 <br />
> Backend: https://github.com/2023-HATCH/hatch-server-2023 <br/>

## Collaborators

| <img src="https://avatars.githubusercontent.com/u/81364415?v=4" width=90px alt="김수빈"/>  | <img src="https://avatars.githubusercontent.com/u/61150378?v=4" width=90px alt="박지혜"/>  | <img src="https://avatars.githubusercontent.com/u/61674991?v=4" width=90px alt="이민영"/>  | <img src="https://avatars.githubusercontent.com/u/86946928?v=4" width=90px alt="문서연"/> |
| :-----: | :-----: | :-----: | :-----: |
| 김수빈(팀장)  | 박지혜 | 이민영 | 문서연 |
| [@Soobin-329](https://github.com/Soobin-329)  | [@jeeheaG](https://github.com/jeeheaG) | [@minWachya](https://github.com/minWachya) | [@devMooon](https://github.com/devMooon) |
|BE, <br/>AI Leader|BE Leader,<br/>Infra Manager|FE Leader,<br/>UI Design|FE, UI Design,<br/>Data Preprocessing Leader| 

<br/>

## Service Architecture

![Service Architecture](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/51c003b9-6eb5-4ef6-833c-3ed695f80b36)


* Frontend Tech Stack 🛠

    <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=Flutter&logoColor=white">
    <img src="https://img.shields.io/badge/MLKit-2396f3?style=flat-square&logo=kit&logoColor=white">
    <img src="https://img.shields.io/badge/Mediapipe-007A73?style=flat-square&logo=Plotly&logoColor=white">

<br/>

* Backend Tech Stack 🛠

    <img src="https://img.shields.io/badge/Spring boot-6DB33F?style=flat-square&logo=Spring boot&logoColor=white">
    <img src="https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=Docker&logoColor=white">
    <img src="https://img.shields.io/badge/Jenkins-D24939?style=flat-square&logo=Jenkins&logoColor=white">
    <img src="https://img.shields.io/badge/Redis-DC382D?style=flat-square&logo=Redis&logoColor=white">
    <img src="https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=MySQL&logoColor=white">
    <img src="https://img.shields.io/badge/JUint5-25A162?style=flat-square&logo=JUnit5&logoColor=white">
    <br/>
    <img src="https://img.shields.io/badge/Amazon EC2-FF9900?style=flat-square&logo=Amazon EC2&logoColor=white">
    <img src="https://img.shields.io/badge/Amazon RDS-527FFF?style=flat-square&logo=Amazon RDS&logoColor=white">
    <img src="https://img.shields.io/badge/Amazon S3-569A31?style=flat-square&logo=Amazon S3&logoColor=white">
    <br/>
    <img src="https://img.shields.io/badge/Flask-000000?style=flat-square&logo=Flask&logoColor=white">
    <img src="https://img.shields.io/badge/Pytorch-EE4C2C?style=flat-square&logo=Pytorch&logoColor=white">

    * Others
        - WebSocket & STOMP
        - Spring Security & JWT
        - Spring Rest Docs & JUnit
        - Hibernate Bean Validator
        - Data JPA
        - Lombok
        - Slf4j

<br/>

## Main Feature
-	**커뮤니티** : 짧은 춤 영상을 공유하는 공간
    * **홈** : 사용자가 업로드한 짧은 춤 영상들을 조회
    * **1대1 채팅** : 다른 사용자와 실시간으로 메시지를 주고받으며 소통
    * **영상 업로드** : 카메라로 바로 촬영하거나 갤러리에 있던 동영상을 커뮤니티에 업로드함
-	**스테이지** : 온라인으로 댄스 챌린지를 즐길 수 있는 공간
    * **스테이지 진행**
        * **대기** : 사용자가 3명 이하일 경우 대기화면에서 대기함. 3명 이상이 되면 캐치를 시작함
        * **캐치** : 랜덤으로 선택된 노래와 노래 정보가 나옴. 해당 노래의 춤을 알고 있으며 플레이 참여를 원하는 사용자들이 캐치 버튼을 누름
        * **플레이** : 캐치 버튼을 누른 선착순 3명이 플레이어가 되어 카메라 앞에서 노래에 맞춰 춤을 춤. 춤추는 모습을 다른 사용자들은 함께 관람하며 즐김
        * **결과(AI 안무 유사도)** : 정답 춤과의 안무 유사도를 계산하여 가장 유사하게 춤춘 사용자가 MVP 로 선정되고 MVP 세리머니 시간이 제공됨. 위 과정을 반복함
    
    * **라이브 소통** : 실시간 채팅 메세지 및 반응을 전송할 수 있음



## Preview
[![PoPo Introduction Video](https://img.youtube.com/vi/6maF_XW2snk/popo.jpg)](https://youtu.be/6maF_XW2snk)


## Service Introduction
![슬라이드1](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/b16ce13f-be62-486d-a9f4-9609b80c6967)
![슬라이드3](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/f63755a9-c4d4-41e5-9654-62fcdfaf511b)
![슬라이드4](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/b9872915-71d9-4dda-b72f-68ed8cfd9acd)
![슬라이드14](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/47fb194f-9ea1-4bb8-93d4-36ee5d7d5be7)
![슬라이드6](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/4a8c9ded-2874-4147-ac22-942f64140776)
![슬라이드7](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/024e5295-42f2-4c74-8af9-4cef4f4be6f1)
![슬라이드8](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/da346366-dc32-48a5-991c-68009327922e)
![슬라이드9](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/1bcb4300-3b35-4bd5-ac19-2a420decca90)
![슬라이드10](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/f6c974f8-7bfd-4dd1-afe4-175ec867fdd1)
![슬라이드16](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/7856fbd0-dd7f-4526-ab34-b7e2712f7c44)
![슬라이드17](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/7c8b5d0d-45b2-4a9b-9a95-7df4b9111904)
![슬라이드18](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/c99944c9-9f40-4bee-93ab-4de66dee3c57)
![슬라이드15](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/309e3e56-bc8e-436b-a4aa-d4d08fa75557)
![슬라이드16](https://github.com/2023-HATCH/hatch-server-2023/assets/81364415/232ef20f-e90e-4d8e-86e0-a5b15440e2a6)
