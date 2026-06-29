-- ============================================
-- 赛事推荐与日程管理系统 - 测试数据（完整84项）
-- 用户数据由前端注册产生，不预置
-- 执行前请确保已执行建表语句
-- ============================================

-- 清理已有测试数据（如需重新插入）
-- DELETE FROM Competition;
-- DELETE FROM CollegeData;

-- ==============================================
-- 1. 学院数据（只有计算机学院）
-- ==============================================
INSERT INTO CollegeData(college_id, college_name, policy, notice)
VALUES('C001', '计算机学院',
       '鼓励学生积极参与学科竞赛，获奖可申请竞赛加分及奖学金评定。',
       '2026年各类赛事已开始报名，请同学们及时关注赛事动态。');

-- ==============================================
-- 2. 赛事数据（84项，按Excel顺序 C001~C084）
--    说明：sign_time = 报名截止时间，game_time = 比赛时间
--    查不到精确时间的设为NULL，由前端提示"时间待更新"
-- ==============================================

-- 序号1：中国国际大学生创新大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C001', '中国国际大学生创新大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号2："挑战杯"全国大学生课外学术科技作品竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C002', '"挑战杯"全国大学生课外学术科技作品竞赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号3："挑战杯"中国大学生创业计划大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C003', '"挑战杯"中国大学生创业计划大赛', '国赛', '综合类', TO_DATE('2026-06-30','YYYY-MM-DD'), NULL, 'C001');

-- 序号4：ACM-ICPC国际大学生程序设计竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C004', 'ACM-ICPC国际大学生程序设计竞赛', '国赛', '计算机类', NULL, TO_DATE('2026-04-11','YYYY-MM-DD'), 'C001');

-- 序号5：全国大学生数学建模竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C005', '全国大学生数学建模竞赛', '国赛', '数学类', TO_DATE('2026-09-07','YYYY-MM-DD'), TO_DATE('2026-09-10','YYYY-MM-DD'), 'C001');

-- 序号6：全国大学生电子设计竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C006', '全国大学生电子设计竞赛', '国赛', '电子信息类', NULL, TO_DATE('2026-07-29','YYYY-MM-DD'), 'C001');

-- 序号7：全国大学生机械创新设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C007', '全国大学生机械创新设计大赛', '国赛', '机械类', NULL, NULL, 'C001');

-- 序号8：全国大学生智能汽车竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C008', '全国大学生智能汽车竞赛', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号9：全国大学生电子商务"创新、创意及创业"挑战赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C009', '全国大学生电子商务"创新、创意及创业"挑战赛', '国赛', '电子商务类', NULL, NULL, 'C001');

-- 序号10：中国大学生工程实践与创新能力大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C010', '中国大学生工程实践与创新能力大赛', '国赛', '工程类', NULL, NULL, 'C001');

-- 序号11：全国大学生物流设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C011', '全国大学生物流设计大赛', '国赛', '物流类', NULL, NULL, 'C001');

-- 序号12："外研社·国才杯"全国大学生外语能力大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C012', '"外研社·国才杯"全国大学生外语能力大赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号13：两岸新锐设计竞赛·华灿奖
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C013', '两岸新锐设计竞赛·华灿奖', '国赛', '设计类', NULL, NULL, 'C001');

-- 序号14：全国大学生创新创业训练计划年会展示
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C014', '全国大学生创新创业训练计划年会展示', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号15：全国大学生机器人大赛(CURC)
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C015', '全国大学生机器人大赛(CURC)', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号16：全国大学生先进成图技术与产品信息建模创新大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C016', '全国大学生先进成图技术与产品信息建模创新大赛', '国赛', '机械类', NULL, NULL, 'C001');

-- 序号17：全国三维数字化创新设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C017', '全国三维数字化创新设计大赛', '国赛', '设计类', NULL, NULL, 'C001');

-- 序号18："西门子杯"中国智能制造挑战赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C018', '"西门子杯"中国智能制造挑战赛', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号19：中国大学生计算机设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C019', '中国大学生计算机设计大赛', '国赛', '计算机类', TO_DATE('2026-04-23','YYYY-MM-DD'), NULL, 'C001');

-- 序号20：中国高校计算机大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C020', '中国高校计算机大赛', '国赛', '计算机类', NULL, NULL, 'C001');

-- 序号21：蓝桥杯全国软件和信息技术专业人才大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C021', '蓝桥杯全国软件和信息技术专业人才大赛', '省赛', '计算机类', TO_DATE('2025-12-15','YYYY-MM-DD'), TO_DATE('2026-04-11','YYYY-MM-DD'), 'C001');

-- 序号22：全国大学生光电设计竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C022', '全国大学生光电设计竞赛', '国赛', '光电类', NULL, NULL, 'C001');

-- 序号23：全国大学生集成电路创新创业大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C023', '全国大学生集成电路创新创业大赛', '国赛', '电子类', NULL, NULL, 'C001');

-- 序号24：全国大学生信息安全竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C024', '全国大学生信息安全竞赛', '国赛', '计算机类', NULL, NULL, 'C001');

-- 序号25：中国机器人大赛暨RoboCup机器人世界杯中国赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C025', '中国机器人大赛暨RoboCup机器人世界杯中国赛', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号26："中国软件杯"大学生软件设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C026', '"中国软件杯"大学生软件设计大赛', '国赛', '计算机类', NULL, NULL, 'C001');

-- 序号27：中美青年创客大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C027', '中美青年创客大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号28：睿抗机器人开发者大赛(RAICOM)
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C028', '睿抗机器人开发者大赛(RAICOM)', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号29：华为ICT大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C029', '华为ICT大赛', '国赛', '计算机类', NULL, NULL, 'C001');

-- 序号30：全国大学生嵌入式芯片与系统设计竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C030', '全国大学生嵌入式芯片与系统设计竞赛', '国赛', '电子类', NULL, NULL, 'C001');

-- 序号31：全国高校BIM毕业设计创新大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C031', '全国高校BIM毕业设计创新大赛', '国赛', '土木类', NULL, NULL, 'C001');

-- 序号32："学创杯"全国大学生创业综合模拟大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C032', '"学创杯"全国大学生创业综合模拟大赛', '国赛', '经管类', NULL, NULL, 'C001');

-- 序号33：中国高校智能机器人创意大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C033', '中国高校智能机器人创意大赛', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号34：中国机器人及人工智能大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C034', '中国机器人及人工智能大赛', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号35："21世纪杯"全国英语演讲比赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C035', '"21世纪杯"全国英语演讲比赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号36：iCAN大学生创新创业大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C036', 'iCAN大学生创新创业大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号37："工行杯"全国大学生金融科技创新大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C037', '"工行杯"全国大学生金融科技创新大赛', '国赛', '金融类', NULL, NULL, 'C001');

-- 序号38：中华经典诵写讲大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C038', '中华经典诵写讲大赛', '国赛', '文学类', NULL, NULL, 'C001');

-- 序号39："外教社杯"全国高校学生跨文化能力大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C039', '"外教社杯"全国高校学生跨文化能力大赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号40：百度之星程序设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C040', '百度之星程序设计大赛', '国赛', '计算机类', NULL, NULL, 'C001');

-- 序号41：全国大学生计算机系统能力大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C041', '全国大学生计算机系统能力大赛', '国赛', '计算机类', NULL, NULL, 'C001');

-- 序号42：全国大学生物联网设计竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C042', '全国大学生物联网设计竞赛', '国赛', '物联网类', NULL, NULL, 'C001');

-- 序号43：全国大学生信息安全与对抗技术竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C043', '全国大学生信息安全与对抗技术竞赛', '国赛', '计算机类', NULL, NULL, 'C001');

-- 序号44：全国大学生统计建模大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C044', '全国大学生统计建模大赛', '国赛', '统计类', NULL, NULL, 'C001');

-- 序号45：全国大学生能源经济学术创意大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C045', '全国大学生能源经济学术创意大赛', '国赛', '能源类', NULL, NULL, 'C001');

-- 序号46：全国大学生数字媒体科技作品及创意竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C046', '全国大学生数字媒体科技作品及创意竞赛', '国赛', '数字媒体类', NULL, NULL, 'C001');

-- 序号47：全国企业模拟竞赛大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C047', '全国企业模拟竞赛大赛', '国赛', '经管类', NULL, NULL, 'C001');

-- 序号48：全国高等院校数智化企业经营沙盘大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C048', '全国高等院校数智化企业经营沙盘大赛', '国赛', '经管类', NULL, NULL, 'C001');

-- 序号49：全国数字建筑创新应用大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C049', '全国数字建筑创新应用大赛', '国赛', '土木类', NULL, NULL, 'C001');

-- 序号50：全球校园人工智能算法精英大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C050', '全球校园人工智能算法精英大赛', '国赛', '人工智能类', NULL, NULL, 'C001');

-- 序号51：全国大学生机器人大赛-RoboTac
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C051', '全国大学生机器人大赛-RoboTac', '国赛', '自动化类', NULL, NULL, 'C001');

-- 序号52：世界技能大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C052', '世界技能大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号53：世界技能大赛中国选拔赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C053', '世界技能大赛中国选拔赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号54：一带一路暨金砖国家技能发展与技术创新大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C054', '一带一路暨金砖国家技能发展与技术创新大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号55：码蹄杯全国职业院校程序设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C055', '码蹄杯全国职业院校程序设计大赛', '省赛', '计算机类', NULL, NULL, 'C001');

-- ==============================================
-- 以下补充剩余的29个比赛（序号56~84）
-- ==============================================

-- 序号56：全国大学生服务外包创新创业大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C056', '全国大学生服务外包创新创业大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号57：全国大学生化工设计竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C057', '全国大学生化工设计竞赛', '国赛', '化工类', NULL, NULL, 'C001');

-- 序号58：全国大学生先进事迹展示与评比大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C058', '全国大学生先进事迹展示与评比大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号59：全国大学生交通科技大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C059', '全国大学生交通科技大赛', '国赛', '交通类', NULL, NULL, 'C001');

-- 序号60：全国大学生农业建筑环境与能源工程相关专业创新创业竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C060', '全国大学生农业建筑环境与能源工程相关专业创新创业竞赛', '国赛', '农业类', NULL, NULL, 'C001');

-- 序号61：全国大学生水利创新设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C061', '全国大学生水利创新设计大赛', '国赛', '水利类', NULL, NULL, 'C001');

-- 序号62：全国大学生地质技能竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C062', '全国大学生地质技能竞赛', '国赛', '地质类', NULL, NULL, 'C001');

-- 序号63：全国大学生测绘学科创新创业智能大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C063', '全国大学生测绘学科创新创业智能大赛', '国赛', '测绘类', NULL, NULL, 'C001');

-- 序号64：全国大学生节能减排社会实践与科技竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C064', '全国大学生节能减排社会实践与科技竞赛', '国赛', '环境类', NULL, NULL, 'C001');

-- 序号65：全国大学生生命科学竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C065', '全国大学生生命科学竞赛', '国赛', '生物类', NULL, NULL, 'C001');

-- 序号66：全国大学生化学实验创新设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C066', '全国大学生化学实验创新设计大赛', '国赛', '化学类', NULL, NULL, 'C001');

-- 序号67：全国大学生物理实验竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C067', '全国大学生物理实验竞赛', '国赛', '物理类', NULL, NULL, 'C001');

-- 序号68：全国大学生市场调查与分析大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C068', '全国大学生市场调查与分析大赛', '国赛', '经管类', NULL, NULL, 'C001');

-- 序号69：全国大学生人力资源职业技能大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C069', '全国大学生人力资源职业技能大赛', '国赛', '经管类', NULL, NULL, 'C001');

-- 序号70：全国大学生公共管理案例大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C070', '全国大学生公共管理案例大赛', '国赛', '经管类', NULL, NULL, 'C001');

-- 序号71：全国大学生广告艺术大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C071', '全国大学生广告艺术大赛', '国赛', '设计类', NULL, NULL, 'C001');

-- 序号72：全国大学生工业设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C072', '全国大学生工业设计大赛', '国赛', '设计类', NULL, NULL, 'C001');

-- 序号73：全国大学生服装服饰创意设计大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C073', '全国大学生服装服饰创意设计大赛', '国赛', '设计类', NULL, NULL, 'C001');

-- 序号74：全国大学生乡村振兴创意大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C074', '全国大学生乡村振兴创意大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号75：全国大学生生态文明教育创意大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C075', '全国大学生生态文明教育创意大赛', '国赛', '环境类', NULL, NULL, 'C001');

-- 序号76：全国大学生红色旅游创意策划大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C076', '全国大学生红色旅游创意策划大赛', '国赛', '综合类', NULL, NULL, 'C001');

-- 序号77：全国大学生商务英语竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C077', '全国大学生商务英语竞赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号78：全国大学生日语综合技能大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C078', '全国大学生日语综合技能大赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号79：全国大学生韩语演讲比赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C079', '全国大学生韩语演讲比赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号80：全国大学生俄语大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C080', '全国大学生俄语大赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号81：全国大学生法语演讲比赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C081', '全国大学生法语演讲比赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号82：全国大学生德语风采大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C082', '全国大学生德语风采大赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号83：全国大学生西班牙语水平竞赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C083', '全国大学生西班牙语水平竞赛', '国赛', '外语类', NULL, NULL, 'C001');

-- 序号84：全国大学生阿拉伯语书法大赛
INSERT INTO Competition(comp_id, comp_name, comp_level, major_type, sign_time, game_time, college_id)
VALUES('C084', '全国大学生阿拉伯语书法大赛', '国赛', '外语类', NULL, NULL, 'C001');

-- ==============================================
-- 验证：查看比赛总数（应为84条）
-- ==============================================
SELECT COUNT(*) AS 比赛总数 FROM Competition;

COMMIT;