package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDetailDTO {
    private int order_detail_id;
    private long order_id;
    private int book_id;
    private int quantity;
    private int purchase_price;
    private int shipping_fee;
    
 // 도서명 출력용 필드 (DB 조회 시 조인 결과 반영)
    private String book_title;
    
 // 도서 이미지 URL 필드 추가
    private String book_image_url;
}

