<?php
header("Content-Type: text/json; charset = utf-8");
require_once('db.php');
require_once('api.php');

$data_array = array();
$day = isset($_GET['day']) ? $_GET['day'] : 0;

$test = Db::getInstance();
$connect = $test->connect();

$connect = Db::getInstance()->connect();
$sql = "select * from sensor where day = '$day'";
$result = mysqli_query($connect, $sql);

foreach ($result as $key => $value) {
$data_array[] = $value;
}

$result = Response::json(200, 'Success', $data_array);

echo $result;

mysqli_close($connect);

