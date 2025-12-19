package com.boot.service;

import java.util.List;
import java.util.Map;

public interface AdminMemberService {
    List<Map<String, Object>> getAllMembers();
    Map<String, Object> getMemberById(String userId);
    int updateMember(Map<String, Object> param);
    int deleteMember(String userId);
    int updateRole(Map<String, Object> param);
    List<Map<String, Object>> getAdmins();

}
