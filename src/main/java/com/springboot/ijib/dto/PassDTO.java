package com.springboot.ijib.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class PassDTO {
	private int pno;
	private String pimg;
	private MultipartFile pupload;
	private String pname;
	private int pprice;
	private int pperiod;
}
