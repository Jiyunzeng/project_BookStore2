package com.boot.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BookBuyDTO {
    private int buy_id;
    private int book_id;
    private String user_id;
    private int quantity;
    private Date purchase_date;
    
    private BookDTO book;
}
