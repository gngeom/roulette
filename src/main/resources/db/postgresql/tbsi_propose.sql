-- TBSI_USER / TBSI_PP_CONTENT — 프로포즈 룰렛 템플릿 (PostgreSQL)
-- 테이블명은 소문자(tbsi_*)로 생성 (Spring JPA 기본 매핑과 일치)

CREATE TABLE IF NOT EXISTS tbsi_user (
    uid       VARCHAR(10) PRIMARY KEY,
    hp        VARCHAR(11) NOT NULL,
    setter_nm VARCHAR(10) NOT NULL,
    getter_nm VARCHAR(10) NOT NULL,
    rl_nm     VARCHAR(10) NOT NULL,
    use_flg   CHAR(1)     NOT NULL DEFAULT 'Y',
    reg_dnt   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    upd_dnt   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE tbsi_user IS 'TBSI_USER — 프로포즈 신청/당첨자 정보';
COMMENT ON COLUMN tbsi_user.uid IS '고유 ID (최대 10자)';
COMMENT ON COLUMN tbsi_user.hp IS '신청자 연락처';
COMMENT ON COLUMN tbsi_user.setter_nm IS '신청자 이름';
COMMENT ON COLUMN tbsi_user.getter_nm IS '받는이 이름';
COMMENT ON COLUMN tbsi_user.rl_nm IS '룰렛 칸 당첨자 (신부/신랑 등)';
COMMENT ON COLUMN tbsi_user.use_flg IS '사용여부 Y/N';
COMMENT ON COLUMN tbsi_user.reg_dnt IS '등록일시';
COMMENT ON COLUMN tbsi_user.upd_dnt IS '수정일시';

CREATE TABLE IF NOT EXISTS tbsi_pp_content (
    uid       VARCHAR(10) PRIMARY KEY,
    resp_dt   VARCHAR(8)  NOT NULL,
    t1        INTEGER     NOT NULL,
    t2        INTEGER     NOT NULL,
    start_dt  DATE        NOT NULL,
    end_dt    DATE        NOT NULL,
    use_flg   CHAR(1)     NOT NULL DEFAULT 'Y',
    reg_dnt   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    upd_dnt   TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    main_txt  TEXT,
    CONSTRAINT fk_pp_user FOREIGN KEY (uid) REFERENCES tbsi_user (uid)
);

COMMENT ON TABLE tbsi_pp_content IS 'TBSI_PP_CONTENT — UID별 프로포즈 룰렛 문구·타이밍';
COMMENT ON COLUMN tbsi_pp_content.uid IS '고유 ID (tbsi_user.uid)';
COMMENT ON COLUMN tbsi_pp_content.resp_dt IS '응답 기한 표기용 (예: YYYYMMDD 8자)';
COMMENT ON COLUMN tbsi_pp_content.t1 IS '당첨 후 모달 전 지연 (초, 앱에서 ×1000 → ms)';
COMMENT ON COLUMN tbsi_pp_content.t2 IS '자동 수락 카운트다운 (초)';
COMMENT ON COLUMN tbsi_pp_content.start_dt IS '이벤트 룰렛 시작일';
COMMENT ON COLUMN tbsi_pp_content.end_dt IS '이벤트 룰렛 종료일';
COMMENT ON COLUMN tbsi_pp_content.use_flg IS '사용여부 Y/N';
COMMENT ON COLUMN tbsi_pp_content.main_txt IS '편지 본문(템플릿, 선택)';

-- 선택: 수정 시 upd_dnt 자동 갱신
CREATE OR REPLACE FUNCTION tbsi_touch_upd_dnt()
RETURNS TRIGGER AS $$
BEGIN
    NEW.upd_dnt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_tbsi_user_upd ON tbsi_user;
CREATE TRIGGER trg_tbsi_user_upd
    BEFORE UPDATE ON tbsi_user
    FOR EACH ROW EXECUTE PROCEDURE tbsi_touch_upd_dnt();

DROP TRIGGER IF EXISTS trg_tbsi_pp_content_upd ON tbsi_pp_content;
CREATE TRIGGER trg_tbsi_pp_content_upd
    BEFORE UPDATE ON tbsi_pp_content
    FOR EACH ROW EXECUTE PROCEDURE tbsi_touch_upd_dnt();

-- 샘플 (선택)
INSERT INTO tbsi_user (uid, hp, setter_nm, getter_nm, rl_nm, use_flg)
VALUES ('DEMO', '01012345678', '민수', '지영', '신부', 'Y')
ON CONFLICT (uid) DO UPDATE SET
    hp = EXCLUDED.hp,
    setter_nm = EXCLUDED.setter_nm,
    getter_nm = EXCLUDED.getter_nm,
    rl_nm = EXCLUDED.rl_nm,
    use_flg = EXCLUDED.use_flg;

INSERT INTO tbsi_pp_content (uid, resp_dt, t1, t2, start_dt, end_dt, use_flg, main_txt)
VALUES (
    'DEMO',
    '20261231',
    5,
    300,
    DATE '2026-01-01',
    DATE '2026-12-31',
    'Y',
    E'안녕, 지영.\n오늘도 고생 많았어.\n\n나랑 평생 같이 살아줄래?'
)
ON CONFLICT (uid) DO UPDATE SET
    resp_dt = EXCLUDED.resp_dt,
    t1 = EXCLUDED.t1,
    t2 = EXCLUDED.t2,
    start_dt = EXCLUDED.start_dt,
    end_dt = EXCLUDED.end_dt,
    use_flg = EXCLUDED.use_flg,
    main_txt = EXCLUDED.main_txt;

-- 조회 예시 (앱과 동일 조건: 사용자·콘텐츠 use_flg)
-- SELECT ... FROM tbsi_user u INNER JOIN tbsi_pp_content c ON c.uid = u.uid
-- WHERE u.uid = 'DEMO' AND u.use_flg = 'Y' AND c.use_flg = 'Y';
