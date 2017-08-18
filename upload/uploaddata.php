<?php
require_once('db.php');
$connect = Db::getInstance()->connect();
//通过$_post从python获取数据
$sensor =  $_POST["sensor"];
$temperature = $_POST["temperature"];
$time = $_POST["time"];
$humidity = $_POST["humidity"];
$light = $_POST["light"];
//$name= "http://115.159.120.50/AgrIntel/image/".$time.".jpg";
//echo $name;
$len=10;
$day=substr($time, 0, $len); 
 echo "<br>";
 echo $sensor;
 echo "<br>";
 echo $time;
 echo "<br>";
 echo $temperature;
 echo "<br>";
 echo $humidity;
 echo "<br>";
 echo  $light;
//把获取过来的数据存入数据�?
$sql = "insert into sensor(sensor, day, time, tem, hum, light, image_url) values ( '$sensor', '$day' '$time ', '$temperature', '$humidity ', '$light', '$name')";
mysqli_query($connect, $sql);
mysqli_close($connect)
?>