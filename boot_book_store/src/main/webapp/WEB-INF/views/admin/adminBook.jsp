<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
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
        margin: 0;
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

    .action-bar {
        width: 85%;
        margin: 20px auto 0;
        display: flex;
        justify-content: flex-end;
    }

    .btn-primary {
        padding: 12px 22px;
        background: #795438;
        color: #fff;
        border: none;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
    }

    .btn-primary:hover {
        background: #8a6141;
    }

    .btn-action {
        padding: 8px 16px;
        background: #795438;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: 0.2s;
        margin: 0 3px;
    }

    .btn-action:hover {
        background: #8a6141;
    }

    .btn-delete {
        background: #b23a30;
    }

    .btn-delete:hover {
        background: #9c2e25;
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
</style>

<div class="title-header">
    <div class="title">도서 관리</div>
</div>

<div class="table-container">
    <table>
        <thead>
            <tr>
                <th style="width:60px;">ID</th>
                <th>제목</th>
                <th>저자</th>
                <th style="width:100px;">가격</th>
                <th style="width:80px;">장르</th>
                <th style="width:150px;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty books}">
                    <tr>
                        <td colspan="6">등록된 도서가 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="b" items="${books}">
                        <tr>
                            <td>${b.book_id}</td>
                            <td>${b.book_title}</td>
                            <td>${b.book_writer}</td>
                            <td><fmt:formatNumber value="${b.book_price}" pattern="#,###" />원</td>
                            <td>${b.genre_id}</td>
                            <td>
                                <button class="btn-action" onclick="loadPage('/admin/book/edit?id=${b.book_id}')">수정</button>
                                <button class="btn-action btn-delete" onclick="deleteBook(${b.book_id})">삭제</button>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<div class="action-bar">
    <button type="button" class="btn-primary" onclick="loadPage('/admin/book/add')">도서 등록</button>
</div>

<c:set var="totalPage" value="${(totalCount / pageSize) + (totalCount % pageSize > 0 ? 1 : 0)}" />

<div class="pagination">
    <c:if test="${currentPage > 1}">
        <a href="javascript:void(0)"
           onclick="loadPage('/admin/book/list?page=${currentPage - 1}')">&lt;</a>
    </c:if>

    <c:forEach begin="1" end="${totalPage}" var="p">
        <a href="javascript:void(0)"
           onclick="loadPage('/admin/book/list?page=${p}')"
           class="${p == currentPage ? 'active' : ''}">${p}</a>
    </c:forEach>

    <c:if test="${currentPage < totalPage}">
        <a href="javascript:void(0)"
           onclick="loadPage('/admin/book/list?page=${currentPage + 1}')">&gt;</a>
    </c:if>
</div>

<script>
function deleteBook(id) {
    if (!confirm("정말 삭제하시겠습니까?")) return;

    fetch('/admin/book/delete?id=' + id, { method: 'POST' })
        .then(res => res.text())
        .then(txt => {
            if (txt.trim() === 'OK') {
                alert('삭제되었습니다.');
                loadPage('/admin/book/list');
            } else {
                alert('삭제 실패: ' + txt);
            }
        });
}
</script>
