package com.boot.dto;

import lombok.Data;

@Data
public class SearchDTO {
    private Integer book_id;
    private String  book_title;
    private String  book_writer;
    private String  book_pub;
    private java.sql.Date  book_date;     
    private Integer genre_id;
    private String  genre_name;
    private Integer book_price;
    private Integer book_count;
    private String  book_comm;
    private String  book_isbn;
    private String  book_image_path; 
}