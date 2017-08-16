<?php
require_once('db.php');

$connect = Db::getInstance()->connect();

$json_string='{"id":1,"name":"jbd1","email":"admin@jb51.net"} ';

$obj=json_decode($json_string,true);

$id = $obj['id'];

$name = $obj['name'];

$email = $obj['email'];

//echo $obj->name."<br>"; //prints foo

//echo $obj->interest[1]; //prints php
foreach($obj as $tem)

 {    
	 echo $tem;
	 echo "<br/>";
 }

$sql = "insert into name(id, name, email) values ('$id ', '$name', '$email ')";

mysqli_query($connect, $sql);

mysqli_close($connect);

?>