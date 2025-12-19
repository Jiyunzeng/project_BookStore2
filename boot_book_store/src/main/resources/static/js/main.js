

// 책 속 한 줄: 좌우 스크롤
(function(){
  const track = document.getElementById('quotesTrack');
  if(!track) return;
  const prev = document.getElementById('quotesPrev');
  const next = document.getElementById('quotesNext');

  const cardWidth = () => {
    const first = track.querySelector('.q-card');
    if(!first) return 320;
    return first.getBoundingClientRect().width + 16;
  };

  prev.addEventListener('click', ()=> track.scrollBy({left:-cardWidth(), behavior:'smooth'}));
  next.addEventListener('click', ()=> track.scrollBy({left: cardWidth(), behavior:'smooth'}));
})();

// FAQ 토글
(function(){
  const items = document.querySelectorAll('.faq-item');
  if(!items.length) return;
  items.forEach(item => {
    const q = item.querySelector('.faq-question');
    const a = item.querySelector('.faq-answer');
    const icon = item.querySelector('.faq-icon');
    if(a){
      a.style.maxHeight = '0px';
      a.style.overflow = 'hidden';
      a.style.boxSizing = 'border-box';
      a.style.willChange = 'max-height';
      a.style.transition = 'max-height 300ms cubic-bezier(.2,.6,.2,1), padding 300ms cubic-bezier(.2,.6,.2,1)';
      a.style.paddingTop = '0px';
      a.style.paddingBottom = '0px';
    }
    q.addEventListener('click', () => {
      const open = a && a.style.maxHeight !== '0px';
      if(open){
        a.style.maxHeight = '0px';
        a.style.paddingTop = '0px';
        a.style.paddingBottom = '0px';
        if(icon){ icon.style.transform = 'rotate(0deg)'; }
        item.classList.remove('active');
      } else {
        a.style.maxHeight = (a.scrollHeight + 24) + 'px';
        a.style.paddingTop = '8px';
        a.style.paddingBottom = '12px';
        if(icon){ icon.style.transform = 'rotate(180deg)'; }
        item.classList.add('active');
      }
    });
  });
})();
//chat
// === 챗봇 열기/닫기 ===
document.getElementById("chatbotBtn").addEventListener("click", function() {
  document.getElementById("chatbotModal").style.display = "block";
});

document.getElementById("chatbotClose").addEventListener("click", function() {
  document.getElementById("chatbotModal").style.display = "none";
});

// === 메시지 출력 함수 (더보기 + 접기 기능 포함) ===
function displayMessage(text, sender = "bot") {
    const box = document.getElementById("chatMessages");

    const wrapper = document.createElement("div");
    wrapper.className = sender === "user" ? "chat-msg user" : "chat-msg bot";

    // 봇일 때만 아바타
    if (sender === "bot") {
        const avatar = document.createElement("img");
        avatar.className = "chat-avatar";
        avatar.src = "/img/bot.png"; 
        wrapper.appendChild(avatar);
    }

    const bubble = document.createElement("div");
    bubble.className = "msg-bubble";
    bubble.innerHTML = text;
    wrapper.appendChild(bubble);

    box.appendChild(wrapper);

    // 자동 접기
//    setTimeout(() => {
//        if (bubble.scrollHeight > 120) {
//            collapseBubble(bubble);
//        }
//		
//    }, 10);

    box.scrollTop = box.scrollHeight;
}


// -------------------------------
// 말풍선 접기 상태로 만들기
// -------------------------------
function collapseBubble(bubble) {

    // class 추가 (중요!!)
    bubble.classList.add("collapsed");

    bubble.dataset.originalHeight = bubble.scrollHeight;

    bubble.style.maxHeight = "140px";
    bubble.style.overflow = "hidden";
    bubble.style.paddingBottom = "32px";

    bubble.style.maskImage =
        "linear-gradient(to bottom, black 70%, transparent 100%)";

    addToggleButton(bubble, "더보기", expandBubble);
}

function expandBubble(bubble) {

    // class 제거
    bubble.classList.remove("collapsed");

    bubble.style.maxHeight = "none";
    bubble.style.overflow = "visible";
    bubble.style.maskImage = "none";

    replaceToggleButton(bubble, "접기", collapseBubble);
}

function addToggleButton(bubble, label, action) {
    const oldBtn = bubble.querySelector(".see-more-btn");
    if (oldBtn) oldBtn.remove();

    const btn = document.createElement("button");
    btn.className = "see-more-btn";
    btn.textContent = label;
    btn.type = "button";

    btn.onclick = (e) => {
        e.stopPropagation();  // 혹시 버블링 문제 방지
        action(bubble);
    };

    bubble.appendChild(btn);
}

function replaceToggleButton(bubble, label, action) {
    const oldBtn = bubble.querySelector(".see-more-btn");
    if (oldBtn) oldBtn.remove();
    addToggleButton(bubble, label, action);
}



// -------------------------------
// 말풍선 확장 (전체 보기)
// -------------------------------
function expandBubble(bubble) {
    bubble.style.maxHeight = "none";
    bubble.style.overflow = "visible";
    bubble.style.maskImage = "none";
    bubble.style.paddingBottom = "32px";

    // 버튼 교체: 접기 버튼으로
    replaceToggleButton(bubble, "접기", collapseBubble);
}

document.querySelector(".chat-send-btn").addEventListener("click", () => {
    sendUserMessage(document.getElementById("chatInput").value);
});

//function displayMessage(text, sender = "bot") {
//    const box = document.getElementById("chatMessages");
//    const div = document.createElement("div");
//
//    if (sender === "user") {
//        div.style.textAlign = "right";
//        div.innerHTML = `
//            <div style="
//                display:inline-block;
//                background:#DCF8C6;
//                padding:8px 12px;
//                border-radius:10px;
//                margin:5px 0;
//                max-width:70%;
//            ">${text}</div>`;
//    } else {
//        div.style.textAlign = "left";
//        div.innerHTML = `
//            <div style="
//                display:inline-block;
//                background:#F1F0F0;
//                padding:8px 12px;
//                border-radius:10px;
//                margin:5px 0;
//                max-width:70%;
//            ">${text}</div>`;
//    }
//
//    box.appendChild(div);
//    box.scrollTop = box.scrollHeight;
//}

//// === 메시지 출력 함수 ===
//function displayMessage(text, sender = "bot") {
//    const box = document.getElementById("chatMessages");
//    const div = document.createElement("div");
//
//    // user / bot 클래스 적용
//    div.className = sender === "user" ? "chat-msg user" : "chat-msg bot";
//
//    // 공통 말풍선
//    div.innerHTML = `<div class="msg-bubble">${text}</div>`;
//
//    box.appendChild(div);
//    box.scrollTop = box.scrollHeight;
//}

// === Gemini API 호출 + 출력 ===
function sendUserMessage(message) {
    if (!message.trim()) return;

    displayMessage(message, "user");
    document.getElementById("chatInput").value = "";

    showTyping();   // 🔥 여기서 로딩말풍선 시작!

    fetch('/api/gemini', {
        method: 'POST',
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify({message: message})
    })
    .then(resp => resp.json())
    .then(data => {
        hideTyping(); // 🔥 답변 오면 제거
        const botText = data.contents[0].parts[0].text;
        displayMessage(botText, "bot");
    })
    .catch(err => {
        hideTyping();
        displayMessage("“지금 GPT가 잠시 바쁨! 조금 뒤 다시 시도해줘 😊”", "bot");
    });
}

// === 엔터로 전송 ===
document.getElementById("chatInput").addEventListener("keydown", function(e){
    if (e.key === "Enter") {
        sendUserMessage(this.value);
    }
});

function showTyping() {
    const box = document.getElementById("chatMessages");

    // 이미 존재하면 중복 생성 방지
    if (document.getElementById("typing-indicator")) return;

    const wrapper = document.createElement("div");
    wrapper.className = "chat-msg bot";
    wrapper.id = "typing-indicator";

    wrapper.innerHTML = `
        <div class="msg-bubble typing-animation">
            <span class="dot"></span>
            <span class="dot"></span>
            <span class="dot"></span>
        </div>
    `;

    box.appendChild(wrapper);
    box.scrollTop = box.scrollHeight;
}

function hideTyping() {
    const typing = document.getElementById("typing-indicator");
    if (typing) typing.remove();
}

function createCard(book) {
  const id = book.id;
  const title = book.title;
  const author = book.author;
  const price = book.price;
  const img = book.image;
  const priceFormatted = price.toLocaleString();
  const detailUrl = `${ctx}/SearchDetail?book_id=${id}`;

  const isLoggedIn = loginId && loginId.trim() !== "";
  const isWished = isLoggedIn ? (wishStatusMap[id] || false) : false;

  return `
    <div class="card">
      <div class="thumb">
        ${img ? `<img src="${img}" alt="${title}">` : `<div class="placeholder"></div>`}

        <!-- 찜 버튼 -->
        ${isLoggedIn ? `
          <button class="heart-btn ${isWished ? 'active' : ''}"
                  data-book-id="${id}">
            <svg viewBox="0 0 24 24" fill="none">
              <path class="heart-empty" d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78
                7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 
                5.5 0 0 0 0-7.78z"/>
            </svg>
          </button>
        ` : ``}
      </div>

      <div class="info">
        <h3 class="title-sm">
          <a href="${detailUrl}" class="title-link">${title}</a>
        </h3>
        <p class="author">${author}</p>

        <div class="info-bottom">
          <p class="price">${priceFormatted}원</p>

          <button class="cart-btn" data-book-id="${id}">
            <svg viewBox="0 0 24 24" fill="none">
              <path d="M6 6h15l-1.5 8.5a2 2 0 0 1-2 1.5H9a2 2 0 0 1-2-1.5L5 3H2"
                    stroke="currentColor" stroke-width="2"
                    stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            담기
          </button>
        </div>
      </div>
    </div>
  `;
}



function renderRecommendedBooks() {
  const container = document.getElementById('productsGrid');
  container.innerHTML = recommendedBooks.map(createCard).join('');
  
  // 이벤트 바인딩 함수 호출 필요 (찜, 장바구니 버튼 등)
  bindHeartButtons();
  bindCartButtons();
}

// 초기 페이지 로드 시 실행
document.addEventListener('DOMContentLoaded', async () => {
  await loadWishStatus();
  renderRecommendedBooks();
});

// 찜 상태 맵
let wishStatusMap = {};

// 찜 상태 로드
async function loadWishStatus() {
  if (!loginId || loginId.trim() === "") return;

  try {
    for (let book of recommendedBooks) {
      const bookId = book.id;

      try {
        const response = await fetch(`${ctx}/wishlist/check?book_id=${bookId}`);
        const data = await response.json();
        wishStatusMap[bookId] = data.wished || false;
      } catch (e) {
        wishStatusMap[bookId] = false;
      }
    }
  } catch (e) {
    console.error("찜 상태 로드 실패:", e);
  }
}

function bindHeartButtons() {
  document.querySelectorAll(".heart-btn").forEach(btn => {
    btn.onclick = null;
    btn.addEventListener("click", async function(e) {
      e.preventDefault();
      e.stopPropagation();
      
      if (!loginId || loginId.trim() === "") {
        alert("로그인 후 이용해주세요.");
        window.location.href = `${ctx}/login`;
        return;
      }

      const bookId = parseInt(this.dataset.bookId);
      const isActive = this.classList.contains('active');

      if (isActive) {
        if (!confirm('이 상품을 찜 목록에서 삭제하시겠습니까?')) return;
      } else {
        if (!confirm('이 상품을 찜 하시겠습니까?')) return;
      }

      try {
        let response;
        if (isActive) {
          response = await fetch(`${ctx}/wishlist/remove`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: `book_id=${bookId}`
          });
        } else {
          response = await fetch(`${ctx}/wishlist/add`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
            body: `book_id=${bookId}`
          });
        }

        const data = await response.json();

        if (data.success) {
          if (isActive) {
            this.classList.remove('active');
            wishStatusMap[bookId] = false;
            alert('찜 목록에서 삭제되었습니다.');
          } else {
            this.classList.add('active');
            wishStatusMap[bookId] = true;
            alert('찜 목록에 추가되었습니다.');
          }
        }
      } catch (err) {
        console.error("찜 처리 오류:", err);
        alert('네트워크 오류가 발생했습니다.');
      }
    });
  });
}

function bindCartButtons() {
  document.querySelectorAll(".cart-btn").forEach(btn => {
    btn.onclick = null;
    btn.addEventListener("click", function() {
      const bookId = this.dataset.bookId;

      if (!loginId || loginId.trim() === "") {
        alert("로그인 후 이용해주세요.");
        window.location.href = `${ctx}/login`;
        return;
      }

      if (!confirm("장바구니에 담으시겠습니까?")) return;

      fetch(`${ctx}/cartAdd`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
        body: `book_id=${encodeURIComponent(bookId)}`
      })
      .then(res => res.text())
      .then(data => {
        const msg = data.trim();
        if(msg === "success"){
          alert("장바구니에 담겼습니다!");
        } else {
          alert(msg);
        }
      })
      .catch(err => {
        console.error("Fetch 에러:", err);
        alert("장바구니 담기 실패");
      });
    });
  });
}
