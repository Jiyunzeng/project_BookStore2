<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>BRAND – 책 찾아보기</title>

<!-- (선택) JS에서 컨텍스트 경로가 필요하면 사용 -->
<meta name="ctx" content="${pageContext.request.contextPath}" />

<!-- Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link
   href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap"
   rel="stylesheet">
<link
   href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap"
   rel="stylesheet">

<!-- External CSS -->
<link rel="stylesheet" href="/css/search.css">

<script>
  const loginId = "${sessionScope.loginId != null ? sessionScope.loginId : ''}";
  console.log("loginId:", loginId);
</script>

</head>
<body data-login-id="${empty sessionScope.loginId ? '' : sessionScope.loginId}">
   <!-- Header -->
   <header>
      <nav class="nav" aria-label="주요 메뉴">
         <a href="<c:url value='/main'/>" class="brand"> <img
            src="/img/book_logo.png" alt="책갈피 로고"
            class="brand-logo" /> <span class="brand-text" aria-hidden="true"></span>
         </a>

         <!-- 로그인 전/후 분기 -->
         <div class="nav-right">
            <c:choose>
               <%-- 로그인 전 --%>
               <c:when test="${empty sessionScope.loginDisplayName}">
                  <a href="<c:url value='/login'/>">로그인</a>
                  <a href="<c:url value='/register'/>">회원가입</a>
                  <a href="<c:url value='/cart'/>">장바구니</a>
               </c:when>

               <%-- 로그인 후 --%>
               <c:otherwise>
                  <a href="<c:url value='/mypage'/>">마이페이지</a>
                  <a href="<c:url value='/cart'/>">장바구니</a>
                  <a href="<c:url value='/logout'/>">로그아웃</a>
                  <span style="color: #666; font-weight: 700;">
                  	  ${sessionScope.loginDisplayName}님 </span>
               </c:otherwise>
            </c:choose>
         </div>
      </nav>
   </header>

   <!-- Sub Header -->
   <section class="subhead">
      <div class="subwrap">
         <div>
            <h1 class="title">책 찾아보기</h1>
            <div class="meta">
               <span id="countText">총 ${fn:length(bookList)}권</span> · 카테고리/정렬로
               골라보세요
            </div>
         </div>
      
      </div>
   </section>

   <!-- Categories -->
   <div class="cats" role="navigation" aria-label="카테고리">
      <div class="cats-inner">
         <div class="cat-left">
            <c:set var="selId"
               value="${empty selectedGenreId ? (empty param.genre_id ? 0 : param.genre_id) : selectedGenreId}" />
            <c:set var="trimQ" value="${empty q ? '' : fn:trim(q)}" />

            <form method="get" action="<c:url value='/Search'/>"
               style="display: inline">
               <input type="hidden" name="q" value="${fn:escapeXml(trimQ)}" /> <input
                  type="hidden" name="genre_id" value="0" />
               <button type="submit" class="cat-btn ${selId == 0 ? 'active' : ''}">전체</button>
            </form>

            <c:forEach var="genre" items="${genreList}">
               <form method="get" action="<c:url value='/Search'/>"
                  style="display: inline">
                  <input type="hidden" name="q" value="${fn:escapeXml(trimQ)}" /> <input
                     type="hidden" name="genre_id" value="${genre.genre_id}" />
                  <button type="submit"
                     class="cat-btn ${selId == genre.genre_id ? 'active' : ''}">
                     ${genre.genre_name}</button>
               </form>
            </c:forEach>
         </div>
         <div class="controls">
            <c:set var="trimQ" value="${empty q ? '' : fn:trim(q)}" />
            <form id="searchForm" class="list-search" role="search" method="get"
               action="<c:url value='/Search'/>">
               <div class="search-box">
                  <input id="q" class="search-input" type="search" name="q"
                     value="${fn:escapeXml(trimQ)}" placeholder="도서명, 저자명으로 검색하세요..."
                     autocomplete="off" />
                  <button class="search-button" type="submit" aria-label="검색">
                     <svg viewBox="0 0 24 24" fill="none" stroke="currentColor"
                        stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                     <circle cx="11" cy="11" r="7"></circle>
                     <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                  </svg>
                  </button>
               </div>
            </form>
         </div>
      </div>
      
   </div>

   <!-- List -->
   <main class="section">
      <div class="container">
         <div id="grid" class="grid"></div>
         <div id="grid2" class="grid hidden" style="margin-top: 24px;"></div>

         <div class="pager" id="pager" style="display: none;">
            <button class="page-btn active" data-page="1">1</button>
            <button class="page-btn" data-page="2">2</button>
         </div>
      </div>
   </main>

   <!-- Footer -->
   <footer style="background: #000; color: #fff; padding: 40px 0">
      <div class="nav"
         style="max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center">
         <div style="font-weight: 800; color: var(- -brand)">BRAND</div>
         <div style="opacity: .8; font-size: 14px">© BRAND BookStore</div>
      </div>
   </footer>

   <!-- 서버 데이터 → JS 배열 -->
   <script>
      const books = [
      <c:forEach var="b" items="${bookList}" varStatus="status">
      {
          id: ${b.book_id},
          title: "${fn:escapeXml(b.book_title)}",
          author: "${fn:escapeXml(b.book_writer)}",
          price: ${b.book_price},
          cat: "${fn:escapeXml(b.genre_id)}"
          <c:if test="${not empty b.book_image_path}">, image: "${fn:escapeXml(b.book_image_path)}"</c:if>
          <c:if test="${not empty b.book_comm}">, tag: "${fn:escapeXml(b.book_comm)}"</c:if>
      }<c:if test="${!status.last}">,</c:if>
      </c:forEach>
      ];
   </script>


   <!-- External JS -->
   <script defer src="/js/search.js"></script>
   
   <!-- URL 파라미터 메시지 처리 -->
   <script>
     document.addEventListener("DOMContentLoaded", function() {
       try {
         const urlParams = new URLSearchParams(window.location.search);
         const message = urlParams.get("message");
         
         // 메시지가 있고 유효한 값일 때만 표시
         if (message !== null && 
             message !== undefined &&
             typeof message === 'string' &&
             message.trim() !== "" && 
             message.trim() !== "null" && 
             message.trim() !== "undefined" &&
             message.toLowerCase().trim() !== "no message available") {
           alert(message.trim());
           // URL에서 메시지 파라미터 제거
           const newUrl = window.location.pathname + 
             (window.location.search.replace(/[?&]message=[^&]*/, '').replace(/^\?/, '') || '');
           window.history.replaceState({}, document.title, newUrl);
         }
       } catch (e) {
         console.error("메시지 처리 오류:", e);
       }
     });
   </script>
</body>
</html>
