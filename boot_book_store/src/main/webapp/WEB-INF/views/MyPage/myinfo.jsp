<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>마이페이지 | BRAND</title>

  <!-- Google Fonts -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200;300;400;500;600;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

  <!-- 외부 CSS -->
  <link rel="stylesheet" href="/css/myinfo.css">
</head>
<body>
  <!-- 헤더 -->
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

  <!-- Promo Bar -->
  <div class="promo" aria-hidden="true"></div>

  <!-- 본문 -->
  <main class="page-wrap">
    <div class="page-container">
      <h1 class="page-title">마이페이지</h1>

      <!-- 탭 -->
      <div class="tab-nav">
        <button class="tab-button active" onclick="switchTab('info')">정보</button>
        <button class="tab-button" onclick="location.href='<c:url value="/mypage/edit"/>'">내정보 수정</button>
        <button class="tab-button" onclick="location.href='<c:url value="/wishlist"/>'">찜 목록</button>
        <button class="tab-button" onclick="location.href='<c:url value="/MyPage/purchaseList"/>'">구매내역</button>
        <button class="tab-button" onclick="location.href='<c:url value="/mypage/withdraw"/>'">회원탈퇴</button>
      </div>

      <div class="content-card">
        <!-- 정보 -->
        <section class="panel active" id="panel-info" role="tabpanel" tabindex="0" style="display:block;">
          <div class="card">
            <div class="card-head">
              <h3 class="card-title">내 정보</h3>
            </div>
            <div class="card-body">
              <div class="profile-row">
                <div><div class="avatar" aria-hidden="true"></div></div>
                <div>
                  <div class="badge" title="등급">
				      회원등급: 
				      <strong>
				          <c:choose>
				              <c:when test="${user.user_role eq 'ADMIN'}">
				                  관리자
				              </c:when>
				              <c:otherwise>
				                  일반
				              </c:otherwise>
				          </c:choose>
				      </strong>
				  </div>
                  <div class="kv"><strong>이름</strong><div><c:out value='${sessionScope.loginDisplayName}' /></div></div>
                  <div class="kv"><strong>닉네임</strong><div><c:out value="${user.user_nickname}" default="-"/></div></div>
                  <div class="kv"><strong>이메일</strong><div><c:out value="${user.user_email}" default="-"/></div></div>
                  <div class="kv"><strong>전화번호</strong><div><c:out value="${user.user_phone_num}" default="-"/></div></div>
                  <div class="kv"><strong>주소</strong>
                    <div>
                      <c:if test="${not empty user.user_post_num}">(<c:out value="${user.user_post_num}"/>) </c:if>
                      <c:out value="${user.user_address}" default=""/>
                      <c:if test="${not empty user.user_detail_address}">, <c:out value="${user.user_detail_address}"/></c:if>
                    </div>
                  </div>
                  <div class="kv" style="border-bottom:none">
                    <strong>가입일</strong><div><c:out value="${user.reg_date}" default="-"/></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </section>

        <!-- 구매내역 -->
        <section class="panel" id="panel-purchase" role="tabpanel" tabindex="0">
          <div class="card">
            <div class="card-head">
              <h3 class="card-title">구매내역</h3>
              <div class="toolbar">
                <input type="text" class="search-sm" id="orderSearch" placeholder="주문번호/도서명 검색…"/>
                <select id="statusFilter" title="상태 필터">
                  <option value="">전체 상태</option>
                  <option value="paid">결제완료</option>
                  <option value="shipping">배송중</option>
                  <option value="refunded">환불완료</option>
                </select>
                <button class="btn ghost" type="button" id="btnExport">내려받기(CSV)</button>
              </div>
            </div>
            <div class="card-body">
              <div class="table-wrap">
                <table aria-describedby="ordersCaption" id="ordersTable">
                  <caption id="ordersCaption" class="visually-hidden" style="position:absolute;width:1px;height:1px;overflow:hidden;clip:rect(0,0,0,0);">최근 주문 내역</caption>
                  <thead>
                    <tr>
                      <th scope="col">주문번호</th>
                      <th scope="col">주문일</th>
                      <th scope="col">도서명</th>
                      <th scope="col">수량</th>
                      <th scope="col">결제금액</th>
                      <th scope="col">상태</th>
                      <th scope="col">영수증</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr data-status="paid">
                      <td>#20251001-0001</td><td>2025-10-01</td><td>모던 자바 인 액션</td><td>1</td><td>₩ 34,200</td>
                      <td><span class="status paid">결제완료</span></td><td><a href="#" class="btn ghost">보기</a></td>
                    </tr>
                    <tr data-status="shipping">
                      <td>#20250928-0007</td><td>2025-09-28</td><td>클린 아키텍처</td><td>1</td><td>₩ 27,900</td>
                      <td><span class="status shipping">배송중</span></td><td><a href="#" class="btn ghost">보기</a></td>
                    </tr>
                    <tr data-status="refunded">
                      <td>#20250920-0003</td><td>2025-09-20</td><td>데이터베이스 첫걸음</td><td>2</td><td>₩ 39,600</td>
                      <td><span class="status refunded">환불완료</span></td><td><a href="#" class="btn ghost">보기</a></td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <div class="pagination" aria-label="페이지네이션">
                <button class="page-btn" type="button" aria-label="이전 페이지">‹</button>
                <button class="page-btn" type="button" aria-current="page">1</button>
                <button class="page-btn" type="button">2</button>
                <button class="page-btn" type="button">3</button>
                <button class="page-btn" type="button" aria-label="다음 페이지">›</button>
              </div>
            </div>
          </div>
        </section>

        <!-- 회원탈퇴 -->
        <section class="panel" id="panel-delete" role="tabpanel" tabindex="0">
          <div class="card">
            <div class="card-head">
              <h3 class="card-title">회원탈퇴</h3>
            </div>
            <div class="card-body">
              <div class="danger-zone">
                <h4>주의해 주세요</h4>
                <p>탈퇴 시 보유하신 포인트/쿠폰/주문 기록 등 계정 정보가 <strong>영구적으로 삭제</strong>됩니다.</p>
                <ul class="muted" style="margin:10px 0 0 18px;">
                  <li>진행중인 주문/환불이 있다면 완료 후 탈퇴를 권장합니다.</li>
                  <li>재가입 시 기존 데이터 복구는 불가능합니다.</li>
                </ul>
                <div style="margin-top:14px">
                  <button class="btn danger" type="button" id="btnDeleteOpen">탈퇴 진행</button>
                </div>
              </div>
            </div>
          </div>
        </section>

      </div>
    </div>
  </main>

  <!-- 푸터 -->
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

  <!-- 외부 JS -->
  <script src="/js/myinfo.js"></script>
</body>
</html>
