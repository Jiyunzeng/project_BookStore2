<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  
  <title>장바구니 | 책갈피</title>

  <meta name="ctx" content="${pageContext.request.contextPath}"/>

  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <link rel="stylesheet" href="/css/cart.css">
  <script src="https://js.tosspayments.com/v1"></script>
</head>
<body>
  <header>
    <nav class="nav" aria-label="주요 메뉴">
      <a href="<c:url value='/main'/>" class="brand">
        <img src="/img/book_logo.png" alt="책갈피 로고" class="brand-logo" />
        <span class="brand-text" aria-hidden="true"></span>
      </a>
      <div class="nav-right">
          <a href="<c:url value='/mypage'/>">마이페이지</a>
          <span id="userGreeting" style="color:var(--brand); font-weight:700;">
          <c:choose>
            <c:when test="${not empty sessionScope.loginUser}"></c:when>
            <c:otherwise>장바구니</c:otherwise>
          </c:choose>
        </span>
          <a href="<c:url value='/logout'/>">로그아웃</a>
          <span style="color:#666; font-weight:700;">
            ${sessionScope.loginDisplayName}님
      </div>
    </nav>
  </header>
  
  <div class="promo" aria-hidden="true"></div>
  
  <section class="page-hero">
    <div class="page-hero-inner">
      <div>
        <h1 class="page-title">장바구니</h1>
        <p class="page-sub">담아둔 상품을 확인하고 주문을 진행하세요.</p>
      </div>
    </div>
  </section>

<form id="orderForm" method="post" action="${pageContext.request.contextPath}/orderBooks">
  <main class="cart-section">
    <div class="cart-container">
      <!-- 장바구니 리스트 카드 -->
      <section class="card" aria-labelledby="cartTitle">
        <div class="card-header" style="display:flex;align-items:center;justify-content:space-between;">
          <div>
            <input type="checkbox" id="selectAll" />
            <label for="selectAll" class="select-all">전체 선택</label>
            <span class="muted" id="selectedCount">(0개 선택)</span>
          </div>
          <div style="display:flex;gap:8px;">
            <button class="btn btn-ghost" id="removeSelectedBtn">선택 삭제</button>
            <button class="btn btn-ghost" id="clearCartBtn">전체 비우기</button>
          </div>
        </div>
        <div>
          <table class="cart-table">
            <thead class="cart-head">
              <tr>
                <th style="width:36px;"></th>
                <th>상품정보</th>
                <th style="width:120px;">수량</th>
                <th style="width:90px;">가격</th>
              </tr>
            </thead>
            <tbody id="cartRows">
              <c:if test="${not empty cartList}">
                <c:forEach var="item" items="${cartList}">
                  <tr data-cart-id="${item.cart_id}" data-price="${item.book.book_price}" class="cart-row">
                    <td>
                      <input type="checkbox" class="cart-checkbox" value="${item.book.book_id}" />
                    </td>
                    <td class="product-info">
                      <div style="display:flex;align-items:center;gap:16px;">
                        <div class="thumb">
                          <img src="${item.book.book_image_path}" alt="${item.book.book_title}" />
                        </div>
                        <div>
                          <div class="product-name" style="font-weight:700;">${item.book.book_title}</div>
                          <div class="meta">${item.book.book_writer} </div>
                        </div>
                      </div>
                    </td>
                    <td>
                      <input type="number" class="quantity-input" value="${item.quantity}" min="1" max="99" data-book-id="${item.book.book_id}" />
                    </td>
                    <td class="price">₩${item.book.book_price * item.quantity}</td>
                  </tr>
                </c:forEach>
              </c:if>
              <c:if test="${empty cartList}">
                <tr>
                  <td colspan="5" style="text-align:center; color:#666;">장바구니에 담긴 상품이 없습니다.</td>
                </tr>
              </c:if>
            </tbody>
          </table>
        </div>
      </section>
      <!-- 우측 요약 카드 -->
      <aside class="summary">
        <div class="card">
          <div class="card-header">
            <h2 class="card-title" id="summaryTitle">주문 요약</h2>
          </div>
          <div class="card-body" aria-labelledby="summaryTitle">
            <div class="summary-line"><span>상품 금액</span><strong id="subtotalText">₩0</strong></div>
            <div class="summary-line"><span>배송비</span><strong id="shippingText">₩0</strong></div>
            <hr style="border:none; border-top:1px solid #eee; margin:6px 0;">
            <div class="summary-line summary-total"><span>전체 주문 금액</span><span id="grandTotalText">₩0</span></div>
            <p class="fine">₩30,000 이상 구매 시 무료배송</p>
			<div class="cart-ctas">
			  <div class="btn-row">
			    <a class="btn btn-ghost" href="<c:url value='/search'/>">계속 쇼핑하기</a>
			    <button class="btn btn-brand" id="checkoutBtn">주문하기</button>
			  </div>
			  <button class="btn btn-tosspay cta-full" id="tossPayBtn" type="button">토스페이 결제하기</button>
			</div>
          </div>
        </div>
      </aside>
    </div>
  </main>
</form>


<script defer src="/js/cart.js"></script>
</body>
</html>
