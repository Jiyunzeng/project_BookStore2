package com.boot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.service.WishlistService;

@Controller
public class WishlistController {

    @Autowired
    private WishlistService wishlistService;

    // 찜 여부 확인
    @GetMapping("/wishlist/check")
    @ResponseBody
    public Map<String, Object> checkWish(@RequestParam("book_id") int bookId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        String userId = (String) session.getAttribute("loginId");
        if (userId == null) {
            result.put("wished", false);
            return result;
        }
        
        boolean wished = wishlistService.isWished(userId, bookId);
        result.put("wished", wished);
        return result;
    }

    // 찜 추가
    @PostMapping("/wishlist/add")
    @ResponseBody
    public Map<String, Object> addWish(@RequestParam("book_id") int bookId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        String userId = (String) session.getAttribute("loginId");
        if (userId == null) {
            result.put("success", false);
            result.put("message", "로그인 후 이용해주세요.");
            return result;
        }
        
        boolean success = wishlistService.addWish(userId, bookId);
        result.put("success", success);
        if (!success) {
            result.put("message", "이미 찜한 도서이거나 추가에 실패했습니다.");
        }
        return result;
    }

    // 찜 삭제
    @PostMapping("/wishlist/remove")
    @ResponseBody
    public Map<String, Object> removeWish(@RequestParam("book_id") int bookId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        String userId = (String) session.getAttribute("loginId");
        if (userId == null) {
            result.put("success", false);
            result.put("message", "로그인 후 이용해주세요.");
            return result;
        }
        
        boolean success = wishlistService.removeWish(userId, bookId);
        result.put("success", success);
        if (!success) {
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    // 찜 ID로 삭제
    @PostMapping("/wishlist/removeById")
    @ResponseBody
    public Map<String, Object> removeWishById(@RequestParam("wish_id") int wishId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        String userId = (String) session.getAttribute("loginId");
        if (userId == null) {
            result.put("success", false);
            result.put("message", "로그인 후 이용해주세요.");
            return result;
        }
        
        boolean success = wishlistService.removeWishById(wishId);
        result.put("success", success);
        if (!success) {
            result.put("message", "삭제에 실패했습니다.");
        }
        return result;
    }

    // 찜 목록 전체 삭제
    @PostMapping("/wishlist/removeAll")
    @ResponseBody
    public Map<String, Object> removeAllWish(HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        
        String userId = (String) session.getAttribute("loginId");
        if (userId == null) {
            result.put("success", false);
            result.put("message", "로그인 후 이용해주세요.");
            return result;
        }
        
        boolean success = wishlistService.removeAllWish(userId);
        result.put("success", success);
        if (!success) {
            result.put("message", "전체 삭제에 실패했습니다.");
        }
        return result;
    }
}