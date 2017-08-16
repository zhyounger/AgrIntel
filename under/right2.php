<?php
header("Content-Type: text/html; charset=utf-8");
require_once('db.php');
$connect = Db::getInstance()->connect();
// if($connect){
// echo "连接成功";
// }else{
// echo "连接失败";
// }
$time = $_GET['time'];
$sql = "select*from student where sbirthday='$time'";
$result = mysqli_query($connect,$sql);
$arr = mysqli_fetch_array($result);
print_r($arr['sno']);
echo "</br>";
print_r($arr['sbirthday']);
echo "</br>";