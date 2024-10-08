package kr.co.smart.board;

import java.sql.Date;
import java.util.List;

import kr.co.smart.common.FileVO;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class BoardVO {
	private int id, readcnt, no, filecnt, notifycnt;
	private String title, content, writer, name;
	private Date writedate;
	private List<FileVO> fileList;
}