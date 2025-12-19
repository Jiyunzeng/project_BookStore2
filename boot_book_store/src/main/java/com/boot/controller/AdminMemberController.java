package com.boot.controller;

import com.boot.service.AdminMemberService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequiredArgsConstructor
@Slf4j
@RequestMapping("/admin/member")
public class AdminMemberController {

    private final AdminMemberService adminMemberService;

    // ⭐ 관리자 회원 목록
    @GetMapping("/adminlist")
    public String adminList(Model model, HttpSession session) {

        String loginId = (String) session.getAttribute("loginId");
        String userRole = (String) session.getAttribute("userRole");

        if (loginId == null) {
            return "redirect:/login";
        }

        // ADMIN 체크 (지금은 주석)
        // if (!"ADMIN".equals(userRole)) return "redirect:/main";

        List<Map<String, Object>> members = adminMemberService.getAllMembers();
        model.addAttribute("members", members);

        return "admin/memberList";
    }

    // ⭐ 페이지 이동용 상세페이지
    @GetMapping("/detail")
    public String detail(@RequestParam("user_id") String userId,
                         Model model,
                         HttpSession session) {

        // if (!"ADMIN".equals(session.getAttribute("userRole"))) return "redirect:/main";

        Map<String, Object> member = adminMemberService.getMemberById(userId);
        // 탈퇴회원이면 detail 페이지 접근 금지
        if ("INACTIVE".equals(member.get("USER_ROLE"))) {
            return "redirect:/admin/member/adminlist";
        }

        model.addAttribute("member", member);
        return "admin/memberDetail";
    }

    // ⭐ 수정 처리
    @PostMapping("/edit")
    @ResponseBody
    public Map<String, Object> edit(@RequestBody Map<String, Object> param) {

        adminMemberService.updateMember(param);

        Map<String, Object> result = new HashMap<>();
        result.put("status", "OK");
        return result;
    }


    @GetMapping("/delete")
    public String delete(@RequestParam("user_id") String userId,
                         HttpSession session) {

        // if (!"ADMIN".equals(session.getAttribute("userRole"))) {
        //     return "redirect:/main";
        // }

        log.info("delete userId = {}", userId);
        adminMemberService.deleteMember(userId);

        return "redirect:/admin/member/adminlist";
    }
 // ⭐ 상세 정보 JSON 제공 (SPA용)
    @GetMapping("/detailData")
    @ResponseBody
    public Map<String, Object> detailData(@RequestParam("user_id") String userId) {
        return adminMemberService.getMemberById(userId);
    }
    
    @PostMapping("/updateRole")
    @ResponseBody
    public String updateRole(@RequestBody Map<String, Object> param, HttpSession session) {
        System.out.println("★ 권한 변경 요청 => " + param);

        int updated = adminMemberService.updateRole(param);
        System.out.println("★ 업데이트된 row => " + updated);

        String targetUserId = (String) param.get("user_id");
        String newRole = (String) param.get("user_role");
        
        // DB 업데이트
        adminMemberService.updateRole(param);

        // 현재 로그인 유저와 동일한 계정의 권한 변경?
        String loginId = (String) session.getAttribute("loginId");

        if (loginId != null && loginId.equals(targetUserId)) {

            // 세션 최신화
            session.setAttribute("userRole", newRole);

            if (!"ADMIN".equals(newRole)) {
                session.invalidate();
                return "REDIRECT_MAIN";
            }
        }

        return "OK";
    }


    @GetMapping("/authority")
    public String authority(Model model) {

        List<Map<String, Object>> members = adminMemberService.getAllMembers();
        List<Map<String, Object>> admins  = adminMemberService.getAdmins();

        model.addAttribute("members", members);
        model.addAttribute("admins", admins);

        return "admin/authorityList";
    }

    
    
}
