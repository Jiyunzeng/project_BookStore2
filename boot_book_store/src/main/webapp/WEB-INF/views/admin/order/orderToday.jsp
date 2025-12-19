<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>오늘 주문 내역</title>

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: #f2eee9;
            margin: 0;
            padding: 0;
        }

        .title-header {
            width: 85%;
            margin: 60px auto 26px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .title {
            font-size: 32px;
            font-weight: 700;
            color: #3e2c1c;
            margin: 0;
        }

        .table-container {
            width: 85%;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            padding: 0;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 15px;
        }

        thead {
            background: #6b4f34;
            color: white;
            font-size: 15px;
        }

        th {
            padding: 16px 12px;
            text-align: center;
            font-weight: 600;
            border: none;
        }

        tbody {
            background: #ffffff;
        }

        td {
            padding: 18px 12px;
            text-align: center;
            border: none;
            border-bottom: 1px solid #ece4d9;
            color: #4b3b2a;
            background: #ffffff;
        }

        tbody tr {
            background: #ffffff;
            transition: background-color 0.2s;
        }

        tbody tr:hover {
            background: #f8f5f1;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .order-link {
            display: inline-block;
            padding: 8px 16px;
            background: #f8f5f1;
            border: 2px solid #6b4f34;
            border-radius: 8px;
            color: #6b4f34;
            font-weight: 600;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .order-link:hover {
            background: #6b4f34;
            color: #ffffff;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(107, 79, 52, 0.3);
        }

        .summary-bar {
            width: 85%;
            margin: 0 auto 10px auto;
            display: flex;
            justify-content: space-between;
            gap: 16px;
            font-size: 14px;
            color: #5d4732;
        }
        .search-container {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        .search-form {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .search-form select,
        .search-form input {
            padding: 12px 14px;
            border: 1px solid #d9cfc4;
            border-radius: 10px;
            background: #faf7f3;
            font-size: 14px;
            color: #4b3b2a;
            outline: none;
        }

        .search-form input:focus,
        .search-form select:focus {
            border-color: #8a6b52;
            background: #fff;
            box-shadow: 0 0 0 2px rgba(138, 107, 82, 0.2);
        }

        .btn-search {
            padding: 12px 22px;
            background: #795438;
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-search:hover {
            background: #8a6141;
        }

        .pagination {
            width: 85%;
            margin: 30px auto 60px;
            display: flex;
            justify-content: center;
            gap: 8px;
            flex-wrap: wrap;
        }

        .pagination a {
            min-width: 34px;
            padding: 8px 12px;
            text-align: center;
            border-radius: 8px;
            border: 1px solid #d9cfc4;
            color: #4b3b2a;
            text-decoration: none;
            font-weight: 600;
            transition: 0.2s;
            cursor: pointer;
        }

        .pagination a:hover {
            background: #f8f5f1;
        }

        .pagination a.active {
            background: #6b4f34;
            color: #fff;
            border-color: #6b4f34;
        }

        .btn-detail {
            padding: 8px 16px;
            background: #795438;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-detail:hover {
            background: #8a6141;
        }
    </style>
</head>

<body>

	<div class="title-header">
		<div class="title">오늘 주문 내역</div>
		<div class="search-container">
			<div style="font-size: 14px; color: #5d4732; margin-right: 16px;">
				오늘 주문 건수 : <strong>${total}</strong> 건
			</div>
			<div>
				<a href="javascript:void(0)" onclick="loadPage('/admin/order/list')" 
				   style="color: #6b4f34; text-decoration: none; font-weight: 600; padding: 8px 12px; border-radius: 8px; transition: 0.2s;">
					전체 주문내역 보기 ▶
				</a>
			</div>
		</div>
	</div>

	<div class="table-container">
	    <table>
	        <thead>
	        <tr>
	            <th>주문번호</th>
	            <th>회원 ID</th>
	            <th>회원명</th>
	            <th>이메일</th>
	            <th>총 수량</th>
	            <th>총 금액</th>
	            <th>주문일</th>
	            <th>관리</th>
	        </tr>
	        </thead>

	        <tbody>
	        <c:forEach var="o" items="${orders}">
	            <tr>
	                <td>
	                    <span class="order-link"
	                          onclick="loadPage('/admin/order/detail?order_id=${o.order_id}')">
	                        ${o.order_id}
	                    </span>
	                </td>
	                <td>${o.user_id}</td>
	                <td>${o.user_name}</td>
	                <td>${o.user_email}</td>
	                <td>${o.total_quantity}</td>
	                <td><fmt:formatNumber value="${o.total_price}" /></td>
	                <td>${o.order_date}</td>
	                <td>
	                    <button class="btn-detail"
	                            onclick="loadPage('/admin/order/detail?order_id=${o.order_id}')">
	                        상세보기
	                    </button>
	                </td>
	            </tr>
	        </c:forEach>
	        </tbody>
	    </table>
	</div>

	<div class="title-header" style="margin-top: 20px; margin-bottom: 20px;">
		<div></div>
		<div class="search-container">
			<form class="search-form" method="get" id="searchForm">
				<select name="type">
					<option value="uid"   ${type == 'uid' ? 'selected' : ''}>회원 ID</option>
					<option value="uname" ${type == 'uname' ? 'selected' : ''}>회원명</option>
					<option value="email" ${type == 'email' ? 'selected' : ''}>이메일</option>
				</select>
				<input type="text" name="keyword" placeholder="검색어를 입력하세요" value="${fn:escapeXml(param.keyword)}">
				<button type="submit" class="btn-search">검색</button>
			</form>
		</div>
	</div>

      <!-- 페이지네이션 -->
      <div class="pagination">
		<c:if test="${startPage > 1}">
		    <a href="javascript:void(0)"
		       onclick="loadPage('${pageContext.request.contextPath}/admin/order/today?page=${startPage-1}&type=${type}&keyword=${keyword}')">
		        <
		    </a>
		</c:if>

		<c:forEach var="i" begin="${startPage}" end="${endPage}">
		    <a href="javascript:void(0)"
		       onclick="loadPage('${pageContext.request.contextPath}/admin/order/today?page=${i}&type=${type}&keyword=${keyword}')"
		       class="${i == page ? 'active' : ''}">
		       ${i}
		    </a>
		</c:forEach>

		<c:if test="${endPage < pageCount}">
		    <a href="javascript:void(0)"
		       onclick="loadPage('${pageContext.request.contextPath}/admin/order/today?page=${endPage+1}&type=${type}&keyword=${keyword}')">
		        >
		    </a>
		</c:if>
      </div>
	<script>
	  document.getElementById("searchForm").addEventListener("submit", function(e) {
	      e.preventDefault(); // 기존 submit 막기

	      const type = this.type.value;
	      const keyword = this.keyword.value;

	      const url = "${pageContext.request.contextPath}/admin/order/today"
	                  + "?type=" + encodeURIComponent(type)
	                  + "&keyword=" + encodeURIComponent(keyword);

	      loadPage(url); // 비동기로 페이지 로드
	  });
	  </script>
</body>
</html>
