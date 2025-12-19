package com.boot.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.boot.dto.CartDTO;
import com.boot.service.CartService;

@Controller
public class CartController {

    @Autowired
    private CartService cartService;

    @PostMapping(value="/cartAdd", produces="text/plain; charset=UTF-8")
    @ResponseBody
    public String addCart(
            @RequestParam("book_id") int book_id,
            HttpSession session) {

        System.out.println("addCart() 호출됨! book_id = " + book_id);

        String user_id = (String) session.getAttribute("loginId");
        if (user_id == null) {
            return "로그인 후 이용해주세요."; // 한글 깨짐 방지됨
        }

        try {
            CartDTO cart = new CartDTO();
            cart.setBook_id(book_id);
            cart.setQuantity(1);
            cart.setUser_id(user_id);

            cartService.addCart(cart);
            System.out.println("장바구니에 추가 완료! user_id = " + user_id);

            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            return "장바구니 담기 실패: " + e.getMessage();
        }
    }

}