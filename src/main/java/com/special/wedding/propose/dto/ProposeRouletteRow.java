package com.special.wedding.propose.dto;

import java.time.LocalDate;

/**
 * tbsi_user + tbsi_pp_content 조인 (use_flg만 SQL에서 필터).
 */
public class ProposeRouletteRow {

	private String uid;
	private String hp;
	private String setterNm;
	private String getterNm;
	private String rlNm;
	private String respDt;
	/** DB에는 초 단위로 저장, 화면 지연(ms)은 서비스에서 ×1000 */
	private Integer t1;
	private Integer t2;
	private LocalDate startDt;
	private LocalDate endDt;
	private String mainTxt;

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getHp() {
		return hp;
	}

	public void setHp(String hp) {
		this.hp = hp;
	}

	public String getSetterNm() {
		return setterNm;
	}

	public void setSetterNm(String setterNm) {
		this.setterNm = setterNm;
	}

	public String getGetterNm() {
		return getterNm;
	}

	public void setGetterNm(String getterNm) {
		this.getterNm = getterNm;
	}

	public String getRlNm() {
		return rlNm;
	}

	public void setRlNm(String rlNm) {
		this.rlNm = rlNm;
	}

	public String getRespDt() {
		return respDt;
	}

	public void setRespDt(String respDt) {
		this.respDt = respDt;
	}

	public Integer getT1() {
		return t1;
	}

	public void setT1(Integer t1) {
		this.t1 = t1;
	}

	public Integer getT2() {
		return t2;
	}

	public void setT2(Integer t2) {
		this.t2 = t2;
	}

	public LocalDate getStartDt() {
		return startDt;
	}

	public void setStartDt(LocalDate startDt) {
		this.startDt = startDt;
	}

	public LocalDate getEndDt() {
		return endDt;
	}

	public void setEndDt(LocalDate endDt) {
		this.endDt = endDt;
	}

	public String getMainTxt() {
		return mainTxt;
	}

	public void setMainTxt(String mainTxt) {
		this.mainTxt = mainTxt;
	}
}
