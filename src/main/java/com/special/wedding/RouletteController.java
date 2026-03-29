package com.special.wedding;

import com.special.wedding.propose.service.ProposeRouletteService;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@Controller
public class RouletteController {

	@Autowired
	private ProposeRouletteService proposeRouletteService;

	@GetMapping("/event/roulette")
	public String eventLegacy() {
		return "redirect:/event/roulette.html";
	}

	/** GS 편의점 룰렛 이벤트 안내 + QR 랜딩 (정적: /event/promo.html) */
	@GetMapping("/event/promo")
	public String eventPromoLanding() {
		return "redirect:/event/promo.html";
	}

	/**
	 * UID별 이벤트 룰렛: tbsi_user 에서 uid + use_flg = 'Y' 일 때만 노출
	 */
	@GetMapping("/event/{user_id}/roulette")
	public String eventRoulette(
		@PathVariable("user_id") String userId,
		HttpServletResponse response
	) {
		if (!proposeRouletteService.isUserActive(userId)) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return "not-found";
		}
		return "forward:/event/roulette.html";
	}

	/** UID 없이 접근 시 기존 정적 데모 */
	@GetMapping("/propose/roulette")
	public String proposeLegacy() {
		return "redirect:/propose/roulette.html";
	}


	@GetMapping("/propose/{user_id}/roulette")
	public String proposeByUserId(
			@PathVariable("user_id") String userId,
			Model model,
			HttpServletResponse response
	) {
		if (!proposeRouletteService.populateModel(userId, model)) {
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			return "not-found";
		}
		return "propose/roulette";
	}
}
