<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BRAND – 글쓰기</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="/css/board.css">
  <link rel="stylesheet" href="/css/boardWrite.css">
</head>
<body>
  <header>
    <nav class="nav">
      <a href="<c:url value='/main'/>" class="brand">
        <img src="/img/book_logo.png" class="brand-logo">
      </a>
      <div class="nav-right">
        <c:choose>
          <c:when test="${empty sessionScope.loginDisplayName}">
            <a href="/login">로그인</a>
            <a href="/register">회원가입</a>
            <a href="/cart">장바구니</a>
          </c:when>
          <c:otherwise>
            <a href="/mypage">마이페이지</a>
            <a href="/cart">장바구니</a>
            <a href="/logout">로그아웃</a>
            <span style="font-weight:700; color:#666;">${sessionScope.loginDisplayName}님</span>
          </c:otherwise>
        </c:choose>
      </div>
    </nav>
  </header>
  <section class="boardhead">
    <div class="boardsubwrap">
      <h1>글쓰기</h1>
      <p>새로운 소식을 자유롭게 공유해보세요</p>
    </div>
  </section>
  <main class="main-content write-content">
    <form id="writeForm" class="write-form" method="post" action="/board/write.do" enctype="multipart/form-data">
      <!-- 제목 -->
      <div class="write-block">
        <label class="write-label">제목</label>
        <input type="text" id="title" name="title" class="write-input" placeholder="제목을 입력하세요" required>
      </div>
      <!-- 내용 -->
      <div class="write-block">
        <label class="write-label">내용</label>
        <textarea id="content" name="contents" class="write-textarea" placeholder="내용을 입력하세요" required></textarea>
      </div>
      <!-- 파일 업로드 -->
	  <div class="form-group">
	    <label class="form-label" for="fileUpload">파일 업로드</label>
	    <div class="file-upload-area" id="fileUploadArea">
	      <div class="file-upload-icon">📎</div>
	      <div class="file-upload-text">파일을 드래그하거나 클릭하여 업로드</div>
	      <input type="file" id="fileUpload" name="images" class="file-input" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png,.gif,.zip,.txt">
	    </div>
	    <div class="file-list" id="fileList"></div>
	  </div>
      <!-- 버튼 -->
      <div class="write-btn-wrap">
        <a href="/board/list" class="write-cancel">취소</a>
        <button type="submit" class="write-submit">등록하기</button>
      </div>
    </form>
  </main>
  <script>
    // 파일 업로드 관련 요소
    const fileUploadArea = document.getElementById('fileUploadArea');
    const fileInput = document.getElementById('fileUpload');
    const fileList = document.getElementById('fileList');
    const selectedFiles = [];

    // 클릭 -> 파일 선택
    fileUploadArea.addEventListener('click', function () { fileInput.click(); });

    // 파일 선택 시
    fileInput.addEventListener('change', function (e) { handleFiles(e.target.files); });

    // 드래그 오버
    fileUploadArea.addEventListener('dragover', function (e) {
      e.preventDefault();
      fileUploadArea.classList.add('dragover');
    });

    // 드래그 떠날 때
    fileUploadArea.addEventListener('dragleave', function () {
      fileUploadArea.classList.remove('dragover');
    });

    // 드롭
    fileUploadArea.addEventListener('drop', function (e) {
      e.preventDefault();
      fileUploadArea.classList.remove('dragover');
      handleFiles(e.dataTransfer.files);
    });

    // 파일 처리
    function handleFiles(files) {
      Array.from(files).forEach(function (file) {
        // 10MB 제한
        if (file.size > 10 * 1024 * 1024) {
          alert(file.name + ' 파일이 10MB를 초과합니다.');
          return;
        }

        // 중복 체크
        if (selectedFiles.some(function (f) { return f.name === file.name && f.size === file.size; })) {
          alert(file.name + ' 파일이 이미 선택되어 있습니다.');
          return;
        }

        selectedFiles.push(file);
      });

      updateFileList();
    }

    // 파일 목록 UI 갱신
    function updateFileList() {
      fileList.innerHTML = '';
      if (selectedFiles.length === 0) { fileList.classList.remove('active'); }
      else { fileList.classList.add('active'); }

      selectedFiles.forEach(function (file, index) {
        const item = document.createElement('div');
        item.className = 'file-item';

        const info = document.createElement('div');
        info.className = 'file-item-info';

        const nameSpan = document.createElement('span');
        nameSpan.className = 'file-item-name';
        nameSpan.textContent = file.name;

        const sizeSpan = document.createElement('span');
        sizeSpan.className = 'file-item-size';
        sizeSpan.textContent = '(' + formatSize(file.size) + ')';

        info.appendChild(nameSpan);
        info.appendChild(sizeSpan);

        const removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'file-item-remove';
        removeBtn.textContent = '삭제';
        removeBtn.addEventListener('click', function () { removeFile(index); });

        item.appendChild(info);
        item.appendChild(removeBtn);

        fileList.appendChild(item);
      });

      const dt = new DataTransfer();
      selectedFiles.forEach(function (file) { dt.items.add(file); });
      fileInput.files = dt.files;
    }

    // 파일 삭제
    function removeFile(index) {
      selectedFiles.splice(index, 1);
      updateFileList();
    }

    // 파일 크기 포맷
    function formatSize(bytes) {
      if (bytes === 0) return '0 Bytes';
      const k = 1024;
      const sizes = ['Bytes', 'KB', 'MB', 'GB'];
      const i = Math.floor(Math.log(bytes) / Math.log(k));
      return (bytes / Math.pow(k, i)).toFixed(2) + ' ' + sizes[i];
    }

    // 폼 검증
    document.getElementById('writeForm').addEventListener('submit', function (e) {
      const title = document.getElementById('title').value.trim();
      const content = document.getElementById('content').value.trim();

      if (!title) {
        alert('제목을 입력해주세요.');
        document.getElementById('title').focus();
        e.preventDefault();
        return;
      }

      if (!content) {
        alert('내용을 입력해주세요.');
        document.getElementById('content').focus();
        e.preventDefault();
        return;
      }
    });
  </script>
</body>
</html>
