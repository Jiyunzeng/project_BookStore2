package com.boot.service;

import java.util.List;
import com.boot.dto.WishlistDTO;

public interface WishlistService {
    // 찜 추가
    boolean addWish(String userId, int bookId);
    
    // 찜 삭제
    boolean removeWish(String userId, int bookId);
    
    // 찜 목록 조회
    List<WishlistDTO> getWishlistByUserId(String userId);
    
    // 찜 여부 확인
    boolean isWished(String userId, int bookId);
    
    // 찜 ID로 삭제
    boolean removeWishById(int wishId);
    
    // 찜 목록 전체 삭제
    boolean removeAllWish(String userId);
}