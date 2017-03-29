<%@ page language="java" import="java.sql.*, atmarkit.MyDBAccess" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>

<head>

<!-- <meta charset="UTF-8" /> -->

<title>Dialogウィジェット</title>

		<link type="text/css" media="screen" href="jquery-ui-1.11.4.custom/jquery-ui.min.css" rel="stylesheet" />
		<link type="text/css" media="screen" href="Guriddo_jqGrid_JS_5.1.1/css/ui.jqgrid.css" rel="stylesheet" />
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery-1.11.0.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/jquery.jqGrid.min.js" ></script>
		<script type="text/javascript" src="Guriddo_jqGrid_JS_5.1.1/js/i18n/grid.locale-ja.js" ></script>

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


	<script type="text/javascript">
	function t_code(){


	}

	$(function(){
		$('#button1').click(function(){
		  $('#dialogdemo1').dialog('open');
		});
	});

	$(function(){
		$('#dialogdemo1').dialog({
		autoOpen: false,
		title: 'jQuery Dialog Demo',
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
		$('button.left_1').button({
			icons:{
				primary: 'ui-icon-check'
			}
		});
		//クローズアイコンを左に
		$('button.left_2').button({
			icons:{
				primary: 'ui-icon-close'
			}
		});

	});

</script>

</head>

<body>
	<div id="dialogdemo1">
<!-- ************:一行目 -->
		<div class= "outor">
			<div class="u-flex">
				<span class="size">
				 	登録日時：<input type="text">　
				 </span>
				 <span class="line_1 ">
					<button type="submit" class="left_1">OK</button>
					<button type="submit" class="left_2">Cancel</button>
				</span>
			</div>
<!-- ******************** -->
		<div style="border-style: none; line-height:60px">
<!-- ************:二行目 -->
			<span style="border-style: none;">
				ＩＤ：<input type="text" ID="num_ID" >
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
						ユーザー名：<input type="text" size="15">　　　　
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
						パスワード：<input type="text" size="15">　　　　
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
							表　示　名：<input type="text" size="15">　　　　
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
	<button id="button">ファイルを開く</button>
</div>

<button id="button">ダイアログを開く</button>

</body>

</html>