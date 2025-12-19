package com.boot.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.boot.dao.BookDAO;
import com.boot.dao.CartDAO;
import com.boot.dao.OrderDAO;
import com.boot.dao.OrderDetailDAO;
import com.boot.dto.BookDTO;
import com.boot.dto.OrderDTO;
import com.boot.dto.OrderDetailDTO;
import com.boot.dto.UserDTO;
import com.boot.service.BookService;
import com.boot.service.OrderDetailService;
import com.boot.service.OrderService;
import com.boot.service.UserServicelmpl;
import com.boot.service.WishlistService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ProjectController {
	@Autowired
	private UserServicelmpl userService;
	@Autowired
	private BookDAO bookDAO;
    @Autowired
    private CartDAO cartDAO;
    @Autowired
    private OrderDAO orderDAO;
    @Autowired
    private OrderDetailDAO orderDetailDAO;
    @Autowired
    private OrderDetailService orderDetailService;
    @Autowired
    private OrderService orderService;
	@Autowired
    private WishlistService wishlistService;
	@Autowired
	private BookService bookService;

    // ------------------ 메인 ------------------
	@GetMapping("/main")
	public String main(Model model, HttpSession session) {

	    String loginId = (String) session.getAttribute("loginId");

	    if (loginId != null) {
	    	// DB에서 최신 사용자 정보 다시 가져오기 → 실제 권한 불러옴
	        Map<String, Object> userInfo = userService.getUser(loginId);

	        if (userInfo != null) {
	            session.setAttribute("userRole", userInfo.get("user_role"));
	            session.setAttribute("loginDisplayName", userInfo.get("user_name"));
	        }
	    }

	    List<BookDTO> recommendList;

	    if (loginId == null) {
	        recommendList = bookService.getRandomBooks();
	    } else {
	        recommendList = bookService.getRecommendByBuy(loginId);
	    }

	    model.addAttribute("recommendList", recommendList);
	    return "main";
	}

	// ------------------ 관리자 메인 ------------------
	@GetMapping("/adminMain")
	public String adminMain(HttpSession session) {

	    String role = (String) session.getAttribute("userRole");

	    // 권한없으면 메인으로
	    if (!"ADMIN".equals(role)) {
	        return "redirect:/main";
	    }

	    return "admin/adminMain";
	}
	
	// ------------------ 회원가입 ------------------
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public String register() {
		return "register";
	}

	@RequestMapping(value = "/register_ok", method = RequestMethod.POST)
	public String registerOk(@RequestParam Map<String, String> param, Model model) {
		if (param.get("user_email_chk") == null || param.get("user_email_chk").equals("")) {
			param.put("user_email_chk", "N");
		}

		int result = userService.register(param);
		if (result == 1) {
			return "redirect:/login";
		} else {
			model.addAttribute("msg", "회원가입 실패. 다시 시도하세요.");
			return "register";
		}
	}

	// ------------------ 로그인 ------------------
    @RequestMapping(value="/login", method=RequestMethod.GET)
    public String login() {
        return "login";
    }

    @RequestMapping(value="/login_yn", method=RequestMethod.POST)
    public String loginYn(@RequestParam Map<String, String> param, HttpSession session, Model model) {
        String userId = param.get("user_id");
        
        // 회원 정보 조회 (로그인 시도 및 시간 확인용)
        UserDTO user = userService.getUserById(userId);

        if (user == null) {
            model.addAttribute("login_err", "존재하지 않는 아이디입니다.");
            return "login";
        }

        // 탈퇴(INACTIVE) + LOCAL 계정은 로그인 불가
        if ("INACTIVE".equals(user.getUser_role())
                && (user.getLogin_type() == null || "LOCAL".equalsIgnoreCase(user.getLogin_type()))) {
            model.addAttribute("login_err", "존재하지 않는 아이디입니다.");
            return "login";
        }
        // 로그인 실패 기록 초기화 조건 확인 (마지막 실패 후 5분 경과 시 자동 초기화)
        if (user.getLast_fail_time() != null) {
            long diffMin = (System.currentTimeMillis() - user.getLast_fail_time().getTime()) / 1000 / 60;
            if (diffMin >= 5 && user.getLogin_fail_count() > 0) {
                userService.resetLoginFail(userId);
            }
        }

        // 로그인 잠금 상태 체크
        if (user.getLogin_fail_count() >= 5 && user.getLast_fail_time() != null) {
            long diffSec = (System.currentTimeMillis() - user.getLast_fail_time().getTime()) / 1000;
            if (diffSec < 30) {
                model.addAttribute("login_err", "비밀번호 5회 이상 틀려 30초간 계정이 비활성화 됩니다.<br>잠시 후 다시 시도해주세요.");
                return "login";
            } else {
                userService.resetLoginFail(userId); // 30초 지났으면 초기화
            }
        }
        boolean ok = userService.loginYn(param);

        if (ok) {
        	userService.resetLoginFail(userId);
            session.setAttribute("loginId", userId);

            // ✅ 로그인한 사용자 정보 불러오기 (항상 이름만 표시)
            Map<String, Object> userInfo = userService.getUser(userId);
            if (userInfo != null) {
                String name = (String) userInfo.get("user_name");
                session.setAttribute("loginDisplayName", name);
                
                session.setAttribute("userRole", userInfo.get("user_role"));
                session.setAttribute("loginType", user.getLogin_type());
            }

            // 로그인 성공 후 메인으로 이동
            return "redirect:/main";
        } else {
        	userService.updateLoginFail(userId); // 실패 카운트 증가
            user = userService.getUserById(userId); // 갱신된 횟수 다시 조회

            if (user.getLogin_fail_count() >= 5) {
                model.addAttribute("login_err", "비밀번호를 5회 이상 틀리셨습니다.<br>계정이 30초간 비활성화 됩니다.");
            } else {
                model.addAttribute("login_err",
                    "아이디 또는 비밀번호가 잘못되었습니다. (" + user.getLogin_fail_count() + "/5)");
            }
            return "login";
        }
    }

	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logout(HttpSession session) {
		session.invalidate();
		return "redirect:/main";
	}

	// ------------------ 아이디 중복 체크 ------------------
	@ResponseBody
	@RequestMapping(value = "/checkId", method = RequestMethod.POST)
	public String checkId(@RequestParam("user_id") String id) {
		int flag = userService.checkId(id);
		return (flag == 1) ? "Y" : "N";
	}

	// ------------------ 마이페이지 ------------------
	@RequestMapping(value = "/mypage", method = RequestMethod.GET)
	public String mypage(Model model, HttpSession session) {
	    String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null) return "redirect:/login";

	    Map<String, Object> user = userService.getUser(loginId);
	    model.addAttribute("user", user);

	    if (user != null) {
	        String name = (String) user.get("user_name");
	        String nickname = (String) user.get("user_nickname"); // ★ 추가
	        session.setAttribute("loginDisplayName", name);
	        session.setAttribute("user_nickname", nickname);      // ★ 추가
	    }
	    return "/MyPage/myinfo";
	}

	@RequestMapping(value = "/mypage/edit", method = RequestMethod.GET)
	public String mypageEdit(Model model, HttpSession session) {
	    String loginId = (String) session.getAttribute("loginId");
	    if (loginId == null) return "redirect:/login";

	    Map<String, Object> user = userService.getUser(loginId);
	    model.addAttribute("user", user);

	    if (user != null) {
	        String name = (String) user.get("user_name");
	        String nickname = (String) user.get("user_nickname"); // ★ 추가
	        session.setAttribute("loginDisplayName", name);
	        session.setAttribute("user_nickname", nickname);      // ★ 추가
	    }
	    return "/MyPage/myinfo_edit";
	}

	@RequestMapping(value = "/mypage/update", method = RequestMethod.POST)
	public String mypageUpdate(@RequestParam Map<String, String> param, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		param.put("user_id", loginId);
		userService.updateUser(param);
		return "redirect:/mypage";
	}
	
	// ------------------ 찜 목록 ------------------
	@RequestMapping(value = "/wishlist", method = RequestMethod.GET)
	public String wishlist(Model model, HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return "redirect:/login";

		// ✅ 이름으로 세션 표시 업데이트
		Map<String, Object> userInfo = userService.getUser(loginId);
		if (userInfo != null) {
			String name = (String) userInfo.get("user_name");
			session.setAttribute("loginDisplayName", name);
		}

		// 찜 목록 조회
		List<com.boot.dto.WishlistDTO> wishlist = wishlistService.getWishlistByUserId(loginId);
		model.addAttribute("wishlist", wishlist);

		return "MyPage/wishlist";
	}
	
	// ------------------ 회원탈퇴 ------------------
	@RequestMapping(value="/mypage/withdraw", method=RequestMethod.GET)
    public String withdraw(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        String loginType = (String) session.getAttribute("loginType"); // ✅ 소셜 로그인 타입 세션에서 가져오기

        if (loginId == null) return "redirect:/login";

        // 상단 인사말용
        Map<String, Object> userInfo = userService.getUser(loginId);
        if (userInfo != null) {
            String name = (String) userInfo.get("user_name");
            session.setAttribute("loginDisplayName", name);
            model.addAttribute("userRole", userInfo.get("user_role"));
        }

        model.addAttribute("loginType", loginType); // JSP에서 일반/소셜 구분용

        return "MyPage/withdraw";
    }

    // ------------------ 회원탈퇴 처리 ------------------
    @RequestMapping(value="/mypage/withdraw_ok", method=RequestMethod.POST)
    public String withdrawOk(@RequestParam Map<String,String> param,
                             HttpSession session, Model model) {

        String loginId = (String) session.getAttribute("loginId");
        String userRole  = (String) session.getAttribute("userRole");
        String loginType = (String) session.getAttribute("loginType");
        String accessToken = (String) session.getAttribute("accessToken"); // ✅ 카카오 연동 해제용

        if (loginId == null) return "redirect:/login";

        // 관리자 탈퇴 금지
        if ("ADMIN".equalsIgnoreCase(userRole)) {
            model.addAttribute("withdraw_err", "관리자 계정은 탈퇴할 수 없습니다.");
            return "MyPage/withdraw";
        }
        
        // 소셜 로그인 회원 탈퇴 처리
        if ("KAKAO".equalsIgnoreCase(loginType)
        	||"NAVER".equalsIgnoreCase(loginType)
        	||"GOOGLE".equalsIgnoreCase(loginType)) {
            Map<String, Object> map = new HashMap<String,Object>();
            map.put("user_id", loginId);
            map.put("login_type", loginType);
            userService.withdrawSocial(map);

            try {
                if ("KAKAO".equalsIgnoreCase(loginType)) {
                    // 🔸 카카오 계정 연결 해제
                    String unlinkUrl = "https://kapi.kakao.com/v1/user/unlink";
                    HttpHeaders headers = new HttpHeaders();
                    headers.add("Authorization", "Bearer " + accessToken);
                    RestTemplate restTemplate = new RestTemplate();
                    HttpEntity<?> request = new HttpEntity(headers);
                    restTemplate.postForEntity(unlinkUrl, request, String.class);
                    System.out.println("카카오 계정 연결 해제 완료");
                } else if ("NAVER".equalsIgnoreCase(loginType)) {
                    // 🔸 네이버 계정 연결 해제
                    String unlinkUrl = "https://nid.naver.com/oauth2.0/token?grant_type=delete"
                            + "&client_id=M9W3QAsKHIjJb2oLN0G5"
                            + "&client_secret=pylzhNXTCV"
                            + "&access_token=" + accessToken
                            + "&service_provider=NAVER";
                    RestTemplate restTemplate = new RestTemplate();
                    restTemplate.getForObject(unlinkUrl, String.class);
                    System.out.println("네이버 계정 연결 해제 완료");
                } else if ("GOOGLE".equalsIgnoreCase(loginType)) {
                    // 🔸 구글 계정 연결 해제
                    String unlinkUrl = "https://accounts.google.com/o/oauth2/revoke?token=" + accessToken;
                    RestTemplate restTemplate = new RestTemplate();
                    restTemplate.getForObject(unlinkUrl, String.class);
                    System.out.println("구글 계정 연결 해제 완료");
                }
            } catch (Exception e) {
                System.out.println(loginType + " 연결 해제 실패: " + e.getMessage());
            }

            // 세션 초기화
            session.invalidate();
            return "redirect:/main?status=withdraw_success";
        }

        // 일반 로그인 회원 탈퇴 처리
        param.put("user_id", loginId);
        int res = userService.withdraw(param);

        if (res == 1) {
            session.invalidate();
            return "redirect:/main?status=withdraw_success";
        } else {
            model.addAttribute("withdraw_err", "비밀번호가 일치하지 않습니다.");
            return "MyPage/withdraw";
        }
    }

	private String getLoginId(HttpSession session) {
		return (String) session.getAttribute("loginId");
	}

	// 구매내역 페이지
    @RequestMapping("/MyPage/purchaseList")
    public String purchaseList(Model model, HttpSession session) {
        log.info("@# purchaseList()");
        String userId = getLoginId(session);
        if (userId == null) return "redirect:/login";
        
        // ✅ 이름으로 세션 표시 업데이트
        Map<String, Object> userInfo = userService.getUser(userId);
        if (userInfo != null) {
            String name = (String) userInfo.get("user_name");
            session.setAttribute("loginDisplayName", name);
        }

        List<OrderDTO> purchaseList = orderDAO.selectPurchaseListByUserId(userId);
        model.addAttribute("purchaseList", purchaseList);

        return "MyPage/purchaseList";
    }
    
    // 구매내역 상세 페이지
    @GetMapping("/purchaseDetail")
    public String purchaseDetail(@RequestParam("orderId") long orderId, Model model) {
        List<OrderDetailDTO> orderDetails = orderDetailService.getOrderDetailsByOrderId(orderId);

        int totalQuantity = orderDetails.stream().mapToInt(OrderDetailDTO::getQuantity).sum();
        int totalPayment = orderDetails.stream()
                            .mapToInt(od -> od.getQuantity() * od.getPurchase_price())
                            .sum();

        // 주문 테이블에서 배송비, 총 결제 금액 조회
        OrderDTO order = orderService.getOrderById(orderId); 

        model.addAttribute("orderDetails", orderDetails);
        model.addAttribute("totalQuantity", totalQuantity);
        model.addAttribute("totalPayment", totalPayment);
        model.addAttribute("order", order);  // 모델에 order 추가

        return "MyPage/purchaseDetail";
    }

//	관리자 화면에서 게시판을 불러옴
	@GetMapping("/admin/qnaManagement")
	public String qnaManagement() {
		return "admin/qnaManagement"; // list.jsp
	}
}
