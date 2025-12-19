package com.boot.service;

import com.boot.mapper.AdminMemberMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AdminMemberServiceImpl implements AdminMemberService {

    private final AdminMemberMapper adminMemberMapper;

    @Override
    public List<Map<String, Object>> getAllMembers() {
        return adminMemberMapper.selectAllUsers();
    }

    @Override
    public Map<String, Object> getMemberById(String userId) {
        return adminMemberMapper.selectUserById(userId);
    }

    @Override
    public int updateMember(Map<String, Object> param) {
        return adminMemberMapper.updateUser(param);
    }

    @Override
    public int deleteMember(String userId) {
        return adminMemberMapper.deleteUser(userId);   // ⭐ XML 의 id와 정확히 일치!
    }
    @Override
    public int updateRole(Map<String, Object> param) {
        return adminMemberMapper.updateRole(param);
    }
    @Override
    public List<Map<String, Object>> getAdmins() {
        return adminMemberMapper.selectAdmins();
    }

}
