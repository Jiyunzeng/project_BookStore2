package com.boot.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dao.OrderDAO;
import com.boot.dao.SearchDAO;
import com.boot.dao.UserReviewDAO;
import com.boot.dto.OrderDTO;
import com.boot.dto.SearchDTO;
import com.boot.dto.UserReviewDTO;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class SearchController {

    @Autowired
    private SqlSession sqlSession;

    // /Search?q=검색어&genre_id=장르아이디
    @GetMapping({"/Search","/search"})
    public String search(@RequestParam(value="q", required=false) String q,
                         @RequestParam(value="genre_id", required=false) Integer genre_id,
                         Model model) {

        final String keyword = (q != null && !q.trim().isEmpty()) ? q.trim() : null;
        // 탭의 '전체'는 0으로 오므로 DB 필터에선 null로 변환
        final Integer genreFilter = (genre_id != null && genre_id == 0) ? null : genre_id;

        SearchDAO dao = sqlSession.getMapper(SearchDAO.class);

        // 장르 목록
        model.addAttribute("genreList", dao.getGenreList());

        List<SearchDTO> bookList;

        if (keyword == null && genreFilter == null) {
            bookList = dao.getBookList(); 
        } else {
            // Map으로 파라미터 묶기
        	Map<String, Object> params = new HashMap<>();
        	params.put("keyword", keyword);
        	params.put("genreFilter", genreFilter);

        	bookList = dao.searchBooksByTitleAndGenre(params);
        }


        model.addAttribute("bookList", bookList);
        model.addAttribute("q", keyword == null ? "" : keyword);
        model.addAttribute("selectedGenreId", genre_id == null ? 0 : genre_id);
        System.out.println("genre_id = " + genre_id + ", keyword = " + q);

        return "Book/Search";
    }

    @GetMapping("/SearchDetail")
    public String detail(@RequestParam("book_id") int book_id, Model model, HttpSession session) {
        SearchDAO dao = sqlSession.getMapper(SearchDAO.class);
        SearchDTO book = dao.getBookById(book_id);
        if (book == null) return "redirect:/Search";
        model.addAttribute("book", book);

        // 리뷰 조회
        UserReviewDAO reviewDAO = sqlSession.getMapper(UserReviewDAO.class);
        List<UserReviewDTO> reviews = reviewDAO.findReviewsByBookId((long)book_id);
        model.addAttribute("reviews", reviews);

        // 로그인한 사용자의 구매 여부 확인
        String userId = (String) session.getAttribute("loginId");
        boolean hasPurchased = false;
        boolean hasReviewed = false;
        if (userId != null) {
            OrderDAO orderDAO = sqlSession.getMapper(OrderDAO.class);
            List<OrderDTO> purchaseList = orderDAO.selectPurchaseListByUserId(userId);
            hasPurchased = purchaseList.stream()
            	    .flatMap(order -> order.getOrderDetails().stream()) // 주문별 상세 펼침
            	    .anyMatch(detail -> detail.getBook_id() == book_id);
            // ▼ 리뷰 작성 여부 확인 (여기 추가)
            int reviewCount = reviewDAO.countUserReviewByBook(userId, (long)book_id);
            hasReviewed = reviewCount > 0;
        }
        model.addAttribute("hasPurchased", hasPurchased);
        model.addAttribute("hasReviewed", hasReviewed); // ★ 추가
        
        return "Book/SearchDetail"; 
    }
}
