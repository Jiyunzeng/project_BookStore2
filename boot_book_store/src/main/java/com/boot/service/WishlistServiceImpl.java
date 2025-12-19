package com.boot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.dao.WishlistDAO;
import com.boot.dto.WishlistDTO;

@Service
public class WishlistServiceImpl implements WishlistService {

    @Autowired
    private WishlistDAO wishlistDAO;

    @Override
    @Transactional
    public boolean addWish(String userId, int bookId) {
        try {
            // 이미 찜한 책인지 확인
            int count = wishlistDAO.checkWishExists(userId, bookId);
            if (count > 0) {
                return false; // 이미 찜한 책
            }
            
            WishlistDTO wishlist = new WishlistDTO();
            wishlist.setUser_id(userId);
            wishlist.setBook_id(bookId);
            
            int result = wishlistDAO.insertWish(wishlist);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    @Transactional
    public boolean removeWish(String userId, int bookId) {
        try {
            int result = wishlistDAO.deleteWish(userId, bookId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<WishlistDTO> getWishlistByUserId(String userId) {
        return wishlistDAO.selectWishlistByUserId(userId);
    }

    @Override
    public boolean isWished(String userId, int bookId) {
        int count = wishlistDAO.checkWishExists(userId, bookId);
        return count > 0;
    }

    @Override
    @Transactional
    public boolean removeWishById(int wishId) {
        try {
            int result = wishlistDAO.deleteWishById(wishId);
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    @Transactional
    public boolean removeAllWish(String userId) {
        try {
            int result = wishlistDAO.deleteAllWishByUserId(userId);
            return result >= 0; // 0개 이상 삭제되면 성공
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}