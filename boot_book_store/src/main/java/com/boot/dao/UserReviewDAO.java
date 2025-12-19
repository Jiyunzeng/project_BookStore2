package com.boot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.UserReviewDTO;

@Mapper
public interface UserReviewDAO {
    void insertReview(UserReviewDTO reviewDTO);   // 반드시 이 이름과 일치해야 함
    List<UserReviewDTO> findReviewsByBookId(Long bookId);
    
    int countUserReviewByBook(@Param("userId") String userId, @Param("bookId") Long bookId);
}
