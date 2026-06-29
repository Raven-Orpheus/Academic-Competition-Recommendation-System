-- ============================================
-- 赛事推荐与日程管理系统
-- 视图 / 存储过程 / 触发器
-- 注意：必须在建表语句执行完毕后再执行本文件
-- ============================================

-- ==============================================
-- 一、联合视图 View（管理员综合查询视图）
-- 功能：联表查询学生、所选赛事、日程信息
-- ==============================================
CREATE OR REPLACE VIEW v_user_comp_schedule AS
SELECT
    u.user_id,
    u.username,
    u.school,
    u.major,
    c.comp_name,
    c.comp_level,
    s.sch_time,
    s.remind_status
FROM UserInfo u
JOIN User_Comp uc ON u.user_id = uc.user_id
JOIN Competition c ON uc.comp_id = c.comp_id
JOIN Schedule s ON u.user_id = s.user_id AND c.comp_id = s.comp_id;

-- 视图调用语句：
-- SELECT * FROM v_user_comp_schedule;

-- ==============================================
-- 二、存储过程1：根据用户编号查询该用户全部日程
-- ==============================================
CREATE OR REPLACE PROCEDURE Get_User_Schedule(
    p_userid IN VARCHAR2
) IS
    CURSOR cur_sch IS
        SELECT comp_name, sch_time, remind_status
        FROM Competition c, Schedule s
        WHERE s.user_id = p_userid AND s.comp_id = c.comp_id;
    v_name   VARCHAR2(100);
    v_time   DATE;
    v_status VARCHAR2(20);
BEGIN
    OPEN cur_sch;
    LOOP
        FETCH cur_sch INTO v_name, v_time, v_status;
        EXIT WHEN cur_sch%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            '赛事名称：' || v_name ||
            '  提醒时间：' || TO_CHAR(v_time, 'YYYY-MM-DD') ||
            '  状态：' || v_status
        );
    END LOOP;
    CLOSE cur_sch;
END;
/

-- 调用示例：
-- SET SERVEROUTPUT ON;
-- EXEC Get_User_Schedule('U001');

-- ==============================================
-- 三、存储过程2：根据赛事级别查询对应所有赛事
-- ==============================================
CREATE OR REPLACE PROCEDURE Get_Comp_ByLevel(
    p_level IN VARCHAR2
) IS
    CURSOR cur_comp IS
        SELECT comp_id, comp_name, major_type, sign_time
        FROM Competition WHERE comp_level = p_level;
    v_cid    VARCHAR2(20);
    v_cname  VARCHAR2(500);
    v_major  VARCHAR2(100);
    v_signt  DATE;
BEGIN
    OPEN cur_comp;
    LOOP
        FETCH cur_comp INTO v_cid, v_cname, v_major, v_signt;
        EXIT WHEN cur_comp%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
            '赛事编号：' || v_cid ||
            '  名称：' || v_cname ||
            '  适配专业：' || v_major ||
            '  报名截止：' || TO_CHAR(v_signt, 'YYYY-MM-DD')
        );
    END LOOP;
    CLOSE cur_comp;
END;
/

-- 调用示例：
-- SET SERVEROUTPUT ON;
-- EXEC Get_Comp_ByLevel('省赛');

-- ==============================================
-- 四、触发器：学生选择赛事后自动生成日程
-- 触发时机：向 User_Comp 插入数据后
-- ==============================================
CREATE OR REPLACE TRIGGER trg_create_schedule
AFTER INSERT ON User_Comp
FOR EACH ROW
DECLARE
    v_schid VARCHAR2(20);
BEGIN
    -- 自动生成日程编号（S + 关联ID）
    v_schid := 'S' || :NEW.rel_id;
    -- 自动插入日程，默认提醒状态为"已开启"
    INSERT INTO Schedule(sch_id, user_id, comp_id, sch_time, remind_status)
    SELECT v_schid, :NEW.user_id, :NEW.comp_id, sign_time, '已开启'
    FROM Competition WHERE comp_id = :NEW.comp_id;
END;
/

-- ==============================================
-- 验证：查看已创建的数据库对象
-- ==============================================
-- 查看视图
SELECT view_name FROM user_views WHERE view_name = 'V_USER_COMP_SCHEDULE';
-- 查看存储过程
SELECT object_name, object_type FROM user_objects
WHERE object_type = 'PROCEDURE';
-- 查看触发器
SELECT trigger_name, status FROM user_triggers
WHERE trigger_name = 'TRG_CREATE_SCHEDULE';
