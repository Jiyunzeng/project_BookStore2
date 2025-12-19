package com.boot.service;

import java.util.List;
import com.boot.dto.BookDTO;
import com.boot.dto.GenreDTO;

public interface BookService {
    List<BookDTO> getAllBooks();
    List<GenreDTO> getAllGenres();
    List<BookDTO> getBooksByGenre(int genre_id);
    List<BookDTO> getRecommendByBuy(String userId);
    List<BookDTO> getRandomBooks();
}
