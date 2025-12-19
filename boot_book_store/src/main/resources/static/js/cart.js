document.addEventListener("DOMContentLoaded", () => {
  const selectAllCheckbox = document.getElementById("selectAll");
  const selectedCountElem = document.getElementById("selectedCount");
  const removeSelectedBtn = document.getElementById("removeSelectedBtn");
  const clearCartBtn = document.getElementById("clearCartBtn");
  const checkoutBtn = document.getElementById("checkoutBtn");
  const form = document.getElementById("orderForm");
  const context = document.querySelector('meta[name="ctx"]').getAttribute('content');

  function updateSelectedCount() {
    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    selectedCountElem.textContent = `(${checkedBoxes.length}개 선택)`;
  }

  function updateSummary() {
    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    let total = 0;

    checkedBoxes.forEach(cb => {
      const row = cb.closest("tr");
      const quantity = parseInt(row.querySelector(".quantity-input").value, 10);
      const unitPrice = parseInt(row.dataset.price, 10);
      total += unitPrice * quantity;
    });

    const delivery = total >= 30000 ? 0 : 3000;

    document.getElementById("subtotalText").textContent = `₩${total.toLocaleString()}`;
    document.getElementById("shippingText").textContent = delivery === 0 ? "무료" : `₩${delivery.toLocaleString()}`;
    document.getElementById("grandTotalText").textContent = `₩${(total + delivery).toLocaleString()}`;
  }

  selectAllCheckbox.addEventListener("change", () => {
    document.querySelectorAll(".cart-checkbox").forEach(cb => (cb.checked = selectAllCheckbox.checked));
    updateSelectedCount();
    updateSummary();
  });

  document.querySelectorAll(".cart-checkbox").forEach(cb => {
    cb.addEventListener("change", () => {
      const allCheckboxes = document.querySelectorAll(".cart-checkbox");
      const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
      selectAllCheckbox.checked = allCheckboxes.length === checkedBoxes.length;
      updateSelectedCount();
      updateSummary();
    });
  });

  document.querySelectorAll(".quantity-input").forEach(input => {
    input.addEventListener("change", e => {
      let qty = parseInt(e.target.value, 10);
      if (isNaN(qty) || qty < 1) qty = 1;
      else if (qty > 99) qty = 99;
      e.target.value = qty;

      const row = e.target.closest("tr");
      const priceElem = row.querySelector(".price");
      const unitPrice = parseInt(row.dataset.price, 10); // 단가를 data-price에서 읽음
      const newPrice = unitPrice * qty;
      priceElem.textContent = `₩${newPrice.toLocaleString()}`;

      updateSummary();
    });
  });

  removeSelectedBtn.addEventListener("click", e => {
    e.preventDefault();
    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    if (checkedBoxes.length === 0) {
      alert("삭제할 상품을 선택해주세요.");
      return;
    }
    if (!confirm("선택한 상품을 삭제하시겠습니까?")) return;

    const cartIds = Array.from(checkedBoxes).map(cb => cb.closest("tr").dataset.cartId);

    fetch(`${context}/deleteCartItems`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ cartIds: cartIds })
    })
    .then(res => {
      if (res.ok) {
        checkedBoxes.forEach(cb => cb.closest("tr").remove());
        updateSelectedCount();
        updateSummary();
      } else {
        alert("삭제 실패. 다시 시도해주세요.");
      }
    })
    .catch(() => alert("네트워크 오류가 발생했습니다."));
  });

  clearCartBtn.addEventListener("click", e => {
    e.preventDefault();
    if (!confirm("장바구니를 모두 비우시겠습니까?")) return;

    fetch(`${context}/clearCart`, { method: 'POST' })
      .then(res => {
        if (res.ok) {
          document.querySelectorAll("#cartRows tr").forEach(row => row.remove());
          updateSelectedCount();
          updateSummary();
        } else {
          alert("전체 비우기 실패. 다시 시도해주세요.");
        }
      })
      .catch(() => alert("네트워크 오류가 발생했습니다."));
  });

  checkoutBtn.addEventListener("click", e => {
    e.preventDefault();

    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    if (checkedBoxes.length === 0) {
      alert("주문할 상품을 선택해주세요.");
      return;
    }

    form.querySelectorAll(".dynamic-input").forEach(el => el.remove());

    checkedBoxes.forEach(cb => {
      const row = cb.closest("tr");
      const bookId = cb.value;
      const quantity = parseInt(row.querySelector(".quantity-input").value, 10);
      const unitPrice = parseInt(row.dataset.price, 10);
      const totalPrice = unitPrice * quantity;

      const inputBook = document.createElement("input");
      inputBook.type = "hidden";
      inputBook.name = "book_id";
      inputBook.value = bookId;
      inputBook.classList.add("dynamic-input");

      const inputQty = document.createElement("input");
      inputQty.type = "hidden";
      inputQty.name = "quantity";
      inputQty.value = quantity;
      inputQty.classList.add("dynamic-input");

      const inputPrice = document.createElement("input");
      inputPrice.type = "hidden";
      inputPrice.name = "purchase_price";
      inputPrice.value = totalPrice;
      inputPrice.classList.add("dynamic-input");

      form.appendChild(inputBook);
      form.appendChild(inputQty);
      form.appendChild(inputPrice);
    });

    form.submit();
  });

  //토스페이 버튼
  // TossPayments 인스턴스 전역 생성 (클라이언트 키는 실제 발급받은 키로 교체)
  const tossPayments = new TossPayments('test_ck_yZqmkKeP8gmklj2ovMMkVbQRxB9l');

  tossPayBtn.addEventListener("click", e => {
    e.preventDefault();

    const checkedBoxes = document.querySelectorAll(".cart-checkbox:checked");
    if (checkedBoxes.length === 0) {
      alert("결제할 상품을 선택해주세요.");
      return;
    }

    const orderItems = Array.from(checkedBoxes).map(cb => {
      const row = cb.closest("tr");
      return {
        book_id: cb.value,
        quantity: parseInt(row.querySelector(".quantity-input").value, 10),
        purchase_price: parseInt(row.dataset.price, 10)
      };
    });

    // 서버에 주문 생성 요청
    fetch(`${context}/api/createTossOrder`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ items: orderItems })
    })
    .then(res => {
      if (!res.ok) throw new Error("서버 오류: " + res.status);
      return res.json();
    })
    .then(data => {
      if (!data.success) {
        alert("주문 생성 실패: " + (data.message || ""));
        return;
      }

      // 토스 결제창 띄우기 - SDK 인스턴스의 requestPayment 메서드 사용
      tossPayments.requestPayment('CARD', {
        amount: data.total_price,
        orderId: data.order_id.toString(),
        orderName: "책갈피 주문",
        successUrl: window.location.origin + "/paymentSuccess",
        failUrl: window.location.origin + "/paymentFail"
      }).then(function(result) {
        // 결제 성공 시 처리 (Redirect 방식에서는 이 Promise는 실행 안 될 수도 있음)
        alert("결제가 완료되었습니다.");
        window.location.href = `${context}/purchaseHistory`;
      }).catch(function(error) {
        // 결제 실패 또는 취소
        alert("결제 실패: " + (error.message || "알 수 없는 오류"));
        console.error("결제 실패 상세:", error);
      });
    })
    .catch(err => {
      alert("네트워크 오류가 발생했습니다: " + err.message);
      console.error("createTossOrder 요청 오류:", err);
    });
  });

  
  //장바구니 수량 변경
  document.querySelectorAll(".quantity-input").forEach(input => {
    input.addEventListener("change", function() {
      const newQuantity = parseInt(this.value, 10);
      const bookId = this.dataset.bookId; // input 태그에 data-book-id 속성이 있다고 가정

      if (newQuantity < 1) {
        alert("수량은 1 이상이어야 합니다.");
        this.value = 1;
        return;
      }

      updateCartQuantity(bookId, newQuantity);
    });
  });

  function updateCartQuantity(bookId, newQuantity) {
    fetch('/api/cart/updateQuantity', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ book_id: parseInt(bookId, 10), quantity: newQuantity })
    })
    .then(response => response.json())
    .then(data => {
      if (!data.success) {
        alert("수량 업데이트에 실패했습니다: " + (data.message || ""));
      }
    })
    .catch(error => {
      console.error("수량 업데이트 오류:", error);
      alert("서버와 통신 중 오류가 발생했습니다.");
    });
  }



  updateSelectedCount();
  updateSummary();
});
