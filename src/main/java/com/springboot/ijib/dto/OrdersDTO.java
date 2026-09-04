package com.springboot.ijib.dto;

import java.util.Date;

import lombok.Data;

@Data
public class OrdersDTO {
	private	int		ono;
	private	int		oprice;
	private	String	mpayment;
	private Date	odate;
	private	int		mno;
}
