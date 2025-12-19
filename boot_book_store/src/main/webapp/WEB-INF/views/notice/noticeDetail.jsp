<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>${notice.noticeTitle}</title>

    <!-- 폰트 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">

    <!-- 공지 상세 CSS (boardDetail.css 복붙) -->
    <link rel="stylesheet" href="/css/noticeDetail.css">
</head>

<body>

	<!-- ====================== 헤더 (main.jsp 버전) ====================== -->
	<header>
		<nav class="nav" aria-label="주요 메뉴">
			<a href="<c:url value='/main'/>" class="brand">
				<img src="/img/book_logo.png" alt="책갈피 로고" class="brand-logo" />
				<span class="brand-text" aria-hidden="true"></span>
			</a>

			<!-- 로그인 전/후 분기 -->
			<div class="nav-right">
				<c:choose>
					<c:when test="${empty sessionScope.loginDisplayName}">
						<a href="<c:url value='/login'/>">로그인</a>
						<a href="<c:url value='/register'/>">회원가입</a>
						<a href="<c:url value='/cart'/>">장바구니</a>
					</c:when>

					<c:otherwise>
						<a href="<c:url value='/mypage'/>">마이페이지</a>
						<a href="<c:url value='/cart'/>">장바구니</a>
						<a href="<c:url value='/logout'/>">로그아웃</a>

						<span style="color:#666; font-weight:700;">
							${sessionScope.loginDisplayName}님
						</span>

						<!-- 고객지원 메뉴 (드롭다운) -->
						<div class="admin-dropdown">
							<span class="admin-text">
								고객지원
								<span class="arrow">▼</span>
							</span>

							<div class="admin-menu">
								<a href="<c:url value='/inquiry'/>">1:1 문의</a>

								<c:if test="${sessionScope.userRole == 'ADMIN'}">
									<a href="/adminMain">관리자 모드</a>
								</c:if>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</nav>
	</header>

	<!-- ====================== 프로모션바 (main.jsp 버전) ====================== -->
	<div class="promo" role="note" aria-label="프로모션">
		<div class="promo-content">
			<div class="promo-nav">
				<a href="<c:url value='/Search'/>" class="nav-search">도서</a>
				<a href="<c:url value='/board/list'/>" class="nav-board">게시판</a>
				<a href="<c:url value='/notice/list'/>" class="nav-notice active">공지사항</a>
			</div>
		</div>
	</div>


<!-- ====================== 상세 페이지 ====================== -->
<section class="write-section">
    <div class="write-container">

        <form class="write-form readonly">

            <!-- 제목 -->
            <div class="form-group">
                <label class="form-label">제목</label>
                <input type="text" class="form-input" value="${notice.noticeTitle}" readonly>
            </div>

            <!-- 첨부 이미지 -->
            <div class="form-group">
                <c:choose>
                    <c:when test="${not empty attaches}">
                        <c:forEach var="att" items="${attaches}">
                            <img src="${att.filePath}" alt="${att.fileName}" style="max-width:400px; margin-bottom:20px;">
                        </c:forEach>
                    </c:when>
                </c:choose>
            </div>

            <!-- 내용 -->
            <div class="form-group">
                <textarea class="form-textarea" readonly>${notice.noticeContent}</textarea>
            </div>

            <!-- 정보 테이블 -->
            <table class="info-table">
                <tr>
                    <th>번호</th>
                    <td>${notice.noticeNo}</td>
                </tr>
                <tr>
                    <th>작성일</th>
                    <td>${notice.noticeDate.toLocalDate()}</td>
                    <th>조회수</th>
                    <td>${notice.noticeHit}</td>
                </tr>
            </table>

            <!-- 버튼 -->
            <div class="form-actions">

                <button type="button" class="btn btn-list"
                        onclick="location.href='/notice/list'">
                    목록
                </button>
            </div>

        </form>
    </div>
</section>

</body>
</html>
