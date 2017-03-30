<%@ page language="java" import="java.sql.*, atmarkit.MyDBAccess" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>マイページ</title>
	<!-- jqGrid 表示ここから -->
		<link type="text/css" media="screen" href="jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" />
		<link type="text/css" media="screen" href="Guriddo_jqGrid_JS_5.1.1/css/ui.jqgrid.css" rel="stylesheet" />
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery-1.11.0.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery.jqGrid.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/i18n/grid.locale-ja.js" ></script>
		<!-- 追加分 -->
		<script type="text/javascript" src="jquery-ui-1.11.4.custom/jquery-ui.min.js" ></script>

		<style>
		div{
		border: solid 1px black;
		}

		outer{
		width:500px;
		}

		u-flex{
		display: flex;
		}

		line_1{
		height:30px;
		line-height: 30px;
		width:100px;
		float:right;
		padding:5px;
		}

		row1{
		height: 30px;
		line-height: 30px
		}

		size{
		width:200px;
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
							document.getElementById("id_select").value = row_del;
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
				document.cookie = 'ck_user_add=' + escape(document.getElementById("dia_name_add").value);
				document.cookie = 'ck_pass_add=' + escape(document.getElementById("dia_pass_add").value);
				document.cookie = 'ck_disp_add=' + escape(document.getElementById("dia_disp_add").value);
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
				var user = document.getElementById("dia_name_add").value;
				var pass = document.getElementById("dia_pass_add").value;
				var disp = document.getElementById("dia_disp_add").value;
				var target = document.getElementById("error");

				console.log([user, pass, disp, target]);

				if(user != 0 && pass != 0 && disp != 0)
				{
					console.log('post insert');
					SaveCookie();//クッキー保存
					document.getElementById("addform").action = "insert";
					document.addform.submit();
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
					document.getElementById("changeform").action = "update";
					document.changeform.submit();
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
						document.getElementById("formid").action = "delete";
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
<!--		//********************************************************// -->
<!--		//ダイアログ -->
<!-- 		//********************************************************// -->



	$(function(){
		$('#button_add').click(function(){
	  		$('#dialog_add').dialog('open');
			var id = document.getElementById("id_select").value;
			var user = document.getElementById("id_user_add").value;
			var pass = document.getElementById("id_pass_add").value;
			var disp = document.getElementById("id_disp_add").value;

			document.getElementById("dia_id_1").value = id;
			document.getElementById("dia_name_add").value = user;
			document.getElementById("dia_pass_add").value = pass;
			document.getElementById("dia_disp_add").value = disp;
		});

		$('#button_change').click(function(){
	  		$('#dialog_change').dialog('open');
			var id = document.getElementById("id_select").value;
			var user = document.getElementById("id_user_add").value;
			var pass = document.getElementById("id_pass_add").value;
			var disp = document.getElementById("id_disp_add").value;

			document.getElementById("dia_id_2").value = id;
			document.getElementById("dia_name_change").value = user;
			document.getElementById("dia_pass_change").value = pass;
			document.getElementById("dia_disp_change").value = disp;
		});
	});

	$(function(){
		$('#dialog_add').dialog({
		autoOpen: false,
		title: 'Dialog Add',
		closeOnEscape: false,
		modal: true,
		width: 600,
		height: 500,
		});

		$('#dialog_change').dialog({
		autoOpen: false,
		title: 'Dialog change',
		closeOnEscape: false,
		modal: true,
		width: 600,
		height: 500,
		});
	});

	$(function(){
		$("input[type=submit],button")
		.button()
		.click(function(event){
			event.preventDefault();
		});
		//チェックアイコンを左に
		$('button.OK_button').button({
			icons:{
				primary: 'ui-icon-check'
			}
		});
		//クローズアイコンを左に
		$('button.Cansel_button').button({
			icons:{
				primary: 'ui-icon-close'
			}
		});
	});
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
					<td  style="border-style: none;"><input type="button" value="追加" id="button_add"></td>
					<td  style="border-style: none;"><input type="button" value="変更" id="button_change"></td>
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
					<td style="border-style: none;"><input id="id_select" type="text" name="name_select" style="width: 150px; height: 24px; color:#000000;"></td>
					<td style="border-style: none;"><input id="id_delete" type="text" name="name_delete" style="width: 150px; height: 24px; color:#000000;"></td>
				</tr>
			</table>
			<table id="list">
			</table>
		</form>

		<div id="dialog_add">
			<form method="POST" name="addform" id="addform" action="insert">
			<!-- ************:一行目 -->
				<div class= "outor">
					<div class="u-flex">
						<span class="size">
						 	登録日時：<input type="text">　
						 </span>
						 <span class="line_1 ">
							<button type="submit" class="OK_button" onclick="AddButton()">OK</button>
							<button type="submit" class="Cancel_button" onclick="$('#dialog_add').dialog('close');">Cancel</button>
						</span>
					</div>
			<!-- ******************** -->
					<div style="border-style: none; line-height:60px">
			<!-- ************:二行目 -->
						<span style="border-style: none;">
							ＩＤ：<input type="text" id="dia_id_1"  name="dia_id_1">
						</span>
						<span style="border-style: none; font-size: 10px; vertical-align:suoer;">
							ああああああ
						</span>
						<span style="border-style: none; font-size: 10px; vertical-align:sub;">
							ああああああ
						</span>
			<!-- ******************** -->
					</div>
					<div style="border-style: none; line-height:50px">
			<!-- ************:三行目 -->
						<div>
							<span style="border-style: none; display:inline-block">
								ユーザー名：<input id="dia_name_add" type="text" name="dia_name_add"  size="15">　　　　
							</span>
							<span>
								<input type="text"  size="15">
							</span>
						</div>
			<!-- ******************** -->
						<div style="border-style: none; line-height:50px">
			<!-- ************:四行目 -->
							<div>
								<span style="border-style: none; display:inline-block">
									パスワード：<input id="dia_pass_add" type="text" name="dia_pass_add"size="15">　　　　
								</span>
								<span>
									<input type="text"  size="15">
								</span>
							</div>
			<!-- ******************** -->
							<div style="border-style: none; line-height:50px">
			<!-- ************:五行目 -->
								<div>
									<span style="border-style: none; display:inline-block">
										表　示　名：<input id="dia_disp_add" type="text" name="dia_disp_add" size="15">　　　　
									</span>
									<span>
										<input type="text"  size="15">
									</span>
								</div>
			<!-- ******************** -->
							</div>
						</div>
					</div>
				</div>
				<button id="button1">ファイルを開く</button>
			</form>
		</div>

		<div id="dialog_change">
			<form method="POST" name="changeform" id="changeform" action="update">
			<!-- ************:一行目 -->
				<div class= "outor">
					<div class="u-flex">
						<span class="size">
							登録日時：<input type="text">　
						 </span>
						 <span class="line_1 ">
							<button type="submit" class="OK_button" onclick="ChangeButton()">OK</button>
							<button type="submit" class="Cancel_button" onclick="$('#dialog_change').dialog('close');">Cancel</button>
						</span>
					</div>
			<!-- ******************** -->
				<div style="border-style: none; line-height:60px">
			<!-- ************:二行目 -->
					<span style="border-style: none;">
						ＩＤ：<input type="text" id="dia_id_2"  name="dia_id_2">
					</span>
					<span style="border-style: none; font-size: 10px; vertical-align:suoer;">
						ああああああ
					</span>
					<span style="border-style: none; font-size: 10px; vertical-align:sub;">
						ああああああ
					</span>
			<!-- ******************** -->
				</div>
				<div style="border-style: none; line-height:50px">
			<!-- ************:三行目 -->
					<div>
						<span style="border-style: none; display:inline-block">
							ユーザー名：<input id="dia_name_change" type="text" name="dia_name_change"  size="15">　　　　
						</span>
						<span>
							<input type="text"  size="15">
						</span>
					</div>
			<!-- ******************** -->
					<div style="border-style: none; line-height:50px">
			<!-- ************:四行目 -->
						<div>
							<span style="border-style: none; display:inline-block">
								パスワード：<input id="dia_pass_change" type="text" name="dia_pass_change" size="15">　　　　
							</span>
							<span>
								<input type="text"  size="15">
							</span>
						</div>
			<!-- ******************** -->
						<div style="border-style: none; line-height:50px">
			<!-- ************:五行目 -->
							<div>
								<span style="border-style: none; display:inline-block">
 									表　示　名：<input id="dia_disp_change" type="text" name="dia_disp_change" size="15">　　　　
								</span>
								<span>
									<input type="text"  size="15">
								</span>
							</div>--%>
			<!-- ******************** -->
							</div>
						</div>
					</div>
				</div>
			<button id="button1">ファイルを開く</button>
			</form>
		</div>
	</body>
</html>