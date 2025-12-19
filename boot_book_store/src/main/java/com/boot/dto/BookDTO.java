package com.boot.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BookDTO {
    private int book_id;
    private String book_title;
    private String book_writer;
    private String book_pub;
    private Date book_date;
    private int genre_id; // Genre 테이블의 외래키
    private int book_price;
    private int book_count;
    private String book_comm;
    private String book_isbn;
    private String book_image_path; 
}