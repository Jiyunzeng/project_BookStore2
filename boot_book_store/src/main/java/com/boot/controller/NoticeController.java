package com.boot.controller;

import com.boot.service.NoticeBoardService;
import com.boot.dto.NoticeBoardDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/notice")
public class NoticeController {

    private final NoticeBoardService noticeService;

    /** 📌 공지 목록 (5개씩 페이지 묶음 페이지네이션 적용) */
    @GetMapping("/list")
    public String noticeList(Model model,
                             @RequestParam(defaultValue = "1") int page) {

        int size = 10; // 한 페이지에 10개 출력
        int block = 5; // 페이지네이션 5개씩

        // 목록
        List<NoticeBoardDTO> notices = noticeService.getPage(page, size);
        int total = noticeService.getTotalCount(); 

        // 전체 페이지 수
        int pageCount = (int) Math.ceil(total / (double) size);

        // 현재 페이지가 포함된 페이지 그룹 계산
        int currentBlock = (int) Math.ceil(page / (double) block);

        int startPage = (currentBlock - 1) * block + 1;
        int endPage = Math.min(startPage + block - 1, pageCount);

        // JSP 전달 데이터
        model.addAttribute("list", notices);
        model.addAttribute("total", total);
        model.addAttribute("page", page);
        model.addAttribute("pageCount", pageCount);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);

        return "notice/noticeList";
    }

    /** 📌 공지 상세 */
    @GetMapping("/detail/{noticeNo}")
    public String detail(@PathVariable Long noticeNo,
                         Model model) {

        NoticeBoardDTO dto = noticeService.getById(noticeNo, true);

        model.addAttribute("notice", dto);
        model.addAttribute("attaches", noticeService.getAttachments(noticeNo));

        return "notice/noticeDetail";
    }
}
