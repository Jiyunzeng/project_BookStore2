<div align="center">

# 📚 온라인 북스토어(책갈피)  
### Spring Boot · MyBatis · Oracle 기반 온라인 도서 판매 플랫폼

<br>


<img src="https://img.shields.io/badge/Java-17-007396?logo=java">
<img src="https://img.shields.io/badge/SpringBoot-2.7-6DB33F?logo=springboot">
<img src="https://img.shields.io/badge/Oracle-F80000?logo=oracle">
<img src="https://img.shields.io/badge/MyBatis-000000">
<img src="https://img.shields.io/badge/JSP-F7DF1E?logo=html5">

<br>

<img src="https://img.shields.io/badge/Toss Payments-0055FF">
<img src="https://img.shields.io/badge/Gemini API-8E75B2">
<img src="https://img.shields.io/badge/Gradle-02303A?logo=gradle&logoColor=white">
<img src="https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white">


<br><br>
</div>

---

## 📖 프로젝트 개요

온라인 북스토어는 **도서 검색, 장바구니, 결제, 주문 관리** 기능을 제공하는  
웹 기반 쇼핑몰 프로젝트입니다.

- 개발 기간 : 1차: `2025.10.13 ~ 2025.10.19`, 2차: `2025.11.13 ~ 2025.11.20`
- 개발 인원 : `7명`

---

## 👨‍💻 담당 역할

| 역할/영역 | 담당 내용 |
|---|---|
| 🖥 프론트엔드 개발 | 메인 페이지, 카테고리 페이지, 게시판, 마이페이지, 장바구니, 로그인, 회원가입 UI 및 화면 흐름 구현 |
| 📝 게시판 기능 (풀스택) | 게시판 DB 설계 및 게시글 등록·조회·수정·삭제(CRUD) 기능 백엔드·프론트엔드 통합 구현 |
| ⭐ 추천 도서 | 메인 페이지 추천 도서(도시/테마) 영역 데이터 조회 및 화면 출력 기능 구현 |
| 🗄 DB 연동 | 게시판 및 메인 추천 영역 데이터베이스 연동 처리 |

---

### ✨ 주요 특징 
  - 🤖 **Google Gemini 기반 챗봇 기능**  
    → 챗봇 기능 구현
  
  - 💳 **Toss Payments API 결제 연동**  
    → 결제 요청 → 승인 API까지 전체 결제 프로세스 구현
  
  - 🔐 **세션 기반 인증 시스템**  
    → 로그인/회원가입, 소셜 로그인(Naver/Google), 권한 구분 처리
  
  - 🛠 **관리자 페이지 구축**  
    → 도서 관리(등록/수정/삭제), 권한 관리, 회원 관리, 게시판 관리, 주문 관리
  
  - 📚 **사용자 커뮤니티 기능**  
    → 리뷰, 댓글, 사용자 게시판, 공지사항 기능 제공

---

## 🛠 기술 스택

| 분야 | 기술 |
|------|-------|
| **Frontend** | <img src="https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white"> <img src="https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white"> <img src="https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black"> <img src="https://img.shields.io/badge/jQuery-0769AD?style=flat-square&logo=jquery&logoColor=white"> |
| **Backend** | <img src="https://img.shields.io/badge/JSP-FF4000?style=flat-square"> <img src="https://img.shields.io/badge/Java-007396?style=flat-square&logo=java&logoColor=white"> <img src="https://img.shields.io/badge/Spring%20Boot-6DB33F?style=flat-square&logo=springboot&logoColor=white"> <img src="https://img.shields.io/badge/Lombok-ED1C24?style=flat-square"> <img src="https://img.shields.io/badge/MyBatis-000000?style=flat-square"> |
| **Database** | <img src="https://img.shields.io/badge/Oracle%20Database-F80000?style=flat-square&logo=oracle&logoColor=white"> |
| **Infra / Server** | <img src="https://img.shields.io/badge/Apache%20Tomcat-F8DC75?style=flat-square&logo=apachetomcat&logoColor=black"> |
| **API / External Services** | <img src="https://img.shields.io/badge/Toss%20Payments%20API-4945FF?style=flat-square"> <img src="https://img.shields.io/badge/Google%20Gemini%20API-8E75B2?style=flat-square"> |
| **Build Tool** | <img src="https://img.shields.io/badge/Gradle-02303A?style=flat-square&logo=gradle&logoColor=white"> |
| **Tools** | <img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white"> <img src="https://img.shields.io/badge/STS-6DB33F?style=flat-square&logo=spring&logoColor=white"> <img src="https://img.shields.io/badge/SourceTree-0052CC?style=flat-square&logo=sourcetree&logoColor=white"> |


---

## 🧩 기능 구성 (클릭해서 보기)

<details>
<summary><strong>🛍 사용자 기능</strong></summary>

- 도서 검색 / 카테고리별 조회  
- 도서 상세보기 (리뷰, 평점 포함)  
- 찜(좋아요) 목록 관리  
- 장바구니 (추가, 수량 변경, 삭제)  
- 도서 결제(Toss Payments API)  
- 주문 생성 / 주문 내역 조회  

</details>

<details>
<summary><strong>🔐 회원 기능</strong></summary>

- 회원가입 / 로그인 / 로그아웃  
- 소셜 로그인(Naver / Google)  
- 아이디·비밀번호 찾기  
- 마이페이지(조회, 수정, 삭제)  
- 탈퇴 회원 관리  
- 찜한 도서 목록 확인  

</details>

<details>
<summary><strong>💬 커뮤니티 기능</strong></summary>

- 사용자 게시판(글 작성, 수정, 조회, 삭제)  
- 사용자 공지사항(공지 조회)  
- 1대1 문의  

</details>

<details>
<summary><strong>🤖 AI 기능</strong></summary>

- Gemini API 기반 챗봇  
- 사용자 질문 자동 응답  

</details>

<details>
<summary><strong>🛠 관리자 기능</strong></summary>

- **회원 관리** (상태 변경, 탈퇴 회원 관리)  
- **도서 관리** (등록 / 수정 / 삭제)  
- **게시판 관리** (사용자 게시판·공지사항)  
- **주문 관리** (주문 리스트, 주문 상세)  
- 문의 리스트 관리  

</details>

<details>
<summary><strong>🚀 기타 기능</strong></summary>

- 페이징, 검색  
- 세션 기반 로그인 인증 처리  

</details>

---

## 🧭 메뉴 구조도 (PDF)

📄 메뉴 구조도 다운로드  
👉 [menu_structure_online_bookstore.pdf](https://github.com/user-attachments/files/24016562/menu_structure_online_bookstore.pdf)

---

## 🖥 화면 설계서 (PDF)

📄 화면 설계서 보기  
👉 [online-bookstore-ui-design.pdf](https://github.com/user-attachments/files/24016616/online-bookstore-ui-design.pdf)

---

## 🗂 ERD 및 테이블 명세서

📄 ERD  
<details> <summary><strong>ERD 다이어그램</strong></summary>

<img width="1467" height="2106" alt="image" src="https://github.com/user-attachments/assets/443ac567-965d-4d8c-b105-995308a2aff7" />

</details>

📄 테이블 명세서  
👉 [database-table-definition.xlsx](https://github.com/user-attachments/files/24016641/database-table-definition.xlsx)

---

## 🔍 담당 기능

---

## 📬 프로젝트 구조

```plaintext
📦 boot_bookstore_store
├─ src/main/java
│  ├─ com.boot.config
│  ├─ com.boot.controller
│  ├─ com.boot.dao
│  ├─ com.boot.dto
│  └─ com.boot.mapper
│  ├─ com.boot.service
│
├─ src/main/resources
│  ├─ mybatis.mappers
│  ├─ static
│  ├─ application.properties
│  └─ mybatis-config.xml
│ 
└─ src/main/webapp/WEB-INF
   └─ views
      ├─ admin
      ├─ board
      ├─ Book
      ├─ inquiry
      ├─ MyPage
      └─ notice
```

---

## 🚀 시연 영상 & 데모

아래 영상은 온라인 북스토어(책갈피)의 주요 기능을 실제 화면과 함께 보여줍니다.  
각 기능별 동작 방식과 흐름을 직관적으로 확인할 수 있습니다.

### 📌 전체 시연 영상
🔗 YouTube 링크: https://youtu.be/3Dzys_04iNE (사용자)<br>
🔗 YouTube 링크: https://youtu.be/qynV_2sgY8g (관리자)

---


