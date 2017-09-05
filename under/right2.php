<?php
header("Content-Type: text/html; charset=utf-8");
require_once('db.php');
$connect = Db::getInstance()->connect();
// if($connect){
// echo "连接成功";
// }else{
// echo "连接失败";
// }
//$_GET方式获取数据
$time = $_GET['time'];
$sql = "select * from data where sensor='2' and time='$time'";
$result = mysqli_query($connect,$sql);
$arr = mysqli_fetch_array($result);
echo '<div style="width:40%; height:80%; border:0px solid; float:left; margin-bottom:15px; margin-top:10px;">';
echo '<img width=100% height=100% src="'.$arr['imgurl'].'"/>';//从数据库获取图片地址
echo '</div>';
echo "</br>";
echo "</br>";
echo '<div style="width:50%; height:100%; background:; float:right;clear:right; margin-bottom:15px; margin-top:10px;">';
echo "温度：";
print_r($arr['tem']);//从数据库获取温度
echo "℃";//温度单位
echo "</br>";//换行
echo "湿度：";
print_r($arr['hum']);//从数据库获取湿度
echo "RH";
echo "</br>";
echo "光强：";
print_r($arr['light']);//从数据库获取光强
echo "cd";
echo "</br>";
echo '</div>';