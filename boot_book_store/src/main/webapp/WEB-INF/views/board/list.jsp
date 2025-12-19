<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>게시판 – 책갈피</title>

  <!-- Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">


  <link rel="stylesheet" href="/css/board.css">
</head>

<body>
<header>
  <nav class="nav">
    <a href="<c:url value='/main'/>" class="brand">
      <img src="/img/book_logo.png" class="brand-logo">
    </a>

    <div class="nav-right">
      <c:choose>
        <c:when test="${empty sessionScope.loginDisplayName}">
          <a href="/login">로그인</a>
          <a href="/register">회원가입</a>
          <a href="/cart">장바구니</a>
        </c:when>
        <c:otherwise>
          <a href="/mypage">마이페이지</a>
          <a href="/cart">장바구니</a>
          <a href="/logout">로그아웃</a>
          <span style="font-weight:700; color:#666;">
            ${sessionScope.loginDisplayName}님
          </span>
        </c:otherwise>
      </c:choose>
    </div>
  </nav>
</header>


<!-- ===================================================== -->
<!-- 상단 헤더 이미지(책갈피 style) -->
<!-- ===================================================== -->
<section class="boardhead">
  <div class="boardsubwrap">
    <h1>게시판</h1>
    <p>도서관 관련 소식과 정보를 공유하는 공간입니다</p>
  </div>
</section>


<!-- ===================================================== -->
<!-- Main Content -->
<!-- ===================================================== -->
<main class="main-content">

  <!-- 검색 & 글쓰기 -->
  <div class="board-controls">

    <!-- 검색 -->
    <form method="get" action="/board/list" class="search-box">
      <input type="hidden" name="size" value="${size}"/>

      <select name="type" style="border:none; background:transparent; font-size:14px;">
        <option value="tc" ${type=='tc'?'selected':''}>제목+내용</option>
        <option value="title" ${type=='title'?'selected':''}>제목</option>
        <option value="content" ${type=='content'?'selected':''}>내용</option>
        <option value="writer" ${type=='writer'?'selected':''}>작성자</option>
      </select>

      <input type="text" name="keyword" placeholder="검색어 입력..."
             value="${fn:escapeXml(keyword)}"/>

      <button type="submit">검색</button>
    </form>

    <!-- 글쓰기 -->
    <a href="/board/write" class="write-btn">글쓰기</a>
  </div>



  <!-- ===================================================== -->
  <!-- 게시판 테이블 -->
  <!-- ===================================================== -->
  <div class="board-table">

    <!-- 헤더 -->
    <div class="table-header">
      <div class="table-cell">번호</div>
      <div class="table-cell">제목</div>
      <div class="table-cell">작성자</div>
      <div class="table-cell">작성일</div>
      <div class="table-cell">조회</div>
    </div>

    <!-- 목록 -->
    <c:choose>
      <c:when test="${empty list}">
        <div class="table-row">
          <div class="table-cell" style="grid-column:1 / 6; padding:30px; text-align:center;">
            등록된 게시물이 없습니다.
          </div>
        </div>
      </c:when>

      <c:otherwise>
        <c:forEach var="b" items="${list}">
          <div class="table-row">

            <div class="table-cell">${b.boardNo}</div>

            <div class="table-cell" style="justify-content:flex-start;">
              <a class="post-title"
                 href="/board/detail?boardNo=${b.boardNo}">
                 ${b.boardTitle}
              </a>
            </div>

            <div class="table-cell post-author">${b.userNickname}</div>
            <div class="table-cell">${fn:substring(b.formattedDate, 0, 10)}</div>
            <div class="table-cell post-views">${b.boardHit}</div>

          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>

  </div>



  <!-- ===================================================== -->
  <!-- Pagination -->
  <!-- ===================================================== -->
  <div class="pagination">

    <!-- 이전 -->
    <c:if test="${startPage > 1}">
      <a href="/board/list?page=${startPage-1}&size=${size}&type=${type}&keyword=${keyword}">
        <button>&lt;</button>
      </a>
    </c:if>

    <!-- 페이지 번호 -->
    <c:forEach var="i" begin="${startPage}" end="${endPage}">
      <a href="/board/list?page=${i}&size=${size}&type=${type}&keyword=${keyword}">
        <button class="${i == page ? 'active' : ''}">${i}</button>
      </a>
    </c:forEach>

    <!-- 다음 -->
    <c:if test="${endPage < pageCount}">
      <a href="/board/list?page=${endPage+1}&size=${size}&type=${type}&keyword=${keyword}">
        <button>&gt;</button>
      </a>
    </c:if>

  </div>

</main>

</body>
</html>
