<?php

header("Content-Type: text/json; charset = utf-8");
require_once('db.php');

require_once('api.php');

$data_array = array();

$compare = $_GET["compare"];

$get_day = $_GET['get_day'];

$sensor = isset($_GET['sensor']) ? $_GET['sensor'] : 1;

$limit = $_GET['limit'];



$day = $_GET['day'];



if ($compare == 1) {

    $connect = Db::getInstance()->connect();

    $sql = "select * from data where tem > maxtem or tem < mintem or hum > maxhum or hum < minhum or light > maxlight or light < minlight order by time desc";

    $result = mysqli_query($connect, $sql);



    foreach ($result as $key => $value) {

        $data_array[] = $value;



    }



    $result = Response::json(200, 'compare_data', $data_array);



    echo $result;



    mysqli_close($connect);

}



if($limit == 1) {

   

    $connect = Db::getInstance()->connect();

    $sql = "select distinct maxtem, mintem, maxhum, minhum, maxlight, minlight from data";

    $result = mysqli_query($connect, $sql);

    

    foreach ($result as $key => $value) {

        $data_array[] = ["maxtem" => $value['maxtem'],

                         "mintem" => $value["mintem"],

                         "maxhum" => $value["maxhum"],

                         "minhum" => $value["minhum"],

                         "maxlight" => $value["maxlight"],

                         "minlight" => $value["minlight"],

                        ];

    }



    $result = Response::json(200, 'limit_data', $data_array);



    echo $result;



    mysqli_close($connect);

}





if($get_day == 1 && !$day) {

    

    $connect = Db::getInstance()->connect();

    $sql = "select distinct day from data order by day desc";

    $result = mysqli_query($connect, $sql);

    

    foreach ($result as $key => $value) {

        $data_array[] = ["day" => $value['day']];

    }



    $result = Response::json(200, 'day_data', $data_array);



    echo $result;



    mysqli_close($connect);

}





if($get_day == 1 && $day && $sensor) {

    

    $connect = Db::getInstance()->connect();

    $sql = "select * from data where day = '$day' and sensor = '$sensor' order by time desc";

    $result = mysqli_query($connect, $sql);

    

    foreach ($result as $key => $value) {

        $data_array[] = $value;



    }

    $result = Response::json(200, 'data_in_day', $data_array);



    echo $result;



    mysqli_close($connect);

}
