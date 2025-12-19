<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fmt:formatDate value="${book.book_date}" pattern="yyyy-MM-dd" var="pubDate" />

<!-- ===== 도서 수정 메인 래퍼 (하얀 카드 + 폼 + 이미지) ===== -->
<div class="edit-wrapper">
  <div class="edit-card">

    <!-- 왼쪽 : 폼 영역 -->
    <div class="edit-form">
      <h2 class="page-title">도서 수정</h2>

      <form method="post" action="/admin/book/edit">
        <input type="hidden" name="book_id" value="${book.book_id}" />

        <div class="form-row">
          <label>제목</label>
          <input type="text" name="book_title" value="${book.book_title}" required />
        </div>

        <div class="form-row">
          <label>저자</label>
          <input type="text" name="book_writer" value="${book.book_writer}" required />
        </div>

        <div class="form-row">
          <label>출판사</label>
          <input type="text" name="book_pub" value="${book.book_pub}" />
        </div>

        <div class="form-row">
          <label>출간일</label>
          <input type="date" name="book_date" value="${pubDate}" />
        </div>

        <div class="form-row">
          <label>장르</label>
          <select name="genre_id">
            <c:forEach var="g" items="${genres}">
              <option value="${g.genre_id}"
                <c:if test="${g.genre_id == book.genre_id}">selected</c:if>>
                ${g.genre_name}
              </option>
            </c:forEach>
          </select>
        </div>

        <div class="form-row">
          <label>가격</label>
          <input type="number" name="book_price" min="0" value="${book.book_price}" />
        </div>

        <div class="form-row">
          <label>재고</label>
          <input type="number" name="book_count" min="0" value="${book.book_count}" />
        </div>

        <div class="form-row">
          <label>ISBN</label>
          <input type="text" name="book_isbn" value="${book.book_isbn}" />
        </div>

        <div class="form-row">
          <label>설명</label>
          <textarea name="book_comm" rows="3">${book.book_comm}</textarea>
        </div>

        <div class="form-row">
          <label>이미지 URL</label>
          <input type="text" name="book_image_path" value="${book.book_image_path}" />
        </div>

        <div class="form-actions">
			<button type="button" class="btn-primary" onclick="saveBookEdit()">저장</button>

          <button type="button" class="btn-outline-brown"
                  onclick="loadPage('/admin/book/list')">취소</button>
        </div>
      </form>
    </div>

    <!-- 오른쪽 : 도서 이미지 미리보기 -->
    <div class="edit-image-box">
      <c:choose>
        <c:when test="${not empty book.book_image_path}">
          <img src="${book.book_image_path}" alt="도서 이미지" />
        </c:when>
        <c:otherwise>
          <div class="image-placeholder">
            이미지 미리보기
          </div>
        </c:otherwise>
      </c:choose>
    </div>

  </div>
</div>

<!-- ===== 이 화면 전용 스타일 (필요하면 adminMain.css로 옮겨도 됨) ===== -->
<style>
  .edit-wrapper {
    display: flex;
    justify-content: center;
    width: 100%;
    padding: 32px 0 40px;
  }

  .edit-card {
    width: 92%;
    max-width: 1300px;
    min-height: 520px;
    background: #ffffff;
    border-radius: 14px;
    padding: 32px 40px;
    box-shadow: 0 6px 20px rgba(0,0,0,0.06);
    display: flex;
    gap: 60px;
    box-sizing: border-box;
  }

  .edit-form {
    flex: 1.1;
  }

  .edit-image-box {
    flex: 0.9;
    display: flex;
    justify-content: center;
    align-items: flex-start;
  }

  .edit-image-box img {
    max-width: 320px;
    width: 100%;
    border-radius: 10px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.25);
  }

  .image-placeholder {
    width: 320px;
    height: 450px;
    border-radius: 10px;
    border: 1px dashed #c4b59c;
    background: rgba(255, 251, 245, 0.7);
    display: flex;
    align-items: center;
    justify-content: center;
    color: #a0885a;
    font-size: 14px;
  }

  .page-title {
    font-size: 20px;
    font-weight: 600;
    margin-bottom: 24px;
    color: #4b3b2a;
  }

  .form-row {
    display: flex;
    flex-direction: column;
    gap: 6px;
    margin-bottom: 14px;
  }

  .form-row label {
    font-size: 13px;
    color: #6b5a49;
  }

  .form-row input,
  .form-row select,
  .form-row textarea {
    height: 34px;
    padding: 6px 10px;
    font-size: 13px;
    border-radius: 6px;
    border: 1px solid #ddd2c4;
    box-sizing: border-box;
  }

  .form-row textarea {
    height: auto;
    min-height: 70px;
    resize: vertical;
  }

  .form-actions {
    margin-top: 18px;
    display: flex;
    gap: 8px;
  }

  .btn-brown {
    padding: 6px 18px;
    border-radius: 6px;
    border: none;
    background: #b47b42;
    color: #fff;
    font-size: 13px;
    cursor: pointer;
  }

  .btn-outline-brown {
    padding: 6px 18px;
    border-radius: 6px;
    border: 1px solid #b47b42;
    background: #fff;
    color: #b47b42;
    font-size: 13px;
    cursor: pointer;
  }

  .btn-brown:hover {
    background: #9c6734;
  }

  .btn-outline-brown:hover {
    background: #fdf7f0;
  }
</style>
<script>
function saveBookEdit() {

  const form = document.querySelector("form");

  const bookData = {
    book_id: form.book_id.value,
    book_title: form.book_title.value,
    book_writer: form.book_writer.value,
    book_pub: form.book_pub.value,
    book_date: form.book_date.value,
    genre_id: form.genre_id.value,
    book_price: form.book_price.value,
    book_count: form.book_count.value,
    book_comm: form.book_comm.value,
    book_isbn: form.book_isbn.value,
    book_image_path: form.book_image_path.value
  };

  fetch("/admin/book/edit", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(bookData)
  })
    .then(res => res.text())
    .then(result => {
      alert("수정 완료되었습니다.");
      loadPage("/admin/book/list");
    })
    .catch(err => {
      alert("수정 중 오류 발생");
      console.error(err);
    });
}
</script>
