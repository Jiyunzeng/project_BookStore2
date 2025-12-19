package com.boot.service;

import java.util.List;
import com.boot.dto.CartDTO;

public interface CartService {
   List<CartDTO> getCartByUserId(String user_id);
   
   // 장바구니 추가 메서드 추가
   void addCart(CartDTO cart);
   
   boolean updateQuantity(String userId, int bookId, int quantity);
}