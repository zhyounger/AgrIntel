<?php
if (isset($_FILES['myFile']))
{
    $names = $_FILES["myFile"]['name'];
    $arr   = explode('.', $names);
    $name  = $arr[0]; //图片名称
    $date   = date('Y-m-d H:i:s'); //上传日期
    $fp     = fopen($_FILES['myFile']['tmp_name'], 'rb');
    $type   = $_FILES['myFile']['type'];
    $filename = $_FILES['myFile']['name'];
    $tmpname = $_FILES['myFile']['tmp_name'];
    echo $_FILES["myFile"]["error"];
  //将文件传到服务器根目录的 upload 文件夹中
if(move_uploaded_file($tmpname,"/var/www/AgrIntel/image2/".$filename))
{
      echo "upload image succeed";
}else{
            echo "upload image failed";
      }
}
     else
    {

    echo "文件未上传";

    }
?>
