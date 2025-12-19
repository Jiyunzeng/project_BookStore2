<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 – 책갈피</title>

	<!-- Fonts -->
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
   
	<!-- 공지 전용 CSS -->
    <link rel="stylesheet" href="/css/noticeList.css">
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

<!-- 📌 공지 헤더 -->
<div class="boardhead">
    <div class="boardsubwrap">
        <h1>공지사항</h1>
        <p>책갈피 서비스의 최신 안내와 소식을 확인하세요 📢</p>
    </div>
</div>

<!-- 📌 메인 콘텐츠 -->
<div class="main-content">

    <!-- 📌 공지 테이블 -->
    <div class="board-table">

		<div class="table-header">
		    <div class="table-cell">번호</div>
		    <div class="table-cell">제목</div>
		    <div class="table-cell"></div>
		    <div class="table-cell">작성일</div>
		    <div class="table-cell">조회수</div>
		</div>

		<c:forEach var="n" items="${list}">
		    <div class="table-row" onclick="location.href='/notice/detail/${n.noticeNo}'">
		        <div class="table-cell">${n.noticeNo}</div>
		        <div class="table-cell">
		            <span class="post-title">${n.noticeTitle}</span>
		        </div>
		        <div class="table-cell"></div>
		        <div class="table-cell">${fn:substring(n.noticeDate, 0, 10)}</div>
		        <div class="table-cell">${n.noticeHit}</div>
		    </div>
		</c:forEach>

        <!-- 공지 없음 -->
        <c:if test="${empty list}">
            <div class="table-row">
                <div class="table-cell" style="grid-column:1/6; text-align:center; padding:30px;">
                    등록된 공지사항이 없습니다.
                </div>
            </div>
        </c:if>

    </div>

    <!-- 📌 페이지네이션 -->
    <div class="pagination">

        <!-- 이전 블록 -->
        <c:if test="${startPage > 1}">
            <button onclick="location.href='?page=${startPage - 1}'">&lt;</button>
        </c:if>

        <!-- 페이지 번호 -->
        <c:forEach begin="${startPage}" end="${endPage}" var="p">
            <button 
                onclick="location.href='?page=${p}'"
                class="${p == page ? 'active' : ''}">
                ${p}
            </button>
        </c:forEach>

        <!-- 다음 블록 -->
        <c:if test="${endPage < pageCount}">
            <button onclick="location.href='?page=${endPage + 1}'">&gt;</button>
        </c:if>

    </div>

</div>

</body>
</html>
