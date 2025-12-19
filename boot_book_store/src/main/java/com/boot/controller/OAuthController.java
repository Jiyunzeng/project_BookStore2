package com.boot.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value; // 👈 @Value 어노테이션 사용을 위해 필요
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping; // 👈 GET 매핑 사용
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.UserDTO;
import com.boot.dto.SocialUserDTO;
import com.boot.service.SocialLoginService;
import com.boot.service.UserService;

@Controller
@RequestMapping("/oauth")
public class OAuthController {

    // application.properties 값 주입 필드 추가
    @Value("${kakao.client.id}") private String kakaoClientId;
    @Value("${kakao.redirect.uri}") private String kakaoRedirectUri;

    @Value("${naver.client.id}") private String naverClientId;
    @Value("${naver.client.secret}") private String naverClientSecret;
    @Value("${naver.redirect.uri}") private String naverRedirectUri;

    @Value("${google.client.id}") private String googleClientId;
    @Value("${google.redirect.uri}") private String googleRedirectUri;

    @Autowired
    private UserService userService;

    @Autowired @Qualifier("kakaoLoginService")
    private SocialLoginService kakaoService;

    @Autowired @Qualifier("naverLoginService")
    private SocialLoginService naverService;

    @Autowired @Qualifier("googleLoginService")
    private SocialLoginService googleService;
    
    @GetMapping("/{provider}/login") // 👈 버튼 클릭 시 요청되는 경로
    public String socialLoginStart(@PathVariable String provider) {
        String authUrl = "";

        if ("kakao".equalsIgnoreCase(provider)) {
            authUrl = "https://kauth.kakao.com/oauth/authorize"
                    + "?client_id=" + kakaoClientId
                    + "&redirect_uri=" + kakaoRedirectUri
                    + "&response_type=code"
                    + "&prompt=login";
            
        } else if ("naver".equalsIgnoreCase(provider)) {
            authUrl = "https://nid.naver.com/oauth2.0/authorize"
                    + "?client_type=pc"
                    + "&client_id=" + naverClientId
                    + "&redirect_uri=" + naverRedirectUri
                    + "&response_type=code"
                    + "&state=" + naverClientSecret 
                    + "&auth_type=reprompt";
            
        } else if ("google".equalsIgnoreCase(provider)) {
            authUrl = "https://accounts.google.com/o/oauth2/v2/auth"
                    + "?client_id=" + googleClientId
                    + "&redirect_uri=" + googleRedirectUri
                    + "&response_type=code"
                    + "&scope=email%20profile"
                    + "&access_type=offline"
                    + "&prompt=consent";
        } else {
            return "redirect:/login"; 
        }
        
        return "redirect:" + authUrl;
    }
    
    @RequestMapping("/{provider}")
    public String socialLogin(@PathVariable String provider,
                              @RequestParam("code") String code,
                              HttpSession session) {

        // 서비스 선택
    	SocialLoginService service;

    	if ("kakao".equalsIgnoreCase(provider)) {
    	    service = kakaoService;
    	} 
    	 else if ("naver".equalsIgnoreCase(provider)) {
    	     service = naverService;
    	 } 
    	 else if ("google".equalsIgnoreCase(provider)) {
    	     service = googleService;
    	 } 
    	else {
    	    throw new IllegalArgumentException("지원하지 않는 로그인 방식입니다.");
    	}

        // Access Token 발급
        String token = service.getAccessToken(code);
        session.setAttribute("accessToken", token); // 탈퇴 시 unlink용
        
        // 사용자 정보
        SocialUserDTO userInfo = service.getUserInfo(token);
        String email = userInfo.getEmail();
        String providerType = userInfo.getLoginType(); // "KAKAO" / "NAVER" / "GOOGLE"
        String socialId = userInfo.getId();
        
        String socialUserId = providerType.toLowerCase() + "_" + socialId;

        UserDTO inactive = userService.getInactiveUser(socialUserId);

        if (inactive != null) {

            // 이메일 충돌 체크 (이미 누군가 active로 같은 이메일 보유)
            UserDTO emailOwner = userService.getUserByEmail(email);

            if (emailOwner != null && !"INACTIVE".equals(emailOwner.getUser_role())) {

                String usedType = emailOwner.getLogin_type();
                if (usedType == null) {
                    usedType = "LOCAL";
                }

                session.setAttribute("socialLoginError",
                    "이미(" + usedType + ")계정에서 사용 중인 이메일입니다. 재가입할 수 없습니다.");

                return "redirect:/login";
            }

            Map<String, Object> map = new HashMap<>();
            map.put("user_id", socialUserId);
            map.put("user_name", userInfo.getName());
            map.put("user_nickname", userInfo.getNickname());
            map.put("user_email", email);
            map.put("login_type", providerType);
            map.put("social_id", socialId);

            userService.reactivateSocialUser(map);

            UserDTO reUser = userService.getUserById(socialUserId);

            session.setAttribute("loginId", reUser.getUser_id());
            session.setAttribute("loginDisplayName", reUser.getUser_name());
            session.setAttribute("loginType", reUser.getLogin_type());
            session.setAttribute("userRole", reUser.getUser_role());

            return "redirect:/main";
        }


        // ---- ACTIVE 회원 조회 ----
        UserDTO existing = userService.getUserByEmail(email);

        if (existing != null) {
            // 이미 존재하는 이메일이면
            String existingType = existing.getLogin_type();

            if (existingType != null && existingType.equalsIgnoreCase(userInfo.getLoginType())) {
                // 같은 플랫폼 → 로그인 허용
                session.setAttribute("loginId", existing.getUser_id());
                session.setAttribute("loginDisplayName", existing.getUser_name());
                session.setAttribute("loginType", existingType);
                session.setAttribute("userRole", existing.getUser_role());
                return "redirect:/main";
            } else {
                // 다른 플랫폼이거나 일반회원 → 로그인 차단
                String typeName = (existingType == null) ? "일반 회원" : existingType;
                session.setAttribute("socialLoginError",
                    "이미 다른 플랫폼(" + typeName + ")으로 가입된 이메일입니다. "
                    + userInfo.getLoginType() + " 로그인을 사용할 수 없습니다.");
                return "redirect:/login";
            }
        }
        // 신규 카카오 회원 등록
        Map<String, String> map = new HashMap<String,String>();
        map.put("user_id", userInfo.getLoginType().toLowerCase() + "_" + userInfo.getId());
        map.put("user_email", email);
        map.put("user_name", userInfo.getName());
        map.put("user_nickname", userInfo.getNickname());
        map.put("login_type", userInfo.getLoginType());
        map.put("social_id", userInfo.getId());
        map.put("user_phone_num", "000-0000-0000");

        userService.insertSocialUser(map);

        // 세션 저장
        session.setAttribute("loginId", map.get("user_id"));
        session.setAttribute("loginDisplayName", userInfo.getName());
        session.setAttribute("loginType", map.get("login_type"));
        return "redirect:/main";
    }
}
