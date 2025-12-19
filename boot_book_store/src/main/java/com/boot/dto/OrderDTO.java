package com.boot.dto;

import java.util.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OrderDTO {
    private long order_id;
    private String user_id;
    private Date order_date;
    private int total_quantity;
    private int total_price;
    private int shipping_fee;  // 배송비 필드 추가
    private List<OrderDetailDTO> orderDetails; // 주문 상세 리스트 (필요시)
}
