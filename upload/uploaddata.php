<?php
require_once('db.php');
$connect = Db::getInstance()->connect();

$sensor =  $_POST["sensor"];
$time = $_POST["time"];
$temperature = $_POST["temperature"];
$humidity = $_POST["humidity"];
$light = $_POST["light"];
$imgurl= "http://115.159.120.50/AgrIntel/image".$sensor."/".$time.".jpg";
$len=10;
$day=substr($time, 0, $len); 
$sql = "insert into data (sensor, day, time, tem, hum, light, imgurl) values ('$sensor', '$day', '$time ', '$temperature', '$humidity ', '$light', '$imgurl')";
mysqli_query($connect, $sql);
mysqli_close($connect)

?>