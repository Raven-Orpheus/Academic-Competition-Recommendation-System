"""
赛事推荐与日程管理系统 - Python Flask 后端【修复报名ORA-01722报错完整版 + 增加取消报名/管理员增删改】
启动方法：python app.py
访问地址：http://127.0.0.1:5000
依赖安装：pip install flask cx_Oracle flask-cors
"""
from flask import Flask, request, jsonify
from flask_cors import CORS
import cx_Oracle
from config import ORACLE_USER, ORACLE_PWD, DSN

app = Flask(__name__)
# 全局统一跨域，删除所有接口内OPTIONS判断
CORS(app, resources={r"/*": {"origins": "*"}})

# =============================================
# 统一数据库执行工具：自动关闭游标、连接，处理事务
# =============================================
def db_run(sql, params=None, is_query=True):
    conn = None
    cur = None
    try:
        conn = cx_Oracle.connect(ORACLE_USER, ORACLE_PWD, DSN)
        cur = conn.cursor()
        if params:
            cur.execute(sql, params)
        else:
            cur.execute(sql)
        if is_query:
            return cur.fetchall()
        conn.commit()
        return True
    except cx_Oracle.IntegrityError as e:
        if conn:
            conn.rollback()
        raise e
    except Exception as e:
        if conn:
            conn.rollback()
        raise e
    finally:
        if cur:
            cur.close()
        if conn:
            conn.close()

# =============================================
# 接口1：账号登录
# =============================================
@app.route("/api/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username", "").strip()
    pwd = data.get("pwd", "").strip()
    if not username or not pwd:
        return jsonify({"code": 400, "msg": "用户名和密码不能为空"})
    try:
        # 查询学生
        rows = db_run("SELECT user_id, major FROM UserInfo WHERE username=:un AND pwd=:pw",
                      params={"un": username, "pw": pwd})
        if rows:
            res = rows[0]
            return jsonify({"code": 200, "msg": "学生登录成功", "userid": res[0], "major": res[1]})
        # 查询管理员
        rows2 = db_run("SELECT admin_id, role FROM AdminInfo WHERE admin_name=:un AND admin_pwd=:pw",
                       params={"un": username, "pw": pwd})
        if rows2:
            res2 = rows2[0]
            return jsonify({"code": 201, "msg": "管理员登录成功", "adminid": res2[0], "role": res2[1]})
        return jsonify({"code": 400, "msg": "用户名或密码错误"})
    except Exception as e:
        return jsonify({"code": 500, "msg": f"服务器错误：{str(e)}"})

# =============================================
# 接口2：学生注册
# =============================================
@app.route("/api/register", methods=["POST"])
def register():
    data = request.get_json()
    try:
        count_rows = db_run("SELECT COUNT(*) FROM UserInfo")
        count = count_rows[0][0]
        user_id = f"U{str(count + 1).zfill(3)}"
        sql = """INSERT INTO UserInfo(user_id, username, pwd, school, major, tel, role) 
                 VALUES (:1, :2, :3, :4, :5, :6, :7)"""
        db_run(sql, params=(
            user_id,
            data.get("username"),
            data.get("pwd"),
            data.get("school", "内蒙古大学"),
            data.get("major", "计算机科学与技术"),
            data.get("tel", ""),
            "学生"
        ), is_query=False)
        return jsonify({"code": 200, "msg": "注册成功", "userid": user_id})
    except cx_Oracle.IntegrityError:
        return jsonify({"code": 400, "msg": "用户名已存在，请更换用户名"})
    except Exception as e:
        return jsonify({"code": 500, "msg": f"注册失败：{str(e)}"})

# =============================================
# 接口3：获取全部赛事列表（增加 official_url + local_sign_time + local_game_time）
# =============================================
@app.route("/api/competition", methods=["GET"])
def get_comp():
    try:
        rows = db_run(
            "SELECT comp_id, comp_name, comp_level, major_type, "
            "TO_CHAR(sign_time,'YYYY-MM-DD'), TO_CHAR(game_time,'YYYY-MM-DD'), official_url, "
            "TO_CHAR(local_sign_time,'YYYY-MM-DD'), TO_CHAR(local_game_time,'YYYY-MM-DD') "
            "FROM Competition ORDER BY sign_time"
        )
        data = []
        for row in rows:
            data.append({
                "comp_id": row[0],
                "comp_name": row[1],
                "comp_level": row[2],
                "major_type": row[3],
                "sign_time": row[4],
                "game_time": row[5],
                "official_url": row[6] or "",
                "local_sign_time": row[7] or "",
                "local_game_time": row[8] or ""
            })
        return jsonify({"code": 200, "data": data})
    except Exception as e:
        print("获取赛事列表错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 新增接口：带用户报名状态的赛事列表（增加 official_url + local_sign_time + local_game_time）
# =============================================
@app.route("/api/competition_with_join/<userid>", methods=["GET"])
def get_comp_with_join(userid):
    try:
        joined_rows = db_run("SELECT comp_id FROM User_Comp WHERE user_id=:user_id", params={"user_id": userid})
        joined_set = {r[0] for r in joined_rows}
        comp_rows = db_run(
            "SELECT comp_id, comp_name, comp_level, major_type, "
            "TO_CHAR(sign_time,'YYYY-MM-DD'), TO_CHAR(game_time,'YYYY-MM-DD'), official_url, "
            "TO_CHAR(local_sign_time,'YYYY-MM-DD'), TO_CHAR(local_game_time,'YYYY-MM-DD') "
            "FROM Competition ORDER BY sign_time"
        )
        data = []
        for row in comp_rows:
            comp_id = row[0]
            data.append({
                "comp_id": comp_id,
                "comp_name": row[1],
                "comp_level": row[2],
                "major_type": row[3],
                "sign_time": row[4],
                "game_time": row[5],
                "official_url": row[6] or "",
                "local_sign_time": row[7] or "",
                "local_game_time": row[8] or "",
                "is_joined": comp_id in joined_set
            })
        return jsonify({"code": 200, "data": data})
    except Exception as e:
        print("带状态赛事查询错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 接口4：按专业推荐赛事
# =============================================
@app.route("/api/recommend", methods=["GET"])
def recommend():
    major = request.args.get("major", "")
    try:
        like_str = f"%{'计算机' if '计算机' in major or '软件' in major else major}%"
        rows = db_run(
            "SELECT comp_id, comp_name, comp_level, major_type, "
            "TO_CHAR(sign_time,'YYYY-MM-DD'), TO_CHAR(game_time,'YYYY-MM-DD') "
            "FROM Competition WHERE major_type LIKE :mj ORDER BY comp_level",
            params={"mj": like_str}
        )
        data = []
        for row in rows:
            data.append({
                "comp_id": row[0], "comp_name": row[1],
                "comp_level": row[2], "major_type": row[3],
                "sign_time": row[4], "game_time": row[5]
            })
        return jsonify({"code": 200, "data": data})
    except Exception as e:
        print("推荐赛事错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 接口5：用户选择赛事（报名）【修改：移除用户存在性检查，仅检查报名关系】
# =============================================
@app.route("/api/select_comp", methods=["POST"])
def select_comp():
    data = request.get_json()
    user_id = str(data.get("user_id", "")).strip()
    comp_id = str(data.get("comp_id", "")).strip()
    if not user_id or not comp_id:
        return jsonify({"code": 400, "msg": "参数缺失"})
    try:
        # 不再检查用户是否在 UserInfo 中，允许管理员ID插入
        # 检查是否已经报名（只查关系）
        exist_rows = db_run(
            "SELECT rel_id FROM User_Comp WHERE user_id = :user_id AND comp_id = :comp_id",
            params={"user_id": user_id, "comp_id": comp_id}
        )
        if exist_rows:
            return jsonify({"code": 400, "msg": "您已选择该赛事"})

        # 生成报名ID
        max_rel_rows = db_run("""
            SELECT NVL(MAX(TO_NUMBER(SUBSTR(rel_id,2))), 0) 
            FROM User_Comp 
            WHERE REGEXP_LIKE(SUBSTR(rel_id,2), '^[0-9]+$')
        """)
        max_rel = max_rel_rows[0][0]
        rel_num = max_rel + 1
        rel_id = f"R{str(rel_num).zfill(3)}"

        db_run(
            "INSERT INTO User_Comp(rel_id, user_id, comp_id) VALUES (:rid, :user_id, :comp_id)",
            params={"rid": rel_id, "user_id": user_id, "comp_id": comp_id},
            is_query=False
        )

        # 生成日程ID
        max_sch_rows = db_run("""
            SELECT NVL(MAX(TO_NUMBER(SUBSTR(sch_id,2))), 0) 
            FROM Schedule 
            WHERE REGEXP_LIKE(SUBSTR(sch_id,2), '^[0-9]+$')
        """)
        max_sch = max_sch_rows[0][0]
        sch_num = max_sch + 1
        sch_id = f"S{str(sch_num).zfill(3)}"

        # 插入日程时，progress_status 默认设为 '待开始'
        db_run("""
            INSERT INTO Schedule(sch_id, user_id, comp_id, sch_time, remind_status, progress_status)
            VALUES (:sid, :user_id, :comp_id, 
                    (SELECT sign_time FROM Competition WHERE comp_id = :comp_id2), 
                    '已开启', '待开始')
        """, params={"sid": sch_id, "user_id": user_id, "comp_id": comp_id, "comp_id2": comp_id},
            is_query=False
        )

        joined_rows = db_run("SELECT comp_id FROM User_Comp WHERE user_id=:user_id", params={"user_id": user_id})
        joined = [r[0] for r in joined_rows]
        return jsonify({
            "code": 200,
            "msg": "选择成功，已自动生成日程",
            "comp_id": comp_id,
            "joined": joined
        })
    except cx_Oracle.IntegrityError:
        return jsonify({"code": 400, "msg": "重复提交，操作失败"})
    except cx_Oracle.DatabaseError as e:
        err_msg = str(e)
        if "ORA-01722" in err_msg:
            return jsonify({"code": 500, "msg": "选择失败：数据库存在异常数据，请联系管理员"})
        return jsonify({"code": 500, "msg": f"数据库错误：{err_msg}"})
    except Exception as e:
        print("选择赛事错误:", str(e))
        return jsonify({"code": 500, "msg": f"选择失败：{str(e)}"})

# 查询用户已报名赛事ID列表
@app.route("/api/user_joined/<userid>", methods=["GET"])
def user_joined_comp(userid):
    try:
        rows = db_run("SELECT comp_id FROM User_Comp WHERE user_id=:user_id", params={"user_id": userid})
        joined = [row[0] for row in rows]
        return jsonify({"code": 200, "joined": joined})
    except Exception as e:
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 接口6：查询个人日程 【核心修复】统一从 Competition 表读取本校时间
# =============================================
@app.route("/api/schedule/<userid>", methods=["GET"])
def get_schedule(userid):
    try:
        rows = db_run("""
            SELECT c.comp_id,
                   c.comp_name,
                   c.comp_level,
                   TO_CHAR(s.sch_time, 'YYYY-MM-DD') as sch_time,
                   TO_CHAR(c.game_time, 'YYYY-MM-DD') as game_time,
                   s.remind_status,
                   s.note,
                   c."OFFICIAL_URL",
                   TO_CHAR(c.local_sign_time, 'YYYY-MM-DD') as local_sign_time,
                   TO_CHAR(c.local_game_time, 'YYYY-MM-DD') as local_game_time,
                   s.progress_status
            FROM Schedule s
            JOIN Competition c ON s.comp_id = c.comp_id
            WHERE s.user_id = :1
            ORDER BY s.sch_time NULLS LAST, c.game_time
        """, params=(userid,))
        
        data = []
        for row in rows:
            data.append({
                "comp_id": row[0],
                "comp_name": row[1],
                "comp_level": row[2],
                "sch_time": row[3],
                "game_time": row[4],
                "remind_status": row[5],
                "note": row[6] or "",
                "official_url": row[7] or "",
                "local_sign_time": row[8] or "",
                "local_game_time": row[9] or "",
                "progress_status": row[10] or "待开始"
            })
        return jsonify({"code": 200, "data": data})
    except Exception as e:
        print("查询日程错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 新增接口：更新日程进度
# =============================================
@app.route("/api/update_progress", methods=["POST"])
def update_progress():
    data = request.get_json()
    user_id = str(data.get("user_id", "")).strip()
    comp_id = str(data.get("comp_id", "")).strip()
    progress_status = str(data.get("progress_status", "")).strip()
    if not user_id or not comp_id:
        return jsonify({"code": 400, "msg": "参数缺失"})
    # 进度状态可扩展
    valid_statuses = ["待开始", "进行中", "已结束"]
    if progress_status not in valid_statuses:
        return jsonify({"code": 400, "msg": f"进度状态必须是：{', '.join(valid_statuses)}"})
    try:
        db_run("""
            UPDATE Schedule 
            SET progress_status = :1
            WHERE user_id = :2 AND comp_id = :3
        """, params=(progress_status, user_id, comp_id), is_query=False)
        return jsonify({"code": 200, "msg": "进度更新成功"})
    except Exception as e:
        print("更新进度错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 新增接口：学生取消报名（移除日程和报名记录）- 使用位置绑定避免 ORA-01745
# =============================================
@app.route("/api/unselect_comp", methods=["POST"])
def unselect_comp():
    data = request.get_json()
    user_id = str(data.get("user_id", "")).strip()
    comp_id = str(data.get("comp_id", "")).strip()
    if not user_id or not comp_id:
        return jsonify({"code": 400, "msg": "参数缺失"})
    try:
        # 使用位置绑定（:1, :2）避免 ORA-01745
        db_run("DELETE FROM Schedule WHERE user_id = :1 AND comp_id = :2",
               params=(user_id, comp_id), is_query=False)
        db_run("DELETE FROM User_Comp WHERE user_id = :1 AND comp_id = :2",
               params=(user_id, comp_id), is_query=False)
        return jsonify({"code": 200, "msg": "已取消报名"})
    except Exception as e:
        print("取消报名错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 管理员：新增赛事（增加 official_url）
# =============================================
@app.route("/api/admin/add_comp", methods=["POST"])
def add_comp():
    data = request.get_json()
    try:
        count_rows = db_run("SELECT COUNT(*) FROM Competition")
        count = count_rows[0][0]
        comp_id = f"CP{str(count + 1).zfill(3)}"
        db_run("""
            INSERT INTO Competition(comp_id,comp_name,comp_level,major_type,
            sign_time,game_time,college_id,official_url) 
            VALUES(:comp_id,:cn,:cl,:mj,
            TO_DATE(:st,'YYYY-MM-DD'),TO_DATE(:gt,'YYYY-MM-DD'),:colid,:url)
        """, params={
            "comp_id": comp_id,
            "cn": data.get("comp_name"),
            "cl": data.get("comp_level"),
            "mj": data.get("major_type"),
            "st": data.get("sign_time"),
            "gt": data.get("game_time"),
            "colid": data.get("college_id", "C001"),
            "url": data.get("official_url", "")
        }, is_query=False)
        return jsonify({"code": 200, "msg": "赛事添加成功", "comp_id": comp_id})
    except Exception as e:
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 新增接口：管理员修改比赛（含官网链接）
# =============================================
@app.route("/api/admin/update_comp", methods=["POST"])
def update_comp():
    data = request.get_json()
    comp_id = data.get("comp_id")
    if not comp_id:
        return jsonify({"code": 400, "msg": "缺少比赛ID"})
    try:
        sql = """
            UPDATE Competition SET
                comp_name = :cn,
                comp_level = :cl,
                major_type = :mj,
                sign_time = TO_DATE(:st, 'YYYY-MM-DD'),
                game_time = TO_DATE(:gt, 'YYYY-MM-DD'),
                official_url = :url
            WHERE comp_id = :cid
        """
        db_run(sql, params={
            "cn": data.get("comp_name"),
            "cl": data.get("comp_level"),
            "mj": data.get("major_type"),
            "st": data.get("sign_time"),
            "gt": data.get("game_time"),
            "url": data.get("official_url", ""),
            "cid": comp_id
        }, is_query=False)
        return jsonify({"code": 200, "msg": "更新成功"})
    except Exception as e:
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# ─── 新增接口：管理员更新赛事的本校时间（local_sign_time / local_game_time） ───
# =============================================
@app.route("/api/admin/update_local_time", methods=["POST"])
def update_local_time():
    data = request.get_json()
    comp_id = str(data.get("comp_id", "")).strip()
    time_type = str(data.get("time_type", "")).strip()
    new_date = str(data.get("new_date", "")).strip()
    
    if not comp_id or not time_type:
        return jsonify({"code": 400, "msg": "参数缺失：comp_id 和 time_type 为必填"})
    
    # 根据 time_type 确定要更新的字段
    if time_type == 'sign':
        field = 'local_sign_time'
    elif time_type == 'game':
        field = 'local_game_time'
    else:
        return jsonify({"code": 400, "msg": "time_type 必须是 sign 或 game"})
    
    try:
        # 更新 Competition 表中的本地时间字段
        if new_date:
            sql = f'UPDATE Competition SET {field} = TO_DATE(:1, \'YYYY-MM-DD\') WHERE comp_id = :2'
            db_run(sql, params=(new_date, comp_id), is_query=False)
        else:
            sql = f'UPDATE Competition SET {field} = NULL WHERE comp_id = :1'
            db_run(sql, params=(comp_id,), is_query=False)
        return jsonify({"code": 200, "msg": f"本校{time_type}时间更新成功"})
    except Exception as e:
        print("更新本地时间错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 新增接口：管理员注册（需验证邀请码）
# =============================================
@app.route("/api/admin_register", methods=["POST"])
def admin_register():
    data = request.get_json()
    username = data.get("username", "").strip()
    pwd = data.get("pwd", "").strip()
    invite_code = data.get("invite_code", "").strip()
    
    # 邀请码校验（硬编码，实际项目应存数据库或更复杂的校验）
    VALID_INVITE_CODE = "imu2026"
    
    if not username or not pwd:
        return jsonify({"code": 400, "msg": "用户名和密码不能为空"})
    if invite_code != VALID_INVITE_CODE:
        return jsonify({"code": 400, "msg": "邀请码错误，请联系管理员获取"})
    
    try:
        # 检查用户名是否已被占用（AdminInfo 表）
        exist_rows = db_run(
            "SELECT admin_id FROM AdminInfo WHERE admin_name = :un",
            params={"un": username}
        )
        if exist_rows:
            return jsonify({"code": 400, "msg": "用户名已被占用，请更换"})
        
        # 生成管理员ID
        count_rows = db_run("SELECT COUNT(*) FROM AdminInfo")
        count = count_rows[0][0]
        admin_id = f"A{str(count + 1).zfill(3)}"
        
        # 插入管理员
        db_run("""
            INSERT INTO AdminInfo(admin_id, admin_name, admin_pwd, role)
            VALUES(:aid, :un, :pwd, 'admin')
        """, params={
            "aid": admin_id,
            "un": username,
            "pwd": pwd
        }, is_query=False)
        
        return jsonify({"code": 200, "msg": "管理员注册成功", "adminid": admin_id})
    except Exception as e:
        print("管理员注册错误:", str(e))
        return jsonify({"code": 500, "msg": f"注册失败：{str(e)}"})
    
# =============================================
# 新增接口：管理员删除比赛（级联删除报名和日程）- 使用位置绑定统一风格
# =============================================
@app.route("/api/admin/delete_comp/<comp_id>", methods=["DELETE"])
def delete_comp(comp_id):
    try:
        db_run("DELETE FROM Schedule WHERE comp_id = :1", params=(comp_id,), is_query=False)
        db_run("DELETE FROM User_Comp WHERE comp_id = :1", params=(comp_id,), is_query=False)
        db_run("DELETE FROM Competition WHERE comp_id = :1", params=(comp_id,), is_query=False)
        return jsonify({"code": 200, "msg": "删除成功"})
    except Exception as e:
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 提交反馈
# =============================================
@app.route("/api/feedback", methods=["POST"])
def add_feedback():
    data = request.get_json()
    try:
        count_rows = db_run("SELECT COUNT(*) FROM Feedback")
        count = count_rows[0][0]
        feed_id = f"F{str(count + 1).zfill(3)}"
        db_run("""
            INSERT INTO Feedback(feed_id,user_id,content,submit_time,deal_status) 
            VALUES(:fid,:user_id,:ct,SYSDATE,'未处理')
        """, params={"fid": feed_id, "user_id": data.get("user_id"), "ct": data.get("content")}, is_query=False)
        return jsonify({"code": 200, "msg": "反馈提交成功"})
    except Exception as e:
        return jsonify({"code": 500, "msg": str(e)})

# 管理员查看所有反馈
@app.route("/api/admin/feedback", methods=["GET"])
def admin_feedback():
    try:
        rows = db_run("""
            SELECT f.feed_id, u.username, f.content, 
            TO_CHAR(f.submit_time,'YYYY-MM-DD'), f.deal_status 
            FROM Feedback f JOIN UserInfo u ON f.user_id = u.user_id 
            ORDER BY f.submit_time DESC
        """)
        data = []
        for row in rows:
            data.append({
                "feed_id": row[0], "username": row[1],
                "content": row[2], "submit_time": row[3], "deal_status": row[4]
            })
        return jsonify({"code": 200, "data": data})
    except Exception as e:
        return jsonify({"code": 500, "msg": str(e)})

# 管理员处理反馈
@app.route("/api/admin/deal_feedback", methods=["POST"])
def deal_feedback():
    data = request.get_json()
    try:
        db_run("UPDATE Feedback SET deal_status='已处理' WHERE feed_id=:fid",
               params={"fid": data.get("feed_id")}, is_query=False)
        return jsonify({"code": 200, "msg": "已标记为处理完成"})
    except Exception as e:
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 接口7：用户手动更新日程时间（支持设置 + 清除日期）
# =============================================
@app.route("/api/update_schedule_time", methods=["POST"])
def update_schedule_time():
    data = request.get_json()
    user_id = str(data.get("user_id", "")).strip()
    comp_id = str(data.get("comp_id", "")).strip()
    new_sch_time = data.get("sch_time")

    if not user_id or not comp_id:
        return jsonify({"code": 400, "msg": "参数缺失（user_id、comp_id必填）"})

    try:
        exist = db_run("SELECT sch_id FROM Schedule WHERE user_id=:1 AND comp_id=:2",
                       params=(user_id, comp_id))
        if not exist:
            return jsonify({"code": 400, "msg": "未找到对应日程记录，请先选择该赛事"})

        if new_sch_time is not None and str(new_sch_time).strip():
            db_run("""
                UPDATE Schedule 
                SET sch_time = TO_DATE(:1, 'YYYY-MM-DD'),
                    remind_status = '待更新'
                WHERE user_id = :2 AND comp_id = :3
            """, params=(new_sch_time, user_id, comp_id), is_query=False)
            print(f"用户 {user_id} 为赛事 {comp_id} 设置日期: {new_sch_time}")
            return jsonify({"code": 200, "msg": "日程时间更新成功"})
        else:
            db_run("""
                UPDATE Schedule 
                SET sch_time = NULL,
                    remind_status = '已开启'
                WHERE user_id = :1 AND comp_id = :2
            """, params=(user_id, comp_id), is_query=False)
            print(f"用户 {user_id} 清除了赛事 {comp_id} 的手动日期")
            return jsonify({"code": 200, "msg": "日程时间已清除"})

    except Exception as e:
        print("更新日程时间错误:", str(e))
        return jsonify({"code": 500, "msg": f"更新失败：{str(e)}"})

# =============================================
# 新增接口：更新日程备注
# =============================================
@app.route("/api/update_schedule_note", methods=["POST"])
def update_schedule_note():
    data = request.get_json()
    user_id = str(data.get("user_id", "")).strip()
    comp_id = str(data.get("comp_id", "")).strip()
    note = data.get("note", "").strip()
    if not user_id or not comp_id:
        return jsonify({"code": 400, "msg": "参数缺失"})
    if len(note) > 500:
        return jsonify({"code": 400, "msg": "备注不能超过500字"})
    try:
        db_run("""
            UPDATE Schedule 
            SET note = :1
            WHERE user_id = :2 AND comp_id = :3
        """, params=(note, user_id, comp_id), is_query=False)
        return jsonify({"code": 200, "msg": "备注更新成功"})
    except Exception as e:
        print("更新备注错误:", str(e))
        return jsonify({"code": 500, "msg": str(e)})

# =============================================
# 启动服务
# =============================================
if __name__ == "__main__":
    print("=" * 50)
    print("  赛事推荐与日程管理系统 后端服务【完整版】")
    print("  访问地址：http://0.0.0.0:5000  (本机可用 http://127.0.0.1:5000)")
    print("  确保 Oracle 数据库已启动！")
    print("=" * 50)
    app.run(host="0.0.0.0", port=5000, debug=True)