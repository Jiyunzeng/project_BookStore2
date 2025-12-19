package com.boot.service;

import com.boot.dao.OrderDetailDAO;
import com.boot.dto.OrderDetailDTO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderDetailServiceImpl implements OrderDetailService {

    @Autowired
    private OrderDetailDAO orderDetailDAO;

    @Override
    public List<OrderDetailDTO> getOrderDetailsByOrderId(long orderId) {
        return orderDetailDAO.selectOrderDetailsByOrderId(orderId);
    }
}
