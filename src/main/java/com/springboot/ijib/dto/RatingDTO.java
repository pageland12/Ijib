package com.springboot.ijib.dto;

import java.util.Date;

import lombok.Data;

@Data
public class RatingDTO {
	private int rno;
	private String rtitle;
	private String rcontent;
	private double rrate;
	private String rfeature;
	private Date rdate;
	private int mno;
	private int sno;
	private String mname;
	private String sname;
	private String sfiles;
}
