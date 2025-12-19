package com.boot.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.boot.dto.BookDTO;
import com.boot.dto.GenreDTO;


@Mapper
public interface BookMapper {
	 // 전체 도서 목록
    List<BookDTO> getAllBooks();

    // 전체 장르 목록
    List<GenreDTO> getAllGenres();

    // 특정 장르의 도서 목록
    List<BookDTO> getBooksByGenre(@Param("genre_id") int genre_id);

	List<BookDTO> recommendByBuy(String userId);
}
