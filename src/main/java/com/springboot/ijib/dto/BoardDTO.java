package com.springboot.ijib.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {
	private int bno;
	private String btitle;
	private String bcontent;
	private String bcategory;
	private Date bdate;
	private int bhit;
	private int mno;
	private String mname;
}
