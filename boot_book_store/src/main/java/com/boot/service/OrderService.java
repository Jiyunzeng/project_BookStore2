package com.boot.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.boot.dao.OrderDAO;
import com.boot.dao.OrderDetailDAO;
import com.boot.dto.OrderDTO;
import com.boot.dto.OrderDetailDTO;
import com.boot.dto.OrderRequestDTO;

@Service
public class OrderService {

    @Autowired
    private OrderDAO orderDAO;
    @Autowired
    private OrderDetailDAO orderDetailDAO;

    // 주문 생성: 주문과 상세를 한 번에 등록하고 주문번호 반환
    public long createOrderWithDetails(String userId, List<OrderRequestDTO.OrderItemDto> items) {
    	int totalPrice = 0;
    	int totalQuantity = 0;
    	int shippingFee = 0;

    	List<OrderDetailDTO> orderDetails = new ArrayList<>();

    	for (OrderRequestDTO.OrderItemDto item : items) {
    		totalQuantity += item.getQuantity();
    	    totalPrice += item.getPurchase_price() * item.getQuantity();

    	    OrderDetailDTO detail = new OrderDetailDTO();
    	    detail.setBook_id(item.getBook_id());
    	    detail.setQuantity(item.getQuantity());
    	    detail.setPurchase_price(item.getPurchase_price());  // 단가 저장 (총액 아님)
    	    orderDetails.add(detail);
    	}

    	shippingFee = totalPrice >= 30000 ? 0 : 3000;
    	int grandTotal = totalPrice + shippingFee;

    	OrderDTO order = new OrderDTO();
    	order.setUser_id(userId);
    	order.setTotal_quantity(totalQuantity);
    	order.setTotal_price(grandTotal);
    	order.setShipping_fee(shippingFee);

    	orderDAO.insertOrder(order);

    	long orderId = order.getOrder_id();

    	for (OrderDetailDTO detail : orderDetails) {
    	    detail.setOrder_id(orderId);
    	    orderDetailDAO.insertOrderDetail(detail);
    	}

        return order.getOrder_id();
    }


 // 총 결제 금액 계산(수량 반영, 배송비 포함)
    public int calculateTotalPrice(List<OrderRequestDTO.OrderItemDto> items) {
        int sum = 0;
        for (OrderRequestDTO.OrderItemDto item : items) {
            sum += item.getPurchase_price() * item.getQuantity();  // 수량 곱하기 추가
        }
        int shippingFee = (sum >= 30000) ? 0 : 3000;
        return sum + shippingFee;
    }
    
 // 주문 조회 메서드 추가
    public OrderDTO getOrderById(long orderId) {
        return orderDAO.selectOrderById(orderId);
    }

}
