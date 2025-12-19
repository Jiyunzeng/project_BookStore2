package com.boot.service;

import com.boot.dto.OrderDetailDTO;
import java.util.List;

public interface OrderDetailService {
    List<OrderDetailDTO> getOrderDetailsByOrderId(long orderId);
}
