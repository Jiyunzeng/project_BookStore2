package com.boot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.dao.CartDAO;
import com.boot.dao.CartDAOImpl;
import com.boot.dto.CartDTO;

@Service
public class CartServiceImpl implements CartService {

    @Autowired
    private CartDAO cartDAO;

    @Override
    public List<CartDTO> getCartByUserId(String user_id) {
        return cartDAO.selectCartWithBookByUserId(user_id);
    }

    @Override
    @Transactional
    public void addCart(CartDTO cart) {
        if (cart.getQuantity() <= 0) {
            cart.setQuantity(1);
        }
        List<CartDTO> cartList = cartDAO.selectCartByUserId(cart.getUser_id());
        CartDTO existing = null;
        for (CartDTO c : cartList) {
            if (c.getBook_id() == cart.getBook_id()) {
                existing = c;
                break;
            }
        }
        if (existing != null) {
            int newQty = existing.getQuantity() + cart.getQuantity();
            cartDAO.updateCartQuantityByParams(existing.getCart_id(), newQty);
        } else {
            cartDAO.insertCartItem(cart);
        }
    }

    @Override
    public boolean updateQuantity(String userId, int bookId, int quantity) {
        CartDTO cart = cartDAO.selectCartItemByUserAndBook(userId, bookId);
        if (cart == null) return false;
        int rows = cartDAO.updateCartQuantityByParams(cart.getCart_id(), quantity);
        return rows > 0;
    }

}
