<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>책갈피 – 책 상세정보</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet" />

  <!-- CSS -->
  <link rel="stylesheet" href="/css/SearchDetail.css" />

  <!-- CSRF 토큰 (스프링 시큐리티 사용 시) -->
  <c:if test="${not empty _csrf}">
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
  </c:if>
</head>

<body>
<header>
  <nav class="nav" aria-label="주요 메뉴">
    <a href="<c:url value='/main'/>" class="brand">
      <img src="/img/book_logo.png" alt="책갈피 로고" class="brand-logo" />
    </a>

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
          <span style="color: #666; font-weight: 700;">${sessionScope.loginDisplayName}님</span>
        </c:otherwise>
      </c:choose>
    </div>
  </nav>
</header>

<main class="page-wrap">
  <!-- 상단 헤더 -->
  <section class="detailhead">
    <div class="detailsubwrap">
      <h1 class="title">도서 상세정보</h1>
      <p class="meta subnote">책갈피가 엄선한 도서 정보를 한눈에 확인하세요.</p>
    </div>
  </section>

  <!-- 도서 정보 -->
  <div class="page-container">
    <div class="product-detail">
      <p class="breadcrumb in-card">
        홈 &gt; 도서 &gt; <c:out value="${book.book_title}" />
      </p>

      <div class="product-main">
        <div class="product-image ${not empty book.book_image_path ? 'has-image' : ''}">
          <c:choose>
            <c:when test="${not empty book.book_image_path}">
              <img src="<c:url value='${book.book_image_path}'/>" alt="${book.book_title}" />
            </c:when>
            <c:otherwise>
              <div class="placeholder">이미지 없음</div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="product-info">
          <h1 class="product-title"><c:out value="${book.book_title}" /></h1>

          <div class="product-price">
            <c:choose>
              <c:when test="${book.book_price != null}">
                <fmt:formatNumber value="${book.book_price}" pattern="#,###" />원
              </c:when>
              <c:otherwise>가격 정보 없음</c:otherwise>
            </c:choose>
          </div>

          <div class="product-description">
            <p><c:out value="${book.book_comm != null ? book.book_comm : '도서 소개 정보가 없습니다.'}" /></p>
          </div>

          <!-- 구매/장바구니 버튼 -->
          <div class="product-actions">
            <button class="btn btn-primary" id="btnAddToCart" type="button">🛒장바구니 담기</button>
            <button class="btn btn-secondary" id="btnBuyNow" type="button">💳구매하기</button>
          </div>

          <!-- 장바구니 폼 (숨김) -->
          <form id="cartForm" method="post" action="${pageContext.request.contextPath}/cartAdd" style="display:none;">
            <input type="hidden" name="book_id" value="${book.book_id}"/>
            <input type="hidden" name="quantity" value="1" />
            <c:if test="${not empty _csrf}">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
          </form>

          <!-- 구매 폼 (숨김) -->
          <form id="buyForm" method="post" action="${pageContext.request.contextPath}/order/buy" style="display:none;">
            <input type="hidden" name="book_id" value="${book.book_id}" />
            <c:if test="${not empty _csrf}">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            </c:if>
          </form>
        </div>
      </div>
    </div>

  <!-- 도서 상세 정보 -->
  			<div class="book-details-section">
  				<h3>도서 상세 정보</h3>
  				<div class="book-details-grid">
  					<div class="book-detail-item">
  						<span class="detail-label">저자</span><span class="detail-value"><c:out
  								value="${book.book_writer}" /></span>
  					</div>
  					<div class="book-detail-item">
  						<span class="detail-label">출판사</span><span class="detail-value"><c:out
  								value="${book.book_pub}" /></span>
  					</div>

  					<div class="book-detail-item">
  						<span class="detail-label">출간일</span> <span class="detail-value">
  							<c:choose>
  								<c:when test="${not empty book.book_date}">
  									<fmt:formatDate value="${book.book_date}" pattern="yyyy-MM-dd" />
  								</c:when>
  								<c:otherwise>정보 없음</c:otherwise>
  							</c:choose>
  						</span>
  					</div>

  					<div class="book-detail-item">
  						<span class="detail-label">ISBN</span> <span
  							class="detail-value mono"><c:out value="${book.book_isbn}" /></span>
  					</div>

  					<div class="book-detail-item">
  						<span class="detail-label">장르</span> <span class="detail-value">
  							<span class="badge-genre"> <c:choose>
  									<c:when test="${book.genre_id == 1}">소설</c:when>
  									<c:when test="${book.genre_id == 2}">에세이</c:when>
  									<c:when test="${book.genre_id == 3}">인문/사회</c:when>
  									<c:when test="${book.genre_id == 4}">과학/기술</c:when>
  									<c:when test="${book.genre_id == 5}">경제/경영</c:when>
  									<c:otherwise>기타</c:otherwise>
  								</c:choose>
  						</span>
  						</span>
  					</div>
  				</div>
  			</div>


  <!-- 리뷰 작성 -->
  <div class="review-write-section">
    <c:choose>
      <c:when test="${not empty sessionScope.loginId && hasPurchased}">
        <c:choose>
          <c:when test="${hasReviewed}">
            <p>리뷰는 1번만 작성할 수 있습니다.</p>
          </c:when>
          <c:otherwise>
            <form action="${pageContext.request.contextPath}/review/write" method="post" id="reviewForm">
              <input type="hidden" name="book_id" value="${book.book_id}" />
              <input type="hidden" name="user_id" value="${sessionScope.loginId}" />
              <input type="hidden" name="review_rating" id="reviewRatingInput" value="" />
              <label for="review_content" class="review-label">리뷰 적기</label>
              <div class="review-write-section">
                <span id="starContainer">
                  <img src="/img/empty_star.png" class="star" data-value="1" alt="1점" width="12" height="12" />
                  <img src="/img/empty_star.png" class="star" data-value="2" alt="2점" width="12" height="12" />
                  <img src="/img/empty_star.png" class="star" data-value="3" alt="3점" width="12" height="12" />
                  <img src="/img/empty_star.png" class="star" data-value="4" alt="4점" width="12" height="12" />
                  <img src="/img/empty_star.png" class="star" data-value="5" alt="5점" width="12" height="12" />
                </span>
                <textarea id="review_content" name="review_content" class="review-textarea" placeholder="리뷰를 작성해주세요." required></textarea>
                <button type="submit" class="review-submit-btn">리뷰 작성</button>
              </div>
            </form>
          </c:otherwise>
        </c:choose>
      </c:when>
      <c:when test="${not empty sessionScope.loginId && !hasPurchased}">
        <p>리뷰 작성은 해당 책을 구매한 사용자만 가능합니다.</p>
      </c:when>
      <c:otherwise>
        <p>리뷰 작성은 <a href="<c:url value='/login'/>">로그인</a> 후 가능합니다.</p>
      </c:otherwise>
    </c:choose>
  </div>

  <!-- 리뷰 목록 -->
  <div class="review-list-section">
    <h3>리뷰 목록</h3>
    <c:if test="${not empty reviews}">
      <c:forEach var="r" items="${reviews}">
        <div class="review-item">
          <div class="review-header">
            <span class="review-stars">
              <c:forEach var="i" begin="1" end="5">
                <img src="<c:out value='${i <= r.review_rating ? "/img/star.png" : "/img/empty_star.png"}' />" alt="별점" width="14" height="14" />
              </c:forEach>
            </span>
          </div>
          <p class="review-content">${r.review_content}</p>
          <div class="review-footer">
            <small class="review-nickname">${r.user_nickname}</small>
            <small><fmt:formatDate value="${r.review_date}" pattern="yyyy-MM-dd HH:mm" /></small>
          </div>
        </div>
        <hr />
      </c:forEach>
    </c:if>
    <c:if test="${empty reviews}">
      <p>아직 작성된 리뷰가 없습니다.</p>
    </c:if>
  </div>
</main>

<footer class="footer">
  <div class="footer-container">
    <div class="footer-brand">BRAND</div>
    <div class="footer-info">
      BRAND | 대표자 : 홍길동 | 사업자번호 : 123-34-56789<br />
      개인정보보호책임자 : 홍길동 | 이메일 : qshop@naver.com<br />
      전화번호: 00-0000-0000 | 주소 : 부산시 부산진구 범내골
    </div>
  </div>
</footer>
<script src="/js/SearchDetail.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', function () {
    const starImages = document.querySelectorAll('#starContainer .star');
    const ratingInput = document.getElementById('reviewRatingInput');
    const filledStar = '/img/star.png';
    const emptyStar = '/img/empty_star.png';

    let currentRating = 0; // 현재 별점

    // 별점 클릭 이벤트 처리
    starImages.forEach(star => {
      const value = Number(star.dataset.value);

      star.addEventListener('click', () => {
        if (currentRating === value) {
          // 같은 별 클릭 시 점수 감소 (최소 0)
          currentRating = Math.max(0, currentRating - 1);
        } else {
          currentRating = value;
        }
        ratingInput.value = currentRating;
        updateStars(currentRating);
      });
    });

    // 별점 상태 업데이트
    function updateStars(rating) {
      starImages.forEach(star => {
        star.src = star.dataset.value <= rating ? filledStar : emptyStar;
      });
    }

    // 리뷰 작성 제한 처리
    const hasReviewed = ${hasReviewed}; // 서버에서 전달받은 변수값
    const reviewForm = document.getElementById('reviewForm');
    const reviewMessage = document.getElementById('reviewMessage');

    if (hasReviewed) {
      if (reviewForm) reviewForm.style.display = 'none'; // 리뷰 폼 숨기기
      if (reviewMessage) reviewMessage.style.display = 'block'; // 제한 메시지 보이기
    } else {
      if (reviewForm) reviewForm.style.display = 'block'; // 리뷰 폼 보이기
      if (reviewMessage) reviewMessage.style.display = 'none'; // 제한 메시지 숨기기
    }
  });

  // 구매하기 버튼 이벤트
  const btnBuyNow = document.getElementById('btnBuyNow');
  if (btnBuyNow) {
    btnBuyNow.addEventListener('click', function (e) {
      e.preventDefault();

      const form = document.getElementById('buyForm');
      form.querySelectorAll('.dynamic-input').forEach(el => el.remove());

      const bookId = document.querySelector('input[name="book_id"]').value;
      const unitPrice = Number(document.querySelector('.product-price').innerText.replace(/[^0-9]/g, ''));
      const quantity = 1;

      const inputBook = document.createElement('input');
      inputBook.type = 'hidden';
      inputBook.name = 'items[0].book_id';
      inputBook.value = bookId;
      inputBook.classList.add('dynamic-input');

      const inputQty = document.createElement('input');
      inputQty.type = 'hidden';
      inputQty.name = 'items[0].quantity';
      inputQty.value = quantity;
      inputQty.classList.add('dynamic-input');

      const inputPrice = document.createElement('input');
      inputPrice.type = 'hidden';
      inputPrice.name = 'items[0].purchase_price';
      inputPrice.value = unitPrice;
      inputPrice.classList.add('dynamic-input');

      form.appendChild(inputBook);
      form.appendChild(inputQty);
      form.appendChild(inputPrice);

      form.submit();
    });
  }
</script>
</body>
</html>
