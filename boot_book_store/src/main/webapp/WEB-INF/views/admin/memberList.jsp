<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 관리</title>

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: #f2eee9;  /* 📌 부드러운 베이지 */
            margin: 0;
            padding: 0;
        }

        .title {
            font-size: 32px;
            font-weight: 700;
            margin: 60px 0 26px 8%;
            color: #3e2c1c; /* 📌 짙은 갈색 */
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

        .btn-edit, .btn-delete {
            padding: 8px 18px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            margin: 0 3px;
        }

        .btn-edit {
            background: #795438; /* 📌 브라운 */
            color: white;
        }

        .btn-edit:hover {
            background: #8a6141;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .btn-delete {
            background: #b6463b;
            color: white;
        }

        .btn-delete:hover {
            background: #cc5247;
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        .action-buttons {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .empty-message {
            text-align: center;
            padding: 60px 20px;
            color: #6b7280;
            font-size: 15px;
        }
    </style>
</head>

<body>

<div class="title">회원 관리</div>

<div class="table-container">
    <table>
        <thead>
            <tr>
                <th>아이디</th>
                <th>이름</th>
                <th>닉네임</th>
                <th>이메일</th>
                <th>전화번호</th>
                <th>로그인 타입</th>
                <th>가입일</th>
                <th>관리</th>
            </tr>
        </thead>

        <tbody>
            <c:choose>
                <c:when test="${empty members}">
                    <tr>
                        <td colspan="8" class="empty-message">등록된 회원이 없습니다.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="m" items="${members}">
                        <tr>
                            <td>${m.USER_ID}</td>
                            <td>${m.USER_NAME}</td>
                            <td>${m.USER_NICKNAME}</td>
                            <td>${m.USER_EMAIL}</td>
                            <td>${m.USER_PHONE_NUM}</td>
                            <td>${m.LOGIN_TYPE}</td>
                            <td>${m.REG_DATE}</td>
                            <td>
                                <div class="action-buttons">
									<c:if test="${m.USER_ROLE != 'INACTIVE'}">
									    <button class="btn-edit"
									            onclick="loadPage('/admin/member/detail?user_id=${m.USER_ID}')">수정</button>
									</c:if>
                                    <button class="btn-delete"
                                            onclick="if(confirm('정말 삭제하시겠습니까?')) loadPage('/admin/member/delete?user_id=${m.USER_ID}')">삭제</button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

</body>
</html>
