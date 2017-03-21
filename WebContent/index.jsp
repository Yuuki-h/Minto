<%@ page language="java" import="java.sql.*, atmarkit.MyDBAccess" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>マイページ</title>
	<!-- jqGrid 表示ここから -->
		<link type="text/css" media="screen" href="jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" />
		<link type="text/css" media="screen" href="Guriddo_jqGrid_JS_5.1.1/css/ui.jqgrid.css" rel="stylesheet" />
		<link type="text/css" media="screen" href="Guriddo_jqGrid_JS_5.1.1/css/ui.theme.css" rel="stylesheet" />

		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery-1.11.0.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery.jqGrid.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/i18n/grid.locale-ja.js" ></script>

		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<style type="text/css">

		#content{
		padding:10px;
		}

		#dialog_back{
		position: absolute;
		top:0px;
		left:0px;
		width:100%;
		background-coror: #000;
		opacity: 0.5;
		}

		#dialog_body{
		position:absolute;
		border-radius: 6px 6px 6px 6px;
		left:75px;
		top:150px;
		width:200px;
		height:150;
		background-color: #FFF;
		box-shadow: 6px 6px 6px rgba(0,0,0.4);
		padding:50px;
		}
		</style>

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
							_grid.jqGrid("setSelection", 1);
						}
					},
					onSelectRow: function(id, b_check)
					{
						var id = grid.getGridParam("selrow");
						if(id.length == 0)
						{
							select_flg = false;
							var target = document.getElementById("error");
							target.innerHTML = "表の行を選択してください";
						}
						if(id.length != 0)
						{
							select_flg = true;
							var row = grid.getRowData(id);
							row_id = row.grid_id;
							row_del = id;
							document.getElementById("id_user_add").value = row.grid_name;
							document.getElementById("id_pass_add").value =row.grid_pass;
							document.getElementById("id_disp_add").value = row.grid_disp;
							document.formname.name_user_add.focus();
							document.formname.name_user_add.select();
						}
					}
				});
			});
		</script>
	<!-- jqGrid 表示ここまで -->
		<script type="text/javascript">
			//＊＊＊＊＊＊＊＊＊
			//ログアウトボタン
			//＊＊＊＊＊＊＊＊＊
			function LogoutButton()//ログアウトボタン押したとき
			{
				SaveCookie();//クッキー保存
				document.formname.submit();
			}

			//＊＊＊＊＊＊＊＊＊
			//クッキー
			//＊＊＊＊＊＊＊＊＊
			function SaveCookie()//クッキー保存
			{
				document.cookie = 'ck_user_add=' + escape(document.getElementById("id_user_add").value);
				document.cookie = 'ck_pass_add=' + escape(document.getElementById("id_pass_add").value);
				document.cookie = 'ck_disp_add=' + escape(document.getElementById("id_disp_add").value);
				document.cookie = 'ck_select=' + escape(document.getElementById("id_select").value);
				document.cookie = 'ck_delete=' + escape(document.getElementById("id_delete").value);
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
				var _strDisp = "";				//表示名を取得するための文字列
				var _strSelect = "";				//選択行を取得するための文字列
				var _strDelete = "";				//選択行を取得するための文字列

				for(var i = 0;i < _item.length;i++)//”;”で分割した回数だけループ
				{
					var _elem = _item[i].split('=');				//”=”で分割

					if(_elem[0].trim() == 'ck_user_add')//trim()という関数で文字の空白部分を取り除いている
					{
					_strUser = unescape(_elem[1]);							//最初の文字が保存する際に使用したnameと同じなら2個目の文字列がユーザー名なので取得
					}
					if(_elem[0].trim() == 'ck_pass_add')
					{
						_strPass = unescape(_elem[1]);							//最初の文字が保存する際に使用したnameと同じなら2個目の文字列がパスワードなので取得
					}
					if(_elem[0].trim() == 'ck_disp_add')
					{
						_strDisp = unescape(_elem[1]);							//最初の文字が保存する際に使用したnameと同じなら2個目の文字列がパスワードなので取得
					}
					if(_elem[0].trim() == 'ck_select')
					{
						_strSelect = unescape(_elem[1]);							//最初の文字が保存する際に使用したnameと同じなら2個目の文字列がパスワードなので取得
					}
					if(_elem[0].trim() == 'ck_delete')
					{
						_strDelete = unescape(_elem[1]);							//最初の文字が保存する際に使用したnameと同じなら2個目の文字列がパスワードなので取得
					}
					else
					{
						continue;											//	何もしない
					}
				}
				document.getElementById("id_select").value = _strSelect;
				document.getElementById("id_delete").value = _strDelete;
				document.formname.name_user_add.focus();
				document.formname.name_user_add.select();
			}
			//＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
			//ユーザマスタ編集
			//＊＊＊＊＊＊＊＊＊＊＊＊
			//追加
			//＊＊＊＊＊＊＊＊＊
			function AddButton()//追加ボタン押したとき
			{
				var user = document.getElementById("id_user_add").value;
				var pass = document.getElementById("id_pass_add").value;
				var disp = document.getElementById("id_disp_add").value;
				var target = document.getElementById("error");

				if(user != 0 && pass != 0 && disp != 0)
				{
					SaveCookie();//クッキー保存
					document.getElementById("formid").action = "Insert.jsp";
					document.formname.submit();
					target.innerHTML = "追加しました";
				}
				else if(user == 0)
				{
					target.innerHTML = "ユーザー名を入力してください";
					document.formname.name_user_add.focus();
					document.formname.name_user_add.select();
					return;
				}
				else if(pass == 0)
				{
					target.innerHTML = "パスワードを入力してください";
					document.formname.name_pass_add.focus();
					document.formname.name_pass_add.select();
					return;
				}
				else if(disp == 0)
				{
					target.innerHTML = "表示名を入力してください";
					document.formname.name_disp_add.focus();
					document.formname.name_disp_add.select();
					return;
				}
			}
			//＊＊＊＊＊＊＊＊＊
			//変更
			//＊＊＊＊＊＊＊＊＊
			function ChangeButton()//変更ボタン押したとき
			{
				var target = document.getElementById("error");
				if(select_flg == true)
				{
					document.getElementById("id_select").value = row_id;
					document.getElementById("id_delete").value = row_del;
					SaveCookie();//クッキー保存
					document.getElementById("formid").action = "Update.jsp";
					document.formname.submit();
					target.innerHTML = "変更しました";
				}
				else
				{
					target.innerHTML = "表の行を選択してください";
					return;
				}
			}
			//＊＊＊＊＊＊＊＊＊
			//削除
			//＊＊＊＊＊＊＊＊＊
			function DeleteButton()//削除ボタン押したとき
			{
				var target = document.getElementById("error");
				if(confirm("削除しますか？"))
				{
					if(select_flg == true)
					{
						document.getElementById("id_select").value = row_id;
						document.getElementById("id_delete").value = row_del;
						SaveCookie();//クッキー保存
						document.getElementById("formid").action = "Delete.jsp";
						document.formname.submit();
						target.innerHTML = "削除しました";
					}
					else
					{
						target.innerHTML = "表の行を選択してください";
						return;
					}
				}
			}
			</script>
<!-- 			//********************************************************// -->
<!-- 			//ダイアログ -->
<!-- 			//********************************************************// -->
			<style type= "text/css">
			#content{
				padding:10px;
			}

			#dialog_back{
				position:absolute;
				top:0px;
				left:0px;
				width:100%;
				background-color: #000;
				opacity: 0.8;
			}
			#dialog_body{
				position: absolute;
				border-radius: 6px 6px 6px 6px;
				left:75px;
				top:150px;
				width:600px;
				height:300px;
				z-index:100;
				background-color: #FFF;
				box-shadow:6px 6px 6px rgba(0,0,0,0.4);
				padding:50px;
			}
			</style>

			<script type="text/javascript">
			function showDialog(){
				//ダイアログ表示
				var html = document.getElementById("content").innerHTML;

				html = html + '<div id="dialog">'
							+ '<div id="dialog_back" style="height:'
							+ getBrowserHeight() + 'px;"></div>'
							+ '<div id="dialog_body">'
							+ '<input type="button" onclick="closeDialog()"value="閉じる">'
							+ '<input type="button" onclick="closeDialog()"value="ふたつめ">'
							+'</div>'
							+'</div>';
				document.getElementById("content").innerHTML = html;
			}

			function getBrowserHeight(){
				//画面の高さを取得
				if(window.innerHeight){
					return window.innerHeight;
				}
				else if (document.documentElement && document.documentElement.clientHeight != 0){
					return documentElement.clientHeight;
				}
				else if(document.body){
					return document.body.clientHeight;
				}
				return 0;
			}

			function closeDialog(){
				//ダイアログを閉じる
				var delNode = document.getElementById("dialog");
				delNode.parentNode.removeChild(delNode);
			}

		</script>
	</head>
	<body onLoad="BakeCookie();" bgcolor="#FFFFFF">
		<form method="POST" name="formname" id="formid" action="login.jsp">
			<table style="border-style: none;" border="1" >
				<tr>
					<td  style="border-style: none;"><input type="button" value="ログアウト" name="a" onclick = "LogoutButton();"></td>
					<td style="border-style: none;">ログインしました</td>
				</tr>
			</table>
			<table style="border-style: none; width:100%;" border="1">
				<tr>
					<td  style="border-style: none;" width="50"><hr color="#696969" size="2" style="border-top: 1px solid #bbb;"></td>
					<td  style="border-style: none;color:#0000FF" width="140" align="center">ユーザマスタ編集</td>
					<td  style="border-style: none;"><hr color="#696969" size="2" style="border-top: 1px solid #bbb;"></td>
				</tr>
			</table>
			<table style="border-style: none;" border="1" >
				<tr>
					<td  style="border-style: none;"><input type="button" value="テスト" name="add" onclick = "AddButton();"></td>
					<td  style="border-style: none;"><input type="button" value="変更" name="change" onclick = "ChangeButton();"></td>
					<td  style="border-style: none;"><input type="button" value="削除" name="delete" onclick = "DeleteButton();"></td>
					<td  style="border-style: none;"><p id="error"></p></td>
				</tr>
			</table>
			<table style="border-style: none;" border="1" >
				<tr>
					<td style="border-style: none;"align="center">ユーザー名</td>
					<td style="border-style: none;"align="center">パスワード</td>
					<td style="border-style: none;"align="center">表示名</td>
				</tr>
				<tr>
					<td style="border-style: none;"><input id="id_user_add" type="text" name="name_user_add" style="width: 150px; height: 24px; color:#000000;" ></td>
					<td style="border-style: none;"><input id="id_pass_add" type="text" name="name_pass_add" style="width: 150px; height: 24px; color:#000000;"></td>
					<td style="border-style: none;"><input id="id_disp_add" type="text" name="name_disp_add" style="width: 150px; height: 24px; color:#000000;"></td>
					<td style="border-style: none;"><input id="id_select" type="hidden" name="name_select" style="width: 150px; height: 24px; color:#000000;"></td>
					<td style="border-style: none;"><input id="id_delete" type="hidden" name="name_delete" style="width: 150px; height: 24px; color:#000000;"></td>
				</tr>
			</table>
			<table id="list">
			</table>
		</form>
		<div id= "content">

		<input type="button" value="テスト" onclick = "showDialog();">
		</div>
	</body>
</html>
