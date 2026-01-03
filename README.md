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

### 👨‍💻 담당 역할

| 역할/영역 | 담당 내용 |
|---|---|
| 🧑‍🏫 팀장 | 일정 관리, 업무 분배, 코드 리뷰 및 프로젝트 총괄 |
| 🗂 DB 설계 | **유저 테이블 구조 설계** |
| 🔐 인증/인가 | **로그인**, **소셜 로그인**, **이메일 인증** |
| 👤 사용자 기능 | **회원가입**, **아이디/비밀번호 찾기**, **회원탈퇴** |
| 🛠 관리자 기능 | **대시보드**, **게시물 관리**, **주문 내역 관리** |
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

## ⭐ 담당 기능 핵심 로직 및 구현 상세
### 1. 게시판 목록 조회·검색·페이징 통합 구현
게시글 수 증가에 대비하여
목록 조회, 검색, 페이징이 함께 동작하는 게시판 구조를 설계·구현했습니다.
**동작 흐름**:
요청 페이지 → offset 계산 → DB 페이징 조회 →
검색 조건 적용 → 페이지 그룹 계산 → JSP 렌더링
- 게시판 목록·상세 조회 기능 구현
- 한 페이지당 게시글 수(size) 조절 가능
- 페이지 그룹(startPage / endPage) 계산으로 UX 개선
- 제목 / 내용 / 작성자 / 제목+내용 검색 지원
- 검색 결과에서도 동일한 페이징 UI 유지
**성과**: 
검색 여부와 관계없이 일관된 사용자 경험을 제공하고,
대량 데이터 환경에서도 안정적인 목록 조회 구조를 확보했습니다.

<details>
<summary><strong>🔍 게시판 페이징 조회 SQL 보기</strong></summary>

```sql
SELECT * FROM (
  SELECT ROWNUM rn, t.*
  FROM (
    SELECT *
    FROM board
    ORDER BY board_no DESC
  ) t
  WHERE ROWNUM <= #{offset} + #{size}
)
WHERE rn > #{offset}
```
</details>

### 2. 게시판 검색 + 페이징 동적 SQL 구현
검색 조건에 따라 SQL이 동적으로 변경되도록
MyBatis 동적 SQL 기반 검색 로직을 구현했습니다.

**동작 흐름**:
- 검색 타입(type)에 따라 조건 분기
- <choose>, <when> 문법 활용
- 검색 결과 개수 기준 페이지네이션 자동 계산
**성과**:
중복 쿼리 없이 유연한 검색 구조를 구성하여 유지보수성을 향상시켰습니다.

<details> 
<summary><strong>🔍 검색 조건 동적 SQL 보기</strong>

```xml
<choose>
  <when test="type == 'title'">
    board_title LIKE '%' || #{keyword} || '%'
  </when>
  <when test="type == 'content'">
    board_content LIKE '%' || #{keyword} || '%'
  </when>
  <when test="type == 'writer'">
    user_id LIKE '%' || #{keyword} || '%'
  </when>
  <otherwise>
    board_title LIKE '%' || #{keyword} || '%'
    OR board_content LIKE '%' || #{keyword} || '%'
  </otherwise>
</choose>
```
</details>


### 3. 게시글 등록·수정·삭제 및 파일 첨부 처리
게시판 CRUD 전반을 풀스택으로 구현하고,
다중 이미지 첨부 기능을 함께 적용했습니다.
**동작 흐름**:
게시글 작성 → 파일 업로드 → 날짜별 디렉토리 저장 →
DB 메타데이터 저장 → 상세 페이지 출력

- 게시글 등록 / 수정 / 삭제 기능 구현
- 다중 이미지 업로드 지원 (MultipartFile)
- 날짜별 디렉토리 구조로 파일 저장
- 기존 파일 유지 + 선택 삭제 + 추가 업로드 처리
- 게시글 삭제 시 첨부 파일도 함께 정리

**성과**:
실제 서비스에서 사용 가능한 안정적인 파일 관리 게시판 구조를 구현했습니다.

### 4. 게시글 수정·삭제 권한 제어
게시글 수정 및 삭제는 작성자 또는 관리자만 가능하도록 권한을 제한했습니다.
- 세션 기반 로그인 사용자 검증
- 작성자 본인 여부 확인
- 관리자 권한(role=ADMIN) 예외 처리
- 권한 없는 접근 시 목록 페이지로 리다이렉트

**성과**:
권한 없는 접근을 방지하여 게시판 데이터 안정성과 신뢰성을 확보했습니다.

### 5. 메인 페이지 추천 도서 기능 구현
메인 페이지에서 사용자 상태에 따라
추천 도서 로직이 다르게 동작하도록 구현했습니다.
**동작 흐름**:
- 비로그인 사용자 → 랜덤 도서 추천
- 로그인 사용자 → 구매 이력 기반 추천 도서 제공
- 서버에서 추천 데이터 가공 후 JSP 렌더링

**성과**:
사용자 상태를 고려한 추천 로직으로
서비스 개인화 경험을 강화했습니다.

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


