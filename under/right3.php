<?php
// //header ( "Content-type: text/html; charset=UTF-8" );
//require_once('db.php');
//$connect = Db::getInstance()->connect();
header ( "Content-type: text/html; charset=UTF-8" );
include("D:/wamp/www/AgrIntel/jpgraph-4.0.2/src/jpgraph.php");
include("D:/wamp/www/AgrIntel/jpgraph-4.0.2/src/jpgraph_line.php");
include ("D:/wamp/www/AgrIntel/jpgraph-4.0.2/src/jpgraph_scatter.php");
//$time = $_GET['time'];
//$sql = "select * from data where sensor='1' and time='$time'";
//$result = mysqli_query($connect,$sql);
//$arr = mysqli_fetch_array($result);
$graph = new Graph(400,300);
$graph->SetScale('textlin');
$datay = array(15,20,5,18,17,18);
$line = new LinePlot($datay);
$graph->Add($line);
$graph->Stroke()
 ?>