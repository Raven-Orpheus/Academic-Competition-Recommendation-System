# =============================================
# Oracle 数据库连接配置
# 修改为你本地 Oracle 的账号、密码
# =============================================

# =============================================
# Oracle 数据库连接配置
# =============================================

ORACLE_USER = "eg_user1"
ORACLE_PWD  = "123456"
ORACLE_HOST = "localhost"
ORACLE_PORT = "1521"
ORACLE_SERVICE_NAME = "XEPDB1"   # 你的 PDB 名称

# 拼接数据库连接串（使用服务名）
DSN = f"{ORACLE_HOST}:{ORACLE_PORT}/{ORACLE_SERVICE_NAME}"
# =============================================


# =============================================
#-- 创建用户
#CREATE USER competition_user IDENTIFIED BY 你的密码;

#-- 授予权限
#GRANT CONNECT, RESOURCE TO competition_user;
#GRANT CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER TO competition_user;
#GRANT UNLIMITED TABLESPACE TO competition_user;




#-- 使用 competition_user 连接数据库
## =============================================
# Oracle 数据库连接配置
# =============================================

#ORACLE_USER = "system"          # Oracle 用户名
#ORACLE_PWD  = "你的Oracle密码"  # Oracle 密码（修改为实际密码）
#ORACLE_HOST = "localhost"
#ORACLE_PORT = "1521"
#ORACLE_SID  = "ORCL"           # Oracle 实例名（默认为 ORCL）

# 拼接数据库连接串
#DSN = f"{ORACLE_HOST}:{ORACLE_PORT}/{ORACLE_SID}"

# =============================================