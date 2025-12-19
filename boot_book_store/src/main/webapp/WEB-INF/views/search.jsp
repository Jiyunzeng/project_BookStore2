const grid  = document.getElementById('grid');
const grid2 = document.getElementById('grid2');
const pager = document.getElementById('pager');
const countText = document.getElementById('countText');

// JSP에서 전달한 컨텍스트 경로
const ctx = document.querySelector('meta[name="ctx"]').content;

// 찜 상태를 저장할 맵 (페이지 로드 시 서버에서 가져옴)
let wishStatusMap = {};

// 페이지 로드 시 찜 상태 불러오기
async function loadWishStatus() {
  if (!loginId || loginId.trim() === "") {
    return;
  }
  
  try {
    // 모든 도서의 찜 상태를 확인
    for (let book of books) {
      const bookId = book.id || book.book_id;
      try {
        const response = await fetch(`${ctx}/wishlist/check?book_id=${bookId}`);
        // 404 에러는 조용히 처리 (엔드포인트가 없을 때)
        if (response.ok) {
          const data = await response.json();
          wishStatusMap[bookId] = data.wished || false;
        } else {
          // 404나 다른 에러는 조용히 처리
          wishStatusMap[bookId] = false;
        }
      } catch (e) {
        // 네트워크 에러는 조용히 처리
        wishStatusMap[bookId] = false;
      }
    }
  } catch (e) {
    // 전체 실패는 조용히 처리
    console.error("찜 상태 로드 실패:", e);
  }
}

function card(b){
  const title = b.title || b.book_title || '';
  const author = b.author || b.writer || '';
  const price = Number(b.price||0);
  const id = b.id || b.book_id;
  const detailUrl = `${ctx}/SearchDetail?book_id=${encodeURIComponent(id)}`;
  
  // 로그인 상태 확인
  const isLoggedIn = loginId && loginId.trim() !== '';
  
  // 하트 상태 확인 (서버에서 가져온 데이터 사용)
  const isWished = isLoggedIn ? (wishStatusMap[id] || false) : false;

  return `
    <div class="card">
      <div class="thumb">
        ${b.image ? `<img src="${b.image}" alt="${title}">` : `<div class="placeholder"></div>`}
        ${b.tag ? `<span class="badge">${b.tag}</span>` : ``}
        <!-- 하트 버튼 - 로그인된 경우에만 표시 -->
        ${isLoggedIn ? `
        <button class="heart-btn ${isWished ? 'active' : ''}" data-book-id="${id}" aria-label="찜하기">
          <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path class="heart-empty" d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" />
          </svg>
        </button>
        ` : ''}
      </div>

      <div class="info">
        <h3 class="title-sm">
          <a href="${detailUrl}" class="title-link" aria-label="${title} 상세보기">${title}</a>
        </h3>
        <p class="author">${author}</p>

        <div class="info-bottom">
          <p class="price">${price.toLocaleString()}원</p>
          <button class="cart-btn" data-book-id="${id}">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M6 6h15l-1.5 8.5a2 2 0 0 1-2 1.5H9a2 2 0 0 1-2-1.5L5 3H2"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            담기
          </button>
        </div>
      </div>
    </div>
  `;
}

let activeCat = 'all';
let searchQuery = '';

// 하트 버튼 이벤트 등록 함수
function bindHeartButtons() {
  document.querySelectorAll(".heart-btn").forEach(btn => {
    btn.onclick = null; // 기존 이벤트 제거
    btn.addEventListener("click", async function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      // 로그인 체크
      if(!loginId || loginId.trim() === "") {
        alert("로그인 후 이용해주세요.");
        window.location.href = `${ctx}/login`;
        return;
      }
      
      const bookId = parseInt(this.dataset.bookId);
      const isActive = this.classList.contains('active');
      
      // 찜 해제인 경우
      if (isActive) {
        if (!confirm('이 상품을 찜 목록에서 삭제하시겠습니까?')) {
          return;
        }
      } else {
        // 찜 추가인 경우
        if (!confirm('이 상품을 찜 하시겠습니까?')) {
          return;
        }
      }
      
      try {
        let response;
        if (isActive) {
          // 찜 해제
          response = await fetch(`${ctx}/wishlist/remove`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: `book_id=${bookId}`
          });
        } else {
          // 찜 추가
          response = await fetch(`${ctx}/wishlist/add`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: `book_id=${bookId}`
          });
        }
        
        // 404 에러 처리
        if (!response.ok) {
          alert('서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
          return;
        }
        
        const data = await response.json();
        
        if (data.success) {
          if (isActive) {
            // 찜 해제 성공
            this.classList.remove('active');
            wishStatusMap[bookId] = false;
            alert('찜 목록에서 삭제되었습니다.');
          } else {
            // 찜 추가 성공
            this.classList.add('active');
            wishStatusMap[bookId] = true;
            alert('찜 목록에 추가되었습니다.');
          }
        } else {
          alert(data.message || '처리 중 오류가 발생했습니다.');
        }
      } catch (err) {
        console.error("찜 처리 오류:", err);
        alert('네트워크 오류가 발생했습니다.');
      }
    });
  });
}

// 장바구니 버튼 이벤트 등록
function bindCartButtons() {
  document.querySelectorAll(".cart-btn").forEach(btn => {
    btn.onclick = null; // 기존 이벤트 제거
    btn.addEventListener("click", function() {
      const bookId = this.dataset.bookId;
      console.log("📌 버튼 클릭됨 -> bookId:", bookId, "loginId:", loginId);

      // 로그인 체크
      if(!loginId || loginId.trim() === "") {
        alert("로그인 후 이용해주세요.");
        console.log("⚠ 로그인 안됨 -> 로그인 페이지로 이동");
        window.location.href = `${ctx}/login`;
        return;
      }

      if(!confirm("장바구니에 담으시겠습니까?")) {
        console.log("❌ 장바구니 담기 취소");
        return;
      }

      fetch(`${ctx}/cartAdd`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
        body: `book_id=${encodeURIComponent(bookId)}`
      })
      .then(res => {
        console.log("🔹 Fetch 응답 상태:", res.status, res.statusText);
        return res.text();
      })
      .then(data => {
        console.log("🔹 Fetch 응답 데이터:", data);
        const msg = data.trim();
        if(msg === "success"){
          alert("✅ 장바구니에 담겼습니다!");
        } else if (msg && msg !== "" && msg !== "null" && msg !== "undefined") {
          // 빈 메시지나 null/undefined 문자열 체크
          alert("⚠ " + msg);
        } else {
          alert("⚠ 장바구니 담기 실패");
        }
      })
      .catch(err => {
        console.error("❌ Fetch 에러:", err);
        alert("장바구니 담기 실패");
      });
    });
  });
}


// apply 함수: 리스트 렌더 후 버튼 이벤트 등록
function apply(){
  let list = books.filter(b => {
    const catMatch = activeCat === 'all' ? true : Number(b.cat) === Number(activeCat);
    const searchMatch = searchQuery === '' ? true :
      b.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      b.author.toLowerCase().includes(searchQuery.toLowerCase());
    return catMatch && searchMatch;
  });

  countText.textContent = `총 ${list.length}권`;
  grid.innerHTML = list.map(card).join('');

  bindCartButtons();
  bindHeartButtons(); // 하트 버튼 이벤트 등록 추가
}

// 카테고리 버튼 이벤트
document.querySelectorAll('.cat-btn').forEach(btn => {
  btn.addEventListener('click', e => {
    document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
    e.currentTarget.classList.add('active');
    activeCat = e.currentTarget.querySelector('input[name="genre_id"]').value;
    apply();
  });
});

// 검색 폼 이벤트
const searchForm = document.getElementById('searchForm');
searchForm.addEventListener('submit', e => {
  searchQuery = document.getElementById('q').value.trim();
  apply();
});

// 초기 렌더
loadWishStatus().then(() => {
  apply();
});
