package com.boot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.boot.dto.WishlistDTO;

@Mapper
public interface WishlistDAO {
    // 찜 추가
    int insertWish(WishlistDTO wishlist);
    
    // 찜 삭제
    int deleteWish(@Param("user_id") String userId, @Param("book_id") int bookId);
    
    // 특정 사용자의 찜 목록 전체 조회 (책 정보 포함)
    List<WishlistDTO> selectWishlistByUserId(@Param("user_id") String userId);
    
    // 찜 여부 확인
    int checkWishExists(@Param("user_id") String userId, @Param("book_id") int bookId);
    
    // 찜 ID로 삭제
    int deleteWishById(@Param("wish_id") int wishId);
    
    // 찜 목록 전체 삭제
    int deleteAllWishByUserId(@Param("user_id") String userId);
}