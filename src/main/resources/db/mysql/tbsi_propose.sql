-- TBSI_USER / TBSI_PP_CONTENT — 프로포즈 룰렛 템플릿 (MySQL 8+)
-- InnoDB, utf8mb4

CREATE TABLE IF NOT EXISTS tbsi_user (
    uid       VARCHAR(10) NOT NULL COMMENT '고유 ID',
    hp        VARCHAR(11) NOT NULL COMMENT '신청자 연락처',
    setter_nm VARCHAR(10) NOT NULL COMMENT '신청자 이름',
    getter_nm VARCHAR(10) NOT NULL COMMENT '받는이 이름',
    rl_nm     VARCHAR(10) NOT NULL COMMENT '룰렛 칸 당첨자 (신부/신랑)',
    use_flg   CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    reg_dnt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    upd_dnt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    PRIMARY KEY (uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='TBSI_USER';

CREATE TABLE IF NOT EXISTS tbsi_pp_content (
    uid       VARCHAR(10) NOT NULL COMMENT '고유 ID (FK)',
    resp_dt   VARCHAR(8)  NOT NULL COMMENT '응답 기한(~까지) 표기용',
    t1        INT         NOT NULL COMMENT '당첨 후 모달 전 지연(초, 앱에서×1000→ms)',
    t2        INT         NOT NULL COMMENT '자동 수락 카운트다운(초)',
    start_dt  DATE        NOT NULL COMMENT '이벤트 시작일',
    end_dt    DATE        NOT NULL COMMENT '이벤트 종료일',
    use_flg   CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용여부',
    reg_dnt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    upd_dnt   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
    main_txt  TEXT        NULL COMMENT '편지 본문(선택)',
    PRIMARY KEY (uid),
    CONSTRAINT fk_pp_user FOREIGN KEY (uid) REFERENCES tbsi_user (uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='TBSI_PP_CONTENT';

-- 샘플 데이터 (UID 예: DEMO)
INSERT INTO tbsi_user (uid, hp, setter_nm, getter_nm, rl_nm, use_flg)
VALUES ('DEMO', '01012345678', '민수', '지영', '신부', 'Y')
ON DUPLICATE KEY UPDATE
    hp = VALUES(hp), setter_nm = VALUES(setter_nm), getter_nm = VALUES(getter_nm), rl_nm = VALUES(rl_nm), use_flg = VALUES(use_flg);

INSERT INTO tbsi_pp_content (uid, resp_dt, t1, t2, start_dt, end_dt, use_flg, main_txt)
VALUES (
    'DEMO',
    '20261231',
    5,
    300,
    '2026-01-01',
    '2026-12-31',
    'Y',
    '안녕, 지영. 오늘도 고생 많았어.\n나랑 평생 같이 살아줄래?'
)
ON DUPLICATE KEY UPDATE
    resp_dt = VALUES(resp_dt), t1 = VALUES(t1), t2 = VALUES(t2),
    start_dt = VALUES(start_dt), end_dt = VALUES(end_dt), use_flg = VALUES(use_flg), main_txt = VALUES(main_txt);

-- HTML/서버에서 한 번에 가져오기: 사용자 + 콘텐츠 조인
SELECT
    u.uid,
    u.hp,
    u.setter_nm,
    u.getter_nm,
    u.rl_nm,
    u.use_flg        AS user_use_flg,
    c.resp_dt,
    c.t1,
    c.t2,
    c.start_dt,
    c.end_dt,
    c.use_flg        AS content_use_flg,
    c.main_txt
FROM tbsi_user u
INNER JOIN tbsi_pp_content c ON c.uid = u.uid
WHERE u.uid = 'DEMO'
  AND u.use_flg = 'Y'
  AND c.use_flg = 'Y';
