# 이집어때 (Ijib)

> 당신이 찾던 변치 않는 단 하나의 백년가게

---

### 1. 프로젝트 소개

- **이집어때**는 백년가게를 한곳에서 탐색하고 다양한 조건으로 검색할 수 있는
  맛집 추천 및 정보 제공 웹 서비스입니다.
- 지역, 음식 종류, 가격대, 특징 등을 기준으로 맛집을 검색할 수 있으며,
  맛집 상세 정보, 리뷰, 북마크, 게시판, 챗봇, 구독 및 결제 기능을 제공합니다.

---

### 2. 기술 스택 (Tech Stack)

| 구분 | 기술 |
|---|---|
| **Backend** | Java 17, Spring Boot 3.5.15, Spring Security, MyBatis |
| **Frontend** | JSP, JSTL, HTML5, CSS3, JavaScript |
| **Database** | Oracle DB |
| **Search / Analysis** | Elasticsearch 7.10.1, Kibana |
| **Build / Server** | Gradle, Apache Tomcat 10.1 |
| **External API** | Kakao Maps API, Mailtrap Email API, PortOne 결제 API |

---

### 3. 프로젝트 주요 기능 (Key Features)

* **회원 및 권한 관리**
  * 회원가입 및 로그인
  * Spring Security 기반 인증 및 권한 관리
  * 회원정보 수정 및 탈퇴
  * 아이디 찾기 / 비밀번호 찾기
  * 가입 완료 이메일 발송

* **맛집 검색**
  * 통합검색 및 식당명 검색
  * Elasticsearch 기반 검색 기능
  * 검색어 자동완성
  * 지역 / 음식 종류 / 가격대 / 특징별 조건 검색
  * 검색 데이터 기반 통계 및 분석

* **맛집 정보**
  * 백년가게 목록 조회
  * 음식 종류 및 지역별 탐색
  * 맛집 상세 정보 및 메뉴 조회
  * Kakao Map을 이용한 위치 정보 제공
  * 맛집 리뷰 작성 및 조회

* **회원 편의 기능**
  * 맛집 북마크
  * 마이페이지
  * 나의 게시글 및 리뷰 조회
  * 구독권 조회 및 관리

* **게시판**
  * 게시글 작성 / 수정 / 삭제
  * 비밀글 기능
  * 관리자 답변 기능

* **챗봇**
  * 맛집 탐색을 위한 챗봇 기능 제공

* **구독 및 결제**
  * 구독권 구매
  * PortOne 결제 API 연동
  * 결제 내역 조회
  * 구독 취소 및 환불 처리

---

### 4. 관리자 (Admin)

* 회원 관리
* 음식점 정보 관리
* 게시판 관리
* 비밀글 답변 관리
* 구독권 관리
* 결제 및 환불 관리

---

### 5. 업무 분장 (Division of Work)

| 직책 / 역할 | 담당 영역 | 주요 수행 업무 |
| :--- | :--- | :--- |
| **팀원 김도연** | 구독권 / 음식점 / 검색창 | • 구독권·음식점 관리 Controller, DAO, DTO, View 구현<br>• Elasticsearch 검색 연동 및 통계<br>• 아이디·비밀번호 찾기<br>• 이메일 API 연동 |
| **팀원 박보성** | 자료 수집 / 결제 | • 백년가게 자료 수집 및 데이터 정제<br>• 결제·환불 API Controller, DAO, DTO, View 구현<br>• 챗봇 구현 |
| **팀원 최민식** | 게시판 | • 게시판 관련 Controller, DAO, DTO, View 구현<br>• 프론트/백엔드 데이터 유효성 검사(Validation) 및 통합 QA 테스트 총괄 |
| **팀원 허지은** | 회원 / 보고서 | • 회원가입, 로그인/로그아웃, 비밀번호 확인 및 회원정보 수정/탈퇴 구현<br>• 프로젝트 최종 보고서 및 발표 자료 작성 |

---

### 6. Elasticsearch

* Elasticsearch를 활용한 맛집 검색 기능 구현
* 검색어 자동완성 구현
* 검색 로그 데이터 수집
* 성별 / 연령 / 지역 / 검색어 등의 검색 데이터 분석
* Kibana를 활용한 검색 통계 시각화

---

### 7. 주요 구현 내용

* Spring Security를 활용한 인증 및 권한 처리
* MyBatis 기반 DB 접근 및 SQL 관리
* Kakao Maps API를 활용한 맛집 위치 정보 제공
* Mailtrap Email API를 활용한 이메일 발송 및 비밀번호 찾기 인증번호 발송
* PortOne API를 활용한 결제 및 환불 기능 구현
* JavaScript를 활용한 검색 자동완성 및 사용자 인터랙션 구현

---

### 8. 주요 화면

### 🏠 메인 페이지
<img width="1902" height="906" alt="image" src="https://github.com/user-attachments/assets/ccf14675-03f6-463a-a750-0e4bfdaedcb1" />

<br>

### 🔍 맛집 검색
<img width="771" height="568" alt="image2" src="https://github.com/user-attachments/assets/7790a3bc-227f-4d8e-8f15-64681de8e2c6" />
<img width="1024" height="636" alt="image2_1" src="https://github.com/user-attachments/assets/09261a8d-cd53-4de2-98f2-c66f3cfda693" />

<br>

### 🍽️ 맛집 상세
<img width="986" height="872" alt="image3_4" src="https://github.com/user-attachments/assets/f814601a-5fef-4dda-a27f-228437063b12" />
<img width="767" height="497" alt="image3" src="https://github.com/user-attachments/assets/4e6d709e-d29c-4905-a8ee-5ff5c657896e" />
<img width="768" height="779" alt="4" src="https://github.com/user-attachments/assets/fea1fb0c-9a52-4536-a75d-910368bbedb4" />

<br>

### 👤 마이페이지
<img width="1122" height="725" alt="image5" src="https://github.com/user-attachments/assets/7076ec5f-ba73-4933-9e8d-9bd92cfaedb8" />

