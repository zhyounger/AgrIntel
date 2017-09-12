<?php
require_once('db.php');
$connect = Db::getInstance()->connect();
//通过$_POST方式从Python端获取数据
$sensor =  $_POST["sensor"];
$time = $_POST["time"];
$temperature = $_POST["temperature"];
$humidity = $_POST["humidity"];
$light = $_POST["light"];
$imgurl= "http://115.159.120.50/AgrIntel/image".$sensor."/".$time.".jpg";
//截取字符串长度
$day=substr($time, 0, 10); 
//把获取的数据插入已有数据库
$sql = "insert into data (sensor, day, time, tem, hum, light, imgurl) values ('$sensor', '$day', '$time ', '$temperature', '$humidity ', '$light', '$imgurl')";
//执行$sql语句
mysqli_query($connect, $sql);
//关闭数据库
mysqli_close($connect)
?>