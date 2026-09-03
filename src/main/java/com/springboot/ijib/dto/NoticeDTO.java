package com.springboot.ijib.dto;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class NoticeDTO {
	private int nno;
	private String ntitle;
	private String ncontent;
	private MultipartFile nfiles;
	private Date ndate;
	private int nhit;
	private int mno;
	private String mname;
}
