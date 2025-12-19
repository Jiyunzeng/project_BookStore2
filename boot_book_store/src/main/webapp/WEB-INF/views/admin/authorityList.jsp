<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>권한 관리</title>

    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background: #f2eee9;
            margin: 0;
            padding: 0;
        }

        .title {
            font-size: 32px;
            font-weight: 700;
            margin: 60px 0 10px 8%;
            color: #3e2c1c;
        }

        .subtitle {
            font-size: 14px;
            color: #6b7280;
            margin: 0 0 30px 8%;
        }

        /* ---- STAT CARDS ---- */
        .stats-container {
            width: 85%;
            margin: 0 auto 30px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
        }

        .stat-card {
            background: #ffffff;
            padding: 24px;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            text-align: center;
        }

        .stat-card-title {
            font-size: 14px;
            color: #6b7280;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .stat-card-value {
            font-size: 28px;
            font-weight: 700;
            color: #3e2c1c;
        }

        .stat-card-value.admin { color: #795438; }
        .stat-card-value.user { color: #10b981; }
        .stat-card-value.withdrawn { color: #b91c1c; }

        /* ---- TABLE ---- */
        .table-container {
            width: 85%;
            margin: 0 auto 40px;
            background: #ffffff;
            border-radius: 16px;
            padding: 0;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            overflow: hidden;
        }

        table { width: 100%; border-collapse: collapse; font-size: 15px; }
        thead { background: #6b4f34; color: white; font-size: 15px; }
        th { padding: 16px 12px; text-align: center; font-weight: 600; }

        td {
            padding: 18px 12px;
            text-align: center;
            border-bottom: 1px solid #ece4d9;
            color: #4b3b2a;
        }

        tbody tr:hover { background: #f8f5f1; }

        /* ---- ROLE BADGES ---- */
        .role-badge {
            display: inline-flex;
            padding: 5px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .role-badge.USER { background: #e0f2fe; color: #0369a1; }
        .role-badge.ADMIN { background: #fef3c7; color: #92400e; }
        .role-badge.INACTIVE { background: #fee2e2; color: #b91c1c; }

        .role-select {
            padding: 8px 12px;
            border: 1px solid #d9cfc4;
            border-radius: 8px;
            background: #faf7f3;
            font-size: 14px;
            margin-right: 8px;
        }

        .btn-save-role {
            padding: 8px 20px;
            background: #795438;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        .btn-remove-admin {
            padding: 8px 20px;
            background: #b6463b;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }

        .section-title {
            font-size: 24px;
            font-weight: 700;
            margin: 50px 0 20px 8%;
            color: #3e2c1c;
        }
    </style>

</head>

<body>

<div class="title">권한 관리</div>
<div class="subtitle">회원 권한을 관리하고 관리자 계정을 설정할 수 있습니다.</div>

<%
    List membersList = (List)request.getAttribute("members");
    List adminsList = (List)request.getAttribute("admins");

    int totalMembers = (membersList != null) ? membersList.size() : 0;
    int adminCount = (adminsList != null) ? adminsList.size() : 0;

    int userCount = 0;
    int inactiveCount = 0;

    if (membersList != null) {
        for (Object obj : membersList) {
            Map m = (Map)obj;
            String role = (String)m.get("USER_ROLE");

            if ("USER".equals(role)) userCount++;
            else if ("INACTIVE".equals(role)) inactiveCount++;
        }
    }

    pageContext.setAttribute("totalMembers", totalMembers);
    pageContext.setAttribute("adminCount", adminCount);
    pageContext.setAttribute("userCount", userCount);
    pageContext.setAttribute("inactiveCount", inactiveCount);
%>

<!-- ---- STATS CARDS ---- -->
<div class="stats-container">
    <div class="stat-card">
        <div class="stat-card-title">전체 회원</div>
        <div class="stat-card-value">${totalMembers}</div>
    </div>

    <div class="stat-card">
        <div class="stat-card-title">관리자</div>
        <div class="stat-card-value admin">${adminCount}</div>
    </div>

    <div class="stat-card">
        <div class="stat-card-title">일반 회원</div>
        <div class="stat-card-value user">${userCount}</div>
    </div>

    <div class="stat-card">
        <div class="stat-card-title">탈퇴 회원</div>
        <div class="stat-card-value withdrawn">${inactiveCount}</div>
    </div>
</div>

<!-- ---- MEMBER ROLE TABLE ---- -->
<div class="section-title">회원 권한 관리</div>

<div class="table-container">
<table>
    <thead>
        <tr>
            <th>아이디</th>
            <th>이름</th>
            <th>현재 권한</th>
            <th>권한 변경</th>
        </tr>
    </thead>

    <tbody>
    <c:forEach var="m" items="${members}">
        <tr>
            <td>${m.USER_ID}</td>
            <td>${m.USER_NAME}</td>

            <!-- 현재 권한 표시 -->
            <td>
                <span class="role-badge ${m.USER_ROLE}">
                    <c:choose>
                        <c:when test="${m.USER_ROLE == 'ADMIN'}">관리자</c:when>
                        <c:when test="${m.USER_ROLE == 'USER'}">일반</c:when>
                        <c:when test="${m.USER_ROLE == 'INACTIVE'}">탈퇴</c:when>
                    </c:choose>
                </span>
            </td>

            <!-- 탈퇴 회원은 권한 변경 불가 -->
            <td>
                <c:choose>
                    <c:when test="${m.USER_ROLE == 'INACTIVE'}">
                        <span style="color:#999;">변경 불가</span>
                    </c:when>
                    <c:otherwise>
                        <select class="role-select" id="role_${m.USER_ID}">
                            <option value="USER"  ${m.USER_ROLE == 'USER' ? 'selected' : ''}>일반</option>
                            <option value="ADMIN" ${m.USER_ROLE == 'ADMIN' ? 'selected' : ''}>관리자</option>
                        </select>

                        <button class="btn-save-role"
                                onclick="updateRole('${m.USER_ID}')">
                            변경
                        </button>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</div>

<!-- ---- ADMIN LIST ---- -->
<div class="section-title">관리자 계정 목록</div>

<div class="table-container">
<table>
    <thead>
        <tr>
            <th>아이디</th>
            <th>이름</th>
            <th>이메일</th>
            <th>권한</th>
            <th>관리</th>
        </tr>
    </thead>

    <tbody>
    <c:forEach var="a" items="${admins}">
        <tr>
            <td>${a.USER_ID}</td>
            <td>${a.USER_NAME}</td>
            <td>${a.USER_EMAIL}</td>

            <td>
                <span class="role-badge ADMIN">관리자</span>
            </td>

            <td>
                <button class="btn-remove-admin"
                        onclick="removeAdmin('${a.USER_ID}')">
                    관리자 제거
                </button>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</div>

<script>
/* --- 권한 변경 처리 --- */
function updateRole(userId) {
    const newRole = document.getElementById('role_' + userId).value;

    if (!confirm("권한을 변경하시겠습니까?")) return;

    fetch('/admin/member/updateRole', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_id: userId, user_role: newRole })
    })
    .then(res => res.text())
    .then(result => {

        if (result === "REDIRECT_MAIN") {
            alert("권한 변경으로 인해 관리자 페이지에서 나갑니다.");
            location.href = "/main";
            return;   // 🔥 핵심: 아래 코드 실행 막기
        }

        alert("권한이 변경되었습니다.");
        refreshAuthorityPage();  // 이건 다른 사람 권한 바꿀 때만 실행됨
    });
}

/* --- 관리자 제거 처리 --- */
function removeAdmin(userId) {
    if (!confirm("해당 관리자의 권한을 제거하시겠습니까?")) return;

    fetch('/admin/member/updateRole', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ user_id: userId, user_role: "USER" })
    })
    .then(res => res.text())
    .then(result => {

        if (result === "REDIRECT_MAIN") {
            alert("관리자 권한이 제거되어 메인으로 이동합니다.");
            location.href = "/main";
            return;   // 🔥 이거 없으면 또 관리자 페이지를 다시 불러버림
        }

        alert("관리자 권한이 제거되었습니다.");
        refreshAuthorityPage();
    });
}
function refreshAuthorityPage() {
    loadPage("/admin/member/authority");
}
</script>

</body>
</html>
