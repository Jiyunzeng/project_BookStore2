<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>구매기록 | 책갈피</title>
    
    <!-- 폰트: 전체는 Noto Sans KR -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
    
    <!-- CSS 파일 링크 -->
    <link rel="stylesheet" href="/css/purchaseList.css">
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
              구매내역
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
           <h1 class="page-title">마이페이지</h1>
   
           <div class="tab-nav">
               <button class="tab-button" onclick="location.href='${pageContext.request.contextPath}/mypage'">정보</button>
               <button class="tab-button" onclick="location.href='${pageContext.request.contextPath}/mypage/edit'">내정보 수정</button>
               <button class="tab-button" onclick="location.href='<c:url value="/wishlist"/>'">찜 목록</button>
               <button class="tab-button active" onclick="location.href='${pageContext.request.contextPath}/MyPage/purchaseList'">구매내역</button>
               <button class="tab-button" onclick="location.href='${pageContext.request.contextPath}/mypage/withdraw'">회원탈퇴</button>
           </div>
   
           <div class="content-card">
               <div class="content-header">
                   <h2 class="content-title">구매 내역</h2>
               </div>
   
               <div class="table-container">
                   <table class="purchase-table">
                       <thead>
                           <tr>
                               <th>주문일자</th>
                               <th>도서명</th>
                               <th>수량</th>
                               <th>결제금액</th>
                           </tr>
                       </thead>
                       <tbody id="purchaseTableBody">
                        <c:choose>
                          <c:when test="${not empty purchaseList}">
                            <c:forEach var="order" items="${purchaseList}" varStatus="status">
                              <c:set var="pageNum" value="${fn:substringBefore(((status.index div 10) + 1), '.')}" />
                              <tr data-page="${pageNum}" data-orderid="${order.order_id}" class="clickable-row">
                                <td><fmt:formatDate value="${order.order_date}" pattern="yyyy-MM-dd" /></td>
                                <td>
                                  <c:choose>
                                    <c:when test="${not empty order.orderDetails}">
                                      ${order.orderDetails[0].book_title}
                                      <c:if test="${fn:length(order.orderDetails) > 1}">
                                        외 ${fn:length(order.orderDetails) - 1}권
                                      </c:if>
                                    </c:when>
                                    <c:otherwise>
                                      도서 정보 없음
                                    </c:otherwise>
                                  </c:choose>
                                </td>
                                <td>${order.total_quantity}</td>
                                <td>₩${order.total_price}</td>
                              </tr>
                            </c:forEach>
                          </c:when>
                          <c:otherwise>
                            <tr>
                              <td colspan="4" style="text-align:center;">구매 내역이 없습니다.</td>
                            </tr>
                          </c:otherwise>
                        </c:choose>
                       </tbody>
                   </table>
               </div>
   
               <div class="pagination" id="pagination"></div>
           </div>
       </div>
   </main>

    <footer class="footer">
        <div class="container">
            © 책갈피 BRAND · 부산시 부산진구 범내골 · 00-0000-0000 · <a href="mailto:qshop@naver.com">qshop@naver.com</a>
        </div>
    </footer>

    <script src="/js/purchaseList.js"></script>
</body>
</html>
