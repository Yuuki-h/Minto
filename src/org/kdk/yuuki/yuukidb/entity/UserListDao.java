package org.kdk.yuuki.yuukidb.entity;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import atmarkit.MyDBAccess;

public class UserListDao {
	public static List<UserListEntity> selectAll(MyDBAccess db) throws Exception {
		List<UserListEntity> list = new ArrayList<>();

		ResultSet rs = db.getResultSet("select * from t_user_list");
		// 取得された各結果に対しての処理
		while(rs.next())
		{
			UserListEntity entity = new UserListEntity();

			entity.setUserId(rs.getInt("user_id")); // IDを取得
			entity.setUserName(rs.getString("user_name")); // ユーザー名を取得
			entity.setUserPass(rs.getString("user_pass")); // パスワードを取得
			entity.setDispName(rs.getString("disp_name")); // 表示名を取得

			list.add(entity);
		}
		return list;
	}

	public static int getMaxId(MyDBAccess db) throws Exception {
		ResultSet rs = db.getResultSet("SELECT MAX(user_id) FROM t_user_list");
		rs.next();
		Integer id = rs.getInt(1);

		return id;
	}

	public static void insert(MyDBAccess db, UserListEntity entity) throws Exception {
		// TODO
		db.execute("INSERT INTO t_user_list VALUES("+entity.getUserId()+", '"+entity.getUserName()+"', '"+entity.getUserPass()+"', '"+entity.getDispName()+"')");
	}
	public static void update(MyDBAccess db, UserListEntity entity) throws Exception {
		// TODO
		db.execute("update t_user_list set user_name='"+entity.getUserName()+"',user_pass='"+entity.getUserPass()+"',disp_name='"+entity.getDispName()+"' where user_id=('"+entity.getUserId()+"');");
	}
	public static void delete(MyDBAccess db, UserListEntity entity) throws Exception {
		// TODO
		db.execute("delete from t_user_list where user_id=('"+entity.getUserId()+"');");
	}
}

