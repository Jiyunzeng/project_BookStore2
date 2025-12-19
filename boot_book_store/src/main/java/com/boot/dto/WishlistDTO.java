package com.boot.dto;

import java.util.Date;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class WishlistDTO {
    private int wish_id;
    private String user_id;  // FK to users
    private int book_id;     // FK to book
    private Date wish_date;
    
    // 찜 목록에 담긴 책 정보를 같이 보내려면 BookDTO를 필드로 추가
    private BookDTO book;
}