<%@ page language="java" import="java.sql.*, atmarkit.MyDBAccess" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>yuuki_login</title>
	<!-- jqGrid 表示ここから -->
		<link type="text/css" media="screen" href="jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" />
		<link type="text/css" media="screen" href="Guriddo_jqGrid_JS_5.1.1/css/ui.jqgrid.css" rel="stylesheet" />
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery-1.11.0.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery.jqGrid.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/i18n/grid.locale-ja.js" ></script>
		<%
		%>
		<script type="text/javascript">
			var row_id = 0;
			var row_del = 0;
			var _test = [];
			var select_flg = new Boolean(false);
		</script>
		<%
			// 内容: データベースにアクセスする
			// MyDBAccess のインスタンスを生成する
			MyDBAccess db = new MyDBAccess();
			// データベースへのアクセス
			db.open();
			request.setCharacterEncoding("UTF-8");
			// メンバーを取得
			ResultSet rs = db.getResultSet("select * from t_user_list");
			// 取得された各結果に対しての処理
			while(rs.next())
			{
				int db_id = rs.getInt("user_id"); // IDを取得
				request.setCharacterEncoding("UTF-8");
				String db_name = rs.getString("user_name"); // ユーザー名を取得
				String db_pass = rs.getString("user_pass"); // パスワードを取得
				String db_disp = rs.getString("disp_name"); // 表示名を取得
		%>
		<script type="text/javascript">
				var _obj = {grid_id:"<%= db_id%>" ,grid_name:"<%= db_name%>" ,grid_pass:"<%= db_pass%>" ,grid_disp:"<%= db_disp%>"};
				_test.push(_obj);
		</script>
		<%
			}
			// データベースへのコネクションを閉じる
			db.close();
		%>
		<script type="text/javascript">
			//＊＊＊＊＊＊＊＊＊
			//ＪＱＧｒｉｄ
			//＊＊＊＊＊＊＊＊＊
			var mydata = _test;
			jQuery(document).ready(function()
			{
				var grid = jQuery("#list");
				jQuery("#list").jqGrid(
				{
					data: mydata,
					datatype: "local",
					colNames:['ID', 'ユーザー名', 'パスワード', '表示名'],
					colModel:[{name:'grid_id'},{name:'grid_name'},{name:'grid_pass'},{name:'grid_disp'}],
					multiselect: false,
					caption: 'ログイン',
					gridComplete: function()
					{
						BakeCookie();
						var _grid = jQuery("#list");
						var id = _grid.jqGrid("getDataIDs");
						if(id.length > 0)
						{
							select_flg = true;
							row_del = document.getElementById("id_delete").value;
							var row = _grid.getRowData(row_del);
							row_id = row.grid_id;
							_grid.jqGrid("setSelection",row_del );
							document.formname.name_user.focus();
							document.formname.name_user.select();
						}
					},
					onSelectRow: function(id, b_check)
					{
						var id = grid.getGridParam("selrow");
						if(id.length == 0)
						{
							select_flg = false;
//							var target = document.getElementById("error");
//							target.innerHTML = "表の行を選択してください";
						}
						if(id.length != 0)
						{
							select_flg = true;
							var row = grid.getRowData(id);
							row_id = row.grid_id;
							row_del = id;
							document.getElementById("id_user").value = row.grid_name;
							document.getElementById("id_pass").value = row.grid_pass;
							document.getElementById("id_disp").value = row.grid_disp;
							document.formname.name_user.focus();
							document.formname.name_user.select();
						}
					}
				});
			});
		</script>
	<!-- jqGrid 表示ここまで -->
		<script type="text/javascript">
		//＊＊＊＊＊＊＊＊＊
		//ログインボタン
		//＊＊＊＊＊＊＊＊＊
		function ButtonClick()//ログインボタン押したとき
		{
			var user = document.getElementById("id_user").value;
			var pass = document.getElementById("id_pass").value;
			var target = document.getElementById("error");
			var allRowsInGrid = $('#list').jqGrid('getGridParam','data');//jqGrid読み込み
			if(user == "")//ユーザー名が空
			{
				target.innerHTML = "ユーザー名を入力してください";
				document.formname.name_user.focus();
				document.formname.name_user.select();
				return;
			}
			if(pass == "")//パスワードが空
			{
				target.innerHTML = "パスワードを入力してください";
				document.formname.name_pass.focus();
				document.formname.name_pass.select();
				return;
			}
			for (var i = 0; i < allRowsInGrid.length; i++)
			{
				var row_u = allRowsInGrid[i].grid_name;//jqGridのユーザー名を取得ループ
				var row_p = allRowsInGrid[i].grid_pass;//jqGridのパスワードを取得ループ
				if(user == row_u && pass == row_p)//ユーザー名とパスワードが当たったら飛ぶ
				{
					target.innerHTML = "";//表示文字空
					SaveCookie();//クッキー保存
					document.formname.submit();
					return;
				}
				else if(user != row_u || pass != row_p)
				{
					target.innerHTML = "ログインに失敗しました";
					document.formname.name_user.focus();
					document.formname.name_user.select();
				}
			}
		}
		//＊＊＊＊＊＊＊＊＊
		//クッキー
		//＊＊＊＊＊＊＊＊＊
		function SaveCookie()//クッキー保存
		{
			document.cookie = 'ck_user=' + escape(document.getElementById("id_user").value);
			document.cookie = 'ck_pass=' + escape(document.getElementById("id_pass").value);
		}
		function BakeCookie()//クッキー焼き付け
		{
			var  _a = document.cookie;	//クッキーの取得

			if(_a.length == 0)
			{
				return;	//クッキーの中身がなければ何もしない
			}
			var _item = _a.split(';');		//文字列を”;”で分割
			var _strUser = "";				//ユーザー名を取得するための文字列
			var _strPass = "";				//パスワードを取得するための文字列

			for(var i = 0;i < _item.length;i++)//”;”で分割した回数だけループ
			{
				var _elem = _item[i].split('=');				//”=”で分割

				if(_elem[0].trim() == 'ck_user')//trim()という関数で文字の空白部分を取り除いている
				{
				_strUser = unescape(_elem[1]);							//最初の文字が保存する際に使用したnameと同じなら2個目の文字列がユーザー名なので取得
				}
				if(_elem[0].trim() == 'ck_pass')
				{
					_strPass = unescape(_elem[1]);							//最初の文字が保存する際に使用したnameと同じなら2個目の文字列がパスワードなので取得
				}
				else
				{
					continue;											//	何もしない
				}
			}
			document.getElementById("id_user").value = _strUser;
			document.getElementById("id_pass").value = _strPass;
			document.formname.name_user.focus();
			document.formname.name_user.select();
		}
		</script>
	</head>
	<body onLoad="BakeCookie();" bgcolor="#FFFFFF">
		<form method="POST" name="formname" id="formid" action="index.jsp">
			<table style="border-style: none;" border="1" >
				<tr>
					<td  style="border-style: none;" ><input type="button" value="ログイン" name="a" onclick = "ButtonClick();"></td>
					<td  style="border-style: none; color:#FF0000; font-weight:900;"><p id="error"></p></td>
				</tr>
			</table>
			<table style="border-style: none;" border="1" >
				<tr>
					<td style="border-style: none;"align="center">ユーザー名</td>
					<td style="border-style: none;"align="center">パスワード</td>
				</tr>
				<tr>
					<td style="border-style: none;"><input id="id_user" type="text" name="name_user" style="width: 150px; height: 24px; color:#000000;" ></td>
					<td style="border-style: none;"><input id="id_pass" type="password" name="name_pass" style="width: 150px; height: 24px; color:#000000;"></td>
<!-- 					<td style="border-style: none;"><input id="id_disp" type="text" name="name_disp" style="width: 0px; height: 0px; color:#000000;"></td> -->
					<td style="border-style: none;"><input id="id_select" type="hidden" name="name_select" style="width: 150px; height: 24px; color:#000000;"></td>
					<td style="border-style: none;"><input id="id_delete" type="hidden" name="name_delete" style="width: 150px; height: 24px; color:#000000;"></td>
				</tr>
			</table>
			<table id="list">
			</table>
		</form>
		<form>
		<input type= "hidden" id="id_disp_add" type="text" name="name_disp_add">
		</form>

	</body>
</html>
