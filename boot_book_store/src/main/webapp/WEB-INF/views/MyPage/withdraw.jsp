<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원 탈퇴 | 책갈피</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  

  <!-- 구매내역과 동일 톤의 배너가 필요하면 CSS만 이 파일과 동일하게 사용 -->
  <link rel="stylesheet" href="/css/withdraw.css">
</head>
<body>
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="<c:url value='/main'/>" class="brand">
        <img src="/img/book_logo.png" alt="책갈피 로고" class="brand-logo"/>
      </a>
      <div class="nav-right">
        <span id="userGreeting" style="color:var(--brand); font-weight:700;">
          <c:choose>
			<c:when test="true">
			  마이페이지
			</c:when>
		  </c:choose>
        </span>
          <a href="<c:url value='/cart'/>">장바구니</a>
          <a href="<c:url value='/logout'/>">로그아웃</a>
          <span style="color:#666; font-weight:700;">
            ${sessionScope.loginDisplayName}님
      </div>
    </nav>
  </header>

  <div class="promo" aria-hidden="true"></div>

<main class="page-wrap">
  <div class="page-container">
    <h1 class="page-title">회원 탈퇴</h1>
    <div class="tab-nav">
      <button class="tab-button" onclick="location.href='<c:url value="/mypage"/>'">정보</button>
      <button class="tab-button" onclick="location.href='<c:url value="/mypage/edit"/>'">내정보 수정</button>
	  <button class="tab-button" onclick="location.href='<c:url value="/wishlist"/>'">찜 목록</button>
      <button class="tab-button" onclick="location.href='<c:url value="/MyPage/purchaseList"/>'">구매내역</button>
      <button class="tab-button active" onclick="location.href='<c:url value="/mypage/withdraw"/>'">회원탈퇴</button>
    </div>

    <div class="content-card">
      <div class="withdraw-container">
        <h2 class="withdraw-title">회원 탈퇴</h2>

        <c:if test="${not empty withdraw_err}">
          <p style="color:#d00; font-weight:700; margin-bottom:12px;">${withdraw_err}</p>
        </c:if>

        <div class="warning-box">
          <div class="warning-header">
            <div class="warning-icon">!</div>
            <p class="warning-text">탈퇴 시 주의사항을 꼭 확인해주세요.</p>
          </div>
          <ul class="warning-list">
            <li>회원정보 및 계정 내역은 <strong>즉시 삭제</strong>되며 복구할 수 없습니다.</li>
            <li>탈퇴 후 30일 동안 재가입이 제한될 수 있습니다.</li>
            <li>법적 보관 의무에 따라 일부 거래 내역은 일정 기간 보관됩니다.</li>
          </ul>
        </div>

        <form id="withdrawForm" method="post" action="<c:url value='/mypage/withdraw_ok'/>">
  <div class="form-group">
    <label class="form-label" for="userId">아이디</label>
    <input type="text" id="userId" class="form-input" value="${sessionScope.loginId}" disabled>
  </div>

  <c:choose>
    <%-- 일반 회원용 --%>
    <c:when test="${sessionScope.loginType eq 'LOCAL' or empty sessionScope.loginType}">
      <div class="form-group">
        <label class="form-label" for="userPassword">비밀번호</label>
        <input type="password" id="userPassword" name="user_pw" class="form-input"
               placeholder="비밀번호를 입력해주세요" required>
      </div>

      <div class="button-group">
        <button type="submit" class="btn btn-primary">회원 탈퇴</button>
        <button type="button" class="btn btn-secondary"
                onclick="location.href='<c:url value="/mypage"/>'">취소</button>
      </div>
    </c:when>

    <%-- 소셜 로그인 회원용 (카카오 / 네이버 / 구글) --%>
    <c:otherwise>
      <div class="notice-box">
        <p>${sessionScope.loginType} 계정으로 로그인된 회원은 비밀번호 입력 없이 즉시 탈퇴할 수 있습니다.</p>
      </div>

      <div class="button-group">
        <button type="submit" class="btn btn-danger">${sessionScope.loginType} 계정 탈퇴</button>
        <button type="button" class="btn btn-secondary"
                onclick="location.href='<c:url value="/mypage"/>'">취 소</button>
      </div>
    </c:otherwise>
  </c:choose>
</form>

      </div>
    </div>
  </div>
</main>

<footer class="footer">
  <div class="footer-container">
    <div class="footer-brand">BRAND</div>
    <div class="footer-info">
      BRAND | 대표자 : 홍길동 | 사업자번호 : 123-34-56789<br>
      통신판매업 : 0000-부산시-0000호 | 개인정보보호책임자 : 홍길동 | 이메일 : qshop@naver.com<br>
      전화번호: 00-0000-0000 | 주소 : 부산시 부산진구 범내골
    </div>
  </div>
</footer>

<script src="/js/withdraw.js"></script>
</body>
</html>
