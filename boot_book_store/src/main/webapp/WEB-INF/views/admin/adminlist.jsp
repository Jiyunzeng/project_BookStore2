<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      background: #f2eee9;
      margin: 0;
      padding: 0;
    }

    .stats-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      gap: 16px;
      margin-bottom: 24px;
    }

    .stat-card {
      background: #ffffff;
      padding: 20px;
      border-radius: 16px;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
    }

    .stat-card-title {
      font-size: 13px;
      color: #6b7280;
      margin-bottom: 8px;
    }

    .stat-card-value {
      font-size: 24px;
      font-weight: 700;
      color: #3e2c1c;
    }

    .inquiry-table {
      width: 100%;
      border-collapse: collapse;
      background: white;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
    }

    .inquiry-table thead {
      background-color: #6b4f34;
    }

    .inquiry-table th {
      padding: 14px 16px;
      text-align: center;
      font-weight: 600;
      color: white;
      font-size: 15px;
      border-bottom: none;
    }

    .inquiry-table td {
      padding: 16px 16px;
      border-bottom: 1px solid #ece4d9;
      font-size: 15px;
      color: #4b3b2a;
      text-align: center;
    }

    .inquiry-table tbody tr {
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .inquiry-table tbody tr:hover {
      background-color: #f8f5f1;
    }

    .inquiry-table tbody tr:last-child td {
      border-bottom: none;
    }

    .status-badge {
      display: inline-block;
      padding: 4px 10px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: 600;
    }

    .status-waiting {
      background-color: #fef3c7;
      color: #92400e;
    }

    .status-completed {
      background-color: #d1fae5;
      color: #065f46;
    }

    .btn-view {
      background-color: #795438;
      color: white;
      padding: 7px 18px;
      border: none;
      border-radius: 6px;
      text-decoration: none;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      display: inline-block;
      transition: 0.2s;
    }

    .btn-view:hover {
      background-color: #8a6141;
    }

    .btn-edit {
      background-color: #10b981;
      color: white;
      padding: 7px 18px;
      border: none;
      border-radius: 6px;
      text-decoration: none;
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      display: inline-block;
      transition: 0.2s;
    }

    .btn-edit:hover {
      background-color: #059669;
    }
  </style>

<h1 style="font-size:18px;margin:0 0 6px 0;">1:1 문의 관리</h1>
<div style="color:var(--muted);font-size:13px;margin-bottom:18px;">고객 문의를 확인하고 답변을 작성하세요.</div>

<c:set var="totalCount" value="${inquiryList.size()}" />
<c:set var="pendingCount" value="0" />
<c:forEach var="inquiry" items="${inquiryList}">
  <c:if test="${inquiry.status == '대기중'}">
    <c:set var="pendingCount" value="${pendingCount + 1}" />
  </c:if>
</c:forEach>

<div class="stats-grid">
  <div class="stat-card">
    <div class="stat-card-title">전체 문의</div>
    <div class="stat-card-value">${totalCount}</div>
  </div>
  <div class="stat-card">
    <div class="stat-card-title">답변 대기</div>
    <div class="stat-card-value" style="color: #F59E0B;">${pendingCount}</div>
  </div>
  <div class="stat-card">
    <div class="stat-card-title">답변 완료</div>
    <div class="stat-card-value" style="color: #10B981;">${totalCount - pendingCount}</div>
  </div>
</div>

<table class="inquiry-table">
  <thead>
    <tr>
      <th style="width: 8%;">번호</th>
      <th style="width: 15%;">작성자</th>
      <th style="width: 40%;">제목</th>
      <th style="width: 12%;">상태</th>
      <th style="width: 15%;">작성일</th>
      <th style="width: 10%;">관리</th>
    </tr>
  </thead>
  <tbody>
    <c:choose>
      <c:when test="${empty inquiryList || inquiryList.size() == 0}">
        <tr>
          <td colspan="6" style="text-align: center; padding: 40px; color: #6B7280;">
            등록된 문의가 없습니다.
          </td>
        </tr>
      </c:when>
      <c:otherwise>
        <c:forEach var="inquiry" items="${inquiryList}">
          <tr class="inquiry-row" data-inquiry-id="${inquiry.inquiry_id}" style="cursor: pointer;">
            <td>${inquiry.inquiry_id}</td>
            <td>${inquiry.user_name}</td>
            <td style="font-weight: 500;">${inquiry.title}</td>
            <td>
              <span class="status-badge ${inquiry.status == '답변완료' ? 'status-completed' : 'status-waiting'}">
                ${inquiry.status}
              </span>
            </td>
            <td>
              <fmt:formatDate value="${inquiry.created_date}" pattern="yyyy-MM-dd" />
            </td>
            <td class="action-cell" onclick="event.stopPropagation();">
              <c:choose>
                <c:when test="${inquiry.status == '답변완료'}">
                  <button class="btn-edit" data-inquiry-id="${inquiry.inquiry_id}">답변수정</button>
                </c:when>
                <c:otherwise>
                  <button class="btn-view" data-inquiry-id="${inquiry.inquiry_id}">답변</button>
                </c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </tbody>
</table>

<script>
(function() {
  function goToDetail(inquiryId) {
    if (typeof loadInquiryDetail === 'function') {
      loadInquiryDetail(inquiryId);
    } else if (typeof loadPage === 'function') {
      loadPage('/inquiry/admin/detail?inquiry_id=' + inquiryId);
    } else {
      window.location.href = '/inquiry/admin/detail?inquiry_id=' + inquiryId;
    }
  }

  // 행 클릭 이벤트
  document.querySelectorAll('.inquiry-row').forEach(function(row) {
    row.addEventListener('click', function(e) {
      if (e.target.closest('button') || e.target.closest('.action-cell')) {
        return;
      }
      const inquiryId = this.getAttribute('data-inquiry-id');
      if (inquiryId) {
        goToDetail(inquiryId);
      }
    });
  });

  // 버튼 클릭 이벤트
  document.querySelectorAll('.btn-view, .btn-edit').forEach(function(btn) {
    btn.addEventListener('click', function(e) {
      e.stopPropagation();
      const inquiryId = this.getAttribute('data-inquiry-id');
      if (inquiryId) {
        goToDetail(inquiryId);
      }
    });
  });
})();
</script>
