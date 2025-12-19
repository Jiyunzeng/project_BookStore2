<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html lang="ko">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>글쓰기 - 게시판</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@100..900&display=swap" rel="stylesheet">
  <style>
	:root{
	  --brand: #795438;
	  --brand-dark: #6b4f34;
	  --text: #3e2c1c;
	  --muted: #8a7a6e;
	  --bg: #f2eee9;
	  --card: #ffffff;
	  --radius: 16px;
	  --shadow: 0 10px 25px rgba(0,0,0,.12);
	}

	/* 기본 */
	*{box-sizing:border-box;}
	html,body{height:100%;}
	body {
	  margin: 0;
	  font-family: 'Noto Sans KR', sans-serif;
	  color: var(--text);
	  background: var(--bg);
	  line-height: 1.5;
	}

	/* 컨테이너 */
	.write-container {
	  max-width: 900px;
	  margin: 60px auto;
	  padding: 0 20px;
	}

	.write-header {
	  margin-bottom: 26px;
	}

	.write-title {
	  font-size: clamp(24px, 3vw, 32px);
	  font-weight: 700;
	  color: var(--text);
	  margin: 0;
	}

	/* 폼 박스 */
	.write-form {
	  background: var(--card);
	  border-radius: var(--radius);
	  box-shadow: var(--shadow);
	  padding: 40px;
	}

	/* input 라벨 */
	.form-group {
	  margin-bottom: 24px;
	}
	.form-label {
	  display: block;
	  font-size: 15px;
	  font-weight: 600;
	  color: var(--text);
	  margin-bottom: 8px;
	}
	.form-label.required::after {
	  content: " *";
	  color: #d9534f;
	}

	/* 공통 input/textarea */
	.form-input,
	.form-textarea {
	  width: 100%;
	  padding: 14px 18px;
	  border: 2px solid #decebf;
	  border-radius: 12px;
	  font-size: 15px;
	  font-family: inherit;
	  background: #faf7f3;
	  outline: none;
	  transition: .25s ease;
	}
	.form-input:focus,
	.form-textarea:focus {
	  border-color: var(--brand);
	  background: #fff;
	  box-shadow: 0 0 0 3px rgba(121,84,56,0.15);
	}

	.form-textarea {
	  resize: vertical;
	  min-height: 300px;
	}

	/* 파일 업로드 */
	.file-upload-area {
	  border: 2px dashed #d6c5b7;
	  border-radius: 12px;
	  padding: 30px;
	  text-align: center;
	  background: #faf7f3;
	  cursor: pointer;
	  transition: .25s ease;
	}
	.file-upload-area:hover {
	  border-color: var(--brand);
	  background: #f5eee7;
	}

	.file-upload-area.dragover {
	  border-color: var(--brand);
	  background: #f1e7de;
	}

	.file-upload-icon {
	  font-size: 48px;
	  color: var(--muted);
	  margin-bottom: 12px;
	}
	.file-upload-text {
	  font-size: 15px;
	  color: var(--text);
	  margin-bottom: 6px;
	}
	.file-upload-hint {
	  font-size: 13px;
	  color: var(--muted);
	}

	.file-input { display: none; }

	/* 파일 목록 */
	.file-list {
	  margin-top: 20px;
	  display: none;
	}
	.file-list.active { display: block; }

	.file-item {
	  display: flex;
	  justify-content: space-between;
	  align-items: center;
	  background: #f6efe7;
	  padding: 12px 16px;
	  border-radius: 10px;
	  margin-bottom: 10px;
	}

	.file-item-info {
	  display: flex;
	  align-items: center;
	  gap: 12px;
	  flex: 1;
	}
	.file-item-name {
	  font-size: 14px;
	  color: var(--text);
	}
	.file-item-size {
	  font-size: 12px;
	  color: var(--muted);
	}

	.file-item-remove {
	  background: #d9534f;
	  color: #fff;
	  border: none;
	  border-radius: 6px;
	  padding: 6px 12px;
	  font-size: 12px;
	  cursor: pointer;
	  transition: .25s;
	}
	.file-item-remove:hover {
	  background: #c0392b;
	}

	/* 버튼 */
	.form-actions {
	  margin-top: 30px;
	  display: flex;
	  justify-content: flex-end;
	  gap: 12px;
	}

	.btn {
	  padding: 14px 28px;
	  border: none;
	  border-radius: 12px;
	  font-size: 15px;
	  font-weight: 600;
	  cursor: pointer;
	  transition: .25s ease;
	  font-family: inherit;
	}

	/* 취소 버튼 */
	.btn-cancel {
	  background: #e8ded4;
	  color: var(--text);
	}
	.btn-cancel:hover {
	  background: #d9c8b9;
	}

	/* 등록 버튼 */
	.btn-submit {
	  background: var(--brand);
	  color: #fff;
	}
	.btn-submit:hover {
	  background: var(--brand-dark);
	  transform: translateY(-2px);
	  box-shadow: 0 4px 12px rgba(121,84,56,.3);
	}

	/* 반응형 */
	@media (max-width: 768px){
	  .write-form { padding: 24px; }
	  .form-actions { flex-direction: column; }
	  .btn { width: 100%; }
	}
  </style>
</head>
<body>

  <!-- 공지사항 등록 섹션 -->
  <section class="write-section">
    <div class="write-container">
      <div class="write-header">
        <h1 class="write-title">공지사항 등록</h1>
      </div>

      <form class="write-form" id="writeForm" method="post" action="/admin/notice/write.do" enctype="multipart/form-data">

        <!-- 제목 -->
        <div class="form-group">
          <label class="form-label required" for="title">제목</label>
          <input type="text" id="title" name="noticeTitle" class="form-input" placeholder="공지 제목을 입력하세요" value="[공지]" required>
        </div>

        <!-- 내용 -->
        <div class="form-group">
          <label class="form-label required" for="content">내용</label>
          <textarea id="content" name="noticeContent" class="form-textarea" placeholder="공지 내용을 입력하세요" required></textarea>
        </div>

        <!-- 파일 업로드 -->
        <div class="form-group">
          <label class="form-label" for="fileUpload">파일 업로드</label>
          <div class="file-upload-area" id="fileUploadArea">
            <div class="file-upload-icon">📎</div>
            <div class="file-upload-text">파일을 드래그하거나 클릭하여 업로드</div>
            <div class="file-upload-hint">최대 10MB까지 업로드 가능</div>
            <input type="file" id="fileUpload" name="images" class="file-input" multiple accept=".pdf,.doc,.docx,.xls,.xlsx,.jpg,.jpeg,.png,.gif,.zip,.txt">
          </div>
          <div class="file-list" id="fileList"></div>
        </div>

        <div class="form-actions">
          <button type="button" class="btn btn-cancel" onclick="loadPage('/admin/noticeManagement')">취소</button>
          <button type="submit" class="btn btn-submit">등록</button>
        </div>
      </form>
    </div>
  </section>

  <script>
	// 파일 업로드 관련 스크립트
	var fileUploadArea = document.getElementById('fileUploadArea');
	var fileInput = document.getElementById('fileUpload');
	var fileList = document.getElementById('fileList');
	var selectedFiles = [];

	fileUploadArea.addEventListener('click', () => fileInput.click());
	fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

	fileUploadArea.addEventListener('dragover', (e) => {
	  e.preventDefault();
	  fileUploadArea.classList.add('dragover');
	});
	fileUploadArea.addEventListener('dragleave', () => fileUploadArea.classList.remove('dragover'));
	fileUploadArea.addEventListener('drop', (e) => {
	  e.preventDefault();
	  fileUploadArea.classList.remove('dragover');
	  handleFiles(e.dataTransfer.files);
	});

	function handleFiles(files) {
	  Array.from(files).forEach(file => {
	    if (file.size > 10 * 1024 * 1024) {
	      alert(`${file.name} 파일이 10MB를 초과합니다.`);
	      return;
	    }
	    if (selectedFiles.some(f => f.name === file.name && f.size === file.size)) {
	      alert(`${file.name} 파일이 이미 선택되어 있습니다.`);
	      return;
	    }
	    selectedFiles.push(file);
	    addFileToList(file);
	  });
	  if (selectedFiles.length > 0) fileList.classList.add('active');
	}

	function addFileToList(file) {
	  const fileItem = document.createElement('div');
	  fileItem.className = 'file-item';
	  const fileName = file.name.replace(/'/g, "\\'");
	  const fileSize = formatFileSize(file.size);
	  fileItem.innerHTML = 
	    '<div class="file-item-info">' +
	      '<span class="file-item-name">' + fileName + '</span>' +
	      '<span class="file-item-size">(' + fileSize + ')</span>' +
	    '</div>' +
	    '<button type="button" class="file-item-remove" onclick="removeFile(\'' + fileName + '\', ' + file.size + ')">삭제</button>';
	  fileList.appendChild(fileItem);
	}

	function removeFile(fileName, fileSize) {
	  const index = selectedFiles.findIndex(f => f.name === fileName && f.size === fileSize);
	  if (index > -1) {
	    selectedFiles.splice(index, 1);
	    updateFileList();
	  }
	}

	function updateFileList() {
	  fileList.innerHTML = '';
	  selectedFiles.forEach(file => addFileToList(file));
	  if (selectedFiles.length === 0) {
	    fileList.classList.remove('active');
	  } else {
	    const dataTransfer = new DataTransfer();
	    selectedFiles.forEach(file => dataTransfer.items.add(file));
	    fileInput.files = dataTransfer.files;
	  }
	}

	function formatFileSize(bytes) {
	  if (bytes === 0) return '0 Bytes';
	  const k = 1024;
	  const sizes = ['Bytes', 'KB', 'MB', 'GB'];
	  const i = Math.floor(Math.log(bytes) / Math.log(k));
	  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
	}

<!--	document.getElementById('writeForm').addEventListener('submit', function(e) {-->
<!--	  const title = document.getElementById('title').value.trim();-->
<!--	  const content = document.getElementById('content').value.trim();-->

<!--	  if (!title) {-->
<!--	    e.preventDefault();-->
<!--	    alert('제목을 입력해주세요.');-->
<!--	    document.getElementById('title').focus();-->
<!--	    return false;-->
<!--	  }-->

<!--	  if (!content) {-->
<!--	    e.preventDefault();-->
<!--	    alert('내용을 입력해주세요.');-->
<!--	    document.getElementById('content').focus();-->
<!--	    return false;-->
<!--	  }-->
<!--	});-->
<!--	document.getElementById("writeForm").addEventListener("submit", function(e) {-->
<!--     e.preventDefault(); // 기본 submit 막기-->

<!--     const form = document.getElementById("writeForm");-->
<!--     const formData = new FormData(form); // 파일 포함 FormData 생성-->

<!--     fetch(form.action, {-->
<!--         method: "POST",-->
<!--         body: formData-->
<!--     })-->
<!--     .then(res => res.text())-->
<!--     .then(html => {-->
<!--         // 수정 성공 후 목록 페이지 비동기 로딩-->
<!--         loadPage("/admin/noticeManagement");-->
<!--     })-->
<!--     .catch(err => {-->
<!--         alert("수정 중 오류 발생!");-->
<!--     });-->
<!-- });-->
 function initNoticeWrite() {
   const form = document.getElementById("writeForm");
   if (!form) return;

   // 중복 바인딩 방지
   if (form.dataset.bound === "1") return;
   form.dataset.bound = "1";

   form.addEventListener("submit", function(e) {
     e.preventDefault();

     // 제목/내용 유효성 검사
     const title = document.getElementById('title').value.trim();
     const content = document.getElementById('content').value.trim();

     if (!title) {
       alert("제목을 입력해주세요.");
       document.getElementById('title').focus();
       return;
     }

     if (!content) {
       alert("내용을 입력해주세요.");
       document.getElementById('content').focus();
       return;
     }

     // 실제 등록 실행
     const formData = new FormData(form);

     fetch(form.action, {
       method: "POST",
       body: formData
     })
     .then(() => loadPage("/admin/noticeManagement"))
     .catch(() => alert("등록 실패"));
   });
 }

  </script>
</body>
</html>
