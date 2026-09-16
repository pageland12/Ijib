package com.springboot.ijib.dto;

import java.util.Date;

import lombok.Data;

@Data
public class AnswerDTO {
	private int ano;
	private String acontent;
	private Date adate;
	private int mno;
	private int bno;
	private String mname;
}
