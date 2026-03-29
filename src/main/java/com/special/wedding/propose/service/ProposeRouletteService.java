package com.special.wedding.propose.service;

import com.special.wedding.propose.dto.ProposeRouletteRow;
import com.special.wedding.propose.mapper.ProposeRouletteMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Service
public class ProposeRouletteService {

	private static final DateTimeFormatter PERIOD_FMT = DateTimeFormatter.ofPattern("yyyy.MM.dd");

	@Autowired
	private ProposeRouletteMapper proposeRouletteMapper;

	/** 이벤트 룰렛: uid 존재 + use_flg = Y */
	public boolean isUserActive(String uid) {
		return proposeRouletteMapper.countActiveUserByUid(uid) > 0;
	}

	/**
	 * 프로포즈 룰렛: 사용자 Y + 콘텐츠 행 존재 시 모델 채움.
	 * t1은 DB에 초 단위로 저장 → DELAY_MS = t1 × 1000
	 */
	public boolean populateModel(String uid, Model model) {
		if (!isUserActive(uid)) {
			return false;
		}
		ProposeRouletteRow row = proposeRouletteMapper.selectProposeByUid(uid);
		if (row == null) {
			return false;
		}

		String rl = row.getRlNm() != null ? row.getRlNm() : "";
		String setterNm = row.getSetterNm();
		String proposeText = rl + "의\n프로포즈";
		String mainLetter = normalizeLetterNewlines(row.getMainTxt());
		String finalMsg = "프로포즈를 수락하셨습니다.\n" + rl + "를 마주보고 진실을 전하세요";
		String stripWon =
			"\uD83D\uDC8D 축하합니다! " + rl + "의 프로포즈가 당첨되셨습니다.\n"
				+ rl + "의 프로포즈를 받고 진실된 답변을 해주세요.\uD83D\uDC95";

		int t1Sec = row.getT1() != null ? row.getT1() : 0;
		long delayMs = t1Sec * 1000L;
		int t2Sec = row.getT2() != null ? row.getT2() : 0;

		model.addAttribute("proposeText", proposeText);
		model.addAttribute("mainLetter", mainLetter);
		model.addAttribute("finalMsg", finalMsg);
		model.addAttribute("stripWon", stripWon);
		model.addAttribute("delayMsBeforeProposeModal", delayMs);
		model.addAttribute("acceptCountdownSec", t2Sec);
		model.addAttribute("respNotice", formatRespNotice(row.getRespDt()));
		model.addAttribute("validityPeriodText", formatValidityPeriod(row.getStartDt(), row.getEndDt()));
		model.addAttribute("rlNm", rl);
		model.addAttribute("setterNm", setterNm);
		return true;
	}

	private static String formatRespNotice(String respDt) {
		if (respDt == null || respDt.isBlank()) {
			return "답변 기한 : 확인 중";
		}
		String s = respDt.trim();
		if (s.length() == 8 && s.chars().allMatch(Character::isDigit)) {
			return "답변 기한 : " + s.substring(0, 4) + "." + s.substring(4, 6) + "." + s.substring(6, 8) + "까지";
		}
		return "답변 기한 : " + s + "까지";
	}

	private static String formatValidityPeriod(LocalDate start, LocalDate end) {
		if (start == null || end == null) {
			return "기간 확인 중";
		}
		return start.format(PERIOD_FMT) + " ~ " + end.format(PERIOD_FMT);
	}

	/**
	 * DB/툴에서 줄바꿈을 문자 '\'+'n'으로 넣은 경우와 실제 개행을 모두 지원.
	 */
	private static String normalizeLetterNewlines(String raw) {
		if (raw == null || raw.isEmpty()) {
			return "";
		}
		return raw.replace("\r\n", "\n").replace("\\r\\n", "\n").replace("\\n", "\n").replace("\\r", "\n");
	}
}
