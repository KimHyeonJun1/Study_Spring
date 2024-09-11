package kr.co.test.faq;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;



@Mapper
public interface FaqMapper {
	//crud
	int registerFaq(FaqVO vo);				//신규 faq등록
	List<FaqVO> getListOfFaq();				//faq 목록조회
	FaqVO getOneFaq(int id);				//faq 정보조회
	int updateFaq(FaqVO vo);				//faq 변경저장
	int deleteFaq(int id);					//faq 삭제
}
