<?php
header("Content-Type: text/json; charset = utf-8");


require_once('db.php');

$post = file_get_contents("php://input");
$data = json_decode($post);

$maxtem = $data->maxtem;
$mintem = $data->mintem;
$maxhum = $data->maxhum;
$minhum = $data->minhum;
$maxlight = $data->maxlight;
$minlight = $data->minlight;
//print_r($post);
//file_put_contents("test.txt", $mintem."&".gettype($maxtem));
$connect = Db::getInstance()->connect();
$sql = "update data set maxtem = '$maxtem', mintem = '$mintem', maxhum = '$maxhum', minhum = '$minhum', maxlight = '$maxlight', minlight = '$minlight'";
$result = mysqli_query($connect, $sql);

/*
if ($result) {
    echo $post;
}
*/
mysqli_close($connect);


