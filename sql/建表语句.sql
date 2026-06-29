-- ============================================
-- 赛事推荐与日程管理系统 - Oracle 建表语句
-- 执行顺序：按照文件从上到下依次执行
-- ============================================

-- 清理旧表（如重新初始化时使用）
-- DROP TABLE Feedback CASCADE CONSTRAINTS;
-- DROP TABLE Schedule CASCADE CONSTRAINTS;
-- DROP TABLE User_Comp CASCADE CONSTRAINTS;
-- DROP TABLE Competition CASCADE CONSTRAINTS;
-- DROP TABLE UserInfo CASCADE CONSTRAINTS;
-- DROP TABLE AdminInfo CASCADE CONSTRAINTS;
-- DROP TABLE CollegeData CASCADE CONSTRAINTS;

-- ==============================================
-- 1. 学院数据表 CollegeData
-- ==============================================
CREATE TABLE CollegeData (
    college_id    VARCHAR2(20) PRIMARY KEY,
    college_name  VARCHAR2(50)  NOT NULL,
    policy        VARCHAR2(1000),
    notice        VARCHAR2(500)
);

-- ==============================================
-- 2. 用户表 UserInfo（统一管理学生和老师）
-- ==============================================
CREATE TABLE UserInfo (
    user_id    VARCHAR2(20) PRIMARY KEY,
    username   VARCHAR2(30) NOT NULL,
    pwd        VARCHAR2(50) NOT NULL,
    school     VARCHAR2(50) NOT NULL,
    major      VARCHAR2(50) NOT NULL,
    tel        VARCHAR2(20),
    role       VARCHAR2(20) NOT NULL   -- 新增：角色（学生/老师）
);
-- 唯一约束：用户名不可重复
ALTER TABLE UserInfo ADD CONSTRAINT uk_username UNIQUE(username);
-- 检查约束：限定角色范围
ALTER TABLE UserInfo ADD CONSTRAINT ck_user_role
    CHECK (role IN ('学生', '老师'));

-- ==============================================
-- 3. 管理员表 AdminInfo
-- ==============================================
CREATE TABLE AdminInfo (
    admin_id    VARCHAR2(20) PRIMARY KEY,
    admin_name  VARCHAR2(30) NOT NULL,
    admin_pwd   VARCHAR2(50) NOT NULL,
    role        VARCHAR2(20) NOT NULL
);
ALTER TABLE AdminInfo ADD CONSTRAINT uk_adminname UNIQUE(admin_name);
-- 检查约束：限定管理员角色范围
ALTER TABLE AdminInfo ADD CONSTRAINT ck_admin_role
    CHECK (role IN ('超级管理员', '普通管理员'));

-- ==============================================
-- 4. 赛事表 Competition（外键关联学院表）
-- ==============================================
CREATE TABLE Competition (
    comp_id      VARCHAR2(20) PRIMARY KEY,
    comp_name    VARCHAR2(100) NOT NULL,  -- 名称长度加长到100，适应长比赛名
    comp_level   VARCHAR2(30) NOT NULL,
    major_type   VARCHAR2(50) NOT NULL,
    sign_time    DATE,
    game_time    DATE,
    college_id   VARCHAR2(20)
);
-- 外键约束
ALTER TABLE Competition ADD CONSTRAINT fk_comp_college
    FOREIGN KEY (college_id) REFERENCES CollegeData(college_id);
-- 检查约束：限定赛事级别
ALTER TABLE Competition ADD CONSTRAINT ck_comp_level
    CHECK (comp_level IN ('校赛', '省赛', '国赛'));

-- ==============================================
-- 5. 用户-赛事中间表 User_Comp（解决多对多关系）
-- ==============================================
CREATE TABLE User_Comp (
    rel_id    VARCHAR2(20) PRIMARY KEY,
    user_id   VARCHAR2(20) NOT NULL,
    comp_id   VARCHAR2(20) NOT NULL
);
ALTER TABLE User_Comp ADD CONSTRAINT fk_rel_user
    FOREIGN KEY (user_id) REFERENCES UserInfo(user_id);
ALTER TABLE User_Comp ADD CONSTRAINT fk_rel_comp
    FOREIGN KEY (comp_id) REFERENCES Competition(comp_id);

-- ==============================================
-- 6. 日程表 Schedule
-- ==============================================
CREATE TABLE Schedule (
    sch_id        VARCHAR2(20) PRIMARY KEY,
    user_id       VARCHAR2(20) NOT NULL,
    comp_id       VARCHAR2(20) NOT NULL,
    sch_time      DATE,
    remind_status VARCHAR2(20) NOT NULL
);
ALTER TABLE Schedule ADD CONSTRAINT fk_sch_user
    FOREIGN KEY (user_id) REFERENCES UserInfo(user_id);
ALTER TABLE Schedule ADD CONSTRAINT fk_sch_comp
    FOREIGN KEY (comp_id) REFERENCES Competition(comp_id);
-- 检查约束：限定提醒状态
ALTER TABLE Schedule ADD CONSTRAINT ck_remind_status
    CHECK (remind_status IN ('已开启', '已关闭', '待更新'));  -- 新增'待更新'状态

-- ==============================================
-- 7. 反馈表 Feedback
-- ==============================================
CREATE TABLE Feedback (
    feed_id     VARCHAR2(20) PRIMARY KEY,
    user_id     VARCHAR2(20) NOT NULL,
    content     VARCHAR2(1000) NOT NULL,
    submit_time DATE           NOT NULL,
    deal_status VARCHAR2(20)   NOT NULL
);
ALTER TABLE Feedback ADD CONSTRAINT fk_feed_user
    FOREIGN KEY (user_id) REFERENCES UserInfo(user_id);
-- 检查约束：限定反馈处理状态
ALTER TABLE Feedback ADD CONSTRAINT ck_deal_status
    CHECK (deal_status IN ('未处理', '已处理'));

-- ==============================================
-- 验证建表结果
-- ==============================================
SELECT table_name FROM user_tables
WHERE table_name IN ('COLLEGEDATA','USERINFO','ADMININFO',
                     'COMPETITION','USER_COMP','SCHEDULE','FEEDBACK')
ORDER BY table_name;