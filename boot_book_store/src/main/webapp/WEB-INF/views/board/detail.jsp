<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>${board.boardTitle} – 게시판</title>

  <link rel="stylesheet" href="/css/main.css">
  <link rel="stylesheet" href="/css/boardDetail.css">
</head>

<body>

<header>
  <nav class="nav">
    <a href="/main" class="brand">
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
          <span style="color:#666; font-weight:700;">
            ${sessionScope.loginDisplayName}님
          </span>
        </c:otherwise>
      </c:choose>
    </div>
  </nav>
</header>
<!-- 상단 프로모션 -->
<div class="promo" role="note" aria-label="프로모션">
	<div class="promo-content">
		<div class="promo-nav">
			<a href="<c:url value='/Search'/>" class="nav-search">도서</a> 
			<a href="<c:url value='/board/list'/>" class="nav-board">게시판</a>
			<a href="<c:url value='/notice/list'/>" class="nav-notice">공지사항</a>

		</div>
	</div>
</div>

<section class="write-section">
  <div class="write-container">

    <form class="write-form readonly">

      <!-- 제목 -->
      <div class="form-group">
        <label class="form-label">제목</label>
        <input type="text" class="form-input" value="${board.boardTitle}" readonly>
      </div>

      <!-- 첨부 이미지 -->
      <div class="form-group">
        <c:if test="${not empty attaches}">
          <c:forEach var="att" items="${attaches}">
            <img src="${att.filePath}" 
                 alt="${att.fileName}" 
                 style="max-width:450px; margin-bottom:20px; border-radius:10px;">
          </c:forEach>
        </c:if>
      </div>

	  <!-- 내용 -->
	        <div class="form-group">
	           <label class="form-label"></label>
	           <textarea class="form-textarea" readonly>${board.boardContent}</textarea>
	        </div>
	        
	        <table class="info-table">
	                  <tr>
	                    <th>번호</th>
	                    <td>${board.boardNo}</td>
	                    <th>작성자</th>
	                    <td>${nickname}</td>
	                  </tr>
	                  <tr>
	                    <th>작성일</th>
	                 <td>
	                   <c:choose>
	                     <c:when test="${not empty board.formattedDate}">
	                       ${board.formattedDate}
	                     </c:when>
	                     <c:otherwise>
	                       <spring:eval expression="board.boardDate != null ? board.boardDate.format(T(java.time.format.DateTimeFormatter).ofPattern('yyyy-MM-dd HH:mm')) : ''" />
	                     </c:otherwise>
	                   </c:choose>
	                 </td>

	                    <th>조회수</th>
	                    <td>${board.boardHit}</td>
	                  </tr>
	                </table>


					<!-- 완료/목록 버튼 -->
					<div class="form-actions">
					    <!-- 작성자와 로그인한 사용자의 ID가 동일할 경우 수정/삭제 버튼 노출 -->
					    <c:if test="${sessionScope.loginId == board.userId}">
					        <div class="form-actions">
					            <button type="button" class="btn btn-edit"
					                    onclick="location.href='${pageContext.request.contextPath}/board/edit/${board.boardNo}'">수정</button>

					            <button type="button" class="btn btn-delete"
					                    onclick="if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/board/delete/${board.boardNo}'">삭제</button>
					        </div>
					    </c:if>

					    <!-- 목록 버튼은 항상 보이게 -->
					    <div class="form-actions">
					        <button type="button" class="btn btn-list"
					                onclick="location.href='${pageContext.request.contextPath}/board/list'">목록</button>
					    </div>
					</div>

					    </form>
					  </div>
					</section>
					    </form>
					  </div>
					</section>

</body>
</html>
