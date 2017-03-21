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

			<script type="text/javascript">
			function showDialog(){
				//ダイアログ表示
				var html = document.getElementById("content").innerHTML;

				html = html + '<div id="dialog">'
							+ '<div id="dialog_back" style="height:'
							+ getBrowserHeight() + 'px;"></div>'
							+ '<div id="dialog_body">'
							+ '<input type="button" onclick="closeDialog()"value="閉じる">'
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
				else if( document.body){
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

<body>
<div id= "content">
<input type="button" value="テスト" onclick = "showDialog();">
</div>
</body>
</html>
