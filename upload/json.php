<?php
require_once('db.php');

$connect = Db::getInstance()->connect();

//通过$_post从python获取数据
$temperature = $_POST["temperature"];

$time = $_POST["time"];

$humidity = $_POST["humidity"];

$light = $_POST["light"];

//json字符串
$json_string='{$time, $temperature, $humidity , $light} ';

//解析json数据
$obj=json_decode($json_string,true);
 
foreach($obj as $tem)

 {    
	 echo $tem;
	 echo "<br/>";
 }
  

//把获取过来的数据存入数据库
$sql = "insert into transducer1(time, temperature, humidity, light) values ('$time ', '$temperature', '$humidity ', '$light')";

mysqli_query($connect, $sql);

mysqli_close($connect)


?>