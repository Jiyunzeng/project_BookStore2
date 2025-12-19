package com.boot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.boot.dto.BookBuyDTO;

@Mapper
public interface BookBuyDAO {
	int insertBookBuy(BookBuyDTO bookBuy);
    List<BookBuyDTO> selectPurchaseListByUserId(String userId);
}
