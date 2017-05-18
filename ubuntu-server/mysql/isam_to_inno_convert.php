<?php 
  /**
   * MyISAM to InnoDB migration script for SmartCJ databases
   */
 
   if (!ini_get('display_errors')) {
    ini_set('display_errors', '1');
  } 
  error_reporting(E_ALL); 
 
   $connect = mysql_connect("localhost","root","ROOT_PASSWORD") 
  or die("unable to connect to msql server: " . msql_error()); 
 
 mysql_select_db("ИМЯ_БАЗЫ", $connect) 
  or die("CAnnot connect to databse: " . msql_error());   

   $result = mysql_query("SHOW TABLES LIKE 'rot_%'"); 
  if (!$result) { 
    die('Query cannot run'); 
  } 
 
   while ($row = mysql_fetch_array($result)){ 
    mysql_query("ALTER TABLE ".$row[0]." ENGINE=InnoDb; "); 
   } 
?>

