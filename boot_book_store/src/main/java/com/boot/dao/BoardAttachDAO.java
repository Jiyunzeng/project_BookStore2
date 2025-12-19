package com.boot.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.boot.dto.BoardAttachDTO;

@Mapper
public interface BoardAttachDAO {
    
    // ✅ 첨부파일 저장
    int insertAttach(BoardAttachDTO dto);
    
    // ✅ 게시글 번호로 전체 조회
    List<BoardAttachDTO> findByBoardNo(@Param("boardNo") Long boardNo);

    // ✅ 게시글 삭제 시 모든 첨부 삭제
    int deleteByBoardNo(@Param("boardNo") Long boardNo);

    // ✅ 개별 첨부파일 조회 (파일 삭제할 때 필요)
    BoardAttachDTO findById(@Param("attachNo") Long attachNo);

    // ✅ 개별 첨부파일 삭제
    int delete(@Param("attachNo") Long attachNo);
}