package com.boot.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.GenreDTO;
import com.boot.dto.SearchDTO;

public interface SearchDAO {

    // 전체 도서 목록 조회
    List<SearchDTO> getBookList();

    // 키워드로 도서 검색
    List<SearchDTO> searchBooks(@Param("keyword") String keyword);

    // 단일 도서 조회
    SearchDTO getBookById(@Param("book_id") int book_id);

    // 장르 목록 조회
    List<GenreDTO> getGenreList();

    // 검색어 + 장르로 도서 검색 (검색어 또는 장르가 null 가능)
    List<SearchDTO> searchBooksByTitleAndGenre(Map<String, Object> params);
}