package com.boot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.OrderHistoryListDTO;
import com.boot.dto.OrderHistoryDetailDTO;
import com.boot.dto.OrderHistoryItemDTO;

@Mapper
public interface OrderHistoryDAO {

	// 전체 주문 목록
    List<OrderHistoryListDTO> getAllOrders();

    // 오늘 주문 목록
    List<OrderHistoryListDTO> getTodayOrders();

    // 주문 기본 정보 (Orders + Users)
    OrderHistoryDetailDTO getOrderInfo(int order_id);

    // 주문 상세 목록 (OrderDetail + Book)
    List<OrderHistoryItemDTO> getOrderItems(int order_id);
    
 // 전체 페이징
    List<OrderHistoryListDTO> selectPage(@Param("offset") int offset,
                                  @Param("size") int size);

    int countAll();

    // 검색 + 페이징
    List<OrderHistoryListDTO> searchPage(@Param("type") String type,
	                                     @Param("keyword") String keyword,
	                                     @Param("offset") int offset,
	                                     @Param("size") int size);

    int countSearch(@Param("type") String type,
                    @Param("keyword") String keyword);
    
    // 오늘 주문 페이징 리스트
    List<OrderHistoryListDTO> getTodayPage(
            @Param("type") String type,
            @Param("keyword") String keyword,
            @Param("offset") int offset,
            @Param("size") int size
    );

    // 오늘 주문 총 개수
    int getTodayTotalCount(
            @Param("type") String type,
            @Param("keyword") String keyword
    );
}
