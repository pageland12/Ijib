package com.springboot.ijib.dto;

import java.util.Date;
import lombok.Data;

@Data
public class MemberDTO {
	private int mno;
	private String memail;
	private String mpasswd;
	private String mname;
	private String mgender;
	private String mage;
	private String maddr;
	private String mtel;
	private String maccount;
	private String mauth;
	private String mstatus;
	private Date mdate;
}